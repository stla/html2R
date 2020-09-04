#' @importFrom shiny registerInputHandler addResourcePath
#' @noRd
.onAttach <- function(libname, pkgname){
  shiny::registerInputHandler("html2R.list", function(data, ...){
    data
  }, force = TRUE)
  shiny::addResourcePath(
    "wwwH2R",
    system.file("www", package = "html2R")
  )
}

#' @importFrom shiny removeResourcePath
#' @noRd
.onDetach <- function(libpath){
  shiny::removeResourcePath("wwwH2R")
}
