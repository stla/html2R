#' @import shiny shinyAce shinythemes shinyjqui
NULL

ui <- function(html, theme, fontSize){

  fluidPage(
    theme = shinytheme("cyborg"),
    tags$head(
      tags$script(src = "wwwH2R/himalaya.js"),
      tags$script(src = "wwwH2R/html2R.js"),
      tags$link(rel = "stylesheet", href = "wwwH2R/html2R.css"),
      tags$link(rel = "stylesheet", href = "wwwH2R/particles.css")
      # tags$script(src = "wwwSP/bootstrap-flash-alert.js"),
      # tags$link(rel = "stylesheet", href = "wwwSP/animate.css"),
    ),

    if(html == ""){
      do.call(
        function(...) tags$div(id = "background", ...),
        rep(list(tags$div(class = "c")), 200L)
      )
    },

    br(),

    wellPanel(
      fluidRow(
        column(
          width = 12,
          fileInput(
            "file", label = NULL,
            buttonLabel = "Upload HTML file..."
          )
        )
      )
    ),

    fluidRow(
      column(
        width = 6,
        fluidRow(
          column(
            width = 6,
            h2(class = "header", "HTML code")
          ),
          column(
            width = 6,
            actionButton("parse", "Convert", class = "btn-danger btn-lg")
          )
        )
      ),
      column(
        width = 6,
        fluidRow(
          column(
            width = 6,
            h2(class = "header", "R code")
          ),
          column(
            width = 6,
            actionButton("copy", "Copy", class = "btn-danger btn-lg")
          )
        )
      )
    ),

    fluidRow(
      column(
        width = 6,
        jqui_resizable(
          aceEditor(
            "aceHTML",
            value = html,
            mode = "html",
            theme = theme,
            fontSize = fontSize,
            height = "calc(100vh - 169px - 10px)",
            tabSize = 2,
            placeholder = "Paste some HTML code here or upload a HTML file."
          ),
          options = list(handles = "s")
        )
      ),
      column(
        width = 6,
        jqui_resizable(
          aceEditor(
            "aceR",
            value = "",
            mode = "r",
            theme = theme,
            fontSize = fontSize,
            height = "calc(100vh - 169px - 10px)",
            tabSize = 2
          ),
          options = list(handles = "s")
        )
      )
    )
      )

}


server <- function(input, output, session){

  # observe(print(hh <<- head(input[["json"]],2)))

  observeEvent(input[["file"]], {
    updateAceEditor(
      session, "aceHTML",
      value = paste0(
        suppressWarnings(readLines(input[["file"]][["datapath"]])),
        collapse = "\n"
      )
    )
    updateAceEditor(
      session, "aceR", value = ""
    )
  }, priority = 2)

  observeEvent(input[["file"]], {
    session$sendCustomMessage("updateScrollBarH", "HTML")
  }, priority = 1)

  observeEvent(input[["json"]], {
    updateAceEditor(
      session, "aceR", value = parse_html(input[["json"]])
    )
  }, priority = 2)

  observeEvent(input[["json"]], {
    session$sendCustomMessage("updateScrollBarH", "R")
  }, priority = 1)

}

#' @title Launch the 'html2R' Shiny app
#' @description Shiny app allowing to convert HTML code to R code.
#' @param file path to a HTML file; can be missing
#' @param theme,fontSize options passed to
#'   \code{\link[shinyAce:aceEditor]{aceEditor}}
#' @export
#' @examples # launch the Shiny app without file ####
#' if(interactive()) html2R()
#'
#' # launch the Shiny app with a file ####
#' if(interactive()){
#'   html2R(system.file("example.html", package = "html2R"))
#' }
html2R <- function(file, theme = "cobalt", fontSize = 16){
  html <- if(missing(file)){
    ""
  }else{
    paste0(suppressWarnings(readLines(file)), collapse = "\n")
  }
  requireNamespace("shinyAce")
  requireNamespace("shinythemes")
  requireNamespace("shinyjqui")
  if(!"html2R" %in% .packages()) attachNamespace("html2R")
  shinyApp(ui(html, theme, fontSize), server)
}

