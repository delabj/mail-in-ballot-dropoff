library(tidyverse)
library(dplyr)
library(shiny)
library(shinydashboard)
library(leaflet)
library(DT)

source("scripts/src/find_drop_off.R")
state_abbr <- data.frame(state.name, state.abb)

rules <- read_csv("Data/fcts/proxy_absentee_return_rules.csv")

allzips <- read_csv("Data/fcts/zip_code_database.csv") %>% filter(type == "STANDARD")
allzips$latitude <- jitter(allzips$latitude)
allzips$longitude <- jitter(allzips$longitude)
allzips$zipcode <- formatC(allzips$zip, width=5, format="d", flag="0")


ui <- dashboardPage(
  dashboardHeader(title = "Where Can I drop off my Mail-In Ballot?"),
  dashboardSidebar(uiOutput("state_selections"), br(), uiOutput("zipcode_selection"), br(), h2("OR"), br(), uiOutput("county_selection")),
  dashboardBody(leafletOutput("mymap"), br(),
                dataTableOutput(outputId = "address"), br(),
  dataTableOutput(outputId = "proxy_dropoff"))
)



server <- function(input, output) {
  user_values <- reactiveValues(list= NULL)
  
  
  output$state_selections <- renderUI({
    states_aval <-  gsub(".csv", "", list.files("Data/drop-off-locations/"), fixed = T)
    states <- state_abbr %>% filter(state.abb %in% states_aval)
    selectInput(label = "Pick your state" ,inputId = "state", choices = c("", as.character(states$state.name)), selected = NULL)
  })
  
  observeEvent(input$state, {
    abrev <- state_abbr %>% filter(state.name == input$state) %>% pull(state.abb)
    user_values$abrev <- as.character(abrev)
    if(length(abrev)){
    user_values$drop_off_data <- read_csv(paste0("Data/drop-off-locations/", abrev, ".csv"))
    }
  })
  
  output$zipcode_selection <- renderUI({
    if(is.null(user_values$drop_off_data)){
      return()}
    else{
      selectInput(label = "What's the zipcode of the address you used to register to vote?" ,
                  inputId = "zipcode", choices =  c("", unique(user_values$drop_off_data$zip)))
    }
    
  })
  
  output$county_selection <- renderUI({
    if(is.null(user_values$drop_off_data)){
      return()}
    else{
      selectInput(label = sprintf("What's the county in %s you used to register to vote?", input$state) ,
                  inputId = "county", choices =  c("", unique(user_values$drop_off_data$county)))
    }
    
  })
  
  
  output$mymap <- renderLeaflet({
    map <- leaflet() %>%
      addProviderTiles(providers$Stamen.TonerLite,
                       options = providerTileOptions(noWrap = TRUE)
      )
    
    state = T
    county = T
    zip = T
    
    if(is.null(input$state)) {
      state=F
    } else if(input$state == "") {
      state=F
    } else{
        state = T
      }
    
    if(is.null(input$county)) {
      county=F
    } else if(input$county == "") {
      county=F
    } else{
      county = T
    }
    
    if(is.null(input$zipcode)) {
      zip=F
    } else if(input$zipcode == "") {
      zip=F
    } else{
      zip = T
    }
    
    if(!state){
      cat("country map\n")
      map <- map %>%
        setView(lat = 39.80,lng =  -98.58, zoom = 4)
    } else if(!county & !zip) {
      cat("state map\n")
      cat(user_values$abrev, "\n")
      state_zips <- allzips %>% filter(state == user_values$abrev) %>% group_by(county) %>% summarise(latitude = mean(latitude), longitude = mean(longitude))
      
      map <- map %>%
        addMarkers(lng = state_zips$longitude, state_zips$latitude)
    } else if(zip) {
      zip <- allzips %>% filter(zip == input$zipcode) %>% summarise(latitude = mean(latitude), longitude = mean(longitude))
      
      map <- map %>%
        addMarkers(lng = zip$longitude, zip$latitude)
    } else if(county) {
      county_zips <- allzips %>% filter(county == input$county) %>% group_by(county) %>% summarise(latitude = mean(latitude), longitude = mean(longitude))
      
      map <- map %>%
        addMarkers(lng = county_zips$longitude, county_zips$latitude)
    }
    
    return(map)
    
    
  })
  
  output$address <- renderDataTable({
    
    if(is.null(input$state)) {
      return()
    } else if(input$state == "") {
      state=NULL
    } else{
      state = user_values$abrev
    }
    
    if(is.null(input$county)) {
      county=NULL
    } else if(input$county == "") {
      county= NULL
    } else{
        county = input$county
    }
    
    if(is.null(input$zipcode)) {
      zip=NULL
    } else if(input$zipcode == "") {
      zip=NULL
    } else{
      zip = as.character(input$zipcode)
    }
    
    if(!is.null(state)){
    DT::datatable(find_location(state = state, County = county, zipcode = zip), escape = F)
      }
    
  })
  
  output$proxy_dropoff <- renderDataTable({
    
    if(is.null(input$state)) {
      rules
    } else if(input$state == ""){
      rules
    } else{
      rules %>% filter(State == input$state) %>% select(-State)
    }
    
  })
  
  
}

shinyApp(ui, server)