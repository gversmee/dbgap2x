#' @title Decrypt ncbi_enc files
#'
#' @return Decrypt the file(s) and replace it in the same folder
#' @param file file or folder where your encrypted files are located
#'
#' @description This function decrypts dbGap files (*ncbi_enc) using your personnal key. Be careful, it can replace the settings of your "vdb-info" file
#'
#' @author Gregoire Versmee, Laura Versmee
#' @export

  dbgap.decrypt <- function(files, key = FALSE)  {

    if (key == FALSE) {
      message("Where is your key?")
      key <- file.choose()
    }

    ## escape regex symbols
    key <- gsub(" ", "\\\\ ", key)

    # docker run sratools
    system2("docker", c("run -v", paste0(files, ":/files"), "--rm -it -d --name sratools gversmee/sratoolkit"))

    # copy key to the container
    system(paste("docker cp", key, "sratools:/key.ngc"))

    # import the key
    system("docker exec sratools vdb-config --import key.ngc")

    # get the repo
    wdc <- system('docker exec sratools sh -c "ls -d /root/ncbi/*"', intern = TRUE)

    # decrypt
    system(paste("docker exec -w ", wdc, 'sratools sh -c "vdb-decrypt /files"'))

    # rm container
    system("docker stop sratools")
  }
