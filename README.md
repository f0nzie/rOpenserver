
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rOpenserver

The goal of `rOpenserver` is to provide an **R** interface to Petex
applications Prosper, GAP and MBAL to perform automated tasks, create
datasets for statistical analysis, and advanced control of solvers and
calculations.

## Installation

`rOpenserver` is not in [CRAN](https://cran.r-project.org/) yet but in
the meantime, you can install it from GtiHub, from the [rOpenserver
repository](https://github.com/f0nzie/rOpenserver) with:

``` r
install.packages("devtools")
devtools::install_github("f0nzie/rOpenserver", dependencies = TRUE)
```

The argument `dependencies` has the role of downloading and installing
packages that are key for rOpenserver, such as `R6` and `RDCOMClient`.

## Indicating files and folders

In R, as in Python or any other programming languages, there are some
conventions to deal with the filenames and folder or directories. In
Windows, we should use a double-backslash to separate the paths. In Unix
operating systems, like Linux and MacOS, we use a single slash.

For instance, in the following example, we set the folder where
typically the Prosper examples are. Then , we use slash `/` or the
double-backslash `\\` to separate the folder names, otherwise you will
get error. We use both ways in the following two code blocks.

``` r
# point to the well model
prosper_folder = "C:/Program Files (x86)/Petroleum Experts/IPM 10/Samples/prosper"
model_file <- "T00_Integrated_Oil_Well.Out"
model_filename <- file.path(prosper_folder, model_file)
file.exists(model_filename)
#> [1] TRUE
```

## Prosper example: read reservoir pressure and temperature

This short example will read some values from the Reservoir pressure and
temperature from a model residing in the Examples folder:
`T00_Integrated_Oil_Well.Out`.

``` r
# load OpenServer
library(rOpenserver)


# Initialize OpenServer
prosper_server <- OpenServer$new()

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
DoCmd(prosper_server, open_cmd)
#> [1] 0


# get reservoir pressure
cmd <- "PROSPER.SIN.IPR.Single.Pres"
prosper_server$DoGet(cmd)
#> [1] "5200.000000000"

# get reservoir temperature
cmd <- "PROSPER.SIN.IPR.Single.Tres"
DoGet(prosper_server, cmd)           # S3 class: another way of getting values
#> [1] "210.000000000"


# shutdown Prosper
Sys.sleep(3)
command = "PROSPER.SHUTDOWN"
prosper_server$DoCmd(command)
#> [1] 0
prosper_server <- NULL
```

## Uses of `rOpenserver`

The previous example just shows a spark of the functionality of
`rOpenserver`: of starting Prosper, opening a well model, read values
from it, and close Prosper. This is what we call an **instance**. There
are plenty more examples that make use of `rOpenserver`. During my years
as Production Engineer working on well models and optimization we
practically had endless use for this interface. Okay, you could call it
a **data science** oriented solution, but not all is really data
science. The use cases go beyond that. Let me cite a few, just for
**Prosper**:

  - Batch automation for reading all the Prosper well models residing in
    your disk, or the network drive

  - Convert all the well models in Prosper to a reactangular dataset,
    very much like an Excel spreadsheet, a dataframe, which is a more
    powerful data structure for performing data analysis

  - Perform an inventory of all the fluid properties correlations that
    work in your field

  - Read specific variables inside the well models and presenting them
    in dataframes

  - Perform statistical analysis of missing values and outliers across
    all the variables that were entered in the well model

  - Treat the well models as observations (rows) instead of binary
    files, where the well properties are the variables or features.

  - Extract well variables for a particular well system, such as well
    tests, bottomhole data, correlation curves, pressure and temperature
    at depth, gas lift properties, or any other artificial lift method

  - Perform corrections of well data in batch, always keeping in mind
    that each well is a row, not a file

  - Export the well model from binary to CSV or another format of your
    preference. Excel, maybe.

  - Find and diagnose quicker a well model that refuses to run

  - Perform the calibration of the well model in an automated fashion

  - Connect the well model using a unique identifier to the master
    production database of the company

  - Use R as a common platform to connect the well models to SQL queries
    of the company production database

  - Reduce drastically the time of calibrating all the well model with
    new well test data, from months to weeks, or even days

  - Run multiple instances of Prosper to analyze wells that have
    multiple strings, such as dual gas wells: one Prosper instance for
    the Short string, and a second instance for the Long string
