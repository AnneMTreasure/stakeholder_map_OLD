
#my_map_activ <- function(x, mapping_var = 'record_type', view, legend_title = mapping_var) {

#my_map_activ <- function(x, mapping_var = 'record_type') {

my_map_activ <- function(stakeholderData) {
    
  # x: data frame containing stakeholder data for different record types, incl lat & long
  # 
  
  ###### ---------- LOAD LIBRARIES ---------- ######
  library(tidyverse)
  library(leaflet)
  
  #x = importStakeholderData(input$record_type)
  
  ###### ---------- DRAW MAP ---------- ######
  project_map <- leaflet(stakeholderData) %>%
    addTiles() %>% 
    setView(24.774610, -29.038968, zoom = 5) %>%
    addCircleMarkers(lng = ~long,
                     lat = ~lat)
  
  project_map
  
}