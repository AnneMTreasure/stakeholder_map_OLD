

# stakeholder map project: import data, manipulate and tidy

library(tidyverse)
library(googlesheets4)

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
form_data <-
  read_sheet(
    "https://docs.google.com/spreadsheets/d/1_LF0MQM1j240Z-S1eemmt6pcpWoGpeidFFIm73bqhhQ/edit?resourcekey#gid=957668315"
  )

###### ---------- INTRO questions ---------- ######
#intro <- form_data %>%
#  select(starts_with('1.'))

###### ---------- Record type: PROJECT ---------- ######
project <- form_data %>%
  filter(`1.5_Record type` == "Project") %>%
  select(c("Timestamp", "Email Address", starts_with(c("1.", "2")))) %>%
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
    "date_start",
    "date_end",
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

###### ---------- Record type: PERSON ---------- ######
person <- form_data %>%
  filter(`1.5_Record type` == "Person") %>%
  select(c("Timestamp", "Email Address", starts_with(c("1.", "3")))) %>%
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
    "title",
    "first_names",
    "surname",
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

###### ---------- Record type: DATASET ---------- ######
dataset <- form_data %>%
  filter(`1.5_Record type` == "Dataset") %>%
  select(c("Timestamp", "Email Address", starts_with(c("1.", "4")))) %>%
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
    "licence",
    "paywall",
    "URL",
    "dataset_format"
  )

###### ---------- Record type: TOOL ---------- ######
tool <- form_data %>%
  filter(`1.5_Record type` == "Tool") %>%
  select(c("Timestamp", "Email Address", starts_with(c("1.", "5")))) %>%
  unite("Tags", 5:6, sep = " | ", remove = FALSE)

names(tool) <-
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
    "tool_type",
    "language_primary",
    "language_other",
    "date_created",
    "date_updated",
    "creators_developers",
    "analysis_type",
    "web_usable",
    "usage",
    "TaDiRAH_methods",
    "licence",
    "tool_family",
    "background_processing",
    "warning",
    "historic_tool",
    "TaDiRAH_goals",
    "Funders",
    "URL"
  )

###### ---------- Record type: PUBLICATION ---------- ######
publication <- form_data %>%
  filter(`1.5_Record type` == "Publication") %>%
  select(c("Timestamp", "Email Address", starts_with(c("1.", "6")))) %>%
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
    "paywall",
    "review",
    "URL",
    "zotero_library"
  )

###### ---------- Record type: TRAINING ---------- ######
training <- form_data %>%
  filter(`1.5_Record type` == "Training") %>%
  select(c("Timestamp", "Email Address", starts_with(c("1.", "7", "8", "9")))) %>%
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
    "Label",
    "Description",
    "keywords",
    "date_start",
    "date_end",
    "organisers_trainers_collaborators",
    "language_primary",
    "language_other",
    "URL",
    "other_social_media",
    "licence",
    "Funders",
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

###### ---------- Record type: ARCHIVES ---------- ######
archives <- form_data %>%
  filter(`1.5_Record type` == "Archives") %>%
  select(c("Timestamp", "Email Address", starts_with(c("1.", "10")))) %>%
  unite("Tags", 5:6, sep = " | ", remove = FALSE)

names(archives) <-
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
    "title",
    "Description",
    "keywords",
    "date",
    "language_primary",
    "language_other",
    "URL",
    "licence"
  )

###### ---------- Record type: LEARNING MATERIAL ---------- ######
learning_material <- form_data %>%
  filter(`1.5_Record type` == "Learning material") %>%
  select(c("Timestamp", "Email Address", starts_with(c("1.", "11")))) %>%
  unite("Tags", 5:6, sep = " | ", remove = FALSE)

names(learning_material) <-
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
    "title",
    "Organisation",
    "province",
    "city",
    "Description",
    "keywords",
    "learning_material_type",
    "date_created",
    "date_updated",
    "authors_contributors",
    "target_audience",
    "pre_requisites",
    "language_primary",
    "language_other",
    "available_online",
    "material_URL",
    "URL",
    "format",
    "licence"
  )

###### ---------- Record type: UNCLASSIFIED ---------- ######
unclassified <- form_data %>%
  filter(`1.5_Record type` == "Unclassified") %>%
  select(c("Timestamp", "Email Address", starts_with(c("1.", "12")))) %>%
  unite("Tags", 5:6, sep = " | ", remove = FALSE)

names(unclassified) <-
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
    "title",
    "Description",
    "keywords",
    "date_collected",
    "language_primary",
    "language_other",
    "URL",
    "licence"
  )


###### ---------- DATA SHEET FOR KUMU: project, person, tool, learning materials ---------- ## 
### columns possibly still needed for kumu: "Image", ID"

kumu_project <- project %>%
  select(Label, Type, Description, Tags, Organisation, URL, Email, Funders)

kumu_person <- person %>%
  select(Label, Type, Description, Tags, Organisation, URL, Email, Funders)

kumu_tool <- tool %>%
  select(Label, Type, Description, Tags, Organisation, URL, Email, Funders)

kumu_training_inperson <- training %>%
  select(Label, Type, Description, Tags, in_person_institution, URL, Email, Funders)
names(kumu_training_inperson) <- c("Label", "Type", "Description", "Tags", "Organisation", "URL", "Email", "Funders")

kumu_training_online <- training %>%
  select(Label, Type, Description, Tags, online_organisor, URL, Email, Funders)
names(kumu_training_inperson) <- c("Label", "Type", "Description", "Tags", "Organisation", "URL", "Email", "Funders")

##### combine ##### 
kumu <- rbind(kumu_person, kumu_project,kumu_training_inperson, kumu_training_online)
# replace commas with |
kumu$Tags <- gsub("[[:punct:]]", " | ", kumu$Tags)

##### write to google spreadsheet ##### 
ss = "https://docs.google.com/spreadsheets/d/1jrToaqsIvv4DzlDGox9DEmsAgIsicymxQE8femfuhEk/edit#gid=369134759"

kumu_gsheet <- sheet_write(kumu, ss = ss, sheet = "kumu")

#kumu_gsheet
# copied the ID given and added to 'https://docs.google.com/spreadsheets/d/'
# to look into how to extract the gsheet ID


###### ---------- DATA SHEETS FOR Shiny ---------- ######
sheet_write(project, ss = ss, sheet = "project")
sheet_write(person, ss = ss, sheet = "person")
sheet_write(dataset, ss = ss, sheet = "dataset")
sheet_write(tool, ss = ss, sheet = "tool")
sheet_write(publication, ss = ss, sheet = "publication")
sheet_write(training, ss = ss, sheet = "training")
sheet_write(archives, ss = ss, sheet = "archives")
sheet_write(learning_material, ss = ss, sheet = "learning_material")
sheet_write(unclassified, ss = ss, sheet = "unclassified")


