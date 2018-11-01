#' @title Create a table 1 with the summary statistics of numerical variables of the study
#'
#' @param phs dbGap study ID (phs00xxxx, or 00xxxx, or xxx)
#'
#' @return an htmlTable
#'
#' @description This function extracts informations from var_report.xml files from the dbgap ftp server to create a variable dictionnary.
#' @import XML
#' @import RCurl
#' @import parallel
#' @import data.table
#' @import htmlTable
#'
#' @author Gregoire Versmee, Laura Versmee
#' @export


variables.report <-function (phs)  {

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

    xmllist_num <- xmllist2[integ]
    variables_id_num <- sapply(xmllist_num, function(x) x[[".attrs"]][["id"]])
    num_tot <- as.character(sapply(variables_id_num, function(x) substr(x, nchar(x)-1, nchar(x)-1) != "c"))
    xmllist_num_tot <- xmllist_num[num_tot == "TRUE"]
    if(length(xmllist_num_tot) == 0) return(NULL)


    table_num <- data.table::as.data.table(cbind(id = sapply(xmllist_num_tot, function(x) x[[".attrs"]][["id"]]),
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
