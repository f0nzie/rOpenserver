
#' Function that converts OpenServer raw vectors to R vectors
#'
#' Get openserver command and convert it to R object
#' @param oserver openserver object
#' @param cmd openserver command or variable
#' @export
rDoGet <- function(oserver, cmd) {
    res <- oserver$DoGet(cmd)
    if(class(res) == "list")    # it is a list because it is returning errors
        # 3004: "Variable name was not found"
        if (res[[1]] == 3012 || res[[1]] == 3004)
            return(NA)
    # convert list to vector
    res <- unlist(strsplit(oserver$DoGet(cmd), "|", fixed = TRUE))
    # find if vector is string or numeric
    if (suppressWarnings(all(is.na(as.numeric(res))))) {
        # it is a string. In OpenServer, usually a DATESTR or TIME
        return(res)
    } else {
        # it is numeric. Now, determine if it is integer or double.
        # when numeric object are greater than 1+e16, the modulus will throw warning
        if (suppressWarnings(all(as.numeric(res) %% 1 == 0))) {
            # it is an integer because there is not residual
            # use `suppressWarnings` to prevent warning `coercion to NA`
            return(suppressWarnings(as.integer(as.numeric(res))))
        } else {
            # it is a double
            return(as.double(as.numeric(res)))
        }
    }
}
