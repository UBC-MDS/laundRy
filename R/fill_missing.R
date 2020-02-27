#' Handles missing values in a dataframe
#'
#' @param df dataframe to be transformed
#' @param num_list list of columns to have numerical imputation applied
#' @param cat_list list of columns to have categorical imputation applied
#' @param num_imp method for numerical imputation (default = "mean")
#' @param cat_imp method for categorical imputation (default = "mode")
#'
#' @return df, with missing values replaced by the specified method
#'
#' @examples
#' fill_missing(df, list('weight'), list('education'))
#'
#' @export
fill_missing <-
  function(df, num_list, cat_list, num_imp, cat_imp)
  { }