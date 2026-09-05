paquetes_necesarios <- c(
  # Manipulacion y visualizacion
  "tidyverse",
  "ggplot2",
  "dplyr",
  "tidyr",
  
  # Datos faltantes
  "naniar",
  "VIM",
  "mice",
  "missForest",
  
  # Correlacion y estadistica
  "corrplot",
  "Hmisc",
  "psych",
  
  # Reportes
  "rmarkdown",
  "knitr",
  "quarto",
  
  #Utilidades
  "here",
  "renv"
)

# Instalar paquetes faltantes
for (pkg in paquetes_necesarios) {
  if (!require(pkg, character.only = TRUE)) {
    cat("Instalando:", pkg, "\n")
    install.packages(pkg, dependencies = TRUE)
  } else {
    cat("Ya instalado", pkg, "\n")
  }
}

cat("\nTodos los paquetes instalados correctamente\n")
