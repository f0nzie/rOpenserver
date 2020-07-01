#' @title OpenServer class
#'
#' @description The OpenServer class contains functions that communicate
#' with Petroleum Experts applications such as Prosper, GAP and MBAL. The
#' function send commands, retrieve data and write data to OpenServer
#' variables exposed by the Windows COM interface.
#'
#' @family server-side items
#' @docType class
#' @import R6
#' @export
.OpenServer <- R6::R6Class(
    ".OpenServer",
    lock_objects = FALSE,
    public = list(
        app_name = NULL,

        #' @description Create new DSLiteServer instance. function for including
        #' when discovering the DataSHIELD configuration from the DataSHIELD
        #' @param server The DataSHIELD configuration. Default is to discover
        #' @return A DSLiteServer object
        initialize = function(server = NULL) {
            if (is.null(server))
                self$server <- RDCOMClient::COMCreate("PX32.OpenServer.1")
            else
                self$server <- server
        },

        #' @title Send an OpenServer command
        #' @section R6 Usage: $DoCmd()
        #' @param command command to send
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

        # get a value from an OpenServer variable
        #' @title Get a value from an OpenServer variable
        #' @section R6 Usage: $DoGet()
        #' @param variable OpenServer variable
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
        #' @title Set a value to an OpenServer variable
        #' @section R6 Usage: $DoSet()
        #' @param variable OpenServer variable
        #' @param set_value value to set to OpenServer variable
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
                invisible(ret_set)
        },

        #' @title Send a command with a delay
        #' @section R6 Usage: $DoSlowCmd()
        #' @param command OpenServer command
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

        #' @title Run a GAP function
        #' @section R6 Usage: $DoGAPFunc()
        #' @param Gv GAP variable
        DoGAPFunc = function(Gv) {
            self$DoSlowCmd(Gv)
            ret_get <- self$DoGet("GAP.LASTCMDRET")
            last_error <- self$server$GetLastError("GAP")
            if (last_error > 0) {
                error_description <- self$server$GetErrorDescription(last_error)
                err = list(last_error, error_description)
                return(err)
            }
            invisible(ret_get)
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
    )
)




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

#' @name DoGet
#' @title Get a value from an OpenServer variable
#' @usage DoGet(object, variable)
#' @section R6 Usage: $DoGet()
#' @param variable OpenServer variable
#' @param object OpenServer object
#' @export
NULL

#' @name DoSet
#' @title Set a value to an OpenServer variable
#' @usage DoSet(object, variable, set_value)
#' @section R6 Usage: $DoSet()
#' @param variable OpenServer variable
#' @param set_value value to set to OpenServer variable
#' @param object OpenServer object
#' @export
NULL

#' @name DoSlowCmd
#' @title Send a command with a delay
#' @usage DoSlowCmd(object, command)
#' @section R6 Usage: $DoSlowCmd()
#' @param command OpenServer command
#' @param object OpenServer object
#' @export
NULL

#' @name DoGAPFunc
#' @title Run a GAP function
#' @usage DoGAPFunc(object, Gv)
#' @section R6 Usage: $DoGAPFunc()
#' @param Gv GAP variable
#' @param object OpenServer object
#' @export
NULL


#' OpenServer class
#'
#' Instantiate the main class .OpenServer
#'
#' @docType class
#' @import R6
#'
#' @export
OpenServerR6 <- R6::R6Class(
    classname = "OpenServerR6",
    lock_objects = FALSE,
    inherit = .OpenServer
)



