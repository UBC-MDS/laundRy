
<!-- README.md is generated from README.Rmd. Please edit that file -->

# laundRy

<!-- badges: start -->
[![codecov](https://codecov.io/gh/UBC-MDS/pylaundry/branch/master/graph/badge.svg)](https://codecov.io/gh/UBC-MDS/pylaundry)

![R-CMD-check](https://github.com/UBC-MDS/laundRy/workflows/R-CMD-check/badge.svg?branch=master)
<!-- badges: end -->

The `laundRy` package performs many standard preprocessing techniques
for Tidyverse tibbles, before use in statistical analysis and machine
learning. The package functionality includes categorizing column types,
handling missing data and imputation, transforming/standardizing columns
and feature selection. The `laundRy` package aims to remove much of the
grunt work in the typical data science workflow, allowing the analyst
maximum time and energy to devote to modelling\!<br><br>

View the full documentation and a [**vignette**](https://ubc-mds.github.io/laundRy/articles/my-vignette.html) at the [laundRy home page](https://ubc-mds.github.io/laundRy/index.html).

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

  - `column_transformer`: This function takes in a training feature dataframe, a testing feature dataframe, and a list of column types (like the output of `categorical`) and applies pre-processing techniques to each column based on type. Categorical columns
  will be transformed with a One Hot Encoding (based on the training dataframe) and numerical columns will be scaled (based on the training dataframe).

  - `feature_selection`: This function takes in a training dataframe a target vector, a target task (Regression or Classification), and a maximum number of features to select. The
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


