library(tidyverse)
library(plumber)

simpsons = readRDS("simpsons.rds")

#* @apiTitle Simpson's Paradox API
#* @apiDescription Plumber demo for an API that demonstrates Simpson's Paradox 
#* using data from the `datasauRus` package.

