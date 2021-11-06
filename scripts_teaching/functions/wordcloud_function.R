# Description: functiong for making wordclouds from hand-ins
# Author: David Langenohl
# Date: 2020-05-26

# install needed packages if not installed yet; load packages
packages_to_install <- c("tm", "SnowballC", "wordcloud", "RColorBrewer")
new_packages <- packages_to_install[!(packages_to_install %in% installed.packages()[,"Package"])]
if(length(new_packages)) install.packages(new_packages)

library(tm)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)
library(pdftools)
library(tesseract)

# define function
meko_wordcloud <- function(unit, task, split_path, max_words, excluded_words = NULL, output_dir){
  
  #check, if the german-language package is loaded in tesseract
  if(c("deu" %in% tesseract::tesseract_info()$available) == F){
    tesseract::tesseract_download("deu")
  }
  
  path <- file.path(split_path, paste0("unit", unit, "_", task))
  
  task_pdfs <- as.list(list.files(path, full.names = T))
  
  #check if task_pdfs is empty and gives out warning, if so
  if(length(task_pdfs)==0){
    stop("please check, if unit was set correctly")
  }
  
  extracted_text <- lapply(task_pdfs, function(x){
    pngfile <- pdftools::pdf_convert(x, dpi = 300)
    text <- tesseract::ocr(pngfile, engine = tesseract(language = "deu"))
    file.remove(pngfile)
    return(text)})
  
  pdf_text <- unlist(extracted_text)
  
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
  if(is.null(excluded_words)==F){
    pdf_text_corp <- tm_map(pdf_text_corp, removeWords, excluded_words)
  }
  
  #inspect(pdf_text_corp)
  
  dtm <- TermDocumentMatrix(pdf_text_corp)
  m <- as.matrix(dtm)
  v <- sort(rowSums(m),decreasing=TRUE)
  d <- data.frame(word = names(v),freq=v)
  head(d, 10)
  
  set.seed(1234)
  
  png(filename = file.path(output_dir, paste0("wordcloud_task_", task, ".png")),
      width = 480,
      height = 480,
      res = 180)
  students_wordcloud <- wordcloud(words = d$word, freq = d$freq, min.freq = 2,
                                  max.words=max_words, random.order=FALSE, rot.per=0.35, 
                                  colors=brewer.pal(8, "Dark2"))
  dev.off()
}
