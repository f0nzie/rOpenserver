library(testthat)
library(rOpenserver)

context("rDoGet returning character vectors")


test_that("DoGet gets proper values", {
    # Initialize OpenServer
    prosper_server <- OpenServer$new()

    # Start Prosper
    cmd = "PROSPER.START"
    prosper_server$DoCmd(cmd)

    # point to the well model
    prosper_folder <- system.file("models", package = "rOpenserver")
    model_file     <- "T00_Integrated_Oil_Well.Out"
    model_filename <- file.path(prosper_folder, model_file)
    file.exists(model_filename)

    # open Prosper model
    open_cmd <- "PROSPER.OPENFILE"
    open_cmd <- paste0(open_cmd, "('", model_filename, "')")
    DoCmd(prosper_server, open_cmd)

    # get reservoir pressure
    cmd <- "PROSPER.SIN.IPR.Single.Pres"
    expect_equal(as.double(prosper_server$DoGet(cmd)), 5200)

    # the Well name is empty
    cmd <- "PROSPER.SIN.SUM.Well"
    expect_equal(class(prosper_server$DoGet(cmd)), "character")
    expect_equal(nchar(prosper_server$DoGet(cmd)), 0)


    # if well is empty it will return length equal zero
    # notice that DoGet and rDoGet obtain different lengths
    cmd <- "PROSPER.SIN.SUM.Well"
    expect_equal(length(DoGet(prosper_server, cmd)), 0)
    expect_equal(length(rDoGet(prosper_server, cmd)), 0)

    # a numeric vector with MD
    cmd <- "PROSPER.SIN.EQP.Devn.Data[$].Md"
    # Dev. Survey: 0  600 1005 4075 7700 9275
    expect_equal(length(rDoGet(prosper_server, cmd)), 6)
    expect_true(is.numeric(rDoGet(prosper_server, cmd)))

    # an empty character vector. Downhole Equipment labels
    cmd <- "PROSPER.SIN.EQP.Down.Data[0].Label"
    expect_equal(length(rDoGet(prosper_server, cmd)), 0)

    # shutdown Prosper
    command = "PROSPER.SHUTDOWN"
    prosper_server$DoCmd(command)
    prosper_server <- NULL


})


#
# # shutdown Prosper
# command = "PROSPER.SHUTDOWN"
# prosper_server$DoCmd(command)
# prosper_server <- NULL
