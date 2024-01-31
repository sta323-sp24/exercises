library(tidyverse)
library(nycflights13)


flights |> 
  group_by(origin, dest) |>
  summarize(
    n = n(), 
    min_dep_delay = min(dep_delay, na.rm=TRUE), 
    max_dep_delay = max(dep_delay, na.rm=TRUE)
  )

## Exercise / Examples

# How many flights to Los Angeles (LAX) did each of the legacy carriers 
# (AA, UA, DL or US) have in May from JFK, and what was their average 
#duration?

flights |>
  mutate(carrier = as.factor(carrier)) |>
  filter(dest == "LAX") |>
  filter(carrier %in% c("AA","UA","DL","US")) |>
  filter(month == 5) |>
  filter(origin == "JFK") |> 
  summarize(
    n = n(),
    avg_dur = mean(air_time, na.rm=TRUE),
    .by = carrier
  )


# What was the shortest flight out of each airport in terms of distance? 
# In terms of duration?

flights |>
  select(origin, dest, distance) |>
  group_by(origin) |>
  arrange(distance) |>
  distinct() |>
  slice_min(n=3, order_by = distance)
  



# Which plane (check the tail number) flew out of each New York airport 
# the most?

flights |>
  count(origin, tailnum) |>
  filter(!is.na(tailnum)) |>
  slice_max(n = 1, order_by = n, by = origin)


# Which date should you fly on if you want to have the lowest possible average 
# departure delay? What about arrival delay?

flights |> 
  mutate(
    date = paste(year, month, day, sep="/")
  ) |>
  summarize(
    avg_dep_delay = mean(dep_delay, na.rm=TRUE),
    .by = date
  ) |>
  slice_min(n=1, order_by = avg_dep_delay)

