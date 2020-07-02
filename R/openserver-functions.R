#-------------------------------------------------------------
# Functions - OpenServer Constructor
#-------------------------------------------------------------

#' @name setOpenServer
#' @title OpenServer constructor
#' @description  Openserver constructor that saves typing
#' \code{.OpenServer$new()}.
#' @param server pass an existing OpenServer instance
#'
#' @family server-side items
#' @export
setOpenServer <- function(server = NULL) {
    .OpenServer$new(server)
}


#' @name newOpenServer
#' @title OpenServer constructor
#' @description  Openserver constructor that saves typing
#' \code{.OpenServer$new()}.
#' @param server pass an existing OpenServer instance
#'
#' @family server-side items
#' @export
newOpenServer <- function(server = NULL) {
    .OpenServer$new(server)
}


#' @name openserver
#' @title OpenServer constructor
#' @description  Openserver constructor that saves typing
#' \code{.OpenServer$new()}. This is used in rProsper.
#' @param server an existing OpenServer instance
#'
#' @family server-side items
#' @export
openserver <- function(server = NULL) {
    .OpenServer$new(server)
}


