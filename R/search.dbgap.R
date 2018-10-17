#' @title Open the results of your search on dbGap
#'
#' @param term Term of your search
#' @param jupyter set on TRUE if you are in a jypyterhub environment
#'
#' @return Open the results of your search on dbGap
#'
#' @author Gregoire Versmee, Laura Versmee

#' @export


search.dbgap <- function(term, jupyter = FALSE)  {

  url <- paste0("https://www.ncbi.nlm.nih.gov/gap/?term=", term,  "%5BStudy+Name%5D")

  if (jupyter == FALSE)  browseURL(url)
  if (jupyter == TRUE)  return(url)

}

