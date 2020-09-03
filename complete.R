complete <- function(directory,id = 1:332){
  ruta <- getwd()
  directorio <- sprintf("%s", paste(ruta, directory, sep="/"))
  #print(directorio)
  archivo <- c(id)
  num_archivos <- length(archivo)
  num_filas <- NULL
  for (i in archivo){
    nom_arch <- paste(sprintf("%03d",i),sep = "",".csv")
    #print(nom_arch)
    ruta_archivo <- paste(directorio,sep="/",nom_arch)
    #print(ruta_archivo)
    data <- read.csv(ruta_archivo)
    datos <- na.omit(data)
    filas <- nrow(datos)
    num_filas <- c(filas,num_filas)
    resultado <- data.frame(id=id,nobs=num_filas)
    cabeza <- head(resultado,2)
    
    
  }
  #print(filas)
  print(cabeza)
  #print(id,datosfilas)
  
}

complete("specdata", 1:3)