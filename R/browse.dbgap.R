#' @title Open the dbGap webpag of your study in your browser
#'
#' @param phs dbGap study ID (phs00xxxx, or 00xxxx, or xxx)
#' @param jupyter set on TRUE if you are in a jypyterhub environment
#'
#' @return Open the dbGap webpag of your study in your browser
#'
#' @author Gregoire Versmee, Laura Versmee, Mikael Dusenne, Niloofar Jalali

#' @export


browse.dbgap <- function(phs, no.browser = FALSE)  {

  url <- paste0("https://www.ncbi.nlm.nih.gov/projects/gap/cgi-bin/study.cgi?study_id=", phs.version(phs))

  if (no.browser)  return(url)  else  browseURL(url)
}

