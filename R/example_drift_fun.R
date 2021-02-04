#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Title: Fouling Correction Function
#Coder: Nate Jones (cnjones7@ua.edu)
#Date: 12/31/2020
#Purpose: Provide a demo function for JTM's sonde workflow
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Function ----------------------------------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
fun_drift <- function(drift, #Dataframe with data and data cols 
              start, #Date and time when to start linear correction
              end, #Date and time when end linear correction
              cleaned #Date and time when the sensor was cleaned
){
  
  #Load required packages 
  library(tidyverse)
  library(lubridate)

  #Estimate fouling rate
  pre_clean  <- drift %>% filter(Timestamp==end) %>% select(value) %>% pull()
  post_clean <- drift %>% filter(Timestamp==cleaned) %>% select(value) %>% pull()
  duration   <- as.numeric(end-start)*24*60 
  f_rate     <- (post_clean-pre_clean)/duration
  
  #Apply linear correction
  drift<-drift %>%
    #Filter to time period in question
    filter(
      Timestamp>=start,
      Timestamp<=cleaned) %>% 
    #Apply Correction
    mutate(
      #Create min col
      time_min = as.numeric(Timestamp - start)/60,
      #Apply correction to value
      value = value + time_min*f_rate
    )
  
  #Clean up data frame
  drift <- drift %>% 
    #Remove "cleaned" value
    filter(Timestamp!=cleaned) %>%
    #Change drift_corr indicator
    mutate(corr = "temp_anomalous_drift") %>% 
    #Remove time_min col
    select(-time_min)
    
  #Export drift correct df
  return(drift)
}
