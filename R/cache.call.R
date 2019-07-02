#' @author Gregoire Versmee, Laura Versmee, Mikael Dusenne, Niloofar Jalali
#' @import
#' @export

cacheEnv <- new.env()

cache.call = function(fname, arg, expr){
    ## transform the "call" object to string
    fname=paste0("env_", paste0(tail(as.character(fname), n=1), collapse = "_"))
    ## print('cache')
    substitute(expr)

    is.ok <- function(e) difftime(Sys.time(), e$time,units="days") < 1
    
    ## only works for character or numeric arguments
    if(! (all(class(arg) %in% c("character", "numeric"))) ){
        warning(sprintf('cache: wrong type of argument (%s)', paste(class(arg), collapse=' - ')))
        ans <- eval(expr)
    }else{
        ans = NULL
        arg = paste0(fname, "_", paste0(arg, collapse = "_"))
        ## print(arg)
        ## print(arg)
        ## check for existence in cache
        if(exists(arg, envir = cacheEnv)) {
            ## print('exists')
            element = get(arg, cacheEnv)
            ## print(element)
            ## check if value is present
            if ( (! is.null(element)) && is.ok(element) ){
                ## print('not null and is ok')
                ## if yes, return it
                ans <- element$value
            }
        }
        
        if(is.null(ans)){
            ## print('not in the cache')
            ## if not in cache, evaluate expr
            ans <- eval(expr)
            ## store it
            assign(arg,
                   list(
                       value = ans,
                       time = Sys.time()),
                   cacheEnv)
            ## print('assigned')
            ## print(get(arg, cacheEnv))
        }    
    }
    
    return(ans)
}
