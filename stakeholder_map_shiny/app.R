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

# ----- load data -----
# Read in Google Sheet data
ss = "https://docs.google.com/spreadsheets/d/1jrToaqsIvv4DzlDGox9DEmsAgIsicymxQE8femfuhEk/edit#gid=369134759"

project <- read_sheet(ss = ss, sheet = "project")
person <- read_sheet(ss = ss, sheet = "person")
dataset <- read_sheet(ss = ss, sheet = "dataset")
tool <- read_sheet(ss = ss, sheet = "tool")
publication <- read_sheet(ss = ss, sheet = "training")
archives <- read_sheet(ss = ss, sheet = "archives")
learning_material <- read_sheet(ss = ss, sheet = "learning_material")
unclassified <- read_sheet(ss = ss, sheet = "unclassified")

# choices for activities map
variables_actm <- c('Person', 'Project', 'Tool', 'Training')

#### ----- Define UI for application that draws plot -----
ui <- fluidPage(
    # Application title
    titlePanel("DH and CSS stakeholder landscape in South Africa"),
    tabsetPanel(
# ----- input for first panel -----
        tabPanel('Activities Map',
                 # Sidebar with a dropdown menu to choose which variable to plot
                 sidebarLayout(
                     sidebarPanel(
                         selectInput(inputId = 'variable_act', ### !! TO EDIT !! ###
                                     label = 'Choose which record type to plot', 
                                     choices = variables_actm,
                                     selected = 'Type of record'
                         ), # end selectInput
                         
                     ), # end sidebarPanel
                     # Show the generated leflet map
                     mainPanel(
                         # add some text on top of main part
                         h4('Add some text here'),
                         p("if we want text here"),
                         p("if we want text here"),
                         
                         # add the map
                         leaflet::leafletOutput(outputId = "my_map_activities",  ### !! TO EDIT !! ###
                                                height = "65vh")  # use height argument to adjust size of map in app
                     ) # end mainPanel
                 ) # end sidebarLayout
        ), # end tabPanel
# ----- input for second panel -----
tabPanel('heading for tab',
         sidebarLayout(
             sidebarPanel(
                 p("if we want text here"),
                 p("if we want text here")
                 
             ), # end sidebarPanel
             mainPanel(
                 h4('title here'),
                 plotOutput(outputId = "LangPlot"),
                 #downloadButton('down', 'Download plot'),
                 p(" "),
                 p("if we want text here."),
                 p("if we want text here")
             ) # end mainPanel
         ) # end sidebarLayout
), # end tabPanel
# ----- input for third panel -----
tabPanel('heading for tab',
         sidebarLayout(
             sidebarPanel(
                 p("if we want text here"),
                 p("if we want text here")
                 
             ), # end sidebarPanel
             mainPanel(
                 h4('title here'),
                 plotOutput(outputId = "LangPlot"),
                 #downloadButton('down', 'Download plot'),
                 p(" "),
                 p("if we want text here."),
                 p("if we want text here")
             ) # end mainPanel
         ) # end sidebarLayout
), # end tabPanel    
    ) # end tabsetPanel   
) # end fluidpage



# Define server logic required to draw a the leaflet map, other plots, and show tables
server <- function(input, output) {

# ----- define original view for maps ---
    view_orig <- list(long = 24.774610, lat = -29.038968, zoom = 5)
    
# ----- output for first panel (activities map) -----
    output$my_map_activities <- leaflet::renderLeaflet({
        # filter the data according to input$filter
        if(input$var_filter1 == 'Quarter'){
            activ_choice <- activ %>%
                filter(quarter %in% input$quarter1)
        }else if(input$var_filter1 == 'Type of Activity'){
            activ_choice <- activ %>% 
                filter(activity_type %in% input$activity1)
        } #end if else
        # draw the map,
        # (input$variable corresponds to the category chosen in the drop-down menu)
        my_map_activ(x = activ_choice, 
                     affil = affil, 
                     mapping_var = choice(input$variable_act), 
                     view = view_orig, 
                     legend_title = input$variable_act
        )
    }) # end my_map
    
    
    
    
}

# Run the application 
shinyApp(ui = ui, server = server)
