#' Importa dati da file TXT in una cartella specificata.
#'
#' Questa funzione importa dati da file TXT presenti in una cartella specificata. Ogni file TXT
#' rappresenta una serie di dati. Il nome del file viene utilizzato come nome del campione.
#'
#' @param folder_path Percorso della cartella contenente i file TXT da importare. Se non specificato, viene utilizzata la directory di lavoro corrente.
#'
#' @return Un data frame che contiene tutti i dati importati da tutti i file TXT nella cartella specificata.
#'
#' @import readr
#'
#' @examples
#' # Importa dati dalla cartella "dati"
#' data <- data_import("dati")
#'
#' @export
data_import <- function(folder_path = getwd()) {

  if (!require("readr")) {
    install.packages("readr")
    library(readr)
  }

  file_list <- list.files(folder_path, pattern = "\\.TXT$", full.names = FALSE)

  series_list <- list()

  for(file in file_list){
    file_content <- readLines(file, n = 1)
    sample_name <- strsplit(file_content, ", ")[[1]][1]

    data <- read_delim(file, delim = "\t", escape_double = FALSE, trim_ws = TRUE, skip = 3)
    data$Sample <- sample_name

    series_list[[file]] <- data
  }

  series <- do.call(rbind, series_list)
  rownames(series) <- NULL

  return(series)
}
