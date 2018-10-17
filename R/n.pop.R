#' @title Gets the population number of the study
#'
#' @param phs dbGap study ID (phs00xxxx, or 00xxxx, or xxx)
#' @param consentgroup if false, will return only the total number of participants
#'
#' @return a data.frame with 2 cols : name of the consent group and n total. Possibility to add the breakdown by gender
#'
#' @description This function extracts informations from data.dict.xml files from the dbgap ftp server to get the population characteristics. Works only for parents studies.
#' @import XML
#' @import RCurl
#'
#' @author Gregoire Versmee, Laura Versmee
#' @export

n.pop <- function(phs, consentgroups = TRUE, gender = TRUE)  {

  phs <- phs.version(phs)
  url<- paste0("ftp://anonymous:anonymous@ftp.ncbi.nlm.nih.gov/dbgap/studies/", unlist(strsplit(phs, "\\."))[1], "/", phs, "/")
  filenames <- RCurl::getURL(url, ftp.use.epsv = FALSE, dirlistonly = TRUE, crlf = TRUE)
  filenames <- paste(url, "/", strsplit(filenames, "\r*\n")[[1]], sep = "")

  phenodir <- filenames[grepl("pheno", filenames)]
  filelist <- RCurl::getURL(paste0(phenodir, "/"), ftp.use.epsv = FALSE, dirlistonly = TRUE, crlf = TRUE)
  filelist <- paste(phenodir, "/", strsplit(filelist, "\r*\n")[[1]], sep = "")
  subjdict <- filelist[grepl("Subject.var_report.xml", filelist)]

  #Extract xml
  xmllist <- XML::xmlToList(XML::xmlParse(RCurl::getURLContent(subjdict)))

  #Create the data.frame
  xmllist <- xmllist[which(grepl("consent", tolower(lapply(xmllist, function(x) return(unlist(x)[".attrs.var_name"])))))]

  df <- lapply(xmllist, function(x) {
    name <- unlist(strsplit(x[["total"]][["stats"]][["enum"]][["text"]], " "))
    name <- name[length(name)]
    name <- substr(name, 2, nchar(name) -1)
    gender <- x[["total"]][["subject_profile"]][["sex"]]
    male <- gender[["male"]]
    female <- gender[["female"]]
    n <- x[["total"]][["stats"]][["stat"]][["n"]]
    return(c(consent_group = name, male = male, female = female, total = n))
  })

  df <- data.frame(t(data.frame(df)), stringsAsFactors = F)
  df[,-1] <- apply(df[,-1], 2, as.integer)
  df <- rbind(df, c(consent_group = "TOTAL", as.list(apply(df[,-1], 2, sum))))
  row.names(df) <- NULL

  if (gender == FALSE)  return(df[,c(1:4)])
  if (consentgroups == TRUE)  return(df)
  if (consentgroups == FALSE) return(df[nrow(df), ncol(df)])
}
