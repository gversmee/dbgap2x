#' @title Gets the number of phenotypic variables in the study
#'
#' @param phs dbGap study ID (phs00xxxx, or 00xxxx, or xxx)
#'
#' @return Return the number of phenotypic variables in the study
#'
#' @description This function extracts informations from data.dict.xml files from the dbgap ftp server to get the study characteristics. Works only for a parent study.
#' @import RCurl
#'
#' @author Gregoire Versmee, Laura Versmee, Mikael Dusenne, Niloofar Jalali
#' @export


n.variables <- function(phs)  {

    phenodir <- pheno.dir(phs)
    
    filelist <- RCurl::getURL(phenodir, ftp.use.epsv = FALSE, dirlistonly = TRUE, crlf=TRUE)
    filelist <- strsplit(filelist, "\r*\n")[[1]]
    
  temp <- list.tables(filelist)

  mcl <- parallel::mclapply(temp, function(e) {
    xmllist <- XML::xmlToList(RCurl::getURLContent(paste0(phenodir, e)))
    return(length(which(names(xmllist) == "variable")))
  }, mc.cores = getOption("mc.cores", parallel::detectCores()))

    return(Reduce(sum, mcl))
}
