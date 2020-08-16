library(tidyverse)
library(dplyr)
library(readr)
zip_code_database <- read_csv("Data/zip_code_database.csv")

PA_zips <- zip_code_database %>% 
  filter(state == 'PA', type == 'STANDARD') %>%
  select(state, county, primary_city, zip) %>% 
  distinct()

# PA_zips[is.na(PA_zips$county),]
## Both Pittsburgh so mapping to the right countuy
PA_zips$county[is.na(PA_zips$county)] = "Allegheny County"
PA_county_electionoffice_map <- read_csv("Data/PA.csv")

PA_zip_to_election_office <- PA_zips %>% inner_join(PA_county_electionoffice_map)
