# prosperHorizNodeSys.R
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

# well lengths, vertical anisotropy and top node pressure vectors
well_length <- seq(500, by = 500, length.out = 17)
kv_kh       <- c(0.001, 0.005, 0.01, 0.1, 1.0)
node_pres   <- c(100, 125, 150, 175, 200, 225, 250, 275, 300)
df <- data.frame(well_length)  # create dataframe with well_length only

# Initialize and start OpenServer
pserver <- OpenServer$new()
cmd = "PROSPER.START"
DoCmd(pserver, cmd)

# open model
model_file <- get_model_filename(model = "HORWELLDP.OUT")
open_cmd <- "PROSPER.OPENFILE"
open_cmd <- paste0(open_cmd, "('", model_file, "')")
DoCmd(pserver, open_cmd)

# iterate with three loops
cum_df <- data.frame()    # dataframe accumulator
for (pres in node_pres) { # iterate through all top node pressures
    DoSet(pserver, "PROSPER.ANL.SYS.Pres", pres) # write the node pressure
    df["node_pres"] <- pres                      # assign value to node_pres
    # iterate through anisotropy values
    for (k in kv_kh) {
        DoSet(pserver, "PROSPER.SIN.IPR.Single.Vans", k)  # write kv_kh to model
        # iterate through all well lengths of interest
        i <-  1
        for (wlen in df[["well_length"]]) {
            # set well length
            DoSet(pserver, "PROSPER.SIN.IPR.Single.WellLen", wlen)
            # set length in zone 1
            DoSet(pserver, "PROSPER.SIN.IPR.Single.HorizdP[0].ZONLEN", wlen)
            DoCmd(pserver, "PROSPER.anl.SYS.CALC")    # do calculation
            # store liquid rate result in dataframe for each anisotropy scenario
            df[[as.character(k)]][i] <-
                as.double(DoGet(pserver, "PROSPER.OUT.SYS.RESULTS[0][0][0].SOL.LIQRATE"))
            i <-  i + 1
        }
    }
    cum_df <- rbind(cum_df, df)  # dataframe accumulator
}
print(cum_df)

# convert dataframe to tidy dataset
df_gather <- gather(cum_df, kv_kh, liquid_rate, '0.001':'1')

# plot
g <- ggplot(df_gather, aes(x = well_length, y = liquid_rate, color = kv_kh)) +
    geom_line() +             # one curve per kv_kh
    geom_point() +
    facet_wrap(node_pres~.)   # one facet per top node pressure
print(g)

# shutdown Prosper
Sys.sleep(3)
command = "PROSPER.SHUTDOWN"
pserver$DoCmd(command)
pserver <- NULL

