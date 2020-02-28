#' Handles missing values in a dataframe
#'
#' Replace missing values in dataframe columns by the specified methods. 
#' Separate methods can be applied for categorical column imputation and 
#' numerical column imputation. 
#' 
#' @param df dataframe to be transformed
#' @param num_list list of columns to have numerical imputation applied
#' @param cat_list list of columns to have categorical imputation applied
#' @param num_imp method for numerical imputation
#' @param cat_imp method for categorical imputation
#'
#' @return df, with missing values replaced by the specified method
#'
#' @examples
#' fill_missing(df, list('weight'), list('education'), 'mean', 'mode')
#'
#' @export
fill_missing <-
  function(df, num_list, cat_list, num_imp, cat_imp)
  { }