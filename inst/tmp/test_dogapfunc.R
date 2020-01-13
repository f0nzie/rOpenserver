library(testthat)

context("test DoGAPFunc")

gap_dir <- system.file("models", "GAP", package = "openserver")
gap_model <- "Gap_Model.gap"
gap_file <- paste(gap_dir, gap_model, sep = "/")

expect_true(file.exists(gap_file))


# start OpenServer and GAP
gserver <- setOpenServer()
gserver$DoCmd("GAP.START")

# open GAP model
cmd_openfile <- paste0('GAP.OPENFILE("', gap_file, '")')
gserver$DoSlowCmd(cmd_openfile)

# get the number of steps for the model prediction
NumSteps <- as.integer(gserver$DoGAPFunc("GAP.PREDINIT()"))
expect_equal(NumSteps, 78)

# exit GAP
Sys.sleep(1)
gserver$DoCmd("GAP.SHUTDOWN")


