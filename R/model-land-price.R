get_data_land_price <- function(land_price) {
  land_price |>
    mutate(
      land_price_JPY = land_price_JPY_per_m2 * land_area_m2,
      land_area_m2,
      .before = 1,
      .keep = "unused"
    ) |>
    filter(
      if_all(
        c(
          land_price_JPY,
          land_area_m2,
          front_road_width_m,
          road_distance_to_nearest_station_m
        ),
        ~ .x > 0
      )
    ) |>
    mutate(
      st_coordinates(geometry) |>
        as_tibble()
    ) |>
    st_drop_geometry()
}

get_model_glm_land_price <- function(data_land_price) {
  glm(
    land_price_JPY ~ log(land_area_m2) +
      log(front_road_width_m) +
      log(road_distance_to_nearest_station_m),
    data = data_land_price,
    family = Gamma(link = "log")
  )
}

get_mesh_land_price <- function(data_land_price) {
  sdmTMB::make_mesh(
    data_land_price,
    xy_cols = c("X", "Y"),
    n_knots = 1000
  )
}
