

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

#' Unzip MBAL model files
#'
#' Models were zipped because they were too big for the package
#' @export
#' @importFrom utils read.table unzip
unzip_mbal_models <- function() {
    mbal_models_loc <- system.file("models", package = "openserver")
    zip_files  <- paste(mbal_models_loc, "mbal_models.zip", sep = "/")
    unzip(zipfile = zip_files, exdir = mbal_models_loc)
}

#' Remove MBAL models from folder
#'
#' Use this after MBAL files have been unzipped to save disk
#' @export
remove_mbal_models <- function() {
    # remove MBAL files that were temporarily unzipped
    mbal_models_loc <- system.file("models", package = "openserver")
    file.remove(list.files(mbal_models_loc, pattern = ".mbi",
                           full.names = TRUE, ignore.case = TRUE))
}


zip_mbal_files <- function() {
    # to do
}



