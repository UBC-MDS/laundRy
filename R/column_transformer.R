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
#' @param num_vec list of columns to have numerical transformation   to be applied
#' @param cat_vec list of columns to have categorical transformations to be applied
#' @param num_trans method for numerical transformation (default = "standard_scaling")
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
  function(df, num_vec, cat_vec, num_trans, cat_trans)
  {

    # numeric column transformation

    if(num_trans == "standard_scaling"){
      preProcValues = preProcess(df[,num_vec], method = c("center", "scale"))

    }
    if(num_trans == "minmax_Scaling"){
      preProcValues = preProcess(df[,num_vec], method = "range")

    }
    else{
      print("Invalid transformation type for numerical columns")
    }

    df[,num_vec] = predict(preProcValues, df[,num_vec])


    # transformation for categorical columns
    if(cat_trans == 'onehot'){
      dmy <- dummyVars(" ~ .", data = df[,cat_vec], fullRank  = TRUE)
    }


    }
