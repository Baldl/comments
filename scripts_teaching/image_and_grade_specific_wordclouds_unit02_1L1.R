# Description: function for making wordclouds from hand-ins, grouped by the described image and the grade of the hand-in
# Author: David Langenohl
# Date: 2020-06-01

#empty the working space
rm(list = ls())

# set wd
setwd(dirname(rstudioapi::getSourceEditorContext()[[2]]))

# install needed packages if not installed yet; load packages
packages_to_install <- c("tm", "SnowballC", "wordcloud", "RColorBrewer", "tesseract", "pdftools")
new_packages <- packages_to_install[!(packages_to_install %in% installed.packages()[,"Package"])]
if(length(new_packages)) install.packages(new_packages)

library(tm)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)
library(pdftools)
library(tesseract)

# drawing function
draw_the_clouds <- function(pdf_text, name_of_output){
  pdf_text <- unlist(pdf_text)
  pdf_text_corp <- Corpus(VectorSource(pdf_text))
  
  # Convert the text to lower case
  pdf_text_corp <- tm_map(pdf_text_corp, content_transformer(tolower))
  # Remove numbers
  pdf_text_corp <- tm_map(pdf_text_corp, removeNumbers)
  # Remove german common stopwords
  #stopwords("german) #shows which stopwords are removed
  pdf_text_corp <- tm_map(pdf_text_corp, removeWords, stopwords("german"))
  # specify additional stopwords as a character vector
  pdf_text_corp <- tm_map(pdf_text_corp, removeWords, c("dass", "aufgabe", "sose", "dr", "thomas", "nauss", "meko", "medienkompetenz"))
  # Remove punctuations
  pdf_text_corp <- tm_map(pdf_text_corp, removePunctuation)
  # Eliminate extra white spaces
  pdf_text_corp <- tm_map(pdf_text_corp, stripWhitespace)
  # if excluded_words were specified, exlude those
  # if(is.null(excluded_words)==F){
  #   pdf_text_corp <- tm_map(pdf_text_corp, removeWords, excluded_words)
  # }
  
  #inspect(pdf_text_corp)
  
  dtm <- TermDocumentMatrix(pdf_text_corp)
  m <- as.matrix(dtm)
  v <- sort(rowSums(m),decreasing=TRUE)
  d <- data.frame(word = names(v),freq=v)
  head(d, 10)
  
  set.seed(1234)
  
  png(filename = name_of_output)
  wordcloud(words = d$word, freq = d$freq, min.freq = 1,
            max.words=max_words, random.order=FALSE, rot.per=0.35, 
            colors=brewer.pal(8, "Dark2"))
  dev.off()
}

# define function
meko_wordcloud_by_grade_and_image <- function(unit, task, split_path, max_words, excluded_words = NULL, output_dir, list_of_grades, grade_col, max_points){
  
  #check, if the german-language package is loaded in tesseract
  if(c("deu" %in% tesseract::tesseract_info()$available) == F){
    tesseract::tesseract_download("deu")
  }
  
  path <- file.path(split_path, paste0("unit", unit, "_", task))
  
  #check if task_pdfs is empty and gives out warning, if so
  if(length(list.files(path, full.names = T))==0){
    stop("please check, if unit was set correctly")
  }
  
  ## read in data
  test <- read.csv(list_of_grades)
  test <- test[, c(3, grade_col)]
  test[,1] <- as.character(test[,1])
  test[,2] <- as.numeric(test[,2])
  test[which(is.na(test[,2])==T),2] <- 0
  
  for(i in seq(0,max_points)){
    students <- as.vector(test[which(test[,2] == i),1])
    
    task_pdfs <- list.files(path, full.names = T)
    
    has_grade <- c()
    
    for(u in students){
      if(is.null(grep(u, task_pdfs))==F){
        has_grade_temp <- task_pdfs[grep(u, task_pdfs)]
        has_grade <- c(has_grade, has_grade_temp)
      }
    }
    
    task_pdfs <- as.list(has_grade)
    
    pdf_text <- lapply(task_pdfs, function(x){
      pngfile <- pdftools::pdf_convert(x, dpi = 72)
      text <- tesseract::ocr(pngfile, engine = tesseract(language = "deu"))
      file.remove(pngfile)
      return(text)})
    
    #pdf_text <- unlist(extracted_text)
    
    Bild_1 <- lapply(pdf_text, function(u){
      if(grepl("Bild 1", u)==T){
        text <- gsub(".*Bild 1\\s*|Bild 2.*", "", u)
      }
      else if(grepl("Bild a)", u)==T){
        text <- gsub(".*Bild a)\\s*|Bild b).*", "", u)
      }
      else if(grepl("Bild (a)", u)==T){
        text <- gsub(".*Bild (a)\\s*|Bild (b).*", "", u)
      }
    })
    
    Bild_2 <- lapply(pdf_text, function(u){
      if(grepl("Bild 1", u)==T){
        text <- gsub(".*Bild 2\\s*|Bild 3.*", "", u)
      }
      else if(grepl("Bild b)", u)==T){
        text <- gsub(".*Bild b)\\s*|Bild c).*", "", u)
      }
      else if(grepl("Bild (a)", u)==T){
        text <- gsub(".*Bild (b)\\s*|Bild (c).*", "", u)
      }
    })
    
    Bild_3 <- lapply(pdf_text, function(u){
      if(grepl("Bild 3", u)==T){
        text <- gsub(".*Bild 3", "", u)
      }
      else if(grepl("Bild c)", u)==T){
        text <- gsub(".*Bild c)", "", u)
      }
      else if(grepl("Bild (c)", u)==T){
        text <- gsub(".*Bild (c)", "", u)
      }
    })
    
    Bildreihe_1 <- lapply(pdf_text, function(u){
      if(grepl("Bilderreihe 1", u)==T){
        text <- gsub(".*Bilderreihe 1\\s*|Bilderreihe 2.*", "", u)
      }
      else if(grepl("Bildreihe 1", u)==T){
        text <- gsub(".*Bildreihe 1\\s*|Bildreihe 2.*", "", u)
      }
    })
    
    Bildreihe_2 <- lapply(pdf_text, function(u){
      if(grepl("Bilderreihe 2", u)==T){
        text <- gsub(".*Bilderreihe 2\\s*|Bilderreihe 3.*", "", u)
      }
      else if(grepl("Bildreihe 2", u)==T){
        text <- gsub(".*Bildreihe 2\\s*|Bildreihe 3.*", "", u)
      }
    })
    
    Bildreihe_3 <- lapply(pdf_text, function(u){
      if(grepl("Bilderreihe 3", u)==T){
        text <- gsub(".*Bilderreihe 3", "", u)
      }
      else if(grepl("Bildreihe 3", u)==T){
        text <- gsub(".*Bildreihe 3", "", u)
      }
    })
    
    
    # now create worldclouds
    if(is.null(unlist(Bild_1))==F){draw_the_clouds(Bild_1, file.path(output_dir, paste0("grade_", i, "_Bild1.png")))}
    if(is.null(unlist(Bild_2))==F){draw_the_clouds(Bild_2, file.path(output_dir, paste0("grade_", i, "_Bild2.png")))}
    if(is.null(unlist(Bild_3))==F){draw_the_clouds(Bild_3, file.path(output_dir, paste0("grade_", i, "_Bild3.png")))}
    if(is.null(unlist(Bildreihe_1))==F){draw_the_clouds(Bildreihe_1, file.path(output_dir, paste0("grade_", i, "_Bildreihe1.png")))}
    if(is.null(unlist(Bildreihe_2))==F){draw_the_clouds(Bildreihe_2, file.path(output_dir, paste0("grade_", i, "_Bildreihe2.png")))}
    if(is.null(unlist(Bildreihe_3))==F){draw_the_clouds(Bildreihe_3, file.path(output_dir, paste0("grade_", i, "_Bildreihe3.png")))}
  }
}

############################################################################################################################
## use the function to create the wordclouds ##
##############################################
## define unit
unit = "02"

## define task
task = "1L1"

## define path to splitted pdf-files
split_path = file.path(getwd(), "Lerneinheit_02_pdf_splits")

## define maximum amount of words, displayed in the workcloud
max_words = 50

## define output_directory; please make sure, the specific directory exists and create defined folder, if necessary
output_dir = file.path(getwd(),"wordclouds_unit02_1l1")

## define path to list of grades
### IMPORTANT: delete the first 6 rows of the "Bewertung"-Excel-Sheet -> then save the current sheet as csv-file -> open it within a text-editor and replace the strange "ÿ" (i.e. ein Ypsilon mit zwei Doppelpunkten darüber) with empty spaces; otherwise the script won't run
list_of_grades <- file.path(getwd(), "wordclouds_unit02_1l1","Bewertung.csv")

## define number of coloumn that contains the grades
grade_col <- 7

## define max number of points a student can earn in the task
max_points <- 2

## perform creation of wordclouds
## IMPORTANT: if for a specific grade no wordcloud is drawn, this means that within the hand-ins which were graded with this specific grade, the specific image (like "Bild 1) has not been described
meko_wordcloud_by_grade_and_image(unit = unit, 
                                  task = task, 
                                  split_path = split_path, 
                                  max_words = max_words, 
                                  excluded_words = NULL, 
                                  output_dir = output_dir, 
                                  list_of_grades = list_of_grades, 
                                  grade_col = grade_col, 
                                  max_points = max_points)
