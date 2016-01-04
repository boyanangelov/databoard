# loading required packages and dependencies
library(pacman)
p_load(shiny, shinydashboard, readr, dplyr, ggplot2, ggthemr, dygraphs, marketeR, forecast, Rfacebook)

# setting working directory
setwd("app/")

# loading source files
source('utils.R')
source('ui.R')
source('server.R')

# running the app
shinyApp(ui = ui, server = server)
