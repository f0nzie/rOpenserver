
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rOpenserver

The goal of `rOpenserver` is to provide an R interface to Petex
applications Prosper, GAP and MBAL.

## Installation

You can install the *development* version of `rOpenserver` from GtiHub
with:

``` r
install.packages("devtools")
devtools::install_github("f0nzie/rOpenserver", dependencies = TRUE)
```

Set the folder where the Prosper examples are. Use slash `/` or
double-backslash `\\` to separate the folder names, otherwise you will
get error.

``` r
# point to the well model
prosper_folder = "C:/Program Files (x86)/Petroleum Experts/IPM 10/Samples/prosper"
model_file <- "T00_Integrated_Oil_Well.Out"
model_filename <- file.path(prosper_folder, model_file)
file.exists(model_filename)
#> [1] TRUE
```

# Prosper example: read reservoir pressure and temperature

This short example will read some values from the Reservoir pressure and
temperature from a model residing in the Examples folder:
`T00_Integrated_Oil_Well.Out`.

``` r
# load OpenServer
library(rOpenserver)


# Initialize OpenServer
prosper_server <- OpenServer()

# Start Prosper
cmd = "PROSPER.START"
prosper_server$DoCmd(cmd)
#> [1] 0

# point to the well model
prosper_folder = "C:\\Program Files (x86)\\Petroleum Experts\\IPM 10\\Samples\\prosper"
model_file <- "T00_Integrated_Oil_Well.Out"
model_filename <- file.path(prosper_folder, model_file)
file.exists(model_filename)
#> [1] TRUE

# open Prosper model
open_cmd <- "PROSPER.OPENFILE"
open_cmd <- paste0(open_cmd, "('", model_filename, "')")
prosper_server$DoCmd(open_cmd)
#> [1] 0


# get reservoir pressure
cmd <- "PROSPER.SIN.IPR.Single.Pres"
prosper_server$DoGet(cmd)
#> [1] "5200.000000000"

# get reservoir temperature
cmd <- "PROSPER.SIN.IPR.Single.Tres"
prosper_server$DoGet(cmd)
#> [1] "210.000000000"

# [1] "1582.449951172"
# [1] "146.667008038"


# shutdown Prosper
command = "PROSPER.SHUTDOWN"
prosper_server$DoCmd(command)
#> [1] 0
prosper_server <- NULL
```
