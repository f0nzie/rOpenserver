library(testthat)
library(rOpenserver)


context("README code")

test_that("README code behaves the same in tests", {

    # Initialize OpenServer
    prosper_server <- OpenServer$new()

    # Start Prosper
    cmd = "PROSPER.START"
    prosper_server$DoCmd(cmd)

    # point to the well model
    prosper_folder = "C:\\Program Files (x86)\\Petroleum Experts\\IPM 10\\Samples\\prosper"
    model_file <- "T00_Integrated_Oil_Well.Out"
    model_filename <- file.path(prosper_folder, model_file)
    file.exists(model_filename)

    # open Prosper model
    open_cmd <- "PROSPER.OPENFILE"
    open_cmd <- paste0(open_cmd, "('", model_filename, "')")
    DoCmd(prosper_server, open_cmd)


    # get reservoir pressure
    cmd <- "PROSPER.SIN.IPR.Single.Pres"
    prosper_server$DoGet(cmd)

    # get reservoir temperature
    cmd <- "PROSPER.SIN.IPR.Single.Tres"
    DoGet(prosper_server, cmd)           # S3 class: another way of getting values

    # [1] "1582.449951172"
    # [1] "146.667008038"


    # shutdown Prosper
    command = "PROSPER.SHUTDOWN"
    prosper_server$DoCmd(command)
    prosper_server <- NULL
})
