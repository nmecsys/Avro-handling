require(jsonlite)
require(rjson)


read_jsonMaldito <- function(file=file){
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
      df_aux <- data.frame(date=json$publication_date,
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
  return(df)
}



arquivos = list.files()
df = NULL
for(i in 1:length(arquivos)){
  df_aux = read_jsonMaldito(file = arquivos[i])
  df = rbind(df,df_aux)
}

