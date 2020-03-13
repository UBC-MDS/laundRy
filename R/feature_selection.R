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
#' feature_selection(data.frame(X1 = c(2, 4, 3), X2 = c(8, 7, 4)), c(4, 3, 5), "regression", 2)


feature_selection <- function(X, y, mode, n_features) {

  #Checking for dataframe
  if (class(X) != "data.frame"){
    stop("Input Data is not Data Frame")
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
