#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Title: Fall 2020 fDOM processing
#Coder: 
#Date: 1/19/2022
#Purpose: 
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#Notes:

#   - 
#   -

# 1. Libraries and work space ----------------------------------------------

remove(list = ls())

library(xts)
library(dygraphs)
library(purrr)
library(readr)
library(lubridate)
library(stringr)
library(tidyverse)

source("R/download_fun_exo.R")

data_dir <- "/Data/"

# 2. Organize files and read data -----------------------------------------

Exo_files <- list.files(paste0(data_dir), full.names = TRUE)

Exo_files <- Exo_files[str_detect(Exo_files, "EXO")]

data_full <- Exo_files %>% 
  map(download_fun) %>% 
  reduce(rbind)


library(readxl)















