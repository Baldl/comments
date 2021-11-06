# Description: similarity check of student's homeworks
# Author: David Langenohl
# Date: 2020-05-26

# install needed packages if not installed yet; load packages
packages_to_install <- c("pdftools", "textreuse")
new_packages <- packages_to_install[!(packages_to_install %in% installed.packages()[,"Package"])]
if(length(new_packages)) install.packages(new_packages)

require(pdftools)
require(textreuse)

# define function
similarity_checker <- function(foldername_merged){
  
  # define inpath
  inpath <- file.path(getwd(), foldername_merged)
  
  # get all files within "pdf_merged"
  merged_files <- as.list(list.files(inpath, pattern = "_all_merged.pdf"))
  
  # similarity check; writes the result of every checked assignment into a csv-file
  possible_similarities <- lapply(merged_files, function(merged_pdf){
    
    students_pdf <- file.path(inpath, merged_pdf)
    
    #check, if the german-language package is loaded in tesseract
    if(c("deu" %in% tesseract::tesseract_info()$available) == F){
      tesseract::tesseract_download("deu")
    }
    
    # extract text from pdf; store every page as seperate item in a vector (needed to create corpus) 
    extracted_text <- lapply(students_pdf, function(x){
      pngfile <- pdftools::pdf_convert(x, dpi = 72)
      text <- tesseract::ocr(pngfile, engine = tesseract(language = "deu"))
      file.remove(pngfile)
      return(text)})
    extracted_text <- unlist(extracted_text)
    
    # create corpus (specific element needed for comparison-function) and do comparison
    corpus <- TextReuseCorpus(text = extracted_text,
                              tokenizer = tokenize_ngrams, n = 25)
    
    comparisons <- as.data.frame(pairwise_compare(corpus, jaccard_similarity))
    
    # reduce to pairs of possible plagiats
    possible_plagiats <- which(comparisons > 0.2, arr.ind=TRUE)
    
    #write to csv-file
    write.csv(possible_plagiats, file.path(inpath, paste0(tools::file_path_sans_ext(merged_pdf), "_similarities.csv")))
    return(possible_plagiats)
  })
  return(possible_similarities)
}

