#' @title Gets the number of phenotypic datatables in the study
#'
#' @param phs dbGaP study ID (phs00xxxx, or 00xxxx, or xxx)
#'
#' @return Return the number of phenotypic datatables in the study
#'
#' @description This function extracts informations from data.dict.xml files from the dbGaP ftp server to get the study characteristics. Works only for a parent study.
#' @import RCurl
#'
#' @author Gregoire Versmee, Laura Versmee, Mikael Dusenne, Niloofar Jalali
#' @export

n.tables <- function(phs)  {

    phenodir <- pheno.dir(phs)
    
    filelist <- file.list(phenodir)
    
  return(length(list.tables(filelist)))
}
