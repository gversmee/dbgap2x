#' @author Gregoire Versmee, Laura Versmee, Mikael Dusenne, Niloofar Jalali
#' @import
#' @export

cache.call = function(fname, arg, expr){
    ## transform the "call" object to string
    fname=paste0(tail(as.character(fname), n=1), collapse = "_")
    
    if(!exists("cache")) cache <<- list()
    substitute(expr)

    ## only works for single character argument
    if(! (all(class(arg) %in% c("character", "numeric"))) ){
        ans <- eval(expr)
    }else{
        arg = paste0(arg, collapse = "_")
        ## check for existence in cache
        if( is.null(cache[[fname]]) ){
            cache[[fname]] <<- list()
        }else{
            ## check if value is present
            if ( ! is.null( cache[[fname]][[arg]] ) ){
                ## if yes, return it
                ans <- cache[[fname]][[arg]]
            }
        }
        
        if(!exists("ans", environment())){
            ## if not in cache, evaluate expr
            ans <- eval(expr)
            ## store it
            cache[[fname]][[arg]] <<- ans
        }    
    }
    
    return(ans)
}
