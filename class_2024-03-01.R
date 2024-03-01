library(tidyverse)
library(rvest)

# La Quinta ----

## Locations ----

url = "https://www.wyndhamhotels.com"

page = read_html(file.path(url, "/laquinta/locations"))

hotel_page = html_nodes(page, ".property a:nth-child(1)") |>
  html_attr("href") |>
  (\(x) paste0(url, x))() |>
  head(5)

## added us location filtering
state.name

dir.create("data/lq/", recursive = TRUE, showWarnings = FALSE)

for(page in hotel_page) {
  out_file = page |> dirname() |> basename() |> paste0(".html")
  
  message(out_file)
  
  download.file(
    url = page, 
    destfile = file.path("data/lq/", out_file),
    quiet = TRUE
  )
}


## parse_lq.R ----

read_html("https://www.wyndhamhotels.com/laquinta/durham-north-carolina/la-quinta-raleigh-durham-southpoint/overview") |>
  html_nodes("div.mob-prop-details.visible-xs-inline-block > div:nth-child(2) > a")



# Dennys ----

## nomnom api -----

x = jsonlite::read_json("https://nomnom-prod-api.dennys.com/restaurants/near?lat=35.780398&long=-78.639099&radius=15&limit=20&nomnom=calendars&nomnom_calendars_from=20240229&nomnom_calendars_to=20240308&nomnom_exclude_extref=999")
View(x)

denny_api_url = function(lat = 35.780398, long = -78.639099,radius = 100, limit=1000) {
  glue::glue(
    "https://nomnom-prod-api.dennys.com/restaurants/near?lat={lat}&long={long}&radius={radius}&limit={limit}&nomnom=calendars&nomnom_calendars_from=20240229&nomnom_calendars_to=20240308&nomnom_exclude_extref=999"
  )
}
denny_api_url(radius=1000, limit=100) |>
  jsonlite::read_json() |>
  View()





