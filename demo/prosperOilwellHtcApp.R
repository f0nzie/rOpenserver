# prosperOilwellHtcApp.R
library(rOpenserver)
library(tidyr)
library(ggplot2)

# function to get the filename for the model
get_model_filename <- function(model) {
    models_dir <- system.file("models", package = "rOpenserver")
    model_file <- file.path(models_dir, model)
    if (!file.exists(model_file)) stop("Model not found ...") else
        return(model_file)
}

# well lengths and vertical anisotropy vectors
htc <- seq(2, by = 0.5, to = 10)
df <- data.frame(htc)
df["liquid_rate"]     <- NA
df["wellhead_temp"]   <- NA
df["sol_bhp"]         <- NA
df["sol_dp_friction"] <- NA


# openserver variables
sys_sol_liqrate       <- "PROSPER.OUT.SYS.RESULTS[0][0][0].SOL.LIQRATE"
sys_sol_whtemperature <- "PROSPER.OUT.SYS.RESULTS[0][0][0].SOL.WHTEMPERATURE"
sys_sol_bhp           <- "PROSPER.OUT.SYS.Results[0].Sol.BHP"
sys_prfric            <- "PROSPER.OUT.SYS.Results[0].Sol.PRFRIC"

# Initialize and start OpenServer
pserver <- OpenServer$new()
cmd = "PROSPER.START"
DoCmd(pserver, cmd)

# open model
model_file <- get_model_filename(model = "oilwell.Out")
open_cmd <- "PROSPER.OPENFILE"
open_cmd <- paste0(open_cmd, "('", model_file, "')")
DoCmd(pserver, open_cmd)

# iterate through heat transfer coefficient vector
i <-  1
for (h in df[["htc"]]) {
    # set HTC
    DoSet(pserver, "PROSPER.SIN.EQP.Geo.Htc", h)
    DoCmd(pserver, "PROSPER.anl.SYS.CALC")    # do calculation
    # store liquid rate, wellhead temperature, solution BHP and dP friction
    df[["liquid_rate"]][i]     <- as.double(DoGet(pserver, sys_sol_liqrate))
    df[["wellhead_temp"]][i]   <- as.double(DoGet(pserver, sys_sol_whtemperature))
    df[["sol_bhp"]][i]         <- as.double(DoGet(pserver, sys_sol_bhp))
    df[["sol_dp_friction"]][i] <- as.double(DoGet(pserver, sys_prfric))
    i <-  i + 1
}
print(df)

# convert dataframe to tidy dataset
df_gather <- gather(df, var, value, liquid_rate:sol_dp_friction)

# plot
g <- ggplot(df_gather, aes(x = htc, y = value)) +
    geom_line() +
    geom_point() +
    facet_wrap(var ~., scales = "free_y")

print(g)

# shutdown Prosper
Sys.sleep(3)
command = "PROSPER.SHUTDOWN"
pserver$DoCmd(command)
pserver <- NULL

