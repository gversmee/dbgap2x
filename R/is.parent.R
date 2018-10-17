#' @title Is the study a parent or a child study
#'
#' @param phs dbGap study ID (phs00xxxx, or 00xxxx, or xxx)
#'
#' @return Returns a logical TRUE if the study is a parent, and false if the study is a child
#'
#' @author Gregoire Versmee, Laura Versmee
#' @export


is.parent <- function(phs)  {

  phs <- phs.version(phs)

  content <- RCurl::getURL(paste0("https://www.ncbi.nlm.nih.gov/projects/gap/cgi-bin/study.cgi?study_id=", phs))

  return(!grepl("A sub-study of ", content))

}
