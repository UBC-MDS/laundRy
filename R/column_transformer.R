#' Transforms columns of a dataframe
#'
#' Transforms  columns in dataframe  by the specified methods.
#' Separate methods can be applied for categorical column transformation and
#' numerical column transformation.
#'
#'
#' @param x_train training set dataframe/tibble
#' @param x_test test set dataframe/tibble
#' @param column_list  named list of categorical and numeric columns.
#' @param num_trans method(character) for numerical transformation - Can take values "standard_scaling" or "minmax_scaling" (default = "standard_scaling")
#' @param cat_trans method(character) for categorical transformation - Cant take values "onehot_encoding" or "label_encoding" (default = "onehot_encoding")
#'
#' @return A list with named items x_train and x_list that have been transformed according to the arguments specified
#' @examples
#' x_train <- data.frame('x' = c(2.5, 3.3, 5,8), 'y' = factor(c(1, 6, 1,6)))
#' x_test <- data.frame('x' = c(2,1), 'y' = factor(c(1,6)))
#' column_transformer(x_train, x_test, list("numeric" = c('x'), "categorical" = c('y')))
#' @export
#'

column_transformer <- function(x_train,x_test, column_list, num_trans="standard_scaling", cat_trans="onehot_encoding")
{



  # checking for incorrect inputs
  if(class(x_train) != 'data.frame'| class(x_test)!= 'data.frame' )
    stop("Input objects x_train and x_test must be of class dataframe")

  if(class(column_list) != 'list' | length(column_list) != 2)
    stop("Parameter column_list must be a list of length 2 specifying named vectors specifying numeric and categoric columns")

  if(num_trans != "standard_scaling"
     & num_trans!= "minmax_scaling")
    stop("num_trans parameter can only be 'standard_scaling' or 'minmax_scaling'")

  if(cat_trans != "onehot_encoding" &
     cat_trans != "label_encoding")
    stop("cat_trans parameter can only take 'onehot_encoding' or 'label_encoding' values")
# Check train set and test set columns are the same
  for (cols in names(x_test)) {
    if(!is.element(cols, names(x_train)))
      stop("Columns of train and test set must be identical")
  }
  for (cols in names(x_train)) {
    if(!is.element(cols, names(x_test)))
      stop("Columns of train and test set must be identical")
  }


  # making sure column names present in dictionary are same as that of x_train
  # code adapted from Alex's module

  for (vect in names(column_list)) {
    for ( col in column_list[[vect]]) {
      if(!is.element(col, names(x_train)))
        stop("Column names in the named list must be present in dataframe")
    }
  }



  numeric <- column_list$numeric
  categorical <- column_list$categorical


  # numeric column transformation

  if(num_trans == "standard_scaling") {
    preProcValues <- caret::preProcess(x_train[ ,numeric, drop = FALSE],
                                       method = c("center", "scale"))
    x_train[,numeric] <- stats::predict(preProcValues,
                                       x_train[ ,numeric, drop = FALSE])
    x_test[,numeric] <- stats::predict(preProcValues,
                                       x_test[ ,numeric, drop = FALSE])


  }else if(num_trans == "minmax_scaling") {
    preProcValues <- caret::preProcess(x_train[, numeric, drop = FALSE],
                                       method = "range")
    x_train[,numeric] <- stats::predict(preProcValues,
                                        x_train[ ,numeric, drop = FALSE])
    x_test[,numeric] <- stats::predict(preProcValues,
                                       x_test[ ,numeric, drop = FALSE])

  }



  # transformation for categorical columns
  if(cat_trans == 'onehot_encoding') {

    x_train_cat <- matrix(sapply(x_train[, categorical,
                                       drop = FALSE], as.factor),
                          ncol=length(categorical),
                          dimnames = list(rownames(x_train), categorical))
    x_train_cat <- data.frame(x_train_cat)
    x_test_cat <- matrix(sapply(x_test[, categorical,
                                      drop = FALSE], as.factor),
                         ncol=length(categorical),
                         dimnames = list(rownames(x_test), categorical))
    x_test_cat <- data.frame(x_test_cat)

    x_train <- x_train[ , numeric, drop = FALSE]
    x_test <- x_test[ , numeric, drop = FALSE]

    dmy <- caret::dummyVars(" ~ .",
                            data = x_train_cat,
                            fullRank  = TRUE)
    x_train_cat <- data.frame(stats::predict(dmy,
                                             newdata = x_train_cat))

    x_test_cat <- data.frame(stats::predict(dmy,
                                           newdata = x_test_cat))

    x_train <- cbind(x_train, x_train_cat)
    x_test <- cbind(x_test, x_test_cat)

  }
  else if(cat_trans=='label_encoding') {
    for (col in categorical) {

      x_train[[col]] <- as.character(x_train[[col]])
      x_test[[col]] <- as.character(x_test[[col]])
      levels <- sort(unique(c(x_train[[col]])))
      x_train[[col]]  <- as.integer(factor( x_train[[col]] ,
                                            levels = levels))
      x_test[[col]]<- as.integer(factor(x_test[[col]],
                                        levels = levels))
    }
  }

  return(list (x_train =  x_train, x_test =  x_test))

}



