# Enable environment for allocation of S3 methods from R6
# these S3 methods will not be able to be tested during unit tests
# because of the environment where they are stored
R62S3::R62Fun(.OpenServer, assignEnvir = topenv(), mask = T)


.onAttach <- function(libname, pkgname) {
    packageStartupMessage("\n-----------------------------")
    packageStartupMessage(
        "\trOpenserver v",
        utils::packageVersion("rOpenserver"),
        "\n\nGet started:\t?rOpenserver")
    packageStartupMessage("-----------------------------\n")
}




