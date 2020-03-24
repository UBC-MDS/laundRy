# This script tests the integration of all functions in laundRy library

source("helper_integration_test.R")


col_list = categorize(df=my_train, max_cat = 4)
# second function - fill_missing
clean_data = fill_missing(my_train, my_test,
                          col_list,
                          num_imp="mean", cat_imp="mode")
# third function - transform_columns
transformed_data = column_transformer(clean_data$x_train,
                                     clean_data$x_test,
                                     col_list)
# fourth function - feature selection
features_selected = feature_selection(transformed_data$x_train,
                                    y_train, mode = "regression", n_features=2)




test_that("Output at end of all functions should be a factor of length 2", {

  expect_equal(class(features_selected), "factor")
  expect_equal(length(features_selected), 2)
})

test_that("Most important feature selected at end of all functions should be 'cat_column2' ", {
  expect_equal(features_selected[[1]] == "num_column1", TRUE)

})


