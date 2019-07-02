#' @import RCurl
#'
#' @author Gregoire Versmee, Laura Versmee, Mikael Dusenne, Niloofar Jalali
#' @export

file.list <- function(phenodir){
    cache.call(
        match.call()[[1]],
        phenodir, {
            
            filelist <- RCurl::getURL(phenodir, ftp.use.epsv = FALSE, dirlistonly = TRUE, crlf=TRUE)
            filelist <- strsplit(filelist, "\r*\n")[[1]]
            filelist
        })            
}
