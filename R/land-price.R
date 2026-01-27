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
