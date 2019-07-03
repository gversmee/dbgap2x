#' @title Gets the phenotypic variables in the study
#'
#' @param phs dbGap study ID (phs00xxxx, or 00xxxx, or xxx)
#'
#' @return Return the phenotypic variables in the study
#'
#' @description This function extracts informations from data.dict.xml files from the dbgap ftp server to get the study characteristics. Works only for a parent study.
#' @import RCurl
#'
#' @author Gregoire Versmee, Laura Versmee, Mikael Dusenne, Niloofar Jalali
#' @export

list.variables <- function(phs, useftp=F)  {
    phs <- phs.version(phs)
    cache.call(
        match.call()[[1]],
        phs, {

            phenodir <- pheno.dir(phs)
            
            filelist <- file.list(phenodir)

            temp <- list.tables(filelist)

            xmllist.to.variableid = function(xmllist){
                setNames(sapply(xmllist[names(xmllist)=="variable"], function(e) e$.attrs["id"]), NULL)
            }
            
            dlftp = function(){
                tmpd = tempdir()
                oldwd = getwd()
                setwd(tmpd)
                by=15
                safesubset = function(v,from, to){
                    v[ max(1,from) : min(length(v), to) ]
                }
                l <- parallel::mclapply(mc.cores = parallel::detectCores(),
                                        seq(1,length(temp), by), function(k){
                                            fs = safesubset(temp, k, k+by-1)
                                            system2("ftp", c("-n", "ftp.ncbi.nlm.nih.gov", sprintf("<<END_SCRIPT
quote USER %s
quote PASS %s
prompt
cd %s
mget %s
quit
END_SCRIPT
", "anonymous", "anonymous", gsub("^.*gov/dbgap","dbgap",phenodir), paste0(fs, collapse = " "))))
                                            sapply(fs, function(e) {
                                                xml = XML::xmlToList(XML::xmlParse(e))
                                                file.remove(paste(tmpd, e, sep="/"))
                                                xml
                                            })
                                        })
                setwd(oldwd)
                Reduce(c, l)
            }
            
            dlcurl = function() {
                mcl <- parallel::mclapply(
                                     temp, 
                                     mc.cores = getOption("mc.cores", parallel::detectCores()),
                                     function(e) XML::xmlToList(RCurl::getURLContent(paste0(phenodir, e)))
                                 )
                mcl
            }

            ftpOK = length(Sys.which("ftp"))>0
            if(useftp && ! ftpOK) warning("FTP not found on system! Using Rcurl to download files.")
            downloader = if(ftpOK && useftp) dlftp else dlcurl

            mcl <- downloader()
            ## ## debug 
            ## t = Sys.time()
            ## mclf <<- dlftp()
            ## cat( "useftp: ", Sys.time() - t, "\n")
            ## t = Sys.time()
            ## mclc <<- dlcurl()
            ## cat( "usecurl: ", Sys.time() - t, "\n")
            ## stopifnot(all(mclf %in% mclc) && all(mclc %in% mclf))
            ## ## end of debug
            
            setNames(unlist(sapply(mcl, xmllist.to.variableid)), NULL)
        }
)
}


