
#' Join spatial and incidence datasets
#' @param sf_data sf object
#' @param tbl_data tibble of incidence
#' @param by Column name to join on
#' @return sf object with joined attributes
#' @export
join_data <- function(sf_data, tbl_data, by) {
  sf_data %>% dplyr::inner_join(tbl_data, by = by)
}
