read_file_shape_property_table2_land_price_2025 <- function(
  file_shape_property_table2
) {
  read_excel(file_shape_property_table2, sheet = "L01地価公示", skip = 3) |>
    select(属性名, 属性コード)
}

read_file_land_price_2025 <- function(
  file_land_price_2025,
  shape_property_table2_land_price_2025
) {
  exdir <- "_targets/user/land_price_2025"
  zip::unzip(file_land_price_2025, exdir = exdir)

  dir_ls(exdir, recurse = TRUE, glob = "*.shp") |>
    read_sf() |>
    rename_with(
      ~ shape_property_table2_land_price_2025$属性名,
      all_of(shape_property_table2_land_price_2025$属性コード)
    )
}

get_land_price_2025 <- function(land_price_2025_raw) {
  land_price_2025_raw |>
    rename(
      land_price_JPY_per_m2 = 地価公示価格,
      land_area_m2 = 地積,
      front_road_width_m = `前面道路の状況：幅員`,
      road_distance_to_nearest_station_m = `交通施設、距離：最寄り駅迄の道路距離`
    ) |>
    select(
      land_price_JPY_per_m2,
      land_area_m2,
      front_road_width_m,
      road_distance_to_nearest_station_m
    ) |>
    mutate(across(where(is.integer), as.numeric))
}
