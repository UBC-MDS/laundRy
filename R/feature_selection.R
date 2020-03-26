#' Apply feature selection for the input data
#'
#'
#' Take input as predictons and response and return the
#' list of features that are important
#'
#'
#' @param X data.frame of predictors
#' @param y vector of response and should be a factor in case of classification
#' @param mode string regression or classification
#' @param n_features int number of top important features select from all the features
#'
#' @return vector of feature nams of top n_features
#' @export
#' @examples
#' feature_selection(data.frame(X1 = c(2, 4, 3), X2 = c(8, 7, 4)), c(4, 3, 5), "regression", 2)
#' feature_selection(data.frame(X1 = c(2, 4, 3), X2 = c(8, 7, 4)), factor(c(1, 1, 0)), "classification", 1)


feature_selection <- function(X, y, mode, n_features=1) {

  #Checking for dataframe
  if (class(X) != "data.frame"){
    stop("Input Data is not Data Frame")
  }

  if (n_features > length(X)){
    stop("Number of features should be less than number of columns of input data")
  }



  if (mode == "regression") {

    control <- caret::rfeControl(functions = caret::lmFuncs,
                          method = "cv", #cross validation,
                          returnResamp = "all",
                          verbose = FALSE,
    )

    lm_m <- caret::rfe(X,
                y,
                sizes = c(1:ncol(X)),
                rfeControl = control)

    tf <- lm_m$variables$var[1:n_features]


  } else {
    if (class(y) != "factor"){
      stop("Input target is not factor")
    }

    control <- caret::rfeControl(functions = caret::lrFuncs,
                          method = "cv", #cross validation,
                          returnResamp = "all",
                          verbose = FALSE,
    )

    lr_m <- caret::rfe(X,
                y,
                sizes = c(1:ncol(X)),
                rfeControl = control)


    tf <- lr_m$variables$var[1:n_features]
  }

  return (tf)


}
