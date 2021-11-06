# Description: merge splitted hand-ins for Meko by task
##main source: https://www.r-bloggers.com/join-split-and-compress-pdf-files-with-pdftools/
# Author: Alice Ziegler, David Langenohl
# Date: 2020-05-25

# install needed packages if not installed yet; load packages
packages_to_install <- c("pdftools")
new_packages <- packages_to_install[!(packages_to_install %in% installed.packages()[,"Package"])]
if(length(new_packages)) install.packages(new_packages)

library(pdftools)

merge_pdfs <- function(inpath, unit, split_rule){
  inpath_folders <- paste0(inpath, "_pdf_splits/")
  merged_folder <- paste0(inpath, "_pdf_merged/")
  if (file.exists(merged_folder)==F){
    dir.create(file.path(merged_folder), recursive = T)
  }
  folders <- list.files(path = inpath_folders, recursive = F, include.dirs = T)
  for (i in folders){
    print(i)
    pdf_nms <- list.files(paste0(inpath_folders, i), full.names = T)
    
    pdf_combine(pdf_nms, output = paste0(merged_folder, i, "_all_merged.pdf")) #"merged.pdf" )#
  }
  
}