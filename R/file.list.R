#' @import RCurl
#'
#' @author Gregoire Versmee, Laura Versmee, Mikael Dusenne, Niloofar Jalali
#' @export

file.list <- function(phenodir){
    filelist <- RCurl::getURL(phenodir, ftp.use.epsv = FALSE, dirlistonly = TRUE, crlf=TRUE)
    filelist <- strsplit(filelist, "\r*\n")[[1]]
    filelist
}
