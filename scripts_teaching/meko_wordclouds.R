# Description: make wordclouds from hand-ins
# Author: David Langenohl
# Date: 2020-05-26

#empty the working space
rm(list = ls())

#set working directory
setwd(dirname(rstudioapi::getSourceEditorContext()[[2]]))

# load functions (needed packages are loaded automatically)
source("functions/pdf_split_function.R")
source("functions/wordcloud_function.R")
source("functions/image_and_grade_specific_wordcloud_function.R")

##########################################################################################################################################################
## Split PDFs ##
###############
## the handed-in PDF-files need to be splitted before creating a wordcloud; if not already done, use the following function
# define name of folder, the students downloaded homework are placed at (in this version, this folder should be directly placed in the working directory)
folder_name <- "Lerneinheit_02"
inpath <- file.path(getwd(), folder_name)

# define number of unit
unit = "02"

# define number of pages for every task 
#split_rule <- data.frame(exs = c("1L1", "1L2", "1L3", "2L1", "2L2", "2L3", "3L1", "3L2", "3L3"), 
#                         no_of_pages = c(1,2,1,1,1,1,1,1,1))
split_rule <- data.frame(exs = c("1L1", "1L2", "1L3"), 
                         no_of_pages = c(1,2,1))

split_pdfs(inpath = inpath, unit = unit, split_rule = split_rule, testing_for_names = F)

##########################################################################################################################################################
## Create wordcloud for specific task ##
#######################################

# define name of folder the splitted PDFs are placed at
split_path <- file.path(getwd(), "Lerneinheit_02_pdf_splits")

# define number of unit (this need to conform with the naming of the folders that contain the split-PDFs; e.g. unit1_L1 -> unit = "1" BUT unit01_L1 -> unit = "01")
unit = "02"

# define task
task = "1L1"

# if preferted, define (additional) words that shall be excluded from the world cloud
## note: typical words like "der", "die", "das" as well as special words like "Aufgabe","Thomas" and "Nauss" are already being exluded and do not need to be specified here
excluded_words <- c("commonswikimediaorg", "commons", "wikimedia", "org", "bysa", "bild", "bildreihe", "bilderreihe")

# specify, how much words should be shown in the wordcloud
max_words = 30

# define output_directory; please make sure, the specific directory exists and create defined folder, if necessary
output_dir = file.path(getwd(),"wordclouds_unit02_1l1")

# create wordcloud
meko_wordcloud(unit = unit, task = task,
               split_path = split_path,
               max_words = max_words,
               excluded_words = excluded_words,
               output_dir = output_dir)

##########################################################################################################################################################
## Create wordcloud for unit02, task 1L1, divided by described image ##
######################################################################

# define unit
unit = "02"

# define task
task = "1L1"

# define path to splitted pdf-files
split_path = file.path(getwd(), "Lerneinheit_02_pdf_splits")

# define maximum amount of words, displayed in the workcloud
max_words = 30

# define words that shall be excluded
excluded_words <- c("commonswikimediaorg", "commons", "wikimedia", "org", "bysa")

# define output_directory; please make sure, the specific directory exists and create defined folder, if necessary
output_dir = file.path(getwd(),"wordclouds_unit02_1l1")

## perform creation of wordclouds by image only
meko_wordcloud_by_image(unit = unit, 
                        task = task, 
                        split_path = split_path, 
                        max_words = max_words, 
                        excluded_words = excluded_words, 
                        output_dir = output_dir)

##########################################################################################################################################################
## Create wordcloud for unit02, task 1L1, divided by described image AND grade of hand-in##
##########################################################################################

# define unit
unit = "02"

# define task
task = "1L1"

# define path to splitted pdf-files
split_path = file.path(getwd(), "Lerneinheit_02_pdf_splits")

# define maximum amount of words, displayed in the workcloud
max_words = 30

# define output_directory; please make sure, the specific directory exists and create defined folder, if necessary
output_dir = file.path(getwd(),"wordclouds_unit02_1l1")

# define path to list of grades
## IMPORTANT: delete the first 6 rows of the "Bewertung"-Excel-Sheet -> then save the current sheet as csv-file -> open it within a text-editor and replace the strange "ÿ" (i.e. ein Ypsilon mit zwei Doppelpunkten darüber) with empty spaces; otherwise the script won't run
list_of_grades <- file.path(getwd(), "wordclouds_unit02_1l1","Bewertung_bearbeitet.csv")

# define number of coloumn that contains the grades
grade_col <- 5

# define max number of points a student can earn in the task
max_points <- 2

# define words that shall be excluded
excluded_words <- c("commonswikimediaorg", "commons", "wikimedia", "org", "bysa")

## perform creation of wordclouds by grade and image
### IMPORTANT: if for a specific grade no wordcloud is drawn, this means that within the hand-ins which were graded with this specific grade, the specific image (like "Bild 1) has not been described
meko_wordcloud_by_grade_and_image(unit = unit, 
                                  task = task, 
                                  split_path = split_path, 
                                  max_words = max_words, 
                                  excluded_words = excluded_words, 
                                  output_dir = output_dir, 
                                  list_of_grades = list_of_grades, 
                                  grade_col = grade_col, 
                                  max_points = max_points)