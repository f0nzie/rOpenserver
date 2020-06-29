
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


#' Convert from OpenServer text object to date
#'
#' Convert an OpenServer vector (string separated by '|') to a vector of dates
#' @param x an Openserver object
#' @param format use the as.Date formats
#' @export
openserver_to_date <- function(x, format = "%m/%d/%Y") {
    str_split <- unlist(strsplit(x, "|", fixed = TRUE))
    as.Date(str_split, format = format)
}
