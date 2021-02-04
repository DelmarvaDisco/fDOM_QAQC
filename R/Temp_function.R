#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Title: fDOM Temperature Correction
#Coder: James Maze (jtmaze@umd.edu)
#Date: 1/20/21
#Purpose: Correcting the fDOM sonde data with co-located temp sensors.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Function ----------------------------------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

fun_temp <- function(df #timeseries with fDOM data and co-located temp sensor. 
                     
){
  #load packages
  library(tidyverse)
  
  #Check values against the residuals of a rolling median. 
  df <- df %>% 
    mutate("Temp_Error" = m/3 * (Temp_C - 22)) %>% 
    mutate("value" = value + (Temp_Error/100 * value)) %>% 
    mutate("corr" = "temp")
  
  #Clean up the dataframe
  df <- df %>% 
    select(c("value", "Timestamp", "corr")) 
  
  #return the df without temperature corrected values
  return(df)
}


