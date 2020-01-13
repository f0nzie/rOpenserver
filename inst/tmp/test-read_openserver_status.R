library(testthat)
library(rOpenserver)

context("status")

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
prosper_server <- NULL
Sys.sleep(1)
prosper_server <- NULL
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
    expect_false(any(grepl("pxserver", unique(status$process))))
}

# wait_for_pxserver(t = 360, style = 3)

