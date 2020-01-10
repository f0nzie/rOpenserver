

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
#' @importFrom utils unzip
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


#' Convert from OpenServer text object to double
#'
#' Convert an OpenServer vector (string separated by '|') to a vector of double
#' @param x an Openserver object
#' @export
openserver_to_double <- function(x) {
    as.double(unlist(strsplit(x, "|", fixed = TRUE)))
}

#' Convert from OpenServer text object to integer
#'
#' Convert an OpenServer vector (string separated by '|') to a vector of integers
#' @param x an Openserver object
#' @export
openserver_to_integer <- function(x) {
    as.integer(unlist(strsplit(x, "|", fixed = TRUE)))
}

#' Convert from OpenServer text object to character
#'
#' Convert an OpenServer vector (string separated by '|') to a vector of character
#' @param x an Openserver object
#' @export
openserver_to_character <- function(x) {
    unlist(strsplit(x, "|", fixed = TRUE))
}

