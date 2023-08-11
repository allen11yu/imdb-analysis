library("shiny")
library("dplyr")
library("shinyjs")
library("ggplot2")
library("plotly")

source("app_ui.R")
source("app_server.R")

shinyApp(ui = ui, server = server)
