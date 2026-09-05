# 02_imputacion_r.R
# Métodos de imputación para valores faltantes

library(tidyverse)
library(mice)
library(naniar)
library(here)

# Cargar datos
datos <- readRDS(here("data/datos_raw.rds")) 


cat("=== IMPUTACIÓN DE VALORES FALTANTES ===\n\n")

# 1. Inputación por mediana
cat("1. Inputación por mediana\n\n")

datos_median <- datos
for (col in names(datos_median)) {
  if (is.numeric(datos_median[[col]])) {
    datos_median[[col]][is.na(datos_median[[col]])] <-
      median(datos_median[[col]], na.rm = TRUE)
  }
}
saveRDS(datos_median, here(data/datos_media.rds))
cat("Completado\n")

# 2. Inputación por regresión
cat("1. Inputación por regresion...\n\n")
datos_regresion <- datos 
modelo_edad <- lm(edad ~ ingreso + educacion + experiencia, data = datos)
indices_na_edad <- which(is.na(datos_regresion$edad)) 
if (length(indices_na_edad) > 0) {
  datos_regresion$edad[indices_na_edad] <-
    predict(modelo_edad, newdata = datos_regresion[indices_na_edad, ])
}

saveRDS(datos_medios, here('data/datos_regresion.rds'))
cat("Completado\n")

# 3. Inputación por MICE
cat("3. Inputación por MICE\n")
imputaciones <- mice(datos, m = 5, method = 'pmm',
                     maxit = 50, seed = 123, printFlag = FALSE)
datos_mice <- complete(imputaciones, 1)
saveRDS(datos_mice, here('data/datos_mice.rds'))
cat("Completado\n")
cat("\n Todas las imputaciones se han completado\n")

