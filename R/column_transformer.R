#' Transforms columns of a dataframe
#'
#' Transforms  columns in dataframe  by the specified methods.
#' Separate methods can be applied for categorical column transformation and
#' numerical column transformation.
#'
#'
#' @param x_train trainingset dataframe/tibble
#' @param x_test test set dataframe/tibble
#' @param column_list  named list of categorical and numeric columns. 
#' @param num_trans method(character) for numerical transformation (default = "standard_scaling")
#' @param cat_trans method(character) for categorical transformation (default = "onehot_encoding")
#'
#' @return list(x_train,x_test) transformed
#'
#'
#' @export
#'

column_transformer <- function(x_train,x_test, col_names, num_trans="standard_scaling", cat_trans="onehot_encoding")
{

  # block to ensure consistency in naming convention
  x_train = x_train
  x_test = x_test


  # checking for incorrect inputs
  if(class(x_train) != 'data.frame'| class(x_test)!= 'data.frame' )
    stop("Input objects x_train and x_test must be of class dataframe")

  if(class(col_names) != 'list' | length(col_names) != 2){
    stop("Parameter col_names must be a  list of length 2 specifying named vectors specifying numeric and categoric columns")
  }

  if(num_trans != "standard_scaling" & num_trans!= "minmax_scaling"){
    stop("num_trans parameter can only be 'standard_scaling' or 'minmax_scaling'")
  }

  if(cat_trans != "onehot_encoding" & cat_trans != "label_encoding")
    stop("cat_trans parameter can only take 'onehot_encoding' or 'label_encoding' values")

  # block to ensure consistency in naming convention
  numeric = col_names$numeric
  categorical = col_names$categorical


  # numeric column transformation

  if(num_trans == "standard_scaling"){
    preProcValues <- caret::preProcess(x_train[,numeric], method = c("center", "scale"))
    x_train[,numeric] = stats::predict(preProcValues, x_train[,numeric])
    x_test[,numeric] = stats::predict(preProcValues, x_test[,numeric])


  }else if(num_trans == "minmax_scaling"){
    preProcValues = caret::preProcess(x_train[,numeric], method = "range")
    x_train[,numeric] = stats::predict(preProcValues, x_train[,numeric])
    x_test[,numeric] = stats::predict(preProcValues, x_test[,numeric])

  }


  # transformation for categorical columns
  if(cat_trans == 'onehot_encoding'){
    x_train_cat <- x_train[, categorical]
    x_test_cat <- x_test[, categorical]
    x_train <- x_train[ , !(names(x_train) %in% categorical)]
    x_test <- x_test[ , !(names(x_test) %in% categorical)]

    dmy <- caret::dummyVars(" ~ .", data = x_train_cat, fullRank  = TRUE)
    x_train_cat <- data.frame(stats::predict(dmy, newdata = x_train_cat))

    x_test_cat <- data.frame(stats::predict(dmy, newdata = x_test_cat))

    x_train <- cbind(x_train, x_train_cat )
    x_test <- cbind(x_test, x_test_cat)

  }
  else if(cat_trans=='label_encoding'){
    for (col in categorical) {

      x_train[[col]] = as.character(x_train[[col]])
      x_test[[col]] = as.character(x_test[[col]])
      levels <- sort(unique(c(x_train[[col]])))
      x_train[[col]]  <- as.integer(factor( x_train[[col]] , levels = levels))
      x_test[[col]]<- as.integer(factor(x_test[[col]], levels = levels))
    }
  }

  return(list (x_train = x_train, x_test = x_test))


}
