#' @importFrom shiny registerInputHandler addResourcePath
#' @importFrom jsonlite fromJSON toJSON
#' @noRd
.onAttach <- function(libname, pkgname){
  shiny::registerInputHandler("html2R.list", function(data, ...){
    jsonlite::fromJSON(
      jsonlite::toJSON(data, auto_unbox = TRUE),
      simplifyDataFrame = FALSE
    )
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
