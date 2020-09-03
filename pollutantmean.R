
pollutantmean <- function(directory,polutant,id = 1:332){
  
  #INICIALIZACIÓN DE VARIABLES
  ruta <- getwd()
  directorio <- sprintf("%s", paste(ruta, directory, sep="/"))
  archivo <- c(id)
  num_archivos <- length(archivo)
 
  sumatoria <- function(y,q,removeNA=TRUE){
     adicion <- sum(y[,q],na.rm=removeNA)
  }
  
  
  cont <- 0
  if (cont <= num_archivos){
    suma <- 0
    filas <- 0
    for (i in archivo){
      nom_arch <- paste(sprintf("%03d",i),sep = "",".csv")
      #print(nom_arch)
      ruta_archivo <- paste(directorio,sep="/",nom_arch)
      print(ruta_archivo)
      data <- read.csv(ruta_archivo)
      # filas <- nrow(is.na(data))

      #print(ruta_archivo)
      if (polutant == "sulfate"){
        suma <- sumatoria(data,2)+suma
        filas <- sum(!is.na.data.frame(data[,2]))+filas
      }
      else {
        suma <- sumatoria(data,3)+suma
        filas <- sum(!is.na.data.frame(data[,3]))+filas 
      }
    }
    #print(suma)
    #print(filas)
    total <- suma/filas
    print(total)
  }

} 


#pollutantmean("specdata","nitrate",1:332)

