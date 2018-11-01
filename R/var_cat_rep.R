#' @title Create a variables dictionnary of your study
#'
#' @param phs dbGap study ID (phs00xxxx, or 00xxxx, or xxx)
#'
#' @return a data.frame with 4 cols : variable identifier (dbGap), table name, variable name, variable description
#'
#' @description This function extracts informations from data.dict.xml files from the dbgap ftp server to create a variable dictionnary.
#' @import XML
#' @import RCurl
#' @import parallel
#' @import data.table
#' @import htmlTable
#'
#' @author Gregoire Versmee, Laura Versmee



variables.cat.report <-function (phs)  {

  phs <- phs.version(phs)

  #selecting all xml files except for "Subject", "Sample", "Pedigree", and phenotypics data from substudies
  url<- paste0("ftp://anonymous:anonymous@ftp.ncbi.nlm.nih.gov/dbgap/studies/", unlist(strsplit(phs, "\\."))[1], "/", phs, "/")

  filenames <- strsplit(RCurl::getURL(url, ftp.use.epsv = TRUE, dirlistonly = TRUE), "\n")[[1]]
  phenodir <- paste0(url, filenames[grep("pheno", filenames)], "/")
  filelist <- strsplit(RCurl::getURL(phenodir, ftp.use.epsv = FALSE, dirlistonly = TRUE), "\n")[[1]]
  temp <- filelist[(grepl(".var_report.xml", filelist)) & (!grepl("Sample_Attributes.data_dict.xml", filelist)) &
                     (!grepl("Subject.data_dict.xml", filelist)) & (!grepl("Sample.data_dict.xml", filelist)) & (!grepl("Pedigree.data_dict.xml", filelist))]

  consent_groups <- consent.groups(phs)
  n_consent_groups <- max(as.integer(row.names(consent_groups)))

  mcl <- parallel::mclapply(temp, function(e) {
    xmllist <- XML::xmlToList(RCurl::getURLContent(paste0(phenodir, e)))
    xmllist2 <- xmllist[names(xmllist) == "variable"]

    integ <- sapply(xmllist2, function(x) any(names(x[["total"]][["stats"]][["stat"]]) == "mean") && any(names(x[["total"]][["stats"]][["stat"]]) == "sd"))
    integ2 <- sapply(xmllist2, function(x) any(names(x) == "value"))

    xmllist_cat <- xmllist2[!integ & integ2]
    variables_id_cat <- sapply(xmllist_cat, function(x) x[[".attrs"]][["id"]])
    cat_tot <- as.character(sapply(variables_id_cat, function(x) substr(x, nchar(x)-1, nchar(x)-1) != "c"))
    xmllist_cat_tot <- xmllist_cat[num_tot == "TRUE"]
    if(length(xmllist_cat_tot) == 0) return(NULL)



    table_cat <- lapply(xmllist_cat_tot, function(x) {
      print(x[names(x) == "value"])
                          data.table::as.data.table(cbind(id = x[[".attrs"]][["id"]],
                                                          description = x[["description"]],
                                                          label = sapply(x[names(x) == "value"], `[[`, "text"),
                                                          n = sapply(x[names(x) == "value"], `[[`, ".attrs")))
    })

    table_cat1 <- data.table::rbindlist(table_cat)

    table_cat1 <- data.table::as.data.table(cbind(id = sapply(xmllist_num_tot, function(x) x[[".attrs"]][["id"]]),
                                                 description = sapply(xmllist_num_tot, function(x) x[["description"]]),
                                                 n = sapply(xmllist_num_tot, function(x) x[["total"]][["stats"]][["stat"]][["n"]]),
                                                 mean = sapply(xmllist_num_tot, function(x) x[["total"]][["stats"]][["stat"]][["mean"]]),
                                                 sd = sapply(xmllist_num_tot, function(x) x[["total"]][["stats"]][["stat"]][["sd"]])))
    row.names(table_num) <- NULL



    table_num_fin <- Reduce(function(y, i) {
      num_c <- as.character(sapply(variables_id_num, function(x) substr(x, nchar(x)-1, nchar(x)) == paste0("c", i)))
      xmllist_num_c <- xmllist_num[num_c == "TRUE"]
      id <- sapply(xmllist_num_c, function(x) x[[".attrs"]][["id"]])
      table_num_c <- data.table::as.data.table(cbind(id = substr(id, 1, nchar(id)-3),
                                                     n = sapply(xmllist_num_c, function(x) x[["total"]][["stats"]][["stat"]][["n"]]),
                                                     mean = sapply(xmllist_num_c, function(x) x[["total"]][["stats"]][["stat"]][["mean"]]),
                                                     sd = sapply(xmllist_num_c, function(x) x[["total"]][["stats"]][["stat"]][["sd"]])))
      row.names(table_num_c) <- NULL

      if(length(id) == 0) table_num_c <- data.table::as.data.table(rbind(c(id = "NULL", n = NA, mean = NA, sd = NA)))
      return(merge(y, table_num_c, by.x = "id", by.y = "id", suffixes = c(i-1,i), all = T))
    }, 1:n_consent_groups, init = table_num)


    return(table_num_fin)

  }, mc.cores = 8)

  table <- data.table::rbindlist(mcl)
  colnames(table) <- c("id", "description", rep(c("n", "mean", "sd"), n_consent_groups + 1))

  study_name <- study.name(phs)

  return(htmlTable(table,
                   col.columns = c(rep("none", 2),
                                   rep("#E6E6F0", 3),
                                   rep("none", ncol(table) - 5)),
                   cgroup = c("", "total", as.character(consent_groups[-1, 1])),
                   n.cgroup = c(2,3, rep(3, n_consent_groups)),
                   caption = paste("Table 1a: Summary statistics of numerical variables from", study_name, "broken down by consent group."),
                   tfoot = paste(as.character(consent_groups[-1, 1]), "=", as.character(consent_groups[-1, 2]))))
}
