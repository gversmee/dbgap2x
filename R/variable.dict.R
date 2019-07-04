#' @title Creates a variables dictionary of your study
#'
#' @param phs dbGaP study ID (phs00xxxx, or 00xxxx, or xxx)
#' @param cores Number of cores used to perform the function. Default to the number of cores available on your system. Decrease the number if the function doesn't perform as expected
#'
#' @return A data.frame with 4 columns : variable identifier (dbGaP), table name, variable name, variable description
#'
#' @description This function extracts informations from data.dict.xml files from the dbGaP ftp server to create a variable dictionary.
#' @import XML
#' @import RCurl
#' @import parallel
#' @import data.table
#'
#' @author Gregoire Versmee, Laura Versmee, Mikael Dusenne, Niloofar Jalali
#' @export

variables.dict <-function (phs, cores = parallel::detectCores())  {

  phs <- phs.version(phs)

  #selecting all xml files except for "Subject", "Sample", "Pedigree", and phenotypics data from substudies
  url<- paste0("ftp://anonymous:anonymous@ftp.ncbi.nlm.nih.gov/dbgap/studies/", unlist(strsplit(phs, "\\."))[1], "/", phs, "/")

  filenames <- strsplit(RCurl::getURL(url, ftp.use.epsv = TRUE, dirlistonly = TRUE), "\n")[[1]]
  phenodir <- paste0(url, filenames[grep("pheno", filenames)], "/")
  filelist <- strsplit(RCurl::getURL(phenodir, ftp.use.epsv = FALSE, dirlistonly = TRUE), "\n")[[1]]
  temp <- filelist[(grepl(".data_dict.xml", filelist)) & (!grepl("Sample_Attributes.data_dict.xml", filelist)) &
                     (!grepl("Subject.data_dict.xml", filelist)) & (!grepl("Sample.data_dict.xml", filelist)) & (!grepl("Pedigree.data_dict.xml", filelist))]

  mcl <- parallel::mclapply(temp, function(e) {
    xmllist <- XML::xmlToList(RCurl::getURLContent(paste0(phenodir, e)))
    dt_name <- xmllist[[".attrs"]][["id"]]
    dt_sn <- substr(e, regexpr(dt_name, e) + nchar(dt_name)+1, regexpr(".data_dict", e)-1)
    xmllist <- xmllist[names(xmllist) == "variable"]
    df <- cbind(as.character(sapply(xmllist, "[", ".attrs")), as.character(sapply(xmllist, "[", "name")), as.character(sapply(xmllist, "[", "description")))
    df <- data.frame(cbind(dt_sn, df))

    return(df)

  }, mc.cores = cores)

  table <- data.table::rbindlist(mcl)

  #Create column names
  colnames(table) <- c("dt_study_name", "phv", "var_name", "var_desc")

  return(table)
}
