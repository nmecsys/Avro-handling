require(jsonlite)
require(rjson)


read_jsonMaldito <- function(file=file){
  options(digits = 22)
  #con <- unz(filename = file, open="r",description = "")
  lines <- readLines(file, n = file.info(file)$size,
                     encoding = "UTF-8", warn = FALSE)
  #close(con)
  df <- data.frame(date=character(),
                   manchete=character(),
                   noticia=character(),
                   comentario=character(),
                   copyright=character(),
                   jornal=character(),
                   word_count=integer())
  for(i in 1:length(lines)){
    tryCatch({
      json <- fromJSON(lines[i])
      aux = format(json$publication_date,digits = 22,scientific=FALSE)
      aux2 = as.POSIXct(as.numeric(paste0(str_split(aux, "00")[[1]][1],"00")), origin="1970-01-01", tz="GMT")
      df_aux <- data.frame(date=aux2,
                           manchete=json$snippet,
                           noticia=json$body,
                           comentario=json$title,
                           copyright=json$copyright,
                           jornal=json$source_code,
                           word_count=json$word_count,
                           stringsAsFactors = FALSE)
      df <- rbind(df,df_aux)
    },error=function(cond){
      message(cond)
      message("Erro AVRO")
    })
  }
  nomes <- c("date","manchete","noticia","comentario","copyright","jornal","word_count")
  names(df) <- nomes
  df$date = as.Date(df$date)
  return(df)
}



arquivos = list.files()
df = NULL
for(i in 1:length(arquivos)){
  df_aux = read_jsonMaldito(file = arquivos[i])
  df = rbind(df,df_aux)
}




