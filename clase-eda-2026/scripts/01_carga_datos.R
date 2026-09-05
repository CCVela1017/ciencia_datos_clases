# 01_carga_datos.R
# Generación y carga de datos

library(tidyverse)
library(here)

# Función para generar datos de ejemplo
generar_datos <- function(n = 1000, seed = 123) {
  set.seed(seed)
  
  cat("Generando datos...\n")
  
  datos <- data.frame(
    id = 1:n,
    edad = round(rnorm(n, mean = 35, sd = 12)),
    ingreso = round(rnorm(n, mean = 50000, sd = 15000)),
    educacion = sample(1:5, n, replace = TRUE, 
                       prob = c(0.1, 0.2, 0.3, 0.25, 0.15)),
    experiencia = round(rnorm(n, mean = 10, sd = 7)),
    satisfaccion = round(runif(n, min = 1, max = 10))
  )
  
  # Introducir valores faltantes (MCAR)
  indices_na <- sample(1:n, size = 50)
  datos$edad[indices_na] <- NA
  
  # Introducir outliers en ingreso
  indices_outliers <- sample(1:n, size = 20)
  datos$ingreso[indices_outliers] <- datos$ingreso[indices_outliers] * 5
  
  # Introducir valores faltantes condicionales (MAR)
  indices_mar <- sample(which(datos$educacion >= 4), size = 30)
  datos$satisfaccion[indices_mar] <- NA
  
  cat("✅ Datos generados\n")
  cat("   - Observaciones:", n, "\n")
  cat("   - Variables:", ncol(datos), "\n")
  cat("   - Valores faltantes en edad:", sum(is.na(datos$edad)), "\n")
  cat("   - Valores faltantes en satisfacción:", sum(is.na(datos$satisfaccion)), "\n")
  cat("   - Outliers en ingreso:", length(indices_outliers), "\n")
  
  return(datos)
}

# Generar y guardar datos
datos <- generar_datos()

# Guardar en diferentes formatos
saveRDS(datos, here("data/datos_raw.rds"))
write.csv(datos, here("data/datos_raw.csv"), row.names = FALSE)

cat("\n💾 Datos guardados en:\n")
cat("   - data/datos_raw.rds\n")
cat("   - data/datos_raw.csv\n")
