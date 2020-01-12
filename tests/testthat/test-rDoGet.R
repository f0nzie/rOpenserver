library(testthat)
library(openserver)

context("rDoGet returning character vectors")

# Initialize OpenServer
prosper_server <- OpenServer()

# Start Prosper
cmd = "PROSPER.START"
prosper_server$DoCmd(cmd)

# point to the well model
prosper_folder <- system.file("models", package = "rProsper")
model_file     <- "T33-GLQL_TSENS-1OP_LS.Out"
model_filename <- file.path(prosper_folder, model_file)
file.exists(model_filename)

# open Prosper model
open_cmd <- "PROSPER.OPENFILE"
open_cmd <- paste0(open_cmd, "('", model_filename, "')")
prosper_server$DoCmd(open_cmd)

# get reservoir pressure
cmd <- "PROSPER.SIN.IPR.Single.Pres"
expect_equal(as.double(prosper_server$DoGet(cmd)), 3475)

# the Well name is empty
cmd <- "PROSPER.SIN.SUM.Well"
expect_equal(class(prosper_server$DoGet(cmd)), "character")

# if well is emptyit will return length equal zero
cmd <- "PROSPER.SIN.SUM.Well"
expect_equal(length(rDoGet(prosper_server, cmd)), 0)

# a numeric vector with MD
cmd <- "PROSPER.SIN.EQP.Devn.Data[$].Md"
expect_equal(length(rDoGet(prosper_server, cmd)), 6)
expect_true(is.numeric(rDoGet(prosper_server, cmd)))

# an empty character vector. Downhole Equipment labels
cmd <- "PROSPER.SIN.EQP.Down.Data[0].Label"
expect_equal(length(rDoGet(prosper_server, cmd)), 0)

# shutdown Prosper
command = "PROSPER.SHUTDOWN"
prosper_server$DoCmd(command)
prosper_server <- NULL
