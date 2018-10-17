#' @title Create a variables dictionnary of your study
#'
#' @param phs dbGap study ID (phs00xxxx, or 00xxxx, or xxx)
#'
#' @return a data.frame with 4 cols : variable identifier (dbGap), table name, variable name, variable description
#'
#' @description This function extracts informations from data.dict.xml files from the dbgap ftp server to create a variable dictionnary.
#' @import XML
#' @import RCurl
#' @import parallel
#' @import data.table
#'
#' @author Gregoire Versmee, Laura Versmee
#' @export

variables.dict <-function (phs)  {

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

  }, mc.cores = getOption("mc.cores", parallel::detectCores()))

  table <- data.table::rbindlist(mcl)

  #Create column names
  colnames(table) <- c("dt_study_name", "phv", "var_name", "var_desc")

  return(table)
}
