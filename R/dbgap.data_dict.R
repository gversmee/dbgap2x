#' @title Create a table dictionnary and a variable dictionnary
#'
#' @param xml Folder where the xml files are located
#' @param dest Folder where the data dictionnary and the table dictionnary will be extracted
#'
#' @return 2 csv files "phs_tables_dict.csv" and "phs_variables_dict.csv"
#'
#' @description This function extracts informations from data.dict xml files in dbgap to create table dictionnary and a variable dictionnary.
#' @import XML
#'
#' @author Gregoire Versmee, Laura Versmee
#' @export

dbgap.data_dict <-function (xml, dest)  {

wd <- getwd()

#selecting all xml files except for "Subject", "Sample" and "Pedigree"
setwd(xml)
temp <- list.files(pattern = "*.data_dict.xml")
ind <- grepl("Subject.data_dict", temp) | grepl("Sample.data_dict", temp) | grepl("Pedigree.data_dict", temp)
temp <- temp[!ind]

#Create the data.frames
datatablesdict <- data.frame()
variablesdict <- data.frame()

#Create column names
cnamesdt <- c("pht", "dt_study_name", "dt_label")
cnamesvt <- c("phv", "dt_study_name", "var_name", "var_label")

#Looping!!
for (i in 1:length(temp))  {

  #Extract xml
  vt <- data.frame()
  xmllist <- XML::xmlToList(temp[i])
  xmlfile <- XML::xmlParse(temp[i])
  xmltop <- XML::xmlRoot(xmlfile)

  #Get dt dbgap name + version + study name
  dt_name <- xmllist[[".attrs"]][["id"]]
  dt_sn <- substr(temp[i], regexpr(dt_name, temp[i]) + nchar(dt_name)+1, regexpr(".data_dict", temp[i])-1)
  dt_label <- xmllist[["description"]]
  if (is.null(dt_label)) dt_label <- dt_sn

  #Create datatablesdict
  dt <- data.frame(dt_name, dt_sn, dt_label)

  #Create vt
  for (j in 2:XML::xmlSize(xmltop))  {
    if (XML::xmlName(xmltop[[j]]) == "variable") {
      vt[j,1] <- xmllist[[j]]$.attrs
      vt[j,2] <- dt_sn
      vt[j,3] <- xmllist[[j]]$name
      vt[j,4] <- xmllist[[j]]$description
    }
  }

  #Append to the final tables
  colnames(dt) <- cnamesdt
  colnames(vt) <- cnamesvt
  datatablesdict <- rbind(datatablesdict, dt)
  variablesdict <- rbind(variablesdict, vt)
}

## Remove empty rows
emrow <- apply(variablesdict, 1, function(x) all(is.na(x)))
variablesdict <- variablesdict[!emrow, ]
emrow <- apply(datatablesdict, 1, function(x) all(is.na(x)))
datatablesdict <- datatablesdict[!emrow, ]

## write the CSV files
write.csv(file = paste0(dest, "/", xmllist[[".attrs"]][["study_id"]], "_tables_dict.csv"), datatablesdict, row.names = FALSE)
write.csv(file = paste0(dest, "/", xmllist[[".attrs"]][["study_id"]], "_variables_dict.csv"), variablesdict, row.names = FALSE)

setwd(wd)
}
