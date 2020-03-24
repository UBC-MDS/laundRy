# dataset for testing integration
my_train <- data.frame(
  'cat_column1' = c(1, 1, 1, 2, 2),
  'cat_column2' = c(3, 3, 2, 1, 1),
  'num_column1' = c(1.5, 2.5, 3.5, NA, 4.5),
  'num_column2' = c(0.001, 0, 0.3, NA, -0.8))


my_test = data.frame(
  'cat_column1' = c(1, 1, NA),
  'cat_column2' = c(3, 3, 2),
  'num_column1' = c(1.5, 2.5, 3.5),
  'num_column2' = c(0.001, 0, 0.3))


y_train <- c(3, 5, 7, 6, 9)
