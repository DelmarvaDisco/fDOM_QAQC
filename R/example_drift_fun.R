#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Title: Fouling Correction Function
#Coder: Nate Jones (cnjones7@ua.edu)
#Date: 12/31/2020
#Purpose: Provide a demo function for JTM's sonde workflow
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Function ----------------------------------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
fun_drift <- function(df, #Dataframe with data and data cols 
              start, #Date and time when to start linear correction
              end, #Date and time when end linear correction
              cleaned #Date and time when the sensor was cleaned
){
  
  #Load required packages 
  library(tidyverse)
  library(lubridate)

  #Estimate fouling rate
  pre_clean  <- df %>% filter(Timestamp==end) %>% select(value) %>% pull()
  post_clean <- df %>% filter(Timestamp==cleaned) %>% select(value) %>% pull()
  duration   <- as.numeric(end-start)*24*60 
  f_rate     <- (post_clean-pre_clean)/duration
  
  #Apply linear correction
  df<-df %>%
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
  df<-df %>% 
    #Remove "cleaned" value
    filter(Timestamp!=cleaned) %>%
    #Change drift_corr indicator
    mutate(drift_corr=1) %>% 
    #Remove time_min col
    select(-time_min)
    
  #Export drift correct df
  df
}
