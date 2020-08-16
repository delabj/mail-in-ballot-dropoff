library(tidyverse)
library(dplyr)

source("scripts/src/find_drop_off.R")


allzips <- read_csv("Data/fcts/zip_code_database.csv")
allzips$latitude <- jitter(allzips$latitude)
allzips$longitude <- jitter(allzips$longitude)
allzips$zipcode <- formatC(allzips$zip, width=5, format="d", flag="0")
row.names(allzips) <- allzips$zipcode
