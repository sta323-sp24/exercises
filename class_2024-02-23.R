library(tidyverse)

## API Basics

jsonlite::read_json("https://www.anapioficeandfire.com/api/books?page=1&pageSize=50") |>
  tibble(data = _) |>
  unnest_wider(data)


jsonlite::read_json("https://www.anapioficeandfire.com/api/characters?page=1&pageSize=50") |>
  tibble(data = _) |>
  unnest_wider(data)

## Iteration




## httr2

library(httr2)

resp = request("https://www.anapioficeandfire.com/api/characters") |>
  req_url_query(pageSize = 50, page = 1) |>
  req_perform()

resp_status(resp)

resp_body_json(resp) |> View()



### httr2 w/ iteration

req = request("https://www.anapioficeandfire.com/api/characters") |>
  req_url_query(pageSize = 50)

full = list()
page = 1

repeat {
  
  cur_req = req |>
    req_url_query(page = page)
  
  message("Grabbing page ", page)
  
  resp = req_perform(cur_req) 
  
  if (!str_detect(resp_header(resp, "link"), "next"))
    break
  
  res = resp_body_json(resp)
  

  
  full = c(full, res)
  page = page+1
}

full |>
  tibble(data = _) |>
  unnest_wider(data)



## GitHub API

request("https://api.github.com/orgs/sta323-sp24/repos") |>
  req_perform() |>
  resp_body_json() |>
  purrr::map_chr("full_name")


request("https://api.github.com/orgs/sta323-sp24/repos") |>
  req_auth_bearer_token("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") |>
  req_perform() |>
  resp_body_json() |>
  purrr::map_chr("full_name")

### Create a gist


resp = request("https://api.github.com/gists") |>
  req_auth_bearer_token("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") |>
  req_body_json(
    list(
      description = "Testing 1... 2... 3...",
      files = list(
        "test.R" = list(content = "print('hello world')\n\n")
      )
    )
  ) |>
  req_perform()
  
resp |> resp_status()

resp |> resp_body_json() |> View()
  
  
  
  
  
  
  
  
  
  






