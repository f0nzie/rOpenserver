

oserver_methods <- c("server", ".__enclos_env__", "clone", "app_name",
                     "DoSet", "DoGet", "DoCmd", "initialize", "DoSlowCmd",
                     "DoGAPFunc")

get_model_from_pkg <- function(mod_num = 1, ext = c("out", "gap", "mbi")) {
    app_dir <- system.file("models", package = "rOpenserver")
    model <- list.files(app_dir, pattern = paste0("*.", ext), ignore.case = TRUE)[mod_num]   # the first
    file <- file.path(app_dir, model)
    if (!file.exists(file)) stop("Model not found ...") else
        return(file)

}
