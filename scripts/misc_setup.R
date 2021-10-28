
# remotes::install_github("jdtrat/tokencodr")
library(tokencodr)
library(googlesheets4)
library(googledrive)

# Run once and copy password to .Renviron
# Added this to GitHub repository secrets, with the name "MY_GOOGLE_PASSWORD"
# just copy the password, or "MY_GOOGLE_PASSWORD=<password>"?
tokencodr::create_env_pw("MY_GOOGLE")

# Assumes the JSON file is a Google Service Account as described here:
# https://gargle.r-lib.org/articles/get-api-credentials.html#service-account-token
# the encrypted json file saved in .secrets folder in GitHub repo
tokencodr::encrypt_token(service = "MY_GOOGLE", # "stakeholder_map"
                         input = "sheets_service_account_key.json", 
                         destination = "path-to-save-encrypted-json-file")

# Locally Authenticate Google Sheets & Google Drive
googlesheets4::gs4_auth(path = tokencodr::decrypt_token(service = "MY_GOOGLE",
                                                        path = ".secret/MY_GOOGLE",
                                                        complete = TRUE))


#googledrive::drive_auth(path = tokencodr::decrypt_token(service = "tokencodr_google_demo",
                                                        # here, the path is "resources/.secret/tokencodr_demo_google"
#                                                        path = "path-to-your-encrypted-json-file",
#                                                        complete = TRUE))

# Create a new sheet
# here, I used "tokencodr-google-demo"
#new_sheet <- googlesheets4::gs4_create(name = "your-sheet-name")

# Choose to share with your personal Google Account
#googledrive::drive_share(new_sheet,
#                         role = "writer",
#                         type = "user",
#                         emailAddress = "your-personal-google-email")
