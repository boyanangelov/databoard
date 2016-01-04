# UI ----------------------------------------------------------------------

header <- dashboardHeader(
    title = "Databoard"
)

sidebar <- dashboardSidebar(
    sidebarMenu(
        menuItem("Data Visualisation", tabName = "data_visualisation", icon = icon("dashboard")),
        menuItem("Predictions", tabName = "predictions", icon = icon("area-chart"))
    ),
    
    dateRangeInput('dateRange',
                   label = 'Date range input: yyyy-mm-dd',
                   start = Sys.Date() - 2, end = Sys.Date() + 2
    ),
    
    fileInput('file1', 'Choose CSV File',
              accept=c('text/csv', 
                       'text/comma-separated-values,text/plain', 
                       '.csv')),
    checkboxInput('header', 'Header', TRUE),
    radioButtons('sep', 'Separator',
                 c(Comma=',',
                   Semicolon=';',
                   Tab='\t'),
                 ',')
)

body <- dashboardBody(
    tags$body(
        tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"),
        tags$script(rel = "javascript", href = "custom.js")),
    
    tabItems(
        tabItem(tabName = "data_visualisation",
                fluidRow(
                    box(
                        title = "Interactive Graphs",
                        width = 12,
                        dygraphOutput("time_series")
                    )
                ),
                fluidRow(
                  box(
                      plotOutput("visualisations"),
                      width = 12
                  )  
                )
            ),
        tabItem(tabName = "predictions",
                fluidRow(
                    box(
                        title = "Predictions",
                        width = 12,
                        plotOutput('forecasts')
                    )
                )
            )
        )
    )


ui <- dashboardPage(header, sidebar, body)
