



# # stakeholder map project:

library(tidyverse)
library(googlesheets4)
library(leaflet)

###### ---------- AUTHORISATIONS ---------- ######
# this works locally
#gs4_auth(email = "*@talarify.co.za", path = "~/stakeholder_map/.secret/MY_GOOGLE")

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

# ----- map with leaflet -----
project_map <- leaflet(project_data) %>%
  addTiles() %>% 
  setView(24.774610, -29.038968, zoom = 5) %>%
  addCircleMarkers(lng = ~long,
                   lat = ~lat)
project_map

# TO DO:
# - combine record types for map to draw from one df





