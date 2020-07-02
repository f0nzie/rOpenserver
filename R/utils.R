

#' Take objects and create a list using their names
#'
#' This avoids retyping the name of the object as in a list
#'
#' @param ... any additional parameters
#' @importFrom stats setNames
#' @keywords internal
#' @export
named.list <- function(...) {
    nl <- setNames( list(...) , as.character( match.call()[-1]) )
    # nl <- setNames( list(...) , as.character( match.call()[-1]) )
    nl
}



#' Unzip model pack
#'
#' Models were zipped because they were too big for the package
#'
#' @param zip_file zipped file to unpack
#'
#' @export
#' @importFrom utils read.table unzip
unzip_model_pack <- function(zip_file) {
    zip_models_loc <- system.file("models", package = "rOpenserver")
    zip_file_path  <- file.path(zip_models_loc, zip_file)
    if (!file.exists(zip_file_path)) stop("file does not exist")
    unzip(zipfile = zip_file_path, exdir = zip_models_loc)
}

#' Remove models by extension
#'
#' Use this after models files have been unzipped to save disk space
#'
#' @param ext extension of the files
#'
#' @export
remove_models_by_ext <- function(ext = c("out", "gap", "mbi")) {
    # remove files that were temporarily unzipped
    pkg_models_loc <- system.file("models", package = "rOpenserver")
    file.remove(list.files(pkg_models_loc, pattern = paste0("*.", ext),
                           full.names = TRUE, ignore.case = TRUE))
}


#' Remove all models sparing zip files
#'
#' Use this to remove model files keeping the zip file
#'
#' @export
remove_models_but_zip <- function() {
    #
    pkg_models_loc <- system.file("models", package = "rOpenserver")
    all_files <- list.files(pkg_models_loc, full.names = TRUE, ignore.case = TRUE)
    exclude <- list.files(pkg_models_loc, pattern = "*.zip", full.names = TRUE, ignore.case = TRUE)
    not_zip <- setdiff(all_files, exclude)
    file.remove(not_zip)
}




