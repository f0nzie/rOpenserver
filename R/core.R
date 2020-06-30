#' OpenServer
#'
#' @description
#'
#' A registry is a collection of one or more metrics. By default, metrics are
#' added to the object returned by `global_openserver()`, but new registries can
#' also be created with `openserver()`. Use `collect_metrics()` to return all
#' metrics that a registry is aware of, or `render_metrics()` to render all of
#' them in aggregate.
#'
#'
#' @details
#'
#' `OpenServer` objects have methods, but they are not intended to be called by
#' users and have no stable API.
#'
#' @name openserver
#' @export
openserver <- function() {
  OpenServer$new()
}



#' @rdname openserver
#' @export
global_openserver <- function() {
  .openserver
}



OpenServer <- R6::R6Class(
  "OpenServer",
  public = list(
    initialize = function() {
      # TODO: This might work as a list column.
      private$metrics <- list()
      private$index <- data.frame(
        name = character(), type = character(), stringsAsFactors = FALSE,
        check.names = FALSE, check.rows = FALSE
      )
      private$collectors <- list()
    }
  ),

  private = list(
    index = NULL, metrics = NULL, collectors = NULL
  )

)






.openserver <- OpenServer$new()
