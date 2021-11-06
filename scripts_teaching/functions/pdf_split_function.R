# Description: split hand_ins for Meko by task
##main source: https://www.r-bloggers.com/join-split-and-compress-pdf-files-with-pdftools/
# Author: Alice Ziegler, David Langenohl
# Date: 2020-05-25

# install needed packages if not installed yet; load packages
packages_to_install <- c("pdftools")
new_packages <- packages_to_install[!(packages_to_install %in% installed.packages()[,"Package"])]
if(length(new_packages)) install.packages(new_packages)

library(pdftools)

# define function
split_pdfs <- function(inpath, unit, split_rule, testing_for_names = F){
  problems <- data.frame(student = c(), problem_with_file_format = c(), problem_with_pages = c(), name_not_on_each_page = c())

  folder_nms <- list.files(inpath, recursive = F)
  
  for (j in folder_nms){ #loop over students folders
    print(j)
    file_nm <- list.files(file.path(inpath,j))
    if(substr(file_nm, nchar(file_nm)-3,nchar(file_nm)) == ".pdf"){ # check if pdf
      pages <- pdf_info(file.path(inpath, j, file_nm))$pages
      #Fehler abfangen: 
      if(pages == sum(split_rule$no_of_pages)){ # check if right number of pages
        for (i in seq(nrow(split_rule))){
          #print(i)
            #Ordner f?r jede Teilaufgabe erstellen
            ex_nm <- paste0("unit", unit, "_", split_rule$exs[i])
            subfolder <- paste0(inpath, "_pdf_splits/", ex_nm, "/")
            
            #check if folder exists
            if (file.exists(subfolder)==F){
              dir.create(file.path(subfolder), recursive = T)
            }
            #start und end Seiten festlegen
            if (i == 1){
              ex_start <- 1
            } else{
              ex_start <- sum(split_rule$no_of_pages[c(1:(i-1))])+1
            }
            
            ex_end <- sum(split_rule$no_of_pages[c(1:(i))])
            
            j_elements <- strsplit(j, "_")
            studi <- paste0(j_elements[[1]][length(j_elements[[1]]) - 3], "_", j_elements[[1]][length(j_elements[[1]])])
            #studi <- substr(j, nchar(j)-6, nchar(j))
            
            #file splitten und in Ordner aufteilen
            pdf_subset(file.path(inpath, j,"/", file_nm), pages = ex_start:ex_end, 
                       output = paste0(subfolder, studi, "_", ex_nm, ".pdf"))
        }
      }else{
        j_elements <- strsplit(j, "_")
        problem_tmp <- data.frame(student = paste0(j_elements[[1]][length(j_elements[[1]]) - 3], "_", j_elements[[1]][length(j_elements[[1]])]),
                         problem_with_file_format = F,
                         problem_with_pages = T,
                         name_not_on_each_page = F)
        problems <- rbind(problems, problem_tmp)
      }
    }else{
      j_elements <- strsplit(j, "_")
      problem_tmp <- data.frame(student = paste0(j_elements[[1]][length(j_elements[[1]]) - 3], "_", j_elements[[1]][length(j_elements[[1]])]),
                       problem_with_file_format = T,
                       problem_with_pages = F,
                       name_not_on_each_page = F)
      problems <- rbind(problems, problem_tmp)
    }
    
    #testing for name on every slide if testing_for_names is set to True
    if(testing_for_names==T && substr(file_nm, nchar(file_nm)-3,nchar(file_nm))==".pdf" && pages==sum(split_rule$no_of_pages)){
      
      students_pdf <- as.list(file.path(inpath, j, file_nm))
      
      extracted_text <- lapply(students_pdf, function(x){
        pngfile <- pdftools::pdf_convert(x, dpi = 72)
        text <- tesseract::ocr(pngfile, engine = tesseract(language = "deu"))
        file.remove(pngfile)
        return(text)})
      extracted_text <- unlist(extracted_text)
      
      for(u in seq(length(extracted_text))){
        if(grepl(j_elements[[1]][length(j_elements[[1]])], extracted_text[u]) == F){
          name_on_every_page <- F
        }
      }
      
      if(name_on_every_page == F){
        problem_tmp <- data.frame(student = paste0(j_elements[[1]][length(j_elements[[1]]) - 3], "_", j_elements[[1]][length(j_elements[[1]])]),
                                  problem_with_file_format = F,
                                  problem_with_pages = F,
                                  name_not_on_each_page = T)
        problems <- rbind(problems, problem_tmp)
      }
    }
    
  }
  
  return(problems)
}
