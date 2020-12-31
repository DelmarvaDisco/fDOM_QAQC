#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Title: Fouling Correction Function
#Coder: Nate Jones (cnjones7@ua.edu)
#Date: 12/31/2020
#Purpose: Provide a demo function for JTM's sonde workflow
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Function ----------------------------------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
fun<-function(df, #Dataframe with data and data cols 
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

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Apply function ---------------------------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Prep dataframe
df<-fDOM_Temp_corr %>% 
  #Filter to one site
  filter(`Site Name`=='ND') %>% 
  #Create cols of interest
  mutate(
    Timestamp=ymd_hms(Date_Time_EST),
    value = fDOM_QSU,
    drift_corr = 0) %>% 
  #Select Cols of interest
  select(Timestamp,value, drift_corr)

#Define dates of interest
start<-mdy_hm("9-12-2020 11:00")
end<-mdy_hm("9-19-2020 13:30")
cleaned<-mdy_hm("9-19-2020 14:30")

#run function
temp<-fun(df, start, end, cleaned)

#Plot
plot(df$Timestamp, df$value, type="l", xlab="Timestamp", ylab="Value")
points(temp$Timestamp, temp$value, type="l", col="red")

#Replace values in master df
df<-bind_rows(df, temp) %>% 
  group_by(Timestamp) %>% 
  slice_max(drift_corr, n=1) 