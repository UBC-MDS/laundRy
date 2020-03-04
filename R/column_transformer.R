# importing required libraries
library(caret)
library(tidyr)
library(dplyr)
library(CatEncoders)

# dataframes for testing
employee_name <- c("A", "B", "C", "D", "E", "F", "G", "H", "I", "J")
manager <- c("M1", "M2", "M3", "M1", "M2", "M3", "M1", "M2", "M3", "M1")
age <- c(23, 56,34,40, 34,56, 45, 65, 54,43)
sex <- c('M', 'F','M', 'F','M', 'F','M', 'F', 'M', 'F' )
daily_wage<- c(100,200, 100, 60, 80, 140, 320,60, 90, 90)
x_train <- data.frame(employee_name, manager, age, sex, daily_wage)


employee_name <- c("K", "L", "M", "N", "O", "P")
manager <- c("M1", "M2", "M3", "M1", "M2", "M3")
age <- c(23, 56,34,40, 34,56)
sex <- c('M', 'F','M', 'F','M', 'F')
daily_wage<- c( 80, 140, 320,60, 90, 90)
x_test <- data.frame(employee_name, manager, age, sex, daily_wage)

col_names <- list(cat_cols= c("manager", "sex"), num_cols = c("age", "daily_wage" ))



#' Transforms columns of a dataframe
#'
#' Transforms  columns in dataframe  by the specified methods.
#' Separate methods can be applied for categorical column transformation and
#' numerical column transformation.
#'
#'
#' @param x_train trainingset dataframe/tibble
#' @param x_test test set dataframe/tibble
#' @param col_names list of names of categorical columns
#' @param num_trans method(character) for numerical transformation (default = "standard_scaling")
#' @param cat_trans method(character) for categorical transformation (default = "ohe")
#'
#' @return x_train,x_test transformed
#'
#' @examples
#' column_transformer(x_train, list('weight'), list('education'))
#'
#' @export



column_transformer <-
  function(x_train,x_test, col_names, num_trans="standard_scaling", cat_trans="onehot_encoding")
  {

    # block to ensure consistency in naming convention
    x_train = x_train
    x_test = x_test


    # checking for incorrect inputs
    if(class(x_train) != 'data.frame'| class(x_test)!= 'data.frame' )
      stop("Input objects x_train and x_test must be of class dataframe")

    if(class(col_names) != 'list'){
      stop("Parameter col_names must be a  list of named vectors specifying numeric and categoric columns")
    }

    if(num_trans != "standard_scaling" & num_trans!= "minmax_scaling"){
      stop("num_trans parameter can only be 'standard_scaling' or 'minmax_scaling'")
    }

    if(cat_trans != "onehot_encoding" & cat_trans != "label_encoding")
      stop("cat_trans parameter can only take 'onehot_encoding' or 'label_encoding' values")

    # block to ensure consistency in naming convention
    num_cols = col_names$num_cols
    cat_cols = col_names$cat_cols


    # numeric column transformation

    if(num_trans == "standard_scaling"){
      preProcValues <- preProcess(x_train[,num_cols], method = c("center", "scale"))
      x_train[,num_cols] = predict(preProcValues, x_train[,num_cols])
      x_test[,num_cols] = predict(preProcValues, x_test[,num_cols])


    }else if(num_trans == "minmax_scaling"){
      preProcValues = preProcess(x_train[,num_cols], method = "range")
      x_train[,num_cols] = predict(preProcValues, x_train[,num_cols])
      x_test[,num_cols] = predict(preProcValues, x_test[,num_cols])

    }


    # transformation for categorical columns
    if(cat_trans == 'onehot_encoding'){
      x_train_cat <- x_train[, cat_cols]
      x_test_cat <- x_test[, cat_cols]
      x_train <- x_train[ , !(names(x_train) %in% cat_cols)]
      x_test <- x_test[ , !(names(x_test) %in% cat_cols)]

      dmy <- dummyVars(" ~ .", data = x_train_cat, fullRank  = TRUE)
      x_train_cat <- data.frame(predict(dmy, newdata = x_train_cat))

      x_test_cat <- data.frame(predict(dmy, newdata = x_test_cat))

      x_train <- cbind(x_train, x_train_cat )
      x_test <- cbind(x_test, x_test_cat)

    }
    else if(cat_trans=='label_encoding'){
      for (col in cat_cols) {

          x_train[[col]] = as.character(x_train[[col]])
          x_test[[col]] = as.character(x_test[[col]])
          levels <- sort(unique(c(x_train[[col]])))
          x_train[[col]]  <- as.integer(factor( x_train[[col]] , levels = levels))
          x_test[[col]]<- as.integer(factor(x_test[[col]], levels = levels))
        }
    }

    return(list (x_train = x_train,x_test = x_test))


  }

