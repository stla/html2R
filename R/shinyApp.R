#' @import shiny shinyAce shinythemes shinyjqui
NULL

ui <- function(html, theme, fontSize){

  fluidPage(
    theme = shinytheme("cyborg"),
    tags$head(
      tags$script(src = "wwwH2R/himalaya.js"),
      tags$script(src = "wwwH2R/html2R.js"),
      tags$link(rel = "stylesheet", href = "wwwH2R/html2R.css")
      # tags$script(src = "wwwSP/bootstrap-flash-alert.js"),
      # tags$link(rel = "stylesheet", href = "wwwSP/animate.css"),
      # tags$script(src = "wwwSP/shinyPrettier.js"),
      # tags$link(rel = "stylesheet", href = "wwwSP/shinyPrettier.css")
    ),

    br(),


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
            width = 12,
            h2(class = "header", "R code")
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
            height = "400px"
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
            height = "400px"
          ),
          options = list(handles = "s")
        )
      )
    )
  )

}


server <- function(input, output, session){

  observe(print(hh <<- head(input[["json"]],2)))

  observeEvent(input[["prettify"]], {
    session$sendCustomMessage(
      "code",
      list(code = input[["code"]], parser = parser)
    )
  })

  observeEvent(input[["json"]], {
    updateAceEditor(
      session, "aceR", value = parse_html(input[["json"]])
    )
    # if(input[["prettyCode"]] != ""){
    #   flashMessage <- list(
    #     message = "Pretty code copied to the clipboard",
    #     title = "Copied!",
    #     type = "success",
    #     icon = "glyphicon glyphicon-check",
    #     withTime = TRUE
    #   )
    #   session$sendCustomMessage("flash", flashMessage)
    # }
  })

  observeEvent(input[["prettifyError"]], {
    flashMessage <- list(
      message = "Prettifier has failed",
      title = "Error!",
      type = "danger",
      icon = "glyphicon glyphicon-flash",
      withTime = TRUE,
      animShow = "rotateInDownLeft",
      animHide = "bounceOutRight",
      position = list("bottom-left", list(0, 0.01))
    )
    session$sendCustomMessage("flash", flashMessage)
  })

  output[["error"]] <- renderPrint({
    cat(input[["prettifyError"]])
  })

}

#' @export
html2R <- function(file, theme = "cobalt", fontSize = 16){
  if(!missing(file)){
    html <- paste0(readLines(file), collapse = "\n")
  }
  requireNamespace("shiny")
  requireNamespace("shinyAce")
  requireNamespace("shinythemes")
  requireNamespace("shinyjqui")
  if(!isNamespaceLoaded("html2R")) attachNamespace("html2R")
  shinyApp(
    ui(html, theme, fontSize),
    server
  )
}

