
# this function imports the stakeholder data record type (project, person, took, training)
# depending what record type is selected to be shown on the map
# and merges it with organisation locations to get the latitude and longitude for the
# leaflet map

importStakeholderData <- function(record_type) {
  
  ###### ---------- LOAD LIBRARIES ---------- ######
  library(tidyverse)
  library(googlesheets4)

  ###### ---------- AUTHORISATIONS ---------- ######
  # for GitHub Action (adapted from https://github.com/jdtrat/tokencodr-google-demo)
  source("R/func_auth_google.R")
  
  # Authenticate Google Service Account (adapted from https://github.com/jdtrat/tokencodr-google-demo)
  auth_google(email = "*@talarify.co.za",
              service = "MY_GOOGLE",
              token_path = ".secret/MY_GOOGLE")
  
  ###### ---------- LOAD DATA ---------- ######
  locations <-
    read_sheet(
      "https://docs.google.com/spreadsheets/d/1Yjb5fknNzrhkHVtK6ca_dagobsQ1hwIVI4beXLWJOt4/edit#gid=628522158",
      sheet = "Organisation_locations"
    )
  
  ss = "https://docs.google.com/spreadsheets/d/1jrToaqsIvv4DzlDGox9DEmsAgIsicymxQE8femfuhEk/edit#gid=369134759"
  
  project <- read_sheet(ss = ss, sheet = "project")
  person <- read_sheet(ss = ss, sheet = "person")
  
  project_data <- locations %>%
    merge(project, by = 'Organisation')
  
  person_data <- locations %>%
    merge(person, by = 'Organisation')
  
  
  if (record_type == "project") {
    data <- project_data
  } else if (record_type == "person") {
    data <- person_data    ### STILL TO ADD OTHER RECORD TYPES
  } else {
    data <- 0
    print("Incorrect entry")
  }
  return(data)
}

#data <- importStakeholderData("person")
#data <- importStakeholderData("project")
#data <- importStakeholderData("test")