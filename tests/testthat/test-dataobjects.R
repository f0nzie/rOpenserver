library(testthat)
source("common.R")


# Initialize OpenServer
prosper_server <- .OpenServer$new()

expect_true(all(names(prosper_server) %in% oserver_methods))

# Start Prosper
cmd = "PROSPER.START"
prosper_server$DoCmd(cmd)

# open Prosper model
# model_filename <- get_model_from_pkg(mod_num = 4, ext = "out")
# cat(model_filename, "\n")

prosper_models <- get_all_models_by_ext(ext = "out")
model_filename <- prosper_models[["full_name"]][4]


open_cmd <- "PROSPER.OPENFILE"
open_cmd <- paste0(open_cmd, "('", model_filename, "')")
prosper_server$DoCmd(open_cmd)

# context("Test scalar data objects for Prosper")

test_that("DoCmd, DoSet work", {

    # get reservoir pressure
    var <- "PROSPER.SIN.IPR.Single.Pres"
    raw_data <- prosper_server$DoGet(var)
    expect_true(class(raw_data) == "character")
    result <- as.double(raw_data)
    expect_equal(result, 5200)
    # print(class(result))
    expect_true(class(result) == "numeric")
    expect_true(class(rDoGet(prosper_server, var)) == "integer")

    var <- "PROSPER.PVT.Input.Grvgas"
    raw_data <- prosper_server$DoGet(var)
    expect_true(class(raw_data) == "character")
    data <- as.double(raw_data)
    expect_equal(data, 0.76, tolerance = 1e-6)
    expect_true(class(data) == "numeric")
    expect_true(class(rDoGet(prosper_server, var)) == "numeric")

    # get reservoir temperature
    var <- "PROSPER.SIN.IPR.Single.Tres"
    result <- as.double(prosper_server$DoGet(var))
    expect_equal(result, 210)
})


# context("Test character data objects for Prosper")
test_that("Single character object", {
    var <- "PROSPER.SIN.SUM.Field"
    raw_data <- prosper_server$DoGet(var)
    expect_true(class(raw_data) == "character")
    expect_true(class(rDoGet(prosper_server, var)) == "character")

    var <- "PROSPER.filename"
    raw_data <- prosper_server$DoGet(var)
    # print(raw_data)
    expect_true(class(basename(raw_data)) == "character")
    expect_true(class(rDoGet(prosper_server, var)) == "character")

})


# context("Test character vector")
test_that("Single character object", {
    var <- "PROSPER.ANL.VMT.Data[$].Label"
    raw_data <- prosper_server$DoGet(var)
    # print(raw_data)
    expect_equal(length(raw_data), 1)
    expect_true(class(raw_data) == "character")


    # print(rDoGet(prosper_server, var))
    # print(class(rDoGet(prosper_server, var)))
    # print(length(rDoGet(prosper_server, var)))
    # print(class(raw_data))

    var <- "PROSPER.ANL.VMT.Data[$].THpres"
    raw_data <- prosper_server$DoGet(var)
    # print(raw_data)
    expect_equal(length(raw_data), 1)
    raw_data <- rDoGet(prosper_server, var)
    expect_equal(length(raw_data), 3)

})



# shutdown Prosper
command = "PROSPER.SHUTDOWN"
prosper_server$DoCmd(command)
prosper_server <- NULL
