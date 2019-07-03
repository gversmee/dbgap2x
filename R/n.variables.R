#' @title Gets the number of phenotypic variables in the study
#'
#' @param phs dbGaP study ID (phs00xxxx, or 00xxxx, or xxx)
#'
#' @return Returns the number of phenotypic variables in the study
#'
#' @description This function extracts informations from data.dict.xml files from the dbGaP ftp server to get the study characteristics. Works only for a parent study.
#' @import RCurl
#'
#' @author Gregoire Versmee, Laura Versmee, Mikael Dusenne, Niloofar Jalali
#' @export


n.variables <- function(...)  {
    length(list.variables(...))
}

