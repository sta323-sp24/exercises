library(tidyverse)

## Example 1

draw_points = function(n) {
  list(
    x = runif(n, -1, 1),
    y = runif(n, -1, 1)
  )
}

in_unit_circle = function(d) {
  sqrt(d$x^2 + d$y^2) <= 1
}

calc_pi = function(in_circ, tot) {
  4 * in_circ / tot
}

draw_points(1e5) |>
  in_unit_circle() |>
  sum() |>
  calc_pi(1e5)

tibble(
  n = 10^(3:7)
) |>
  mutate(
    draws = map(n, draw_points),
    n_in_ucirc = map_int(draws, ~ sum(in_unit_circle(.x))),
    pi_approx = map2_dbl(n_in_ucirc, n, calc_pi),
    pi_error = abs(pi - pi_approx)
  )




## Example 2


