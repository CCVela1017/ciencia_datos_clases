# .Rprofile
cat("=== PROYECTO: Análisis exploratorio de datos ===\n")
cat("Curso: Ciencia de Datos\n")
cat("Fecha:", Sys.Date(), "\n")
cat("Directorio de trabajo:", getwd(), "\n\n")

# Cargar paquetes comunes automaticamente
if (interactive()) {
  tryCatch({
    library(tidyverse)
    library(ggplot2)
    cat("Paquetes base cargados\n")
  }, error = function(e) {
    cat("Paquetes no disponibles. Ejecuta: source('scripts/00_instalar_paquetes.R')\n")
  })
}

