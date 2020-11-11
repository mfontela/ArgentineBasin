#ABtrends_step0

list.of.packages <- c("R.matlab", "rlist", "tidyverse", "readxl", "marmap", "seacarb", "xlsx", "reshape2")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
#This step install packages when needed

# Load packages -----------------------------------------------------------
library(R.matlab)
library(rlist)
library(tidyverse)
library(readxl)
library(marmap)
library(seacarb)
library(xlsx)
library(reshape2)

# Load theme for plots ----------------------------------------------------
source("ABtrends_theme.R")

