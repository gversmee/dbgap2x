#' @title Creates study's tables dictionary
#'
#' @param phs dbGaP study ID (phs00xxxx, or 00xxxx, or xxx)
#' @param cores Number of cores used to perform the function. Default to the number of cores available on your system. Decrease the number if the function doesn't perform as expected
#'
#' @return a data.frame with 3 columns : table id (pht), table name (dt_study_name) and description (dt_label)
#'
#' @description This function extracts informations from data.dict.xml files from the dbGaP ftp server to create a table dictionary.
#' @import XML
#' @import RCurl
#' @import parallel
#'
#' @author Gregoire Versmee, Laura Versmee, Mikael Dusenne, Niloofar Jalali
#' @export

datatables.dict <-function (phs, cores = parallel::detectCores())  {

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
  }, mc.cores = cores)
  , check.names = FALSE, fix.empty.names = FALSE, stringsAsFactors = FALSE)))

  #Create column names
  colnames(df) <- c("pht", "dt_study_name", "dt_label")

  return(df)
}

