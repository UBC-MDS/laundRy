#' Transforms categorical and numerical features
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
column_transformer <-
  function(df, num_list, cat_list, num_trans, cat_trans)
  { }
