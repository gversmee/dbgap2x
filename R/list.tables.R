#' @title Lists the phenotypic datatables in the study
#'
#' @return Return the phenotypic datatables in the study
#'
#' @import RCurl
#'
#' @author Gregoire Versmee, Laura Versmee, Mikael Dusenne, Niloofar Jalali
#' @export

list.tables <- function(filelist){
    filelist[(grepl(".data_dict.xml", filelist)) & (!grepl("Sample_Attributes.data_dict.xml", filelist)) &
             (!grepl("Subject.data_dict.xml", filelist)) & (!grepl("Sample.data_dict.xml", filelist)) &
             (!grepl("Pedigree.data_dict.xml", filelist))]
}
