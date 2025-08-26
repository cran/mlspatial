
test_that("shapefile loads correctly", {
  data("africa_shp", package = "mlspatial")  # Load from package
  expect_s3_class(africa_shp, "sf")
})
