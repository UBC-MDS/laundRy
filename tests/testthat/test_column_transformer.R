# This script tests the column_transformer function


# test dataframes for testing
employee_name <- c("A", "B", "C", "D", "E", "F", "G", "H", "I", "J")
manager <- c("M1", "M2", "M3", "M1", "M2", "M3", "M1", "M2", "M3", "M1")
age <- c(23, 56,34,40, 34,56, 45, 65, 54,43)
sex <- c('M', 'F','M', 'F','M', 'F','M', 'F', 'M', 'F' )
daily_wage<- c(100,200, 100, 60, 80, 140, 320,60, 90, 90)
x_train <- data.frame(employee_name, manager, age, sex, daily_wage)


employee_name <- c("K", "L", "M", "N", "O", "P")
manager <- c("M1", "M2", "M3", "M1", "M2", "M3")
age <- c(23, 56,34,40, 34,56)
sex <- c('M', 'F','M', 'F','M', 'F')
daily_wage<- c( 80, 140, 320,60, 90, 90)
x_test <- data.frame(employee_name, manager, age, sex, daily_wage)

col_names <- list(categorical= c("manager", "sex"), numeric = c("age", "daily_wage" ))


# testing bad inputs for the arguments from user
test_that("Test suite for testing bad inputs from user", {
  expect_error(column_transformer(column_transformer(list(x_train),x_test, col_names )), "Input objects x_train and x_test must be of class dataframe")
  expect_error(column_transformer(column_transformer(x_train,list(x_test), col_names )), "Input objects x_train and x_test must be of class dataframe")
  expect_error(column_transformer(column_transformer(x_train,x_test, data.frame(col_names) )), "Parameter col_names must be a  list of length 2 specifying named vectors specifying numeric and categoric columns")
  #expect_error(column_transformer(column_transformer(x_train,x_test, list(col_names) )), "Parameter col_names must be a  list of length 2 specifying named vectors specifying numeric and categoric columns")
  expect_error(column_transformer(column_transformer(x_train,x_test, col_names, num_trans = "randominput")), "num_trans parameter can only be 'standard_scaling' or 'minmax_scaling'")
  expect_error(column_transformer(column_transformer(x_train,x_test, col_names, cat_trans = "randominput" )), "cat_trans parameter can only take 'onehot_encoding' or 'label_encoding' values")


})


