library(datasets)
library(dplyr)
library(readr)

state_abbr <- data.frame(state.name, state.abb)


find_location <- function(state, zipcode = NULL, closest_city =  NULL, County = NULL){
  abb <- state_abbr %>% filter(tolower(state.name) == tolower(state)) %>% 
    pull(state.abb) %>% as.character()
  offices <- get_office_locations(abb)

  if(!is.null(zipcode)){
    address <- offices %>% filter(zip == zipcode) %>% pull(address) %>% unique()
    if(length(address)){
    return(address)
    } else{
      stop(sprintf("We don't have a record of an office for zipcode: %s in %s", 
           zipcode, state))
    }
  }
  else if(!is.null(closest_city)){
    address <- offices %>% filter(primary_city == closest_city) %>% pull(address) %>% unique()
    if(length(address)){
      return(address)
    } else{
      stop(sprintf("We don't have a record of an office for %s in %s", 
                   closest_city, state))
    }
  }
  else if(!is.null(county)){
    address <- offices %>% filter(county == County) %>% pull(address) %>% unique()
    if(length(address)){
      return(address)
    } else{
      stop(sprintf("We don't have a record of an office for %s in %s", 
                   county, state))
    }
  }
  else{
  warning("Please enter a zipcode or a nearest major city in your county for an addrees")
  return(offices %>% pull(address) %>% unique())
  }
  
}

get_office_locations <- function(abb){
  filepath <- sprintf("Data/drop-off-locations/%s.csv", abb)
  offices <- read_csv(filepath)
  return(offices)
}
