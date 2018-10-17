#' @title Create a tables dictionnary of your study
#'
#' @param phs dbGap ID of your study "phs000000". No version please, as it will automatically return the latest one.
#'
#' @return a data.frame with 3 cols : XXXXX
#'
#' @description This function extracts informations from data.dict.xml files from the dbgap ftp server to create a table dictionnary.
#' @import XML
#' @import RCurl
#' @import parallel
#'
#' @author Gregoire Versmee, Laura Versmee
#' @export

datatables.dict <-function (phs)  {

  phs <- phs.version(phs)

  #selecting all xml files except for "Subject", "Sample", "Pedigree", and phenotypics data from substudies
  url<- paste0("ftp://anonymous:anonymous@ftp.ncbi.nlm.nih.gov/dbgap/studies/", unlist(strsplit(phs, "\\."))[1], "/", phs, "/")

  filenames <- strsplit(RCurl::getURL(url, ftp.use.epsv = TRUE, dirlistonly = TRUE), "\n")[[1]]
  phenodir <- paste0(url, filenames[grep("pheno", filenames)], "/")
  filelist <- strsplit(RCurl::getURL(phenodir, ftp.use.epsv = FALSE, dirlistonly = TRUE), "\n")[[1]]
  temp <- filelist[(grepl(".data_dict.xml", filelist)) & (!grepl("Sample_Attributes.data_dict.xml", filelist)) &
        (!grepl("Subject.data_dict.xml", filelist)) & (!grepl("Sample.data_dict.xml", filelist)) & (!grepl("Pedigree.data_dict.xml", filelist))]

  #Looping!!
  df <- data.frame(t(as.data.frame(
  parallel::mclapply(temp, function(e) {
    xmllist <- XML::xmlToList(RCurl::getURLContent(paste0(phenodir, e)))

    dt_name <- xmllist[[".attrs"]][["id"]]
    dt_sn <- substr(e, regexpr(dt_name, e) + nchar(dt_name)+1, regexpr(".data_dict", e)-1)
    dt_label <- xmllist[["description"]]
    if (is.null(dt_label)) dt_label <- dt_sn

    return(c(dt_name, dt_sn, dt_label))
  }, mc.cores = getOption("mc.cores", parallel::detectCores()))
  , check.names = FALSE, fix.empty.names = FALSE, stringsAsFactors = FALSE)))

  #Create column names
  colnames(df) <- c("pht", "dt_study_name", "dt_label")

  return(df)
}
