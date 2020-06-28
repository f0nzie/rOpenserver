
#' Read the status of OpenServer and IPM objects
#'
#' Create a dataframe with the count of OpenServer and IPM objects
#' @param verbose indicate if we want live printing
#' @importFrom utils read.table
#' @export
read_openserver_status <- function(verbose = FALSE) {
    # after shutdown Prosper and px32COM dissapear from processes
    # pxserver
    try_reading_table <- function(process) {
        #
        tryCatch(read.table(text = as.character(process), strip.white=TRUE,
                            header = FALSE, stringsAsFactors = FALSE),
                 error = function(e) {
                     e
                     return()
                 }
        )
    }

    task_row <- data.frame(process = as.character(), pid = as.integer(),
                           type = as.character(), session_id = as.character(),
                           memory_ws = as.integer(), memory_uom = as.character())

    tasklists <- system2( 'tasklist' , stdout = TRUE )
    call_system <- system('tasklist', intern=TRUE)

    ipm_objects <- c("prosper", "gap", "mbal", "pxserver", "PxLs", "px32COM",
                     "pvtp", "resolve")

    row <- vector("list")
    df <- data.frame()
    for (ipm_obj in ipm_objects) {
        txt  <- grep(paste0("^", ipm_obj),
                     readLines(textConnection(call_system)),
                     value = TRUE, ignore.case = TRUE)
        tbl <- try_reading_table(txt)
        if (verbose) cat(ipm_obj, length(tbl), dim(tbl), "\n")
        # if ( ((is.null(tbl)) || (dim(tbl)[2] < 6)) ) {
        if (! length(tbl) < 6) {
            # print(tbl)
            df <- rbind(df, tbl)
        }
    }
    if (nrow(df) == 0) {
        # no rows in dataframe
        df <- task_row
    } else {
        names(df) <- names(task_row)
    }
    df
}
