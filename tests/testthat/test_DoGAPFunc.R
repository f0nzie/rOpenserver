library(testthat)

oserver_methods <- c("server", ".__enclos_env__", "clone", "app_name",
                     "DoSet", "DoGet", "DoCmd", "initialize", "DoSlowCmd",
                     "DoGAPFunc")

get_gap_model_01 <- function() {
    # get the GAP model "Gap Model.gap"
    gap_dir <- system.file("models", package = "rOpenserver")
    gap_model <- list.files(gap_dir, pattern = "*.GAP", ignore.case = TRUE)[1]   # the first
    gap_file <- file.path(gap_dir, gap_model)
    if (!file.exists(gap_file)) stop("Model not found ...") else
        return(gap_file)

}


context("DoGAPFunc")

test_that("DoGAPFunc works as expected", {
    # start OpenServer and GAP
    gserver <- setOpenServer()
    expect_true(all(names(gserver) %in% oserver_methods))
    result <- gserver$DoCmd("GAP.START")
    expect_equal(result, 0)

    # open GAP model
    cmd_openfile <- paste0('GAP.OPENFILE("', get_gap_model_01(), '")')
    result <- gserver$DoSlowCmd(cmd_openfile)
    expect_equal(result, 0)

    # get the number of steps for the model prediction
    result <- gserver$DoGAPFunc("GAP.PREDINIT()")
    expect_equal(result, "78")
    expect_equal(class(result), "character")
    NumSteps <- as.integer(result)
    expect_equal(NumSteps, 78)

    # exit GAP
    Sys.sleep(1)
    result <- gserver$DoCmd("GAP.SHUTDOWN")
    expect_equal(result, 0)
    gserver <- NULL
})






