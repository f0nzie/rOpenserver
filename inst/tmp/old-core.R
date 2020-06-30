# library(RDCOMClient)
# library(R6)

#' @export
createCOMReference <- function(ref, className) {
    RDCOMClient::createCOMReference(ref, className)
}

#' @import R6
.OpenServer <- R6::R6Class("OpenServer",
       lock_objects = FALSE,
       public = list(
           app_name = NULL,
           # create a COM connection to OpenServer
           initialize = function(server = NULL) {
               if (is.null(server))
                   self$server <- RDCOMClient::COMCreate("PX32.OpenServer.1")
               else
                   self$server <- server
           },
           # send commands to IPM OpenServer
           DoCmd = function(command) {
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
           },
           DoSlowCmd = function(command) {
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
           },
           # get a value from an OpenServer variable
           DoGet = function(variable) {
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
           },
           # set a value to an OpenServer variable
           DoSet = function(variable, set_value = NULL) {
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
           },
           DoGAPFunc = function(Gv) {
               self$DoSlowCmd(Gv)
               ret_get <- self$DoGet("GAP.LASTCMDRET")
               last_error <- self$server$GetLastError("GAP")
               if (last_error > 0) {
                   error_description <- self$server$GetErrorDescription(last_error)
                   err = list(last_error, error_description)
                   return(err)
               }
               return(ret_get)
           }
       ),
       private = list(
           # get the IPM application name and validate
           get_app_name = function(string_value) {
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
           }
       ))


#' Openserver function
#' WIll call class
#' @param server an existing OpenServer instance
#' @aliases createCOMReference
#' @export
OpenServer <- function(server = NULL) {
    oserver <- .OpenServer$new(server)
    return(oserver)
}




