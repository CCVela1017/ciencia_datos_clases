library(ISLR2)
library(ggplot2)
library(dplyr)
library(tidyr)
library(patchwork)
library(tibble)


mpg <- Auto


mpg$origin <- factor(mpg$origin,
                     levels = c(1, 2, 3),
                     labels = c("usa", "europe", "japan"))


mpg$model_year <- mpg$year

filas_columnas <- dim(mpg)
variables_numericas <- names(mpg)[sapply(mpg, is.numeric)]
variables_numericas <- setdiff(variables_numericas, "year") 
valores_nulos <- colSums(is.na(mpg))
columnas_con_nulos <- names(valores_nulos[valores_nulos > 0])
variable_a_analizar <- "mpg"

print(filas_columnas)
print(variables_numericas)
print(columnas_con_nulos)
print(variable_a_analizar)
print(as_tibble(mpg))

"
Pregunta:
**¿Cuántas filas y columnas tiene el dataset?**

Filas: 398
Columnas: 9

¿Qué variables numéricas contiene?

7 variables numericas

¿Existen valores nulos? ¿En qué columnas?

La variable de Horsepower

¿Cuál es la variable que analizaremos? (sugerencia: mpg, horsepower, weight)
"


# Estadísticos descriptivos de horsepower

hp <- na.omit(mpg$horsepower)

n <- length(hp)
minimo <- min(hp)
maximo <- max(hp)
rango <- maximo - minimo
media <- mean(hp)
mediana <- median(hp)
desviacion_estandar <- sd(hp)
coeficiente_variacion <- (desviacion_estandar / media) * 100

cat(sprintf("n (tamaño de muestra): %d\n", n))
cat(sprintf("Mínimo: %s\n", minimo))
cat(sprintf("Máximo: %s\n", maximo))
cat(sprintf("Rango (R): %s\n", rango))
cat(sprintf("Media (x̄): %s\n", media))
cat(sprintf("Mediana: %s\n", mediana))
cat(sprintf("Desviación estándar (s): %s\n", desviacion_estandar))
cat(sprintf("Coeficiente de variación (CV %%): %.2f%%\n", coeficiente_variacion))

# **Variable elegida: Horsepower**


# Histograma y porcentaje acumulado

# Obtener datos de horsepower limpios
hp_clean <- na.omit(mpg$horsepower)
hp_sorted <- sort(hp_clean)
y_cumulative <- seq_along(hp_sorted) / length(hp_sorted) * 100

df_acum <- data.frame(hp = hp_sorted, acumulado = y_cumulative)
df_hp <- data.frame(hp = hp_clean)
ancho_bin <- 10

# 1. Histograma (con curva KDE escalada a frecuencias)
g_hist <- ggplot(df_hp, aes(x = hp)) +
  geom_histogram(binwidth = ancho_bin, fill = "skyblue", color = "white") +
  geom_density(aes(y = after_stat(density) * length(hp_clean) * ancho_bin),
               color = "steelblue", linewidth = 1) +
  labs(title = "Histograma de Horsepower",
       x = "Horsepower", y = "Frecuencia") +
  theme_minimal()

# 2. Gráfico de porcentaje acumulado
g_acum <- ggplot(df_acum, aes(x = hp, y = acumulado)) +
  geom_line(color = "orange") +
  geom_point(color = "orange", size = 1) +
  labs(title = "Porcentaje Acumulado de Horsepower",
       x = "Horsepower", y = "Porcentaje Acumulado (%)") +
  theme_minimal()

print(g_hist + g_acum)

"
Visualizacion
¿Es simétrica o sesgada?: El histograma es sesgado. La de porcentaje acumulado es simetrica

¿Hacia qué lado se concentra la mayor frecuencia?: Hacia los autos con horsepower de 75 - 100

¿Hay valores atípicos visibles?:
En el histograma los atípicos son los que más poder tienen
"


# Pregunta 1: ¿Existen diferencias en el rendimiento (mpg) según el número de cilindros?

g1 <- ggplot(mpg, aes(x = factor(cylinders), y = mpg, fill = factor(cylinders))) +
  geom_boxplot() +
  scale_fill_viridis_d(guide = "none") +
  labs(title = "Rendimiento (mpg) por Número de Cilindros",
       x = "Número de Cilindros", y = "Rendimiento (mpg)") +
  theme_minimal() +
  theme(panel.grid.major.x = element_blank(),
        panel.grid.major.y = element_line(linetype = "dashed", color = "grey70"))
print(g1)

"
**¿Cómo varía la mediana de mpg al aumentar el número de cilindros?**

Entre mas cilindros, menos rendimiento

**¿Qué grupo presenta mayor dispersión? ¿A qué podría deberse?**

Al que tiene 6 cilindros, porque algunos autos tienen mejores condiciones y el numero de cilindros presenta estabilidad.

**¿Hay solapamiento entre las cajas? ¿Qué implica estadísticamente?**

Si, implica que el rango de datos y la media presentan comportamientos equitativos
"


# Pregunta 2: ¿Existen diferencias significativas en el rendimiento según el país de origen (origin)?

g2 <- ggplot(mpg, aes(x = origin, y = mpg, fill = origin)) +
  geom_boxplot() +
  scale_fill_brewer(palette = "Set2", guide = "none") +
  labs(title = "Rendimiento (mpg) por País de Origen",
       x = "País de Origen", y = "Rendimiento (mpg)") +
  theme_minimal() +
  theme(panel.grid.major.x = element_blank(),
        panel.grid.major.y = element_line(linetype = "dashed", color = "grey70"))
print(g2)

"
**¿Qué origen tiene mejor rendimiento promedio? ¿Y peor?**

El país con mejor rendimiento promedio es Japon y el mejor es USA.

**¿La forma de las distribuciones es similar entre orígenes?**

Sí

**¿Los datos sugieren igualdad de varianzas entre grupos?**

Sí en USA y europa

**¿Qué otros factores podrían estar confundiendo la comparación (variables de confusión)?**

El año del modelo y los estandares de ese año para el sector.
"


# Pregunta 3: ¿Cómo interactúan el origen y el número de cilindros sobre el rendimiento?

mpg_prom <- mpg %>%
  group_by(cylinders, origin) %>%
  summarise(mpg_prom = mean(mpg), .groups = "drop") %>%
  complete(cylinders, origin, fill = list(mpg_prom = 0))  # combinaciones sin datos = barra vacía

g3 <- ggplot(mpg_prom, aes(x = factor(cylinders), y = mpg_prom, fill = origin)) +
  geom_col(position = position_dodge(width = 0.9)) +
  scale_fill_manual(values = c(usa = "#4878D0", europe = "#EE854A", japan = "#6ACC64"),
                    name = "Origen") +
  labs(title = "Interacción de Origen y Cilindros sobre el Rendimiento Promedio",
       x = "Número de Cilindros", y = "Rendimiento Promedio (mpg)") +
  theme_minimal() +
  theme(panel.grid.major.x = element_blank(),
        panel.grid.major.y = element_line(linetype = "dashed", color = "grey70"))
print(g3)

"
**¿El efecto de los cilindros sobre mpg es constante entre orígenes?**

No.

**¿Algún origen tiene un comportamiento diferenciado?**

Estados unidos es el más bajo y Japon siempre supera a los demás.

**¿Qué ventajas tiene este gráfico respecto a los anteriores?**

Que se puede visualizar el rendimiento de cada orígen respecto a su número de cilindros claramente.
"


# Pregunta 4: ¿Cómo ha cambiado la composición de cilindros y orígenes por año?

# Composición de cilindros por año (porcentaje, barras apiladas)
g4a <- ggplot(mpg, aes(x = factor(model_year), fill = factor(cylinders))) +
  geom_bar(position = "fill") +
  scale_y_continuous(labels = function(x) x * 100) +
  scale_fill_viridis_d(name = "Cilindros") +
  labs(title = "Composición de Cilindros por Año",
       x = "Año del Modelo (19xx)", y = "Porcentaje (%)") +
  theme_minimal()

# Composición de orígenes por año
g4b <- ggplot(mpg, aes(x = factor(model_year), fill = origin)) +
  geom_bar(position = "fill") +
  scale_y_continuous(labels = function(x) x * 100) +
  scale_fill_brewer(palette = "Set2", name = "Origen") +
  labs(title = "Composición de Orígenes por Año",
       x = "Año del Modelo (19xx)", y = "Porcentaje (%)") +
  theme_minimal()

print(g4a + g4b)

"
**¿Cómo ha evolucionado la participación de cada origen por año?**

Europa se mantuvo bajo, pero sufrio una disminución en los años 80.
Estados unidos tuvo una participación más estable.
Japón disminuyó en el año 79, pero se mantuvo estable al inicio de los 80.

**¿Disminuyó la presencia de vehículos con 8 cilindros con los años?**

Sí, disminuyó hasta el punto de dejar de producirse en el año 82.

**¿Qué relación encuentras entre este gráfico y la tendencia de mpg del Bloque I?**

Sí, que el rendimiento es más bajo y por lo tanto se prefiere utilizar autos con un menor numero de cilindros.
"


# Analisis Propio: ¿Como cambia el peso segun el año del modelo?

# Media por año con intervalo de confianza del 95%
peso_anual <- mpg %>%
  group_by(model_year) %>%
  summarise(media = mean(weight),
            n = n(),
            se = sd(weight) / sqrt(n),
            ic = qt(0.975, n - 1) * se,
            .groups = "drop")

g5 <- ggplot(peso_anual, aes(x = model_year, y = media)) +
  geom_ribbon(aes(ymin = media - ic, ymax = media + ic), fill = "purple", alpha = 0.2) +
  geom_line(color = "purple") +
  geom_point(color = "purple") +
  labs(title = "Evolución del Peso Promedio de los Vehículos según el Año del Modelo",
       x = "Año del Modelo (19xx)", y = "Peso (libras)") +
  theme_minimal() +
  theme(panel.grid.major = element_line(linetype = "dashed", color = "grey70"))
print(g5)

"
**¿Como cambia el peso segun el año del modelo?**

El peso generalmente continúa disminuyendo conforme el paso de los años. El promedio de peso se encuentra cerca de las 3400 libras en 1970 y en el año 1982, disminuye casi por 1000 libras. Si tomamos en cuenta las optimizaciones para mejorar el rendimiento y la disminución de cilindros, el peso debería disminuír y el rendimiento aumentar conforme los años pasen.
"

