# run_all.R
# Script principal que ejecuta todo el análisis

cat("=== INICIANDO ANÁLISIS EXPLORATORIO ===\n")
cat("Fecha:", Sys.time(), "\n\n")

# 1. Instalar paquetes (si es necesario)
cat("Paso 1: Verificando paquetes...\n")
source("scripts/00_instalar_paquetes.R")

# 2. Generar datos
cat("\nPaso 2: Generando datos...\n")
source("scripts/01_carga_datos.R")

# 3. Imputación
cat("\nPaso 3: Aplicando imputación...\n")
source("scripts/02_imputacion_r.R")

# 4. Outliers
cat("\nPaso 4: Detectando y tratando outliers...\n")
source("scripts/03_outliers_r.R")

# 5. Generar informe
cat("\nPaso 5: Generando informe...\n")
quarto::quarto_render("reports/informe_eda.qmd")

cat("\n✅ ANÁLISIS COMPLETADO\n")
cat("📄 Informe generado en: reports/informe_eda.html\n")