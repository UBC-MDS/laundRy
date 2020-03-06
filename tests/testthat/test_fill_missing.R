context("fill_missing")
# Generate data for test cases
df_tr <- data.frame(x = c(4.0, 3.0, NA, 2.0), y = c(2, 2, NA, 1))
df_te <- data.frame(x = c(1.0, 1.0, NA), y = c(1, NA, 1))
list_input <- list("numeric" = c('x'), "categorical" = c('y'))

test_that("Output length of fill_missing() is correct", {
  output <- fill_missing(df_tr, df_te, list_input, "mean", "mode")
  expect_equal(length(output), 2)
})

test_that("Output objects of fill_missing() are dataframes", {
  output <- fill_missing(df_tr, df_te, list_input, "mean", "mode")
  expect_equal(class(output[1]), 'list')
  expect_equal(class(output[2]), 'list')
})

test_that("Training set mean imputation accuate", {
  output <- fill_missing(df_tr, df_te, list_input, "mean", "mode")
  train_out <- output$x_train
  expect_equal(train_out$x[3], 3)
})

test_that("Test set mean imputation accuate", {
  output <- fill_missing(df_tr, df_te, list_input, "mean", "mode")
  test_out <- output$x_test
  expect_equal(test_out$x[3], 3)
})

test_that("Training set median imputation accuate", {
  output <- fill_missing(df_tr, df_te, list_input, "median", "mode")
  train_out <- output$x_train
  expect_equal(train_out$x[3], 3)
})

test_that("Test set median imputation accuate", {
  output <- fill_missing(df_tr, df_te, list_input, "median", "mode")
  test_out <- output$x_test
  expect_equal(test_out$x[3], 3)
})

test_that("Training set categorical imputation accuate", {
  output <- fill_missing(df_tr, df_te, list_input, "median", "mode")
  train_out <- output$x_train
  expect_equal(train_out$y[3], 2)
  })

test_that("Test set categorical imputation accuate", {
  output <- fill_missing(df_tr, df_te, list_input, "median", "mode")
  test_out <- output$x_test
  expect_equal(test_out$y[2], 2)
})

test_that("Invalid input gives error", {
  expect_error(fill_missing(c(4,3,3), df_te, list_input, "median", "mode"), "Training set must be a dataframe.")
  expect_error(fill_missing(df_tr,c(4,3,3), list_input, "median", "mode"), "Test set must be a dataframe.")
  expect_error(fill_missing(df_tr, df_te, c(4,3,3), "median", "mode"), "num_list must be a named list of columns.")
  expect_error(fill_missing(df_tr, df_te, list_input, "mode", "mode"), "numerical imputation method can only be mean or median")
  expect_error(fill_missing(df_tr, df_te, list_input, "median", "median"), "categorical imputation method can only be mode")
})
