#' @title Open the study webpage in a web browser
#'
#' @param phs dbGap study ID (phs00xxxx, or 00xxxx, or xxx)
#' @param jupyter set on TRUE if you are in a jypyterhub environment
#'
#' @return Open the study webpage in a web browser
#'
#' @author Gregoire Versmee, Laura Versmee

#' @export


browse.study <- function(phs, jupyter = FALSE)  {

  phs <- phs.version(phs)
  gapexchange <- paste0("ftp://anonymous:anonymous@ftp.ncbi.nlm.nih.gov/dbgap/studies/", unlist(strsplit(phs, "\\."))[1], "/", phs, "/", "GapExchange_", phs, ".xml")
  xmllist <- XML::xmlToList(RCurl::getURLContent(gapexchange))
  url <- xmllist[["Studies"]][["Study"]][["Configuration"]][["StudyURLs"]][["Url"]][["url"]]

  if (jupyter)  return(url)  else   browseURL(url)
}
