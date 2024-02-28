library(tidyverse)
library(plumber)

simpsons = readRDS("simpsons.rds")

#* @apiTitle Simpson's Paradox API
#* @apiDescription Plumber demo for an API that demonstrates Simpson's Paradox 
#* using data from the `datasauRus` package.

#* @get /data
function() {
  simpsons
}

#* @get /data/html
#* @serializer html
function() {
  knitr::kable(simpsons, format = "html")
}

#* @get /data/csv
#* @serializer csv
function() {
  simpsons
}

#* @get /data/text
#* @serializer print
function() {
  simpsons
}

#* @get /data/plot
#* @serializer png list(width=800, height=800, res=150)
function(color="") {
  g = ggplot(simpsons) +
  if (color == "") 
    geom_point(aes(x,y))
  else
    geom_point(aes_string(x="x",y="y",color=color))
  
  print(g)
}

#* @get /model
#* @serializer print
function(formula = "y~x") {
  lm(as.formula(formula), data=simpsons) |>
    summary()
}

#* @get /model/stats
#* @serializer print
function(formula = "y~x") {
  lm(as.formula(formula), data=simpsons) |>
    broom::glance()
}


#* @post /data/new
#* @serializer print
function(req) {
  (simpsons <<- bind_rows(
    simpsons,
    req$body
  ))
}

