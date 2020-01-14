#-------------------------------------------------------------
# OpenServer Documentation
#-------------------------------------------------------------
#' @title R6 class for OpenServer object
#'
#' @description A class to create OpenServer objects
#'
#' @name OpenServer
#'
#' @section Constructor: OpenServer$new(server = NULL)
#'
#' @section Public Methods:
#' \tabular{ll}{
#' \strong{Parameters Methods} \tab \strong{Link} \cr
#' \code{DoCmd()} \tab \code{\link{DoCmd}} \cr
#' \code{DoGet()} \tab \code{\link{DoGet}} \cr
#' \code{DoSet()} \tab \code{\link{DoSet}} \cr
#' \code{DoSlowCmd()} \tab \code{\link{DoSlowCmd}} \cr
#' \code{DoGAPFunc()} \tab \code{\link{DoGAPFunc}} \cr
#' \code{setOpenServer()} \tab \code{\link{setOpenServer}} \cr
#' }
#'
#'
#' @return Returns R6 object of class OpenServer
#'
#' @export
NULL
#-------------------------------------------------------------
# OpenServer Definition
#-------------------------------------------------------------
OpenServer <- R6::R6Class("OpenServer", lock_objects = FALSE)


#-------------------------------------------------------------
# Public Methods - Constructor
#-------------------------------------------------------------
OpenServer$set("public","initialize", function(server = NULL) {
  if (is.null(server))
    self$server <- RDCOMClient::COMCreate("PX32.OpenServer.1")
  else
    self$server <- server
})


#-------------------------------------------------------------
# OpenServer - Public Methods
#-------------------------------------------------------------
#' @name DoCmd
#' @title Send an OpenServer command
#' @usage DoCmd(object, command)
#' @section R6 Usage: $DoCmd()
#' @param object OpenServer object
#' @param command command to send
#' @export
NULL
OpenServer$set("public","DoCmd",function(command) {
  app_name <- private$get_app_name(command)
  ret_cmd <- self$server$DoCommand(command)
  last_error <- self$server$GetLastError(app_name)
  if (last_error > 0) {
    error_description <- self$server$GetErrorDescription(last_error)
    err = list(last_error, error_description)
    return(err)
  }
  else
    return(ret_cmd)
})


#' @name DoGet
#' @title Get a value from an OpenServer variable
#' @usage DoGet(object, variable)
#' @section R6 Usage: $DoGet()
#' @param variable OpenServer variable
#' @param object OpenServer object
#' @export
NULL
# get a value to an OpenServer variable
OpenServer$set("public","DoGet",function(variable) {
  app_name <- private$get_app_name(variable)
  ret_get <- self$server$GetValue(variable)
  last_error <- self$server$GetLastError(app_name)
  if (last_error > 0) {
    error_description <- self$server$GetErrorDescription(last_error)
    err = list(last_error, error_description)
    return(err)
  }
  else
    return(ret_get)
})

#' @name DoSet
#' @title Set a value to an OpenServer variable
#' @usage DoSet(object, variable, set_value)
#' @section R6 Usage: $DoSet()
#' @param variable OpenServer variable
#' @param set_value value to set to OpenServer variable
#' @param object OpenServer object
#' @export
NULL
# set a value to an OpenServer variable
OpenServer$set("public","DoSet",function(variable, set_value = NULL) {
  app_name <- private$get_app_name(variable)
  ret_set <- self$server$SetValue(variable, set_value)
  last_error <- self$server$GetLastError(app_name)
  if (last_error > 0) {
    error_description <- self$server$GetErrorDescription(last_error)
    err = list(last_error, error_description)
    return(err)
  }
  else
    return(ret_set)
})


#' @name DoSlowCmd
#' @title Send a command with a delay
#' @usage DoSlowCmd(object, command)
#' @section R6 Usage: $DoSlowCmd()
#' @param command OpenServer command
#' @param object OpenServer object
#' @export
NULL
#
OpenServer$set("public","DoSlowCmd",function(command) {
  step <-  0.001
  app_name   <- private$get_app_name(command)
  last_error <- self$server$DoCommandAsync(command)
  if (last_error > 0) {
    error_description <- self$server$GetErrorDescription(last_error)
    err = list(last_error, error_description)
    return(err)
  }
  while(self$server$IsBusy(app_name) > 0) {
    if (step < 2)
      step <- step * 2
    start_time <- Sys.time()
    end_time <- start_time + step
    bLoop = TRUE
    while (bLoop) {
      current_time <- Sys.time()
      bLoop <- TRUE
      if (current_time < start_time)
        bLoop <- FALSE
      else if (current_time > end_time)
        bLoop <- FALSE
    }
  }
  app_name <- private$get_app_name(command)
  last_error <- self$server$GetLastError(app_name)
  if (last_error > 0) {
    error_description <- self$server$GetErrorDescription(last_error)
    err = list(last_error, error_description)
    return(err)
  }
  else
    return(last_error)
})

#' @name DoGAPFunc
#' @title Run a GAP function
#' @usage DoGAPFunc(object, Gv)
#' @section R6 Usage: $DoGAPFunc()
#' @param Gv GAP variable
#' @param object OpenServer object
#' @export
NULL
#
OpenServer$set("public","DoGAPFunc",function(Gv) {
  self$DoSlowCmd(Gv)
  ret_get <- self$DoGet("GAP.LASTCMDRET")
  last_error <- self$server$GetLastError("GAP")
  if (last_error > 0) {
    error_description <- self$server$GetErrorDescription(last_error)
    err = list(last_error, error_description)
    return(err)
  }
  return(ret_get)
})



#-------------------------------------------------------------
# OpenServer Private Methods
#-------------------------------------------------------------
OpenServer$set("private","get_app_name",function(string_value) {
  string_value <- toupper(string_value)
  pos <- regexpr(".", string_value, fixed = TRUE)
  if (pos < 2) {
    print("ERROR: BAD STRING")
    return(FALSE)
  }
  app_name <- substring(string_value, 1, pos-1)
  # these are the valid IPM applications for now
  if ((!app_name == "PROSPER") &&
      (!app_name == "GAP") &&
      (!app_name == "MBAL"))
  {
    print("ERROR: APP NOT RECOGNIZED")
    return(FALSE)
  }
  else
    self$app_name <- app_name
  return(app_name)
})


#-------------------------------------------------------------
# OpenServer Public Variables
#-------------------------------------------------------------
OpenServer$set("public","app_name",NULL)



#-------------------------------------------------------------
# Functions - OpenServer Constructor
#-------------------------------------------------------------
#' @name setOpenServer
#' @title Another Openserver constructor without using `$new()`
#' @description  Call class
#' @param server an existing OpenServer instance
#' @export
setOpenServer <- function(server = NULL) {
  return(OpenServer$new(server))
}




#' @title COM Reference call
#'
#' @description Call COM client reference function
#'
#' @param ref the reference to pass
#' @param className the name of the class
#' @export
#' @keywords internal
createCOMReference <- function(ref, className) {
  RDCOMClient::createCOMReference(ref, className)
}
