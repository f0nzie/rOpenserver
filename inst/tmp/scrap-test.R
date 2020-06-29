library(rOpenserver)
prosper_server <- OpenServer$new()
var <- "PROSPER.ANL.VMT.Data[$].THpres"
raw_data <- prosper_server$DoGet(var)

res <- prosper_server$DoGet(var)
res
