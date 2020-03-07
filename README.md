
<!-- README.md is generated from README.Rmd. Please edit that file -->

# laundRy

<!-- badges: start -->

<!-- badges: end -->

The `laundRy` package performs many standard preprocessing techniques
for Tidyverse tibbles, before use in statistical analysis and machine
learning. The package functionality includes categorizing column types,
handling missing data and imputation, transforming/standardizing columns
and feature selection. The `laundRy` package aims to remove much of the
grunt work in the typical data science workflow, allowing the analyst
maximum time and energy to devote to modelling\!

## Installation

Install the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("UBC-MDS/laundRy")
```

### Features

  - `categorize`: This function will take in a dataframe and output a
    list of vectors with names 'numeric' and 'categorical', each containing the column names associated with the name type.
      - Categorical criteria: All columns of type 'factor' or any columns with fewer than a specified number of unique values are considered categorical. A column denoted 'factor' overrides the specification for number of unique values.
      - Numeric criteria: All numeric columns that have greater than the specified number of unique values are considered numeric.

  - `fill_missing`: This function takes in a training feature dataframe, a testing feature dataframe, and a list of column types (like the output of `categorical`) and imputes missing values based on column type. Missing values in numeric columns may be filled by the mean or median of the training feature dataframe, and categorical columns are filled by the mode of the feature dataframe.

  - `transform_columns`: This function takes in a training feature dataframe, a testing feature dataframe, and a list of column types (like the output of `categorical`) and applies pre-processing techniques to each column based on type. Categorical columns
  will be transformed with a One Hot Encoding (based on the training dataframe) and numerical columns will be scaled (based on the training dataframe).

  - `feature_selector`: This function takes in a training dataframe a target vector, a target task (Regression or Classification), and a maximum number of features to select. The
    function returns the most important features to predict the target vector for the target task.

## Dependencies

  - caret
  - dplyr
  - rlang
  - stats

## LaundRy in the R ecosystem

  - [mice](https://cran.r-project.org/web/packages/mice/mice.pdf) offers
    similar functionality for the fill\_missing function, but is not
    integrated with a column categorizer.

  - The main feature selection and preprocessing package in R is
    [caret](https://cran.r-project.org/web/packages/caret/caret.pdf),
    which carries out similar functionality to our `feature_selector`
    function though laundRy makes the workflow more efficient and adds
    imputation.

  - As far as we know, there are no similar packages for Categorizing
    Columns and providing a list of the categorized columns. `laundRy`
    is the first package we are aware of to abstract away the full
    dataframe pre-processing workflow with a unified and simple API.


## Usage and examples

#### categorize()

```R
library(laundRy)

df <- data.frame(a = c(1, 2, 3, 4, 5, 1, 2, 3, 4, 5, 0),
                       b = c(1.2, 3.4, 3.0, 4.9, 5.3, 6.1, 8.8, 9.4, 10.4, 1.3, 0.0),
                       c = c('A','B','C','D','E','F','G','H','I','J','B'))

# categorize with default max_cat (10)
categorize(df)
>>> $numeric
    [1] "b"

    $categorical
    [1] "c" "a"


# categorize with max_cat = 5 (column c is neither numeric or categorical 
# under this restriction)
categorize(df, max_cat = 5)
>>> $numeric
    [1] "a" "b"

    $categorical
    [1] "c"

# Explicitly setting dtype to override max_cat settings for a column
df$b = as.factor(df$b)
categorize(df)
>>> $numeric
    [1] character(0)

    $categorical
    [1] "b" "c" "a"
```

#### fill_missing()

```R
library(laundRy)

df_train <- data.frame(a = c(, 2, NA, 4, 5, 1, 2, 3, 4, 5),
                       b = (1.2, 3.4, 3.0, 4.9, 5.3, 6.1, 8.8, 9.4, NA, 1.2),
                       c = c('A','B','C','D','E','F','B','H','I',NA))

df_test <- data.frame(a = c(6, NA, 0),
                       b = c(0.5, 9.2, NA),
                       c = c(NA, 'B', 'D'))

fill_missing(df_train, df_test, list(numeric = c('a', 'b'), categorical = c('c')))
>>> $x_train
    [1]      a    b    c
        0  1.0  1.2    A
        1  2.0  3.4    B
        2  3.0  3.0    C
        3  4.0  4.9    D
        4  5.0  5.3    E
        5  1.0  6.1    F
        6  2.0  8.8    B
        7  3.0  9.4    H
        8  4.0  4.8    I
        9  5.0  1.2    B

    $x_test
    [1]      a    b    c
        0  6.0  0.5    B
        1  3.0  9.2    B
        2  0.0  4.8    C
    

fill_missing(df_train, df_test, list(numeric = c('a', 'b'), categorical = c('c'))) 
             num_imp = 'median')
>>> $x_train
    [1]      a    b    c
        0  1.0  1.2    A
        1  2.0  3.4    B
        2  3.0  3.0    C
        3  4.0  4.9    D
        4  5.0  5.3    E
        5  1.0  6.1    F
        6  2.0  8.8    B
        7  3.0  9.4    H
        8  4.0  4.9    I
        9  5.0  1.2    B

    $x_test
    [1]      a    b    c
        0  6.0  0.5    B
        1  3.0  9.2    B
        2  0.0  4.9    C
```

#### transform_columns()

```R
library(laundRy)

df_train <- data.frame(a = c(1, 2, 3),
                       b = c(1.2, 3.4, 3.0),
                       c = c('A','B','C'))

df_test <- data.frame(a = c(6, 2),
                       b = c(0.5, 9.2),
                       c = ('B', 'B'))

transform_columns(df_train, df_test, list(numeric = c('a', 'b'), categorical = c('c')))
>>> $x_train
    [1]       a      b    A  B  C
        0  -1.2  -1.39    1  0  0
        1   0.0   0.91    0  1  0
        2   1.2   0.49    0  0  1

    $x_test
    [1]       a      b    A  B  C
         0  4.9   -2.1    0  1  0
         1  1.2   6.96    0  1  0
```

#### select_features()

```R
library(laundRy)

df <- data.frame(a = c(1, 2, 3),
                       b = c(1.2, 2.2, 3.2),
                       c = c(10.4, 0.02, 5.4))

target = c(1, 2, 3)


select_features(df, target, mode = 'regression', n_features = 2)
>>>  "a" "b"
```

#### Proposed workflow

```R
library(laundRy)

X_train <- data.frame(a = c(, 2, NA, 4, 5, 1, 2, 3, 4, 5),
                       b = (1.2, 3.4, 3.0, 4.9, 5.3, 6.1, 8.8, 9.4, NA, 1.2),
                       c = c('A','B','C','D','E','F','B','H','I',NA))

X_test <- data.frame(a = c(6, NA, 0),
                       b = c(0.5, 9.2, NA),
                       c = c(NA, 'B', 'D'))

y_train <- c(1, 2, 3, 4, 5, 6, 2, 3, 4, 5)

# Categorize columns
col_list <- categorize(X_train)

# Fill missing values
filled_list <- fill_missing(X_train, X_test, col_list)
X_train_filled <- filled_list$x_train
X_test_filled <- filled_list$x_test

# Transform data
transformed_list <- transform_columns(X_train_filled, X_test_filled, col_list)
X_train_transformed <-transformed_list$x_train
X_test_transformed <- transformed_list$x_test

# Select features
cols <- select_features(X_train_transformed, y_train, mode = 'regression')

X_train <- X_train_transformed[cols]
X_test <- X_test_transformed[cols]

```

