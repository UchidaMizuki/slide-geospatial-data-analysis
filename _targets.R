library(targets)
library(tarchetypes)

tar_source("R/global.R")
tar_option_set(
  packages = packages
)

tar_source()

tar_plan(
  tar_file(
    file_shape_property_table2,
    curl::curl_download(
      "https://nlftp.mlit.go.jp/ksj/gml/codelist/shape_property_table2.xlsx",
      "_targets/user/shape_property_table2.xlsx"
    )
  ),
  tar_file(
    file_land_price_2025,
    xml2::url_absolute(
      "/ksj/gml/data/L01/L01-25/L01-25_GML.zip",
      "https://nlftp.mlit.go.jp/"
    ) |>
      curl::curl_download("_targets/user/land-price_2025.zip")
  ),

  shape_property_table2_land_price_2025 = read_file_shape_property_table2_land_price_2025(
    file_shape_property_table2 = file_shape_property_table2
  ),
  land_price_2025_raw = read_file_land_price_2025(
    file_land_price_2025 = file_land_price_2025,
    shape_property_table2_land_price_2025 = shape_property_table2_land_price_2025
  ),
  land_price_2025 = get_land_price_2025(
    land_price_2025_raw = land_price_2025_raw
  ),

  # model-land-price
  data_land_price = get_data_land_price(
    land_price = land_price_2025
  ),
  model_glm_land_price = get_model_glm_land_price(
    data_land_price = data_land_price
  ),
  mesh_land_price = get_mesh_land_price(
    data_land_price = data_land_price
  ),
)
