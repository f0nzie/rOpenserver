library(testthat)
# Functions tested:
#   setOpenServer()
#   DoGAPFunc, DoCmd, DoSlowCmd


context("DoGAPFunc, DoCmd, DoSlowCmd for GAP")

oserver_methods <- c("server", ".__enclos_env__", "clone", "app_name",
                     "DoSet", "DoGet", "DoCmd", "initialize", "DoSlowCmd",
                     "DoGAPFunc")

get_model_from_pkg <- function(mod_num = 1, ext = c("out", "gap", "mbi")) {
    app_dir <- system.file("models", package = "rOpenserver")
    model <- list.files(app_dir, pattern = paste0("*.", ext), ignore.case = TRUE)[mod_num]   # the first
    file <- file.path(app_dir, model)
    if (!file.exists(file)) stop("Model not found ...") else
        return(file)

}



test_that("DoGAPFunc works as expected", {
    # start OpenServer and GAP
    gserver <- setOpenServer()
    expect_true(all(names(gserver) %in% oserver_methods))
    result <- gserver$DoCmd("GAP.START")
    expect_equal(result, 0)

    # open GAP model
    cmd_openfile <- paste0('GAP.OPENFILE("',
                           get_model_from_pkg(mod_num = 1, ext = "gap"), '")')
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






