#' @title Open the results of your search on dbGap
#'
#' @param term Term of your search
#' @param jupyter set on TRUE if you are in a jypyterhub environment
#'
#' @return Open the results of your search on dbGap
#'
#' @author Gregoire Versmee, Laura Versmee, Mikael Dusenne, Niloofar Jalali

#' @export


search.dbgap <- function(term, no.browser = FALSE)  {

  url <- paste0("https://www.ncbi.nlm.nih.gov/gap/?term=", term,  "%5BStudy+Name%5D")

  if (no.browser == FALSE)  browseURL(url)
  if (no.browser == TRUE)  return(url)

}

