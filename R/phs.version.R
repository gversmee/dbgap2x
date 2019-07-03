#' @title Gets you the full dbGaP study ID of your study, with the latest version
#'
#' @param phs dbGaP study ID (phs00xxxx, or 00xxxx, or xxx)
#'
#' @return Returns the full ID of the latest version of your study
#'
#' @author Gregoire Versmee, Laura Versmee, Mikael Dusenne, Niloofar Jalali
#' @import httr
#' @export

phs.version <- function(phs)  {
  
  ##standardize the phs name
  # Remove version and/or page
  phs <- unlist(strsplit(phs, "\\."))[1]

  # Remove the letters
  phs <- gsub("[[:alpha:]]","",phs)
    
  # Get sure that phs number has 6 digits, and add leading 0s if necessary
  if (nchar(phs) > 6)  warning("too many digits in the phs")
  if (nchar(phs) < 6)  {
    phs <- sprintf("%06d", as.integer(phs))
  }

  phs <- cache.call(
      match.call()[[1]],
      phs, {
          url<- paste0("https://www.ncbi.nlm.nih.gov/projects/gap/cgi-bin/study.cgi?study_id=phs", phs)
          url <- httr::GET(url)
          phs <- unlist(strsplit(url[["url"]], "="))[2]
          phs
      } )

  return(phs)
}

