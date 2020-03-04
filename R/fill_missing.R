library(dplyr)
library(tidyr)
#' Handles missing values in a dataframe
#'
#' Replace missing values in dataframe columns by the specified methods. 
#' Separate methods can be applied for categorical column imputation and 
#' numerical column imputation. 
#' 
#' @param df_train training set dataframe to be transformed
#' @param df_test test set dataframe to be transformed
#' @param column_list named list of columns with two sub vectors (categorical and numeric)
#' @param num_imp method for numerical imputation
#' @param cat_imp method for categorical imputation
#'
#' @return df, with missing values replaced by the specified method
#'
#' @examples
#' fill_missing(df, list('weight'), list('education'), 'mean', 'mode')
#'
#' @export
fill_missing <- function(df_train, df_test, column_list, num_imp, cat_imp)
  {
    # Check input types  are as specified
    if (!tibble::is_tibble(df_train)) 
        stop("Training set should be a tidyverse tibble")
    if (!tibble::is_tibble(df_test))
        stop("Test set should be a tidyverse tibble") 
    if (!is.list(column_list))
        stop("num_list should be a list of columns")
    if (!is.character(num_imp))
        stop("num_imp method should be a string")     
    if (!is.character(cat_imp))
        stop("cat_imp method should be a string") 
    # Check train set and test set columns are the same
    if (!all_equal(colnames(df_train), colnames(df_test)))
        stop("Columns of train and test set must be identical")
    
    # Check all the columns listed in the named list are in the df
    colnames = df_train %>% names
    for (type in column_list){
        for (column in type){
            if(!is.element(column, colnames))
            stop("Columns in named list must be in dataframe")
        }    
    }
    
    # Check that numerical imputation method is one of the two options 
    if (num_imp != "mean" | num_imp == "median")
        stop("numerical imputation method can only be mean or median")
    
    # Check categorical imputation method is one of the two options 
    if (cat_imp != "mode")
        stop("categorical imputation method can only be mode")
    
    # Imputation methods for numerical columns
    for (type in column_list){
        for (column in type){
            if (num_imp == "mean"){
                col_imp = train_df$column %>% mean()
            }
        }    
    }
        # get column mean or median
        if num_trans == "mean":
            col_imp = train_df[column].mean()
        if num_trans == "median":
            col_imp = train_df[column].median()
            
        # Get index of NaN values in train columns
        # Todo: If these are empty (no Nan) is that fine
        index_train = train_df[column].index[train_df[column].apply(np.isnan)]
        index_test = test_df[column].index[test_df[column].apply(np.isnan)]
        
        # Use impute value on train set
        train_df.loc[index_train,column] = col_imp
        # Use same impute value on test set
        test_df.loc[index_test,column] = col_imp
    
    
  }