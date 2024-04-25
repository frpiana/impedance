#' Importa dati da file TXT in una cartella specificata.
#'
#' Questa funzione importa dati da file di testo (TXT) presenti in una cartella specificata.
#' Ogni file TXT rappresenta una serie di dati, dove il nome del file viene utilizzato come nome del campione.
#'
#' @param folder_path Percorso della cartella contenente i file TXT da importare. Se non specificato,
#'                    viene utilizzata la directory di lavoro corrente.
#'
#' @return Un data frame contenente tutti i dati importati da tutti i file TXT nella cartella specificata.
#'
#' @import readr
#'
#' @examples
#' # Importa dati dalla cartella "dati"
#' data <- data_import("dati")
#'
#' @export
data_import <- function(folder_path = getwd()) {

  # Controlla se il pacchetto readr è installato, altrimenti lo installa e lo carica
  if (!require("readr")) {
    install.packages("readr")
    library(readr)
  }

  # Ottiene la lista dei file nella cartella specificata con estensione .TXT
  file_list <- list.files(folder_path, pattern = "\\.TXT$", full.names = FALSE)

  # Inizializza una lista per memorizzare le serie di dati da ogni file
  series_list <- list()

  # Itera su ciascun file nella lista
  for(file_name in file_list){

    # Ottiene il percorso completo del file
    full_file_path <- file.path(folder_path, file_name)

    # Legge la prima riga del file per ottenere il nome del campione
    file_content <- readLines(full_file_path, n = 3)
    sample_name <- strsplit(file_content[1], ", ")[[1]][1]

    # Legge i dati dal file utilizzando il pacchetto readr
    data <- read_delim(full_file_path, delim = "\t", escape_double = FALSE, trim_ws = TRUE, skip = 3)

    # Aggiunge una colonna "Sample" al dataframe contenente il nome del campione
    data$Sample <- sample_name

    # Isola la terza riga di intestazione e converte la codifica da latino1 in UTF-8
    terza_riga <- iconv(file_content[3], from = "ISO-8859-1", to = "UTF-8")
    print(terza_riga)
    # Estrae il valore di temperatura
    temperature <- sub(".*Temp\\. \\[°C\\]=(-?[0-9]\\.[0-9]{4}e[+-][0-9]{2}).*", "\\1", terza_riga)

    # Formatta e approssima la temperatura
    temperature <- format(round(as.numeric(temperature)), digits = 2)

    # Controlla che il valore di temperatura sia stato effettivamente trovato
    if (nchar(temperature) > 0) {
      # Se il valore di temperatura viene trovato, aggiunge una colonna con tale valore
      data$Temperature <- temperature
    }

    # Aggiunge la serie di dati alla lista
    series_list[[file_name]] <- data
  }

  # Combina tutte le serie di dati in un unico dataframe
  series <- do.call(rbind, series_list)

  # Imposta i nomi delle righe a NULL per evitare duplicati
  rownames(series) <- NULL

  return(series)
}
