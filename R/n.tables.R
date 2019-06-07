#' @title Gets the number of phenotypic datatables in the study
#'
#' @param phs dbGap study ID (phs00xxxx, or 00xxxx, or xxx)
#'
#' @return Return the number of phenotypic datatables in the study
#'
#' @description This function extracts informations from data.dict.xml files from the dbgap ftp server to get the study characteristics. Works only for a parent study.
#' @import RCurl
#'
#' @author Gregoire Versmee, Laura Versmee, Mikael Dusenne, Niloofar Jalali
#' @export

n.tables <- function(phs)  {

  phs <- phs.version(phs)
  url<- paste0("ftp://anonymous:anonymous@ftp.ncbi.nlm.nih.gov/dbgap/studies/", unlist(strsplit(phs, "\\."))[1], "/", phs, "/")

    filenames <- RCurl::getURL(url, ftp.use.epsv = FALSE, dirlistonly = TRUE, crlf = TRUE)
    filenames <- strsplit(filenames, "\r*\n")[[1]]
    phenodir <- paste0(url, filenames[grep("pheno", filenames)], "/")
    
    filelist <- RCurl::getURL(phenodir, ftp.use.epsv = FALSE, dirlistonly = TRUE, crlf=TRUE)
    filelist <- strsplit(filelist, "\r*\n")[[1]]

    
  return(length(list.tables(filelist)))
}
