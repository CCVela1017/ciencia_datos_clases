# Crear estructura de carpetas

crear_estructura <- function() {
  carpetas <- c(
    "data",
    "scripts",
    "reports",
    "outputs",
    "outputs/figuras",
    "outputs/tablas"
  )
  
  for (carpeta in carpetas) {
    if (!dir.exists(carpeta)) {
      dir.create(carpeta, recursive = TRUE)
      cat("Carpeta creada:", carpeta, "\n")
    } else {
      cat("Carpeta ya existe:", carpeta, "\n")
    }
  }
}

crear_estructura()

