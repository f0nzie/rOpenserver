
context("Test Openserver core and quick PROSPER, GAP, MBAL")

oserver_methods <- c("server", ".__enclos_env__", "clone", "app_name",
                     "DoSet", "DoGet", "DoCmd", "initialize", "DoSlowCmd",
                     "DoGAPFunc")


test_that("OpenServer with new() loads", {
    mserver <- OpenServer$new()
    expect_s4_class(mserver$server, "COMIDispatch")
    expect_true(all(class(mserver) %in% c("OpenServer", "R6")))
    expect_true(all(names(mserver) %in% oserver_methods))
    mserver <- NULL
})



test_that("PROSPER works by supplying name", {
    skip("skip")
    mserver <- OpenServer$new()
    expect_s4_class(mserver$server, "COMIDispatch")
    cmd = "PROSPER.START"
    mserver$DoCmd(cmd)
    # DoCmd(mserver, cmd)
    expect_equal(mserver$app_name, "PROSPER")
    Sys.sleep(1)
    cmd = "PROSPER.SHUTDOWN"
    result <- mserver$DoCmd(cmd)
    expect_equal(result, 0)
    expect_true(all(names(mserver) %in% oserver_methods))
    mserver <- NULL
})


context("Test setOpenserver function as constructor ")

test_that("OpenServer with setOpenServer function works", {
    mserver <- setOpenServer()
    # tests
    expect_s4_class(mserver$server, "COMIDispatch")
    expect_true(all(class(mserver) %in% c("OpenServer", "R6")))
    expect_true(all(names(mserver) %in% oserver_methods))
    mserver <- NULL
})

test_that("PROSPER works by supplying name", {
    # skip("skip")
    mserver <- OpenServer$new()
    expect_s4_class(mserver$server, "COMIDispatch")
    cmd = "PROSPER.START"
    expect_error(DoCmd(cmd))
    # expect_equal(mserver$app_name, "PROSPER")
    Sys.sleep(1)
    cmd = "PROSPER.SHUTDOWN"
    result <- mserver$DoCmd(cmd)
    # print(result)
    expect_true(result[[1]] == 11)   # error #11 no communication
    #expect_true(all(names(mserver) %in% oserver_methods))
    mserver <- NULL
})
