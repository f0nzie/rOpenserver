library(rOpenserver)

context("Openserver core and quick PROSPER, GAP, MBAL")

prosper_folder = "C:\\Program Files (x86)\\Petroleum Experts\\IPM 10\\Samples\\prosper"

oserver_methods <- c("server", ".__enclos_env__", "clone", "app_name",
                     "DoSet", "DoGet", "DoCmd", "initialize", "DoSlowCmd",
                     "DoGAPFunc")


get_prosper_01 <- function() {
    # point to the well model
    model_file <- list.files(prosper_folder)[1]
    model_filename <- file.path(prosper_folder, model_file)
    if (!file.exists(model_filename)) stop("Model not found ...") else
        return(model_filename)
}

test_that("DoCmd, DoGet work", {
    # Initialize OpenServer
    prosper_server <- OpenServer$new()

    expect_true(all(names(prosper_server) %in% oserver_methods))

    # Start Prosper
    cmd = "PROSPER.START"
    prosper_server$DoCmd(cmd)

    # open Prosper model
    model_filename <- get_prosper_01()
    open_cmd <- "PROSPER.OPENFILE"
    open_cmd <- paste0(open_cmd, "('", model_filename, "')")
    prosper_server$DoCmd(open_cmd)


    # get reservoir pressure
    var <- "PROSPER.SIN.IPR.Single.Pres"
    result <- as.double(prosper_server$DoGet(var))
    expect_equal(result, 5200)

    # get reservoir temperature
    var <- "PROSPER.SIN.IPR.Single.Tres"
    result <- as.double(prosper_server$DoGet(var))
    expect_equal(result, 210)

    # shutdown Prosper
    command = "PROSPER.SHUTDOWN"
    prosper_server$DoCmd(command)
    prosper_server <- NULL
})


test_that("OpenServer with $new() loads", {
    mserver <- OpenServer$new()
    expect_s4_class(mserver$server, "COMIDispatch")
    expect_true(all(class(mserver) %in% c("OpenServer", "R6")))
    expect_true(all(names(mserver) %in% oserver_methods))
    mserver <- NULL
})



context("setOpenserver function as constructor ")

test_that("OpenServer with setOpenServer function works", {
    mserver <- setOpenServer()
    # tests
    expect_s4_class(mserver$server, "COMIDispatch")
    expect_true(all(class(mserver) %in% c("OpenServer", "R6")))
    expect_true(all(names(mserver) %in% oserver_methods))
    mserver <- NULL
})


