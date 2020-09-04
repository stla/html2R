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
  if(interactive()){
    packageStartupMessage(
      "Tip: you can vertically resize the editors by dragging their bottom border."
    )
  }
}

#' @importFrom shiny removeResourcePath
#' @noRd
.onDetach <- function(libpath){
  shiny::removeResourcePath("wwwH2R")
}
