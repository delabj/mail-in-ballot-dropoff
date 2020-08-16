library(datasets)
library(dplyr)
library(readr)




find_location <- function(state, zipcode = NULL, closest_city =  NULL, County = NULL){
  offices <- get_office_locations(state)

  if(!is.null(zipcode)){
    address <- offices %>% filter(zip == zipcode) %>% select(address, phone) %>% mutate(address = google_it(address))%>% distinct()
    if(nrow(address)){
    return(address)
    } else{
      stop(sprintf("We don't have a record of an office for zipcode: %s in %s", 
           zipcode, state))
    }
  }
  else if(!is.null(closest_city)){
    address <- offices %>% filter(primary_city == closest_city) %>%select(address, phone) %>% mutate(address = google_it(address))%>% distinct()
    if(nrow(address)){
      return(address)
    } else{
      stop(sprintf("We don't have a record of an office for %s in %s", 
                   closest_city, state))
    }
  }
  else if(!is.null(County)){
    address <- offices %>% filter(county == County) %>% select(address, phone) %>% mutate(address = google_it(address))%>% distinct()
    if(nrow(address)){
      return(address)
    } else{
      stop(sprintf("We don't have a record of an office for %s in %s", 
                   county, state))
    }
  }
  else{
  warning("Please enter a zipcode or a nearest major city in your county for an addrees")
  return(offices %>% select(address, phone) %>% mutate(address = google_it(address)) %>% distinct())
  }
  
}

get_office_locations <- function(abb){
  filepath <- sprintf("Data/drop-off-locations/%s.csv", abb)
  offices <- read_csv(filepath)
  return(offices)
}

google_it <- function(addr){
  
  url <- paste0("https://www.google.com/maps/place/",
                gsub("[[:space:]]", "+", gsub("\n"," ",addr, fixed = T)))
  
  link <- sprintf('<a href="%s">%s</a>',url, addr)
  
  return(link)
  
}
