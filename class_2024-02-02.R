library(tidyverse)

## Exercise 1

palmerpenguins::penguins |>
  count(island, species) |>
  pivot_wider(
    id_cols = island, 
    names_from = species, 
    values_from = n, 
    values_fill = 0
  )

## Example 1

grades = tibble::tribble(
  ~name,   ~hw_1, ~hw_2, ~hw_3, ~hw_4, ~proj_1, ~proj_2,
  "Alice",    19,    19,    18,    20,      89,      95,
  "Bob",      18,    20,    18,    16,      77,      88,
  "Carol",    18,    20,    18,    17,      96,      99,
  "Dave",     19,    19,    18,    19,      86,      82
)

grades |>
  select(-hw_4, -proj_2) |>
  pivot_longer(
    cols = -name,
    names_to = "assignment",
    values_to = "score"
  ) |>
  separate_wider_delim(
    assignment, delim="_", names = c("type", "id")
  ) |>
  summarize(
    avg_score = mean(score),
    .by = c(name, type)
  ) |>
  pivot_wider(
    id_cols = name, names_from = type, values_from = avg_score
  ) |>
  mutate(
    final_score = 0.5*hw/20 + 0.5*proj/100
  )


## Exercise 2

# 1.

repurrrsive::sw_planets |>
  tibble(planet = _) |>
  unnest_wider(planet) |>
  select(name, films) |>
  unnest_longer(films) |>
  summarize(n=n(), .by=name) |>
  slice_max(order_by = n, n = 3)
  
# 2. Which planet was the homeworld of the most characters in 
#    the starwars films?


inner_join(
  repurrrsive::sw_planets |>
    tibble(planet = _) |>
    unnest_wider(planet) |>
    select(name, url), 
  repurrrsive::sw_people |>
    tibble(people = _) |>
    unnest_wider(people) |>
    select(name, homeworld),
  by = c(url = "homeworld"),
  suffix = c("_homeworld", "_person")
) |>
  count(name_homeworld) |>
  slice_max(order_by = n, n=3)

repurrrsive::sw_planets |>
  tibble(planet = _) |>
  unnest_wider(planet) |>
  select(name, url) |>
  inner_join(
    repurrrsive::sw_people |>
      tibble(people = _) |>
      unnest_wider(people) |>
      select(name, homeworld),
    by = c(url = "homeworld"),
    suffix = c("_homeworld", "_person")
  ) |>
  count(name_homeworld) |>
  slice_max(order_by = n, n=3)
