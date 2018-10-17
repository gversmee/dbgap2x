#' @title Gets you the full dbGap study ID of your study, with the latest version
#'
#' @param phs dbGap study ID (phs00xxxx, or 00xxxx, or xxx)
#'
#' @return Returns the full ID of the latest version of your study
#'
#' @author Gregoire Versmee, Laura Versmee
#' @import httr
#' @export

phs.version <- function(phs)  {

  ##standardize the phs name
  # Remove version and/or page
  phs <- unlist(strsplit(phs, "\\."))[1]

  # Remove the letters
  ind <- c()
  for (i in 1:nchar(phs))  {
    charac <- substr(phs, i, i)
    if (grepl("[[:alpha:]]", charac))  ind <- c(ind, charac)
  }

  if (!is.null(ind))  {
    for (j in 1:length(ind))  {
      phs <- sub(ind[j], "", phs)
    }
  }

  # Get sure that phs number has 6 digits, and add leading 0s if necessary
  if (nchar(phs) > 6)  warning("too many digits in the phs")
  if (nchar(phs) < 6)  {
    for (h in 1:(6-nchar(phs)))  {
      phs <- paste0("0", phs)
    }
  }

  url<- paste0("https://www.ncbi.nlm.nih.gov/projects/gap/cgi-bin/study.cgi?study_id=phs", phs)
  url <- httr::GET(url)
  phs <- unlist(strsplit(url[["url"]], "="))[2]

  return(phs)
}








