getmode <- function(v) {
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}
#' Handles missing values in a dataframe
#'
#' Replace missing values in dataframe columns by the specified methods.
#' Separate methods can be applied for categorical column imputation and
#' numerical column imputation.
#'
#' @param x_train training set dataframe to be transformed
#' @param x_test test set dataframe to be transformed
#' @param column_list named list of columns with two sub vectors, must be named
#' 'numeric' and 'categorical'
#' @param num_imp method for numerical imputation (default = "mean")
#' @param cat_imp method for categorical imputation
#'
#' @return df, with missing values replaced by the specified method
#' @importFrom magrittr %>%
#' @import readr
#' @import tidyr
#' @importFrom dplyr select
#' @importFrom dplyr select
#' @examples
#' fill_missing(df, list('weight'), list('education'), 'mean', 'mode') # UPDATE example??
#'
#' @export
fill_missing <- function(df_train, df_test, column_list, num_imp, cat_imp)
{
  # Check input types  are as specified
  if (!is.data.frame(df_train))
    stop("Training set must be a dataframe.")
  if (!is.data.frame(df_test))
    stop("Test set must be a dataframe.")
  if (!is.list(column_list))
    stop("num_list must be a named list of columns.")
  if (!is.character(num_imp))
    stop("num_imp method must be a string.")
  if (!is.character(cat_imp))
    stop("cat_imp method must be a string.")

  # Check train set and test set columns are the same
  if (!dplyr::all_equal(colnames(df_train), colnames(df_test)))
    stop("Columns of train and test set must be identical.")

  # Check column categories as well as
  # that all columns listed in the named list are in the df
  colnames = df_train %>% names
  for (type in column_list){
    for (column in type){
      if(!is.element(column, colnames))
        stop("Columns in named list must be in dataframe")
    }
  }

  # Check that numerical imputation method is one of the two options
  if (num_imp != "mean" && num_imp != "median")
    stop("numerical imputation method can only be mean or median")

  # Check categorical imputation method is one of the two options
  if (cat_imp != "mode")
    stop("categorical imputation method can only be mode")

  # Imputation methods for numerical columns
  for (column in column_list$"numeric"){
    if (num_imp == "mean"){
      train_col_mean <- df_train %>% dplyr::select(column) %>% dplyr::pull() %>% mean(na.rm = TRUE)
      # impute training mean to train column
      df_train <- df_train %>%
        dplyr::mutate(!!column := ifelse(is.na(!!rlang::sym(column)),
                                         train_col_mean,
                                         !!rlang::sym(column)))
      # impute _training mean_ to test column
      df_test <- df_test %>%
        dplyr::mutate(!!column := ifelse(is.na(!!rlang::sym(column)),
                                         train_col_mean,
                                         !!rlang::sym(column)))
    }

    if (num_imp == "median"){
      train_col_med <- df_train %>% dplyr::select(column) %>% dplyr::pull() %>% median(na.rm = TRUE)
      # impute training median to train column
      df_train <- df_train %>%
        dplyr::mutate(!!column := ifelse(is.na(!!rlang::sym(column)),
                                         train_col_med,
                                         !!rlang::sym(column)))
      # impute _training median_ to test column
      df_test <- df_test %>%
        dplyr::mutate(!!column := ifelse(is.na(!!rlang::sym(column)),
                                         train_col_med,
                                         !!rlang::sym(column)))
    }
  }

  # Imputation methods for categorical columns
  for (column in column_list$"categorical"){
    train_col_mode <- df_train %>% dplyr::select(column) %>% dplyr::pull() %>% getmode()
    # impute training mode to train column
    df_train <- df_train %>%
      dplyr::mutate(!!column := ifelse(is.na(!!rlang::sym(column)),
                                       train_col_mode,
                                       !!rlang::sym(column)))
    # impute _training mode_ to test column
    df_test <- df_test %>%
      dplyr::mutate(!!column := ifelse(is.na(!!rlang::sym(column)),
                                       train_col_mode,
                                       !!rlang::sym(column)))
  }
  list("x_train" = x_train,"x_test" = x_test)
}
