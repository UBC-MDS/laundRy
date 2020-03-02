# importing required libraries
library(caret)
library(tidyverse)

#' Transforms columns of a dataframe
#'
#' Transforms  columns in dataframe  by the specified methods.
#' Separate methods can be applied for categorical column transformation and
#' numerical column transformation.
#'
#'
#' @param df dataframe to be transformed
#' @param num_list list of columns to have numerical transformation   to be applied
#' @param cat_list list of columns to have categorical transformations to be applied
#' @param num_trans method for numerical transformation (default = "standard scaling")
#' @param cat_trans method for categorical transformation (default = "ohe")
#'
#' @return df, with tranformed column values
#'
#' @examples
#' column_transformer(df, list('weight'), list('education'))
#'
#' @export
#'
column_transformer <-
  function(df, num_list, cat_list, num_trans, cat_trans)
  {

    preProcValues <- preProcess(df[,num_cols], method = c("center", "scale"))

    training[,num_cols] = predict(preProcValues, training[,num_cols])
    test[,num_cols] = predict(preProcValues, test[,num_cols])
    head(training[,num_cols])
    }
