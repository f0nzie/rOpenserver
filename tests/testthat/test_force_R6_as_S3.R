context("Force R6 methods as S3 methods")

oserver_methods <- c("server", ".__enclos_env__", "clone", "app_name",
                     "DoSet", "DoGet", "DoCmd", "initialize", "DoSlowCmd",
                     "DoGAPFunc")

test_that("PROSPER using DoCmd to start produces communication error in unit tests", {
    mserver <- OpenServer$new()
    cmd = "PROSPER.START"
    expect_error(DoCmd(cmd))
    # expect_equal(mserver$app_name, "PROSPER")
    Sys.sleep(1)
    cmd = "PROSPER.SHUTDOWN"
    result <- mserver$DoCmd(cmd)
    expect_true(result[[1]] == 11)        # error #11 no communication
    expect_true(all(names(mserver) %in% oserver_methods))
    mserver <- NULL
})
