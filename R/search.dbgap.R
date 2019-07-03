#' @title Gets the results of your search on dbGaP
#'
#' @param term Term of your search
#' @param no.browser set on TRUE will just display the URL
#'
#' @return A data frame of the results of your search on dbGaP
#'
#' @author Gregoire Versmee, Laura Versmee, Mikael Dusenne, Niloofar Jalali

#' @export


search.dbgap <- function(term, no.browser = FALSE)  {
    ## example of data: https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?db=gap&id=1692088&retmode=json

    baseURL = "https://eutils.ncbi.nlm.nih.gov/entrez/eutils"
    ## for searching, used with N[s_discriminator] to filter results
    result.category = c("study", "variable", "document", "analyse", "dataset")

    ## for fetching
    chunksize = 500

    build.params = function(useHistory=T, db="gap" , retmode="json", ...){
        c(mget(ls()), list(...))
    }

    build.url=function(type=c("search", "summary")){
        sprintf(paste0(baseURL, "/e", match.arg(type) ,".fcgi/"))
    }

    get.json = function(querytype, ...){
        resp = httr::GET(build.url(querytype),
                         query=build.params(...))
        httr::content(resp, as="parsed")
    }

    search.ids = function(term, type=c("study", "variable", "document", "analyse", "dataset")){
        type = which(result.category == match.arg(type))
        term = sprintf( "%d[s_discriminator] AND (%s)", type, term )

        ## message(sprintf("searching ids for '%s'...", term))
        get.json("search", term=term)
    }

    fetch = function(search.response, filter.studies = T){
        r = search.response$esearchresult
        ## message("fetching results...")
        
        l = parallel::mclapply( mc.cores = getOption("mc.cores", parallel::detectCores()),
            ## lapply(
                seq(0, r$count, chunksize), function(retstart){
                    if(r$count>500) {
                        cat('fetched', retstart, '/', r$count,'...        \r')
                        flush.console()
                    }
                    get.json("summary",
                             query_key=r$querykey,
                             WebEnv=r$webenv,
                             retstart=retstart,
                             retmax=chunksize)$result
                } )
        l = Reduce(l, f = function(acc, e){
                    acc$uids = c(acc$uids, e$uids)
                    e$uids = NULL
                    c(acc, e)
                })
        if(r$count>500) cat('                          \n')
        
        if(filter.studies) l = filter.studies(l)
        
        l
    }

    filter.studies = function(l){
        l = l[-which(names(l)=="uids")]
        ### l[ which(l$d_object_type == "study") ]
        l = l[ unlist( sapply(l, function(e) (e$d_study_results$d_study_id != "")) ) ]
        ## l = l[ l %>% sapply(function(e) (e$d_study_results$d_study_id != "")) %>% unlist ]
        l$uids = names(l)
        l
    }

    mkdf.studies = function(r){
        r$uids = NULL
        df = lapply(r, function(row){
            row = row$d_study_results

            ## moldatatype = row$d_study_molecular_data_type_list %>%
            ##     sapply(function(e) e$d_molecular_data_type_name) %>%
            ##     paste0(collapse=", ")
            moldatatype = row$d_study_molecular_data_type_list
            moldatatype = sapply(moldatatype, function(e) e$d_molecular_data_type_name)
            moldatatype = paste0(moldatatype, collapse=", ")

            list.to.cell = function(v,field) paste0(collapse=", ", unique(sapply(v, function(e)e[[field]]) ))
            
            l = list(
                "Study ID"           = row$d_study_id,
                "Study Name"         = row$d_study_name,
                "Release Date"       = row$d_study_release_date,
                "Nb Participants"    = row$d_num_participants_in_subtree,
                "Study Design"       = row$d_study_design,
                "Project"            = list.to.cell(row$d_study_project_list, "d_project_name"),
                "Diseases"           = list.to.cell(row$d_study_disease_list, "d_disease_name"),
                "Ancestor ID"      = "",
                "Ancestor Name"    = "",
                "Molecular Data Type" = moldatatype,
                "Tumor Type"          = list.to.cell(row$d_study_tumor_type_list, "d_tumor_type")
            )
            if(length(row$d_study_ancestor) > 0){
                l[["Ancestor ID"]]   = row$d_study_ancestor[[1]]$d_ancestor_id
                l[["Ancestor Name"]] = row$d_study_ancestor[[1]]$d_ancestor_name
            }
            l
        })
        df = Reduce(df, f=rbind)
        df = as.data.frame(df, check.names=F, stringAsFactors=F)
        row.names(df) = NULL
        df$UID = names(r)
        df
    }

    ## search.studies = . %>% search.ids(type="study") %>%
    ##     fetch(filter.studies=T) %>%
    ##     mkdf.studies
    search.studies = function(term) mkdf.studies( fetch(filter.studies=T, search.ids(type="study", term)   ))

    url <- paste0("https://www.ncbi.nlm.nih.gov/gap/?term=", term,  "%5BStudy+Name%5D")
    cat(url, "\n")
    search.studies( paste0(term, "[Study Name]") )

    ## if (no.browser == FALSE)  browseURL(url)
    ## if (no.browser == TRUE)  return(url)

}

