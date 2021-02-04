#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Title: Anomaly Remover
#Coder: James Maze (jtmaze@umd.edu)
#Date: 1/14/21
#Purpose: To remove unusual/low values from fDOM sonde data.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Function ----------------------------------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

fun_anomalous <- function(anomaly, #timeseries data with anomalous values
                min, #The minimum threshold for residuals from rolling median 
                max #The maximum threshold for residuals from rolling median
){
  #load packages
  library(tidyverse)
  library(zoo)

  #Check values against the residuals of a rolling median. 
  anomaly <- anomaly %>% 
    mutate("rolling_median" = rollmedian(anomaly$value,
                                         7, 
                                         fill = NA, 
                                         align = "center")) %>% 

    mutate("residuals" = value - rolling_median) %>% 
    filter(residuals > min) %>% 
    filter(residuals < max)
  
  #Clean up the dataframe
  anomaly <- anomaly %>% 
    select(value, Timestamp) %>% 
    mutate(corr = "temp_anomalous")
  
  #return the df without anomalous values
  return(anomaly)
}



  
  
  

