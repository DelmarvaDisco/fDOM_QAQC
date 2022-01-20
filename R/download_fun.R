#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Title: Downloading Exo files
#Coder: James Maze (jtmaze@umd.edu)
#Date: 1/19/2022
#Purpose: To read in large batches of EXO downloads and keep metadata
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

download_fun <- function(file_path){
  #Read files
  temp <- read_csv(paste0(file_path),
                   skip = 9, 
                   col_names = FALSE) %>% 
    as_tibble()
  
  temp
    
}




