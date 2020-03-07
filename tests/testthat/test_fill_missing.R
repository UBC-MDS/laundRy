context("fill_missing")
source("helper_function_fill_missing.R")

# This script tests the fill missing function
# Each function's purpose is given in the test_that string
test_that("Output length of fill_missing() is correct", {
  output <- fill_missing(df_tr, df_te, list_input, "mean", "mode")
  expect_equal(length(output), 2)
})

test_that("Output objects of fill_missing() are dataframes", {
  output <- fill_missing(df_tr, df_te, list_input, "mean", "mode")
  expect_equal(class(output[1]), 'list')
  expect_equal(class(output[2]), 'list')
})

test_that("Training set mean imputation accurate", {
  output <- fill_missing(df_tr, df_te, list_input, "mean", "mode")
  train_out <- output$x_train
  expect_equal(train_out$x[3], 3)
})

test_that("Test set mean imputation accurate", {
  output <- fill_missing(df_tr, df_te, list_input, "mean", "mode")
  test_out <- output$x_test
  expect_equal(test_out$x[3], 3)
})

test_that("Training set median imputation accurate", {
  output <- fill_missing(df_tr, df_te, list_input, "median", "mode")
  train_out <- output$x_train
  expect_equal(train_out$x[3], 3)
})

test_that("Test set median imputation accurate", {
  output <- fill_missing(df_tr, df_te, list_input, "median", "mode")
  test_out <- output$x_test
  expect_equal(test_out$x[3], 3)
})

test_that("Training set categorical imputation accurate", {
  output <- fill_missing(df_tr, df_te, list_input, "median", "mode")
  train_out <- output$x_train
  expect_equal(train_out$y[3], 2)
  })

test_that("Test set categorical imputation accurate", {
  output <- fill_missing(df_tr, df_te, list_input, "median", "mode")
  test_out <- output$x_test
  expect_equal(test_out$y[2], 2)
})

test_that("Invalid input gives error", {
  expect_error(fill_missing(c(4,3,3), df_te, list_input, "median", "mode"), "Training set must be a dataframe.")
  expect_error(fill_missing(df_tr,c(4,3,3), list_input, "median", "mode"), "Test set must be a dataframe.")
  expect_error(fill_missing(df_tr, df_te, c(4,3,3), "median", "mode"), "num_list must be a named list of columns.")
  expect_error(fill_missing(df_tr, df_te, list_input, 4, "mode"), "num_imp method must be a string.")
  expect_error(fill_missing(df_tr, df_te, list_input, "median", 4), "cat_imp method must be a string.")
  expect_error(fill_missing(df_tr, df_te, list_input, "mode", "mode"), "numerical imputation method can only be mean or median")
  expect_error(fill_missing(df_tr, df_te, list_input, "median", "median"), "categorical imputation method can only be mode")
  expect_error(fill_missing(df_tr, df_te, list_input_2, "median", "mode"), "Columns in named list must be in dataframe")
  expect_error(fill_missing(df_tr_2, df_te_2, list_input_2, "median", "mode"), "Columns of train and test set must be identical.")
  expect_error(fill_missing(df_tr_3, df_te, list_input, "median", "mode"), "Columns must have numeric data, encode categorical variables as integers")
})
