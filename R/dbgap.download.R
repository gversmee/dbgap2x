#' @title Decrypt ncbi_enc files
#'
#' @return Decrypt the file(s) and replace it in the same folder
#' @param file file or folder where your encrypted files are located
#'
#' @description This function decrypts dbGap files (*ncbi_enc) using your personnal key. Be careful, it can replace the settings of your "vdb-info" file
#'
#' @author Gregoire Versmee, Laura Versmee
#' @export

dbgap.download <- function(krt, key = FALSE)  {

  if (key == FALSE) {
    message("Where is your key?")
    key <- file.choose()
  }

  ## escape regex symbols
  key <- gsub(" ", "\\\\ ", key)

  # docker run sratools
  system("docker run --rm -it -d --name sratools gversmee/sratoolkit")

  # copy key and krt to the container
  system(paste("docker cp", key, "sratools:/key.ngc"))
  system(paste("docker cp", krt, "sratools:/cart.krt"))

  # import the key
  system("docker exec sratools vdb-config --import key.ngc")

  # get the repo
  wdc <- system('docker exec sratools sh -c "ls -d /root/ncbi/*"', intern = TRUE)

  # dl and decrypt
  system(paste("docker exec -w", wdc, 'sratools sh -c "prefetch /cart.krt && vdb-decrypt ."'))

  # copy to host
  system(paste0("docker cp sratools:", wdc, " ."))

  # rm container
  system("docker stop sratools")
}
