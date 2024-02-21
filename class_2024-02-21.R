library(tidyverse)
library(rvest)

url = "http://www.rottentomatoes.com/"

(session = polite::bow(url))

page = polite::scrape(session)

movies = tibble::tibble(  
  title = page |>
    html_elements(".dynamic-text-list__streaming-links+ ul .dynamic-text-list__item-title") |>
    html_text2(),
  
  totatometer = page |>
    html_elements(".dynamic-text-list__streaming-links+ ul .b--medium") |>
    html_text2() |>
    str_remove("%$") |>
    as.double() |>
    (\(x) x / 100)(),

  fresh = page |>
    html_elements(".dynamic-text-list__streaming-links+ ul .icon--tiny") |>
    html_attr("class") |>
    str_remove_all("icon |icon--tiny |icon__") |>
    str_to_title(),
  
  url = page |>
    html_elements(".dynamic-text-list__streaming-links+ ul li a.dynamic-text-list__tomatometer-group") |>
    html_attr("href")
)

movies


get_movie = function(url) {
  
  message("Scraping ", url)
  
  page = polite::nod(session, url) |>
    polite::scrape()
  
  list(
    rating = page |>
      html_elements(".info-item:nth-child(1) span") |>
      html_text2() |>
      str_remove(" \\(.*\\)"),
    
    rating2 = page |>
      html_elements("#scoreboard") |>
      html_attr("rating"),
    
    audiencescore = page |>
      html_elements("#scoreboard") |>
      html_attr("audiencescore") |>
      as.double()
  )
}

movies |>
  mutate(
    details = purrr::map(url, get_movie)
  ) |>
  unnest_wider(details)
  

