

# stakeholder map project: import data, manipulate and tidy

library(tidyverse)
library(googlesheets4)

## ---------- AUTHORISATIONS ---------- ##
  # this works locally
  #gs4_auth(email = "*@talarify.co.za", path = "~/stakeholder_map/.secret/MY_GOOGLE")

# for GitHub Action (adapted from https://github.com/jdtrat/tokencodr-google-demo)
source("R/func_auth_google.R")

# Authenticate Google Service Account (adapted from https://github.com/jdtrat/tokencodr-google-demo)
auth_google(email = "*@talarify.co.za",
            service = "MY_GOOGLE",
            token_path = ".secret/MY_GOOGLE")


## ---------- READ DATA FROM GOOGLE SHEET ---------- ##
form_data <-
  read_sheet(
    "https://docs.google.com/spreadsheets/d/1M0Pyk_YxjoUlV5lzWkClVWAXdBgYgilz_7SPmsffARo/edit?resourcekey#gid=1996403281"
  )

## ---------- INTRO questions ---------- ##
#intro <- form_data %>%
#  select(starts_with('1'))

## ---------- Record type: PROJECT ---------- ##
project <- form_data %>%
  filter(`1.5_Record type` == "Project") %>%
  select(c("Timestamp", "Email Address", starts_with(c("1", "2")))) %>%
  unite("Tags", 5:6, sep = " | ", remove = FALSE)

names(project) <-
  c(
    "Timestamp",
    "data_submitter_email",
    "data_submitter_name",
    "data_source",
    "Tags",
    "subject_area",
    "methods",
    "Type",
    "contact_first_names",
    "contact_surname",
    "contact_title",
    "contact_location",
    "Email",
    "Organisation",
    "province",
    "city",
    "Label",
    "Description",
    "keywords",
    "status",
    "start_date",
    "end_date",
    "PI",
    "team_members",
    "partner_institutes",
    "students",
    "Funders",
    "parent_project_id",
    "natural_languages",
    "URL",
    "twitter",
    "facebook",
    "other_social_media",
    "project_outputs"
  )


## ---------- Record type: PERSON ---------- ##
person <- form_data %>%
  filter(`1.5_Record type` == "Person") %>%
  select(c("Timestamp", "Email Address", starts_with(c("1", "3")))) %>%
  unite("Tags", 5:6, sep = " | ", remove = FALSE) %>%
  unite("Label", 9:11, sep = " ", remove = FALSE)


names(person) <-
  c(
    "Timestamp",
    "data_submitter_email",
    "data_submitter_name",
    "data_source",
    "Tags",
    "subject_area",
    "methods",
    "Type",
    "Label",
    "first_names",
    "surname",
    "title",
    "organisation_full",
    "Description",
    "Email",
    "Organisation",
    "province",
    "city",
    "description_full",
    "keywords",
    "Funders",
    "orcid",
    "URL",
    "linkedin_url",
    "researchgate_url",
    "twitter",
    "other_social_media"
  )


## ---------- DATA SHEET FOR KUMU ---------- ##
  ### columns possibly still needed for kumu:
  # "Image", ID", "Funders"

kumu_project <- project %>%
  select(Label, Type, Description, Tags, Organisation, URL, Email, Funders)

kumu_person <- person %>%
  select(Label, Type, Description, Tags, Organisation, URL, Email, Funders)

# combine project and person
kumu <- rbind(kumu_person, kumu_project)
# replace commas with |
kumu$Tags <- gsub("[[:punct:]]", " | ", kumu$Tags)

##### write to google spreadsheet
ss = "https://docs.google.com/spreadsheets/d/1jrToaqsIvv4DzlDGox9DEmsAgIsicymxQE8femfuhEk/edit#gid=369134759"

kumu_gsheet <- sheet_write(kumu, ss = ss, sheet = "kumu")

#kumu_gsheet
# copied the ID given and added to 'https://docs.google.com/spreadsheets/d/'
# to look into how to extract the gsheet ID


## ---------- Record type: DATASET ---------- ##
dataset <- form_data %>%
  filter(`1.5_Record type` == "Dataset") %>%
  select(c("Timestamp", "Email Address", starts_with(c("1", "4")))) %>%
  unite("Tags", 5:6, sep = " | ", remove = FALSE)

names(dataset) <-
  c(
    "Timestamp",
    "data_submitter_email",
    "data_submitter_name",
    "data_source",
    "Tags",
    "subject_area",
    "methods",
    "Type",
    "contact_first_names",
    "contact_surname",
    "contact_title",
    "contact_location",
    "Email",
    "authors_contributors",
    "title",
    "status",
    "publisher",
    "repository",
    "publication_year",
    "language_primary",
    "language_other",
    "keywords",
    "Description",
    "date_start",
    "date_end",
    "identifier",
    "licence_url",
    "paywall",
    "dataset_url",
    "dataset_format"
  )


## ---------- Record type: TOOL ---------- ##
#tool <- form_data %>%
#  filter(`1.5_Record type` == "Tool") %>%
#  select(c("Timestamp", "Email Address", starts_with(c("1", "5")))) %>%
#  unite("Tags", 5:6, sep = " | ", remove = FALSE)


## ---------- Record type: PUBLICATION ---------- ## 6
publication <- form_data %>%
  filter(`1.5_Record type` == "Publication") %>%
  select(c("Timestamp", "Email Address", starts_with(c("1", "6")))) %>%
  unite("Tags", 5:6, sep = " | ", remove = FALSE)

names(publication) <-
  c(
    "Timestamp",
    "data_submitter_email",
    "data_submitter_name",
    "data_source",
    "Tags",
    "subject_area",
    "methods",
    "Type",
    "pulication_type",
    "language_primary",
    "language_other",
    "title",
    "authors",
    "publisher",
    "status",
    "volume_no",
    "start_page_no",
    "end_page_no",
    "publication_year",
    "conference_name",
    "conference_start_date",
    "keywords",
    "abstract",
    "identifier",
    "licence",
    "licence_url",
    "paywall",
    "review",
    "publication_url",
    "zotero_library"
  )

## ---------- Record type: TRAINING ---------- ##
training <- form_data %>%
  filter(`1.5_Record type` == "Training") %>%
  select(c("Timestamp", "Email Address", starts_with(c("1", "7", "8", "9")))) %>%
  unite("Tags", 5:6, sep = " | ", remove = FALSE)

names(training) <-
  c(
    "Timestamp",
    "data_submitter_email",
    "data_submitter_name",
    "data_source",
    "Tags",
    "subject_area",
    "methods",
    "Type",
    "contact_first_names",
    "contact_surname",
    "contact_title",
    "contact_location",
    "Email",
    "training_type",
    "title",
    "Description",
    "keywords",
    "start_date",
    "end_date",
    "organisers_trainers_collaborators",
    "language_primary",
    "language_other",
    "training_url",
    "other_social_media",
    "licence",
    "inperson_online",
    "in_person_province",
    "in_person_city",
    "in_person_institution",
    "in_person_organisor",
    "online_time",
    "online_organisor",
    "online_province",
    "online_city"
  )



## ---------- Record type: ARCHIVES ---------- ##


## ---------- Record type: LEARNING MATERIAL ---------- ##


## ---------- Record type: UNCLASSIFIED ---------- ##





