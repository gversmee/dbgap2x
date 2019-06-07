#' @author Gregoire Versmee, Laura Versmee, Mikael Dusenne, Niloofar Jalali
#' @import
#' @export

cacheEnv <- new.env()

cache.call = function(fname, arg, expr){
    ## transform the "call" object to string
    fname=paste0("env_", paste0(tail(as.character(fname), n=1), collapse = "_"))

    substitute(expr)

    is.ok <- function(e) difftime(Sys.time(), t,units="days") >= 1
    
    ## only works for character or numeric arguments
    if(! (all(class(arg) %in% c("character", "numeric"))) ){
        ans <- eval(expr)
    }else{
        ans = NULL
        arg = paste0(fname, "_", paste0(arg, collapse = "_"))
        ## print(arg)
        ## check for existence in cache
        if(exists(arg, envir = cacheEnv)) {
            element = get(arg, cacheEnv)
            ## print(element)
            ## check if value is present
            if ( (! is.null(element)) && is.ok(element) ){
                ## if yes, return it
                ans <- element$value
            }
        }
        
        if(is.null(ans)){
            ## if not in cache, evaluate expr
            ans <- eval(expr)
            
            ## store it            
            assign(arg,
                   list(
                       value = ans,
                       date = Sys.time()),
                   cacheEnv)
        }    
    }
    
    return(ans)
}
