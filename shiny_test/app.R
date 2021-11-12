# Stakeholder map project - Shiny App
#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
# http://shiny.rstudio.com/
#

# ----- load libraries -----
library(shiny)
library(tidyverse)
library(googlesheets4)
library(leaflet)

# usecairo = T from package Cairo for better quality of figures in shiny app
options(shiny.usecairo=T)

# ----- authorisations -----
# for GitHub Action (adapted from https://github.com/jdtrat/tokencodr-google-demo)
source("R/func_auth_google.R")

# Authenticate Google Service Account (adapted from https://github.com/jdtrat/tokencodr-google-demo)
auth_google(email = "*@talarify.co.za",
            service = "MY_GOOGLE",
            token_path = ".secret/MY_GOOGLE")

###### ---------- READ DATA FROM GOOGLE SHEET ---------- ######
locations <-
    read_sheet(
        "https://docs.google.com/spreadsheets/d/1Yjb5fknNzrhkHVtK6ca_dagobsQ1hwIVI4beXLWJOt4/edit#gid=628522158",
        sheet = "Organisation_locations"
    )

# ----- load data -----
# Read in Google Sheet data
ss = "https://docs.google.com/spreadsheets/d/1jrToaqsIvv4DzlDGox9DEmsAgIsicymxQE8femfuhEk/edit#gid=369134759"

project <- read_sheet(ss = ss, sheet = "project")
person <- read_sheet(ss = ss, sheet = "person")

project_data <- locations %>%
    merge(project, by = 'Organisation')
person_data <- locations %>%
    merge(person, by = 'Organisation')

#dataset <- read_sheet(ss = ss, sheet = "dataset")
#tool <- read_sheet(ss = ss, sheet = "tool")
#publication <- read_sheet(ss = ss, sheet = "training")
#archives <- read_sheet(ss = ss, sheet = "archives")
#learning_material <- read_sheet(ss = ss, sheet = "learning_material")
#unclassified <- read_sheet(ss = ss, sheet = "unclassified")

# ----- load functions -----
#source('functions/importStakeholderData.R')
#source('functions/my_map_activ.R')

# choices for activities map
chocies_record_type <- c('person', 'project', 'tool', 'training')

#### ----- Define UI for application that draws plot -----
ui <- (fluidPage(
    titlePanel(title = "DH and CSS stakeholder landscape in South Africa"),
    sidebarLayout(
        sidebarPanel(uiOutput("Type")
        ),
        mainPanel(leafletOutput("my_map_activities", height = "500")
        ))
)
)

# Define server logic required to draw a the leaflet map, other plots, and show tables
server <- function(input, output){
    output$Type <- renderUI({
        selectInput(inputId = "Type", label = "Choose which record type to view",
                    choices = chocies_record_type)
    })
     map_data <- reactive({
      if (input$Type == "project") {
             data <- project_data
         } else if (input$Type == "person") {
             data <- person_data    
         } else {
             data <- 0            
         }
         return(data)
    })
    output$my_map_activities <- renderLeaflet({
        leaflet(data = map_data()) %>%
            addTiles() %>% 
            setView(24.774610, -29.038968, zoom = 5) %>%
            addCircleMarkers(lng = ~long,
                             lat = ~lat)
    })
}

# Run the application
shinyApp(ui, server)
