### WORKING ORIGINAL ###

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
library(DT)
library(tableHTML)

# usecairo = T from package Cairo for better quality of figures in shiny app
options(shiny.usecairo=T)

# ----- authorisations -----
# for GitHub Action (adapted from https://github.com/jdtrat/tokencodr-google-demo)
source("functions/func_auth_google.R")

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
tool <- read_sheet(ss = ss, sheet = "tool")
#training <- read_sheet(ss = ss, sheet = "training")

project_data <- locations %>%
    merge(project, by = 'Organisation')
person_data <- locations %>%
    merge(person, by = 'Organisation')
tool_data <- locations %>%
    merge(tool, by = 'Organisation')
#training_data <- locations %>%
#    merge(training, by = 'Organisation')

#dataset <- read_sheet(ss = ss, sheet = "dataset")
publication <- read_sheet(ss = ss, sheet = "publication") %>%
  select("subject_area", "methods", "publication_type", "language_primary", "language_other", "title", "authors", "publisher", "status", "volume_no", "start_page_no", "end_page_no", "publication_year", "conference_name", "conference_start_date", "keywords", "abstract", "identifier", "licence", "paywall", "review", "URL")
#  names(publication) <- c("subject_area", "methods", "publication_type", "language_primary", "language_other", "title", "authors", "publisher", "status", "volume_no", "start_page_no", "end_page_no", "publication_year", "conference_name", "conference_start_date", "keywords", "abstract", "identifier", "licence", "paywall", "review", "URL"
#  )
  
#archives <- read_sheet(ss = ss, sheet = "archives")
#learning_material <- read_sheet(ss = ss, sheet = "learning_material")
#unclassified <- read_sheet(ss = ss, sheet = "unclassified")

# ----- load functions -----
#source('functions/importStakeholderData.R')
#source('functions/my_map_activ.R')

# choices for activities map
choices_record_type <- c('Person', 'Project', 'Tool', 'Training')
subject_area <- c('African studies',
                  'Anthropology',
                  'Archaeology', 
                  'Architecture: History, Theory & Practice', 
                  'Classics and Ancient History', 
                  'Community Arts (including Art and Health)', 
                  'Cultural Heritage', 
                  'Cultural Policy, Arts management and the creative industries',
                  'Dance Studies', 
                  'Data Science', 
                  'Design', 
                  'Drama and Theatre Studies', 
                  'Education', 
                  'English Language and Literature', 
                  'Government Studies', 
                  'History', 
                  'Information and Communication Technology', 
                  'Law', 
                  'Librarianship, Information and Museum Studies', 
                  'Linguistics', 
                  'Media', 
                  'Modern Languages', 
                  'Multilingualism', 
                  'Music', 
                  'Oriental Studies', 
                  'Philosophy', 
                  'Speech and / or language technology',  
                  'Theology',
                  'Divinity and Religious Studies',  
                  'Visual Arts',  
                  'Other')

#### ----- Define UI for application that draws plot -----
ui <- (fluidPage(
    titlePanel(title = "Digital Humanities and Computational Social Sciences landscape in South Africa"),
    p("The South African Centre for Digital Language Resources (SADiLaR) is a national centre supported by the Department of Science and Innovation (DSI) as part of the South African Research Infrastructure Roadmap (SARIR). SADiLaR has an enabling function, with a focus on all official languages of South Africa, supporting research and development in the domains of language technologies and language-related studies in the humanities and social sciences. Furthermore the centre has a mandate to develop digital humanities capacity in South Africa."),
    tabsetPanel(
# ----- input for first panel (activities map) -----
      tabPanel('Activities Map',
        sidebarLayout(
          sidebarPanel(
            uiOutput("Type"),
      # add filter for data
            selectInput(
              inputId = 'subject',
              label = 'Choose filter for data by subject area',
              choices = subject_area
            
            ) # end selectInput
            
          ), # end sidebarPanel
          mainPanel(
#            h4('DH and CSS landscape in South Africa'),
            p("This map shows data on Digital Humanities (DH), Computational Social Sciences (CSS),  Human Language Technologies (HLT) and Natural Language Processing (NLP) activities and initiatives in South Africa."),
            leafletOutput("my_map_activities", height = "500"),
                     h4('Add some text here'),
                     p("if we want text here"),
                     p("if we want text here"), 
          ) # end mainPanel
        ) # end sidebarLayout
      ), # end tabPanel 1
      
# ----- input for second panel () -----
      tabPanel('heading for panel 2'
        
      ), # end tabPanel 2

# ----- input for third panel -----  
      tabPanel('Datasets'#,
              # DT::dataTableOutput("mytable") # TO CREATE DATASETS TABLE
      ), # end tabPanel 3

# ----- input (table) for fourth panel -----
      tabPanel('Publications',
               DT::dataTableOutput("mytable")
      ), # end tabPanel 4
      
    ) # end tabsetPanel
) # end fluidpage
)

# Define server logic required to draw a the leaflet map, other plots, and show tables
server <- function(input, output){

# ----- output for first panel (activities map) -----
      output$Type <- renderUI({
        selectInput(inputId = "Type", label = "Choose which record type to view",
                    choices = choices_record_type)
    })
     mapData <- reactive({
      if (input$Type == "Project") {
             data <- project_data
         } else if (input$Type == "Person") {
             data <- person_data    
         } else {
             data <- 0
         }
         return(data)
    })
    
     
    output$my_map_activities <- renderLeaflet({
        leaflet(data = mapData()) %>%
            addTiles() %>% 
            setView(24.774610, -29.038968, zoom = 5) %>%
            addCircleMarkers(lng = ~long,
                             lat = ~lat,
                             popup = ~tableHTML(data.frame(Label, Organisation, URL),
                                                rownames = FALSE,
                                                border = 2)
                          # popup = ~htmlTable(data.frame(Label, Organisation, URL))
            )
    })

# ----- output (table) for fourth panel (publications table) -----
    output$mytable = DT::renderDataTable({
      publication
    })
} # end server

# Run the application
shinyApp(ui, server)
