library(dplyr)

oserver_methods <- c("server", ".__enclos_env__", "clone", "app_name",
                     "DoSet", "DoGet", "DoCmd", "initialize", "DoSlowCmd",
                     "DoGAPFunc")

get_model_from_pkg <- function(mod_num = 1, ext = c("out", "gap", "mbi")) {
    app_dir <- system.file("models", package = "rOpenserver")
    models <- list.files(app_dir, pattern = paste0("*.", ext), ignore.case = TRUE)
    model <- models[mod_num]  # the first
    file <- file.path(app_dir, model)
    if (!file.exists(file)) stop("Model not found ...") else
        return(file)

}

get_all_models_by_ext <- function(ext = c("out", "gap", "mbi")) {
    app_dir <- system.file("models", package = "rOpenserver")
    full_name <- list.files(app_dir, pattern = paste0("*.", ext),
                              ignore.case = TRUE, full.names = TRUE)
    base_name <- basename(full_name)
    # very important to sort but first convert to lowercase
    arrange(data.frame(base_name = base_name, full_name = full_name,
                       stringsAsFactors = FALSE),
            tolower(base_name))


}
