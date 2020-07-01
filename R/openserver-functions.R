#-------------------------------------------------------------
# Functions - OpenServer Constructor
#-------------------------------------------------------------

#' @name setOpenServer
#' @title Another Openserver constructor without using `$new()`
#' @description  Call class
#' @param server an existing OpenServer instance
#'
#' @family server-side items
#' @export
setOpenServer <- function(server = NULL) {
    .OpenServer$new(server)
}


#' @name newOpenServer
#' @title Another Openserver constructor without using `$new()`
#' @description  Call class
#' @param server an existing OpenServer instance
#'
#' @family server-side items
#' @export
newOpenServer <- function(server = NULL) {
    .OpenServer$new(server)
}


#' @name openserver
#' @title Openserver constructor without using `$new()`
#' @description  Another Openserver constructor. Same as
#' @param server an existing OpenServer instance
#'
#' @family server-side items
#' @export
openserver <- function(server = NULL) {
    .OpenServer$new(server)
}


