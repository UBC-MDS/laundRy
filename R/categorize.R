#' Categorize dataframe columns
#'
#' Denote each dataframe category as numeric, categorical, or text
#' and return a list of lists labeled 'numeric',
#' 'categorical' and 'text' containing column names
#' that fall into each category. A 'categorical' column is any
#' column of type 'factor', or any column with fewer than
#' max_cat unique values. A 'numeric' column is any column
#' of type 'numeric' that is not considered 'categorical'
#' under the specified criteria.
#'
#' @param df a data.frame
#' @param max_cat int, the maximum number of unique values that
#' define a categorical column
#'
#' @return list with char vectors named 'numeric' and 'categorical',
#' containing column names of each type
#' @export
#' @examples
#' categorize(data.frame(a = c(1.2, 2.3, 3.4), b = c('a', 'b', 'c')))

categorize <- function(df, max_cat = 10) {
  # Check that inputs are valid
  (if(class(max_cat) != 'numeric')
    stop("Error: max_cat must be a positive integer"))
  (if(max_cat%%1 != 0 | max_cat < 1)
    stop("Error: max_cat must be a positive integer"))
  (if(class(df) != 'data.frame')
    stop("Error: Input for df must be of class data.frame"))


  # Track all columns and their types
  col_types <- sapply(df, class)

  # Mark categorical columns
  # Columns of type 'factor' are categorized as categorical
  categorical <- c(names(col_types[col_types == 'factor']))
  # Add columns to list with fewer than or equal to max_cat unique values
  unique_vals <- sapply(df, function(x) length(unique(x)))
  categorical <- (append(categorical,
                         names(unique_vals[unique_vals <= max_cat])))

  # Mark numeric columns
  # All columns of type numeric that aren't already marked categorical
  numeric <- (names(col_types[col_types == 'numeric' &
                                !(names(col_types) %in% categorical)]))

  # Return list of vectors with duplicates removed
  return(list(numeric=unique(numeric), categorical=unique(categorical)))
}





