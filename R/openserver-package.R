#' @keywords internal
"_PACKAGE"







#' @title COM Reference call
#'
#' @description Call COM client reference function
#'
#' @param ref the reference to pass
#' @param className the name of the class
#' @export
#' @keywords internal
#' @import RDCOMClient
createCOMReference <- function(ref, className) {
    RDCOMClient::createCOMReference(ref, className)
}


