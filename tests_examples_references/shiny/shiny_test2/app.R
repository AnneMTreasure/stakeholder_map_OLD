###### TEST FILE ###### 

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

# choices for activities map
choices_record_type <- c('Person', 'Project', 'Tool', 'Training')
choices_subject_area <- c('African studies',
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
                         conditionalPanel(condition = "input.subject",
                             selectInput(
                                 inputId = 'subject',
                                 label = 'Choose filter for data by subject area',
                                 choices = choices_subject_area
                             ) # end selectInput 
                         ) # end conditionalPanel
                     ), # end sidebarPanel
                     mainPanel(
                         p("This map shows data on Digital Humanities (DH), Computational Social Sciences (CSS),  Human Language Technologies (HLT) and Natural Language Processing (NLP) activities and initiatives in South Africa."),
                         leafletOutput("my_map_activities", height = "500"),
                     ) # end mainPanel
                 ) # end sidebarLayout
        ), # end tabPanel 1
        
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
            #data <- project_data
            #data <- project_data %>% filter(subject_area == input$subject)
            
            #project_data$subject_area <- gsub(", ", ",", project_data$subject_area)
            test <- unlist(strsplit(project_data$subject_area, ";"))
            
            data <- project_data %>% filter(input$subject %in% test)            
            
            
        } else if (input$Type == "Person") {
            #data <- person_data
            #data <- person_data %>% filter(subject_area == input$subject)
            
            person_data$subject_area <- gsub(", ", ",", person_data$subject_area)
            test <- unlist(strsplit(person_data$subject_area, ","))

            data <- person_data %>% filter(input$subject %in% test)
                        
        } else {
            data <- 0
        }
        #data <- filter(data, subject_area == input$subject)
        return(data)
    })
    
#    mapData2 <- reactive({
#    })
    
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
} # end server

# Run the application
shinyApp(ui, server)
