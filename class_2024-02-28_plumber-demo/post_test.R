library(httr2)

library(job)
empty({
  library(plumber)
  plumb(file='api.R')$run(port=4443)
})

new_data = tibble::tibble(
  x = rnorm(30),
  y = rnorm(30),
  group = "9",
  rand = "9"
)

## Predict

request("http://127.0.0.1:4443") |>
  req_url_path("/model/predict") |>
  req_method("post") |>
  req_body_json(new_data) |>
  req_perform()

last_response() |> 
  resp_body_string() |> 
  cat()



## New data

request("http://127.0.0.1:4443") |>
  req_url_path("/data/new") |>
  req_method("post") |>
  req_body_json(new_data) |>
  req_perform()


last_response() |> 
  resp_body_string() |> 
  cat()