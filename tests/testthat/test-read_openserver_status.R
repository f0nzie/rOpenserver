library(testthat)
library(rOpenserver)

context("OpenServer Windows processes")

test_that("Windows processes are captured", {
    # Initialize OpenServer
    prosper_server <- OpenServer$new()

    # Start Prosper
    cmd = "PROSPER.START"
    prosper_server$DoCmd(cmd)

    status <- read_openserver_status()

    # print(unique(status$process))
    expect_true(any(grepl("prosper", unique(status$process))))
    expect_true(any(grepl("px32COM10", unique(status$process))))

    cmd = "PROSPER.SHUTDOWN"
    prosper_server$DoCmd(cmd)

    # tests that after shutdown some processes remain
    status <- read_openserver_status()
    expect_true(any(grepl("pxserver.exe", unique(status$process))))
    expect_true(any(grepl("PxLs.exe", unique(status$process))))
    expect_true(any(grepl("px32COM10", unique(status$process))))

    # couple of processes remain after NULL
    prosper_server <- NULL
    status <- read_openserver_status()
    expect_true(any(grepl("pxserver.exe", unique(status$process))))
    expect_true(any(grepl("PxLs.exe", unique(status$process))))

    # test if anything remains after deleting object
    Sys.sleep(1)
    # prosper_server <- NULL
    rm(prosper_server)
    status <- read_openserver_status()
    expect_false(any(grepl("prosper", unique(status$process))))
    expect_false(any(grepl("px32COM10", unique(status$process))))


    wait_for_pxserver <- function(t = 90, ...) {
        sec = 1
        x <- sort(runif(t))
        pb <- txtProgressBar(...)
        for(i in c(0, x, 1)) {
            # cat(i)
            Sys.sleep(sec)
            setTxtProgressBar(pb, i)
        }
        Sys.sleep(1)
        close(pb)
        status <- read_openserver_status()
        expect_false(any(grepl("PxLs.exe", unique(status$process))))
        expect_false(any(grepl("pxserver", unique(status$process))))
    }

    # wait_for_pxserver(t = 360, style = 3)

})

