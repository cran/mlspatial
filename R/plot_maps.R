#' Build a tmap for a single variable
#'
#' Creates a thematic map using the `tmap` package for a single variable in an sf object.
#'
#' @param sf_data An sf object containing spatial data.
#' @param var Variable name as a string to map.
#' @param title Legend title for the fill legend.
#' @param palette Color palette for the map (default is "reds").
#'
#' @return A tmap object representing the thematic map.
#'
#' @importFrom tmap tm_shape tm_fill tm_scale_intervals tm_legend tm_borders tm_compass tm_layout
#' @export
#'
#' @examples
#' \donttest{
#' library(sf)
#' # Create example sf object
#' nc <- st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
#' nc$incidence <- runif(nrow(nc), 0, 100)
#'
#' # Plot
#' p1 <- plot_single_map(nc, "incidence", "Incidence")
#' }
plot_single_map <- function(sf_data, var, title, palette = "reds") {
  tm_shape(sf_data) +
    tm_fill(var, fill.scale = tm_scale_intervals(
      values = paste0("brewer.", palette),
      style = "quantile"
    ), fill.legend = tm_legend(title = title)) +
    tm_borders(fill_alpha = .3) +
    tm_compass() +
    tm_layout(
      legend.text.size = 0.5, legend.position = c("left", "bottom"),
      frame = TRUE, component.autoscale = FALSE
    )
}

#' Arrange Multiple tmap Plots in a Grid
#'
#' Arrange a list of tmap objects into a grid layout.
#'
#' @param maps A list of tmap objects.
#' @param ncol Number of columns in the grid (default is 2).
#'
#' @return A tmap object representing arranged maps.
#'
#' @importFrom tmap tmap_mode tmap_arrange
#' @export
#'
#' @examples
#' \donttest{
#' library(sf)
#' library(tmap)
#'
#' # Load sample spatial data
#' nc <- st_read(system.file("shape/nc.shp", package = "sf"), quiet = TRUE)
#'
#' # Add mock variables to map
#' nc$var1 <- runif(nrow(nc), 0, 100)
#' nc$var2 <- runif(nrow(nc), 10, 200)
#'
#' # Create individual maps
#' map1 <- tm_shape(nc) + tm_fill("var1", title = "Variable 1")
#' map2 <- tm_shape(nc) + tm_fill("var2", title = "Variable 2")
#'
#' # Arrange the maps in a grid using your function
#' plot_map_grid(list(map1, map2), ncol = 2)
#' }


plot_map_grid <- function(maps, ncol = 2) {
  old_mode <- tmap::tmap_mode("plot")
  res <- do.call(tmap::tmap_arrange, c(maps, list(ncol = ncol)))
  tmap::tmap_mode(old_mode)
  invisible(res)
}
