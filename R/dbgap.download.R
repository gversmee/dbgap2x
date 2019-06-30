#' @title Downloads and decrypts dbGaP files
#'
#' @return A folder named dbGaP-*** in your working directory that contains your decrypted files
#' @param krt path/to/your/cart.krt file generated from the dbGaP website
#' @param key path/to/yourkey.ngc file
#'
#' @description This function downloads and decrypts dbGaP files
#'
#' @author Gregoire Versmee, Laura Versmee, Mikael Dusenne, Niloofar Jalali
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
