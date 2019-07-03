#' @title Opens the study webpage in a web browser
#'
#' @param phs dbGaP study ID (phs00xxxx, or 00xxxx, or xxx)
#' @param no.browser set on TRUE will just display the URL
#'
#' @return Opens the study webpage in a web browser
#'
#' @author Gregoire Versmee, Laura Versmee, Mikael Dusenne, Niloofar Jalali

#' @export


browse.study <- function(phs, no.browser = FALSE)  {

  phs <- phs.version(phs)
  gapexchange <- paste0("ftp://anonymous:anonymous@ftp.ncbi.nlm.nih.gov/dbgap/studies/", unlist(strsplit(phs, "\\."))[1], "/", phs, "/", "GapExchange_", phs, ".xml")
  xmllist <- XML::xmlToList(RCurl::getURLContent(gapexchange))
  url <- xmllist[["Studies"]][["Study"]][["Configuration"]][["StudyURLs"]][["Url"]][["url"]]

  if (no.browser)  return(url)  else   browseURL(url)
}
