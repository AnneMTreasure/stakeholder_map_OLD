
# stakeholder map project

# script to convert Google spreadsheet (linked to Google Form) to a Kumu ready spreadsheet

#install.packages("googlesheets4")
library(tidyverse)
library(googlesheets4)

###### authorisations
#drive_auth(email = "*@example.com")
#gs4_auth(token = drive_token())

gs4_auth(email = "*@talarify.co.za", path = "~/stakeholder_map/sheets_service_account_key.json")

# full form
form_data <- read_sheet("https://docs.google.com/spreadsheets/d/1QypMe5AMMRqC99xErDrLNg_MNFh8GgJgvgk1GgTgqvc/edit?resourcekey#gid=1544501697")

###### project
project <- form_data %>%
  filter(`Record type` == "Project") %>%
  select(c(1:7, 8:34)) %>%
  unite("Tags", 5:6, sep = " | ", remove = FALSE)

names(project) <- c("Timestamp", "data_submitter_email", "data_submitter_name", "data_source", "Tags", "subject_area", "methods", "Type", "contact_first_names", "contact_surname", "contact_title", "contact_location", "Email", "Organisation", "country", "province", "city", "Label", "Description", "keywords", "status", "start_date", "end_date", "PI", "team_members", "partner_institutes", "students", "Funders", "parent_project_id", "natural_languages", "URL", "twitter", "facebook", "other_social_media", "project_outputs")

### columns possibly still needed for kumu:
# "Image", ID", "Funders"

kumu_project <- project %>%
  select(Label, Type, Description, Tags, Organisation, URL, Email, Funders)

###### person
person <- form_data %>%
  filter(`Record type` == "Person") %>%
  select(c(1:7, 35:52)) %>%
  unite("Tags", 5:6, sep = " | ", remove = FALSE) %>%
  unite("Label", 9:11, sep = " ", remove = FALSE)
 
names(person) <- c("Timestamp", "data_submitter_email", "data_submitter_name", "data_source", "Tags", "subject_area", "methods", "Type", "Label", "first_names", "surname", "title", "organisation_full", "Description", "Email", "Organisation", "province", "city", "description_full", "keywords", "Funders", "orcid", "URL", "linkedin_url", "researchgate_url", "twitter", "other_social_media")

kumu_person <- person %>%
  select(Label, Type, Description, Tags, Organisation, URL, Email, Funders)


###### combine project and person for a kumu spreadsheet
kumu <- rbind(kumu_person, kumu_project)
# replace commas with |
kumu$Tags <- gsub("[[:punct:]]", " | ", kumu$Tags)

##### write to google spreadsheet
ss = "https://docs.google.com/spreadsheets/d/1jrToaqsIvv4DzlDGox9DEmsAgIsicymxQE8femfuhEk/edit#gid=369134759"

kumu_gsheet <- sheet_write(kumu, ss = ss, sheet = "kumu")

#kumu_gsheet
# copied the ID given and added to 'https://docs.google.com/spreadsheets/d/'

# how to extract the gsheet ID?
