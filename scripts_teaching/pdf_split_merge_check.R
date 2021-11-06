# Description: script for splitting and merging of students' hand-ins for MeKo and checking for possible plagiats
# Author: Alice Ziegler, David Langenohl
# Date: 2020-05-25

#empty working space
rm(list=ls())

#load functions for splitting and merging and similarity checking
source("functions/pdf_split_function.R")
source("functions/pdf_merge_function.R")
source("functions/similarity_checker_function.R")

#set working directory
setwd(dirname(rstudioapi::getSourceEditorContext()[[2]]))

#define name of folder, the students downloaded homework are placed at (in this version, this folder should be directly placed in the working directory)
folder_name <- "Lerneinheit_01"
inpath <- file.path(getwd(), folder_name)

# define number of unit
unit = 1

# define number of pages for every task 
## e.g.: if for task 1L3 3 pages shall be handed in, write a 3 at the third place 
split_rule <- data.frame(exs = c("1L1", "1L2", "1L3", "2L1", "2L2", "2L3", "3L1", "3L2", "3L3"), 
                         no_of_pages = c(1,1,1,1,1,1,1,1,1))

##########################################################################################################################################################
## Split PDFs ##
###############
## gives back a data frame, containing information about students which: 
### handed in non-PDF files
### did not use empty pages for tasks they did not do
### did not write their name on every page (you need to set "testing_for_names == T" for this; takes very long)

wrong_format <- split_pdfs(inpath = inpath, unit = unit, split_rule = split_rule, testing_for_names = F)

##########################################################################################################################################################
## Merge PDFs ##
###############
## merges the splitted PDFs to 9 PDF files, one for each task

merge_pdfs(inpath = inpath, unit = unit, split_rule = split_rule)

##########################################################################################################################################################
## Check for possible plagiats ##
################################
## writes the result of every checked assignment into a csv-file

## specifiy directory the pdf-files you want to check are stored at
foldername_merged <- paste0(folder_name, "_pdf_merged")

similarity_checker(foldername_merged = foldername_merged)
