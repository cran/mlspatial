#' Train Random Forest model
#'
#' Trains a Random Forest regression model.
#'
#' @param data A data frame containing the training data.
#' @param formula A formula describing the model structure.
#' @param ntree Number of trees to grow (default 500).
#' @param seed Random seed for reproducibility (default 123).
#'
#' @return A trained randomForest model object.
#'
#' @examples
#' \donttest{
#' library(randomForest)
#' data(mtcars)
#' rf_model <- train_rf(mtcars, mpg ~ cyl + hp + wt, ntree = 100)
#' print(rf_model)
#' }
#' @export
train_rf <- function(data, formula, ntree = 500, seed = 123) {
  set.seed(seed)
  randomForest::randomForest(formula, data = data, ntree = ntree, importance = TRUE)
}



#' Train XGBoost model
#'
#' Trains an XGBoost regression model.
#'
#' @name train_xgb
#' @title Train XGBoost model
#'
#' @param data A data frame with the training data.
#' @param formula A formula defining the model structure.
#' @param nrounds Number of boosting iterations.
#' @param max_depth Maximum tree depth.
#' @param eta Learning rate.
#'
#' @return A trained xgboost model object.
#' @importFrom xgboost xgb.DMatrix xgboost
#' @examples
#' \donttest{
#' # Load required package
#' library(xgboost)
#'
#' # Use built-in dataset
#' data(mtcars)
#'
#' # Define regression formula
#' xgb_formula <- mpg ~ cyl + disp + hp + wt
#'
#' # Train XGBoost model
#' xgb_model <- train_xgb(data = mtcars, formula = xgb_formula, nrounds = 50)
#'
#' # Print model summary
#' print(xgb_model)
#' }
#' @export
train_xgb <- function(data, formula, nrounds = 100, max_depth = 4, eta = 0.1) {
  x <- model.matrix(formula, data = data)[, -1]
  label <- eval(formula[[2]], data)
  dtrain <- xgboost::xgb.DMatrix(x, label = label)
  xgboost::xgboost(
    data = dtrain,
    objective = "reg:squarederror",
    nrounds = nrounds,
    max_depth = max_depth,
    eta = eta,
    verbose = 0)
}


#' Train Support
#'
#' Trains an SVR model using the radial kernel.
#'
#' @name train_svr
#' @title Train Support Vector Regression (SVR) model
#'
#' @param data A data frame containing the training data.
#' @param formula A formula specifying the model.
#'
#' @return A trained \code{svm} model object from the \pkg{e1071} package.
#'
#' @importFrom e1071 svm
#' @examples
#' \donttest{
#' # Load required package
#' library(e1071)
#'
#' # Use built-in dataset
#' data(mtcars)
#'
#' # Define regression formula
#' svr_formula <- mpg ~ cyl + disp + hp + wt
#'
#' # Train SVR model
#' svr_model <- train_svr(data = mtcars, formula = svr_formula)
#'
#' # Print model summary
#' print(svr_model)
#'
#' # Predict on the same data (for illustration)
#' preds <- predict(svr_model, newdata = mtcars)
#' head(preds)
#' }
#' @export
train_svr <- function(data, formula) {
  e1071::svm(formula, data = data, type = "eps-regression", kernel = "radial")
}


