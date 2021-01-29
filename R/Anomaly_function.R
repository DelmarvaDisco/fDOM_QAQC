#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Title: Anomaly Remover
#Coder: James Maze (jtmaze@umd.edu)
#Date: 1/14/21
#Purpose: To remove unusual/low values from sonde data.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Function ----------------------------------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

fun_anomalous <- function(df, #timeseries data with anomalous values
                min, #The minimum threshold for residuals from rolling median 
                max #The maximum threshold for residuals from rolling median
){
  #load packages
  library(tidyverse)
  library(zoo)

  #Check values against the residuals of a rolling median. 
  df <- df %>% 
    mutate("rolling_median" = rollmedian(df$value,
                                         7, 
                                         fill = NA, 
                                         align = "center")) %>% 

    mutate("residuals" = value - rolling_median) %>% 
    filter(residuals > min) %>% 
    filter(residuals < max)
  
  #Clean up the dataframe
  df <- df %>% 
    select(value, Timestamp) %>% 
    mutate(corr = 2)
  
  #return the df without anomalous values
  return(df)
}



  
  
  

