#' @title Opens the results of your search on dbGaP
#'
#' @param term Term of your search
#' @param no.browser set on TRUE will just display the URL
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

