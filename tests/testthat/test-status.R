library(testthat)
library(rOpenserver)


sleep_well <- function(seconds = 1.0) {
    date_time <- Sys.time()
    seconds <- as.numeric(seconds)
    while((as.numeric(Sys.time()) - as.numeric(date_time)) < seconds) {}
}

context("OpenServer Windows processes")

test_that("Windows processes are captured", {
    # Initialize OpenServer
    prosper_server <- OpenServer$new()

    # Start Prosper
    cmd = "PROSPER.START"
    prosper_server$DoCmd(cmd)

    verbose <- FALSE
    status <- read_openserver_status(verbose = verbose)  # status dataframe

    # print(unique(status$process))
    expect_true(any(grepl("prosper", unique(status$process))))
    expect_true(any(grepl("px32COM10", unique(status$process))))

    #Sys.sleep(2)
    cmd = "PROSPER.SHUTDOWN"
    prosper_server$DoCmd(cmd)

    # tests that after shutdown some processes remain
    status <- read_openserver_status()
    if (verbose) print(status)
    sleep_well(5)
    expect_true(any(grepl("pxserver.exe", unique(status$process))))
    expect_true(any(grepl("PxLs.exe", unique(status$process))))
    expect_true(any(grepl("px32COM10.exe", unique(status$process))))

    # couple of processes remain after NULL
    prosper_server <- NULL
    status <- read_openserver_status()
    if (verbose) print(status)
    expect_true(any(grepl("pxserver.exe", unique(status$process))))
    expect_true(any(grepl("PxLs.exe", unique(status$process))))

    # test if anything remains after deleting object
    Sys.sleep(2)
    # prosper_server <- NULL
    rm(prosper_server)
    status <- read_openserver_status()
    if (verbose) print(status)
    expect_true(any(grepl("pxserver.exe", unique(status$process))))
    expect_true(any(grepl("PxLs.exe", unique(status$process))))
    expect_false(any(grepl("prosper", unique(status$process))))
    expect_false(any(grepl("px32COM10", unique(status$process))))

    # wait for PxLs.exe process to shut
    wait_for_pxserver <- function(t = 90, ...) {
        x <- sort(runif(t))
        pb <- txtProgressBar(...)
        for(i in c(0, x, 1)) {
            # 1 second delay: Sys.sleep() will not work here
            date_time <- Sys.time()
            while((as.numeric(Sys.time()) - as.numeric(date_time)) < 1.0) {}
            setTxtProgressBar(pb, i)
        }
        close(pb)
        status <- read_openserver_status()
        expect_false(any(grepl("PxLs.exe", unique(status$process))))
        expect_false(any(grepl("pxserver", unique(status$process))))
    }

    wait_for_pxserver(t = 27, style = 3)
})

