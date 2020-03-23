#' Helper function to find mode of a column
#' @param v a column
#' @NoRd
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
#' @param column_list named list of columns with two character vectors, must be named
#' 'numeric' and 'categorical'
#' @param num_imp method for numerical imputation, options are "mean and" median
#' @param cat_imp method for categorical imputation, only option is "mode"
#'
#' @return named list, with two vectors: "x_train", the training set with
#' missing values filled, and "x_test", the test set with missing values filled
#' @importFrom magrittr %>%
#' @importFrom rlang :=
#' @examples
#' x_tr <- data.frame('x' = c(2.5, 3.3, NA), 'y' = c(1, NA, 1))
#' x_test <- data.frame('x' = c(NA), 'y' = c(NA))
#' fill_missing(x_tr, x_test, list("numeric" = c('x'),
#'  "categorical" = c('y')), 'mean', 'mode')
#'
#' @export
fill_missing <- function(x_train, x_test, column_list, num_imp, cat_imp)
{
  # Check input types  are as specified
  if (!is.data.frame(x_train))
    stop("Training set must be a dataframe.")
  if (!is.data.frame(x_test))
    stop("Test set must be a dataframe.")
  if (!is.list(column_list))
    stop("num_list must be a named list of columns.")
  if (!is.character(num_imp))
    stop("num_imp method must be a string.")
  if (!is.character(cat_imp))
    stop("cat_imp method must be a string.")

  # Check train set and test set columns are the same
  if (!isTRUE(dplyr::all_equal(colnames(x_train), colnames(x_test))))
    stop("Columns of train and test set must be identical.")

  # Check column categories as well as
  # that all columns listed in the named list are in the df
  colnames = x_train %>% names
  for (type in column_list){
    for (column in type){
      if(!is.element(column, colnames))
        stop("Columns in named list must be in dataframe")
    }
  }

  # Check that all columns have numeric data
  if (!dim(x_train)[2]==dim(dplyr::select_if(x_train, is.numeric))[2])
      stop("Columns must have numeric data, encode categorical variables as integers")

  # Check that numerical imputation method is one of the two options
  if (num_imp != "mean" && num_imp != "median")
    stop("numerical imputation method can only be mean or median")

  # Check categorical imputation method is one of the two options
  if (cat_imp != "mode")
    stop("categorical imputation method can only be mode")

  # Imputation methods for numerical columns
  for (column in column_list$"numeric"){
    if (num_imp == "mean"){
      train_col_mean <- x_train %>% dplyr::select(column) %>%
        dplyr::pull() %>% mean(na.rm = TRUE)
      # impute training mean to train column
      x_train <- x_train %>%
        dplyr::mutate(!!column := ifelse(is.na(!!rlang::sym(column)),
                                         train_col_mean,
                                         !!rlang::sym(column)))
      # impute _training mean_ to test column
      x_test <- x_test %>%
        dplyr::mutate(!!column := ifelse(is.na(!!rlang::sym(column)),
                                         train_col_mean,
                                         !!rlang::sym(column)))
    }

    if (num_imp == "median"){
      train_col_med <- x_train %>% dplyr::select(column) %>%
        dplyr::pull() %>%  stats::median(na.rm = TRUE)
      # impute training median to train column
      x_train <- x_train %>%
        dplyr::mutate(!!column := ifelse(is.na(!!rlang::sym(column)),
                                         train_col_med,
                                         !!rlang::sym(column)))
      # impute _training median_ to test column
      x_test <- x_test %>%
        dplyr::mutate(!!column := ifelse(is.na(!!rlang::sym(column)),
                                         train_col_med,
                                         !!rlang::sym(column)))
    }
  }

  # Imputation methods for categorical columns
  for (column in column_list$"categorical"){
    train_col_mode <- x_train %>% dplyr::select(column) %>%
                      dplyr::pull() %>% getmode()
    # impute training mode to train column
    x_train <- x_train %>%
      dplyr::mutate(!!column := ifelse(is.na(!!rlang::sym(column)),
                                       train_col_mode,
                                       !!rlang::sym(column)))
    # impute _training mode_ to test column
    x_test <- x_test %>%
      dplyr::mutate(!!column := ifelse(is.na(!!rlang::sym(column)),
                                       train_col_mode,
                                       !!rlang::sym(column)))
  }
  list("x_train" = x_train,"x_test" = x_test)
}
