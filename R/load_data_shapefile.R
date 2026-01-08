
#' Load shapefile as sf + optionally convert to sp
#' @param shp_path Path to shapefile (.shp)
#' @param to_sp logical: also return Spatial object?
#' @return list with sf and optionally sp object
#' @export
load_shapefile <- function(shp_path, to_sp = FALSE) {
  sf_obj <- sf::st_read(shp_path, quiet = TRUE)
  if (to_sp) {
    sp_obj <- methods::as(sf_obj, "Spatial")
    return(list(sf = sf_obj, sp = sp_obj))
  } else {
    return(list(sf = sf_obj))
  }
}

#' Load incidence data from Excel
#' @param xlsx_path Path to Excel file
#' @return tibble of data
#' @export
load_incidence_data <- function(xlsx_path) {
  readxl::read_excel(xlsx_path)
}
