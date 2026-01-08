#' Compute Moran's I & LISA, classify clusters
#'
#' Computes global and local Moran’s I to assess spatial autocorrelation
#' and classifies observations into spatial cluster types (e.g., High-High).
#'
#' @param sf_data An \code{sf} object containing spatial features.
#' @param values A numeric vector or column name with the variable to test.
#' @param signif Numeric significance level threshold for clusters (default 0.05).
#'
#' @return A named list with elements:
#' \itemize{
#'   \item \code{data}: An \code{sf} object with added columns for standardized values,
#'     spatial lag, local Moran's I values, z-scores, p-values, and cluster classification.
#'   \item \code{moran}: An object of class \code{htest} with global Moran's I test results.
#' }
#'
#' @examples
#' \donttest{
#' library(sf)
#' library(spdep)
#' library(dplyr)
#'
#' #Load and prepare spatial data
#' mapdata <- st_read(system.file("shape/nc.shp", package="sf"), quiet = TRUE)
#' mapdata <- st_make_valid(mapdata)
#'
#' #Variable to analyze
#' values <- rnorm(nrow(mapdata))
#'
#' #Run function
#' result <- compute_spatial_autocorr(mapdata, values, signif = 0.05)
#'
#' #Inspect results
#' head(result$data)
#' result$moran
#' }
#'
#' @importFrom spdep poly2nb nb2listw moran.test localmoran lag.listw
#' @importFrom dplyr mutate case_when
#' @importFrom sf st_as_sf st_make_valid
#' @export
compute_spatial_autocorr <- function(sf_data, values, signif = 0.05) {
  nb <- spdep::poly2nb(sf_data) %>% spdep::nb2listw(style = "W", zero.policy = TRUE)
  std <- scale(values)[, 1]
  lag_val <- spdep::lag.listw(nb, std, zero.policy = TRUE)
  local <- spdep::localmoran(values, nb, zero.policy = TRUE)
  df <- sf_data %>%
    dplyr::mutate(
      val_st = std,
      lag_val = lag_val,
      Ii = local[, 1],
      Z_Ii = local[, 4],
      Pr_z = local[, 5],
      cluster = dplyr::case_when(
        val_st > 0 & lag_val > 0 & Pr_z <= signif ~ "High-High",
        val_st < 0 & lag_val < 0 & Pr_z <= signif ~ "Low-Low",
        val_st < 0 & lag_val > 0 & Pr_z <= signif ~ "Low-High",
        val_st > 0 & lag_val < 0 & Pr_z <= signif ~ "High-Low",
        TRUE ~ "Not Significant"
      )
    )
  list(data = df, moran = spdep::moran.test(values, nb, zero.policy = TRUE))
}
