library(testthat)

context("Test Openserver core and quick PROSPER, GAP, MBAL")

test_that("OpenServer loads", {
    mserver <- OpenServer()
    expect_s4_class(mserver$server, "COMIDispatch")
    expect_true(all(class(mserver) %in% c("OpenServer", "R6")))
    expect_true(all(names(mserver) %in% c("server", ".__enclos_env__", "clone", "app_name",
                                          "DoSet", "DoGet", "DoCmd", "initialize",
                                          "DoSlowCmd", "DoGAPFunc"
                                          )))
    mserver <- NULL
})


test_that("MBAL DoSlowCmd", {
    xserver <- OpenServer()
    expect_s4_class(xserver$server, "COMIDispatch")
    cmd = "MBAL.START"
    xserver$DoSlowCmd(cmd)
    expect_equal(xserver$app_name, "MBAL")
    Sys.sleep(1)
    cmd = "MBAL.SHUTDOWN"
    xserver$DoSlowCmd(cmd)
    xserver <- NULL
})


test_that("PROSPER works by supplying name", {
    mserver <- OpenServer()
    expect_s4_class(mserver$server, "COMIDispatch")
    cmd = "PROSPER.START"
    mserver$DoCmd(cmd)
    expect_equal(mserver$app_name, "PROSPER")
    Sys.sleep(1)
    cmd = "PROSPER.SHUTDOWN"
    mserver$DoCmd(cmd)
    mserver <- NULL

})

test_that("GAP works by supplying name", {
    xserver <- OpenServer()
    expect_s4_class(xserver$server, "COMIDispatch")
    cmd = "GAP.START"
    xserver$DoCmd(cmd)
    expect_equal(xserver$app_name, "GAP")
    Sys.sleep(1)
    cmd = "GAP.SHUTDOWN"
    xserver$DoCmd(cmd)
    xserver <- NULL

})

test_that("MBAL works by supplying name", {
    xserver <- OpenServer()
    expect_s4_class(xserver$server, "COMIDispatch")
    cmd = "MBAL.START"
    xserver$DoCmd(cmd)
    expect_equal(xserver$app_name, "MBAL")
    Sys.sleep(1)
    cmd = "MBAL.SHUTDOWN"
    xserver$DoCmd(cmd)
    xserver <- NULL
})

