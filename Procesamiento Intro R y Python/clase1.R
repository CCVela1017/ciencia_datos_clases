library(dplyr)
library(googlesheets4)
library(rvest)

# Crear un vector
nombres <- c("Falcon 9", "Saturn V", "Soyuz", "Ariane 5", "Delta IV")
anos = c(2010, 1967, 1966, 1996, 2002)
data.frame(Nombre = nombres, "Primer Lanzamiento" = anos) -> cohetes
cohetes

print(cohetes)

# Extraccion de un dato

indice_antiguo = which.min(cohetes$Primer.Lanzamiento)

print(paste("El cohete mas antiguo es: ", cohetes$Nombre[indice_antiguo]))


# Carga de datos
ruta = "https://raw.githubusercontent.com/abemen/datasets/refs/heads/main/antropometricas.csv"
antropometricas = read.csv(ruta)
print(antropometricas)


# Scrapping de los titulos de noticias de la NASA 

url <- "https://www.nasa.gov/2026-news-releases/"

pagina <- read_html(url)

titulos <- pagina %>%
  html_nodes(".hds-ally-heading-22") %>%
  html_text(trim = TRUE)

print(titulos)

# Secuencias

2:8

# Secuencia indicando el paso

seq(2,3,by=0.1)

# Vector repetitivo

rep(1:3, times  = 3)

# Vector con elementos repetitivos

rep(1:3, each=4)

# Almacenar un vector

x <- seq(1, 5, by=0.5)


# Crear funciones

doble <- function(x) {
  resultado <- x *2
  return(resultado)
}

doble(5)

# Operaciones con vectores

x + 10
x * 3
m = 0.5
b = -2

y = m*x + b
y

# Seleccionar datos
y[3]

# Omitir datos
y[-3]

# Datos que cumplen una condicion
x[x>2]

# Generar una matriz
m = matrix(x, nrow = 3, ncol = 3)
m


n = matrix(x, nrow = 3, ncol = 6)
n

# Grafica 

plot(x,y)

# Datos desde el clipboard

datos2 = clipr::read_clip_tbl()
datos2

# Dimension del conjunto de datos
length(antropometricas)

# Dimension de una columna
length(antropometricas$Sexo)

max(antropometricas$Peso)
min(antropometricas$Peso)
which.max(antropometricas$Peso)
antropometricas$Peso[34]


# Graficos utilizando ggplot
# tres capas = data, aes, geom

misiones <- data.frame(
  Mision = c("Apollo 11", "Apollo 13", "Crew-1", "Starline", "Artemis I"),
  Exito = c(1, 0, 1, 0, 1),
  Costo = c(355, 400, 220, 450, 500)
)

View(misiones)

# Grafico de barras de costo por mision, coloreado por exito
ggplot(misiones, aes(x=Mision, y=Costo, fill = as.factor(Exito))) +
  geom_bar(stat = "identity") +
  labs(title = "Costo de Misiones Espaciales",
       subtitle = "Rojo = Fracaso, Azul = Exito",
       y = "Costo (Millones USD)", x = "Mision",
       fill = "??Exito?") +
  theme_minimal()























