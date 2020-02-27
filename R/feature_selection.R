#' Apply feature selection for the input data
#'
#'
#' Take input as predictons and response and return the
#' list of features that are important
#'
#'
#' @param X data.frame of predictors
#' @param y vector of renponse
#' @param mode string regression or classification
#' @param n_features int
#'
#' @return list
#' @export
#' @examples
#' feature_selection(data.frame(X1 = c(2,4,3), X2 = c('c','d','c')),c(4,3,5),"regression",2)
feature_selection <- function(X,y,mode,n_features) {
  pass
}
