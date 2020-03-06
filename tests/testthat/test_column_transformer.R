# This script tests the column_transformer function

source("helper_function_column_transformer.R")


# testing bad inputs for the arguments from user
test_that("Test suite for testing bad inputs from user", {
  expect_error(column_transformer(list(x_train),x_test, column_list ), "Input objects x_train and x_test must be of class dataframe")
  expect_error(column_transformer(x_train,list(x_test), column_list ), "Input objects x_train and x_test must be of class dataframe")
  expect_error(column_transformer(x_train,x_test, data.frame(column_list) ), "Parameter column_list must be a  list of length 2 specifying named vectors specifying numeric and categoric columns")
  expect_error(column_transformer(x_train,x_test, column_list, num_trans = "randominput"), "num_trans parameter can only be 'standard_scaling' or 'minmax_scaling'")
  expect_error(column_transformer(x_train,x_test, column_list, cat_trans = "randominput" ), "cat_trans parameter can only take 'onehot_encoding' or 'label_encoding' values")
  expect_error(column_transformer(x_train, column_list,x_test = x_test[names(x_test)[1]] ), "Columns of train and test set must be identical")
  expect_error(column_transformer(x_test = x_test, column_list,x_train = x_train[names(x_train)[1]] ), "Columns of train and test set must be identical")
  expect_error(column_transformer(x_train,x_test, column_list= list(categorical= c("manager", "random"), numeric = c("age", "daily_wage" )) ), "Column names in the named list must be present in dataframe")


})

# test standard and minmax scaling


test_that("X_train's numeric columns after standard scaling must have mean close to 0", {
  output_list <- column_transformer(x_train, x_test, column_list)
  output_xtrain <- output_list$x_train

  expect_lt(mean(output_xtrain[[column_list$numeric[1]]]), 0.001)
})

test_that("X_train's numeric columns after minmax scaling must have maximum value of 1", {
  output_list <- column_transformer(x_train, x_test, column_list, num_trans = "minmax_scaling")
  output_xtrain <- output_list$x_train

  expect_lt(max(output_xtrain[[column_list$numeric[1]]]), 1.1)
})

test_that("X_train's numeric columns after minmax scaling must have minimum value of 0", {
  output_list <- column_transformer(x_train, x_test, column_list, num_trans = "minmax_scaling")
  output_xtrain <- output_list$x_train

  expect_gte(min(output_xtrain[[column_list$numeric[1]]]), 0)
})


# test label encoding


test_that("Number of columns in transformed x_train and x_test must be equal to input x_train  and x_test respectively after label encoding", {
  output_list <- column_transformer(x_train, x_test, column_list, num_trans = "minmax_scaling", cat_trans = "label_encoding")
  output_xtrain <- output_list$x_train
  output_xtest <- output_list$x_test

  expect_equal(length(names(output_xtrain)), length(names(x_train)))
  expect_equal(length(names(output_xtest)), length(names(x_test)))
})


# test onehot encoding


test_that("Number of columns in transformed x_train and x_test must be greater than or equal to input x_train  and x_test respectively after onehot encoding", {
  output_list <- column_transformer(x_train, x_test, column_list )
  output_xtrain <- output_list$x_train
  output_xtest <- output_list$x_test

  expect_gte(length(names(output_xtrain)), length(names(x_train)))
  expect_gte(length(names(output_xtest)), length(names(x_test)))
})


# testing for correct outputs
test_that("Output  must be a list of length 2", {
  output_list <- column_transformer(x_train, x_test, column_list )
  expect_equal(length(output_list),2)
})


test_that("Output list elements must be dataframes", {

  output_list <- column_transformer(x_train, x_test, column_list )
  expect_equal(class(output_list[[1]]),"data.frame")
  expect_equal(class(output_list[[2]]),"data.frame")
})

test_that("Transformed x_train/x_test must have same number of rows as input x_train/x_test", {

  output_list <- column_transformer(x_train, x_test, column_list )
  expect_equal(dim(output_list[[1]])[1],dim(x_train)[1])
  expect_equal(dim(output_list[[2]])[1],dim(x_test)[1])
})





