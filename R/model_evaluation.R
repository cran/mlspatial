#' Get RMSE/MAE/R² metrics on training data
#'
#' Evaluate Model Performance by calculating RMSE, MAE, and R² metrics.
#'
#' @param model A trained model
#' @param data A data frame
#' @param formula A formula object
#' @param model_type Character string: one of "rf", "xgb", or "svr"
#' @return A numeric value representing the model's accuracy
#'
#' @importFrom ggplot2 aes geom_point geom_abline labs theme_minimal
#' @importFrom dplyr %>%
#' @importFrom xgboost xgb.DMatrix
#' @importFrom stats model.matrix predict
#' @export
eval_model <- function(model, data, formula, model_type = c("rf", "xgb", "svr")) {
  model_type <- match.arg(model_type)
  if (model_type == "xgb") {
    mm <- model.matrix(formula, data)
    preds <- predict(model, newdata = mm)
  } else {
    preds <- predict(model, newdata = data)
  }
  obs <- eval(formula[[2]], data)
  caret::postResample(preds, obs)
}

#' Examples for model evaluation functions
#'
#' @name model_evaluation_examples
#' @examples
#' \donttest{
#' library(randomForest)
#' library(caret)
#' data(panc_incidence)
#' mapdata <- join_data(africa_shp, panc_incidence, by = "NAME")
#' rf_model <- randomForest(incidence ~ female + male + agea + ageb + agec + fagea + fageb + fagec +
#' magea + mageb + magec + yrb + yrc + yrd + yre, data = mapdata, ntree = 500,
#' importance = TRUE)
#'
#' rf_preds <- predict(rf_model, newdata = mapdata)
#' rf_metrics <- postResample(pred = rf_preds, obs = mapdata$incidence)
#' print(rf_metrics)
#' }
NULL


#' Declare known global variables to suppress R CMD check NOTE
#' Global variables used in evaluation functions
#'
#' This is to suppress R CMD check notes about undefined global variables.
#'
#' @name global_variables_eval
NULL
utils::globalVariables(c("obs", "pred"))

#' Plot observed vs predicted values with correlation
#'
#' Creates a scatterplot of observed vs predicted values, with a 1:1 reference line and Pearson's R².
#'
#' @param observed Numeric vector of observed values.
#' @param predicted Numeric vector of predicted values.
#' @param title String for the plot title (default: "").
#'
#' @return No return value; called for side effect of displaying a plot.
#'
#' @examples
#' observed <- c(10, 20, 30, 40)
#' predicted <- c(12, 18, 33, 39)
#' plot_obs_vs_pred(observed, predicted, title = "Observed vs Predicted")
#'
#' @importFrom ggplot2 ggplot aes geom_point geom_abline labs theme_minimal
#' @importFrom ggpubr stat_cor
#' @export
plot_obs_vs_pred <- function(observed, predicted, title = "") {
  ggplot2::ggplot(data.frame(obs = observed, pred = predicted),
                  aes(x = obs, y = pred)) +
    geom_point(alpha = 0.6) +
    geom_abline(slope = 1, intercept = 0, color = "red", linetype = "dashed") +
    ggpubr::stat_cor(method = "pearson", aes(label = paste0("R^2 = "))) +
    labs(title = title, x = "Observed", y = "Predicted") +
    theme_minimal()
}
