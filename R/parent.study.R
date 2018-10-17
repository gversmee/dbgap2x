#' @title Gets you the parent study of the specified study
#'
#' @param phs dbGap study ID (phs00xxxx, or 00xxxx, or xxx)
#'
#' @return Returns the phs id of the latest version of the parent study, and its full name. If the study is it's parent itself, will return the phs id and the name of the study.
#'
#' @author Gregoire Versmee, Laura Versmee
#' @export


parent.study <- function(phs)  {

  phs <- phs.version(phs)
  if (is.parent(phs)) return(message("This is already a parent study"))

  content <- RCurl::getURL(paste0("https://www.ncbi.nlm.nih.gov/projects/gap/cgi-bin/study.cgi?study_id=", phs))

  start <- regexpr("A sub-study of ", content) + 76
  stop <- regexpr(";return true;", content) -3
  parentphs <- substr(content, start, stop)

  parentname <- study.name(parentphs)

  return(c(parentphs, parentname))

}

