#' @title Gives the substudies associated with the one selected
#'
#' @param phs dbGap study ID (phs00xxxx, or 00xxxx, or xxx)
#'
#' @return Returns a dataframe with 2 cols : the phs id and the name of the substudy
#'
#' @author Gregoire Versmee, Laura Versmee
#' @export

sub.study <- function(phs)  {

  if (!is.parent(phs))  warning("Your study is not a parent study")
  phs <- phs.version(phs)
  url <- paste0("https://www.ncbi.nlm.nih.gov/projects/gap/cgi-bin/GetFolderView.cgi?current_study_id=", phs, "&current_type=101&current_object_id=1&current_folder_type=101")
  substudies <- RCurl::getURLContent(url)
  substudies <- XML::xmlToList(strsplit(substudies, "\r*\n")[[1]])[[3]]

  substudies <- lapply(substudies, function (x) {
    a <- x[["a"]][[".attrs"]][["onclick"]]
    return(c(phs = substr(a, regexpr("phs", a), regexpr("return", a)-4),
             name = x[["a"]][["text"]]))
  })

  substudies <- t(as.data.frame(substudies))
  row.names(substudies) <- NULL

  return(substudies)
}
