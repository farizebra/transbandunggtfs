library(dplyr)
library(tidyr)
library(purrr)

rm(list = ls())

tj <- readRDS("data/tj_detail.rds")

# stop_id, stop_name, stop_lat, stop_lon,
# zone_id, parent_station, location_type
stops <- tj %>%
  mutate(stop_detail = map(tj$route_info, "stops")) %>%
  select(stop_detail) %>%
  unnest("stop_detail") %>%
  mutate(id = gsub("idjkb_", "", .$id)) %>%
  select(-icon, -mapIcon, -areaName, -directionName) %>%
  distinct()

names(stops) <- c("stop_id", "stop_name", "stop_lat", "stop_lon")

# save data
write.csv(stops, "data/gtfs/stops.txt", row.names = FALSE, na = "")
