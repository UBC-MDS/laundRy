context("categorize")

# Generate test data
input <- data.frame(cat1 = c(1,2,3,1,4,3,3,2,1,1,
                           2,3,2,3,1,3,2,4,1,1,
                           3,2,4,2,2,2,3,1,2,3),
                    cat2 = c('A','B','C','A','B','C',
                             'A','B','C','A','B','C',
                             'A','B','C','A','B','C',
                             'A','B','C','A','B','C',
                             'A','B','C','A','B','C'),
                    num1 = runif(30, min = 0.0, 5.0),
                    num2 = floor(runif(30, min = -10, max = 10)),
                    text1 = sprintf("text value %s", seq(1:30)),
                    num3 = runif(30, min = -100, max = 100),
                    cat3 = rep(c("Mon", "Tue", "Wed", "Thu", "Fri"),
                               times = 6),
                    text2 = sprintf("text instance #[%s]", seq(1:30)),
                    stringsAsFactors = FALSE
                    )

input_vec <- data.frame(cat1 = c(1,2,3,1,4,3,3,2,1,1,
                                 2,3,2,3,1,3,2,4,1,1,
                                 3,2,4,2,2,2,3,1,2,3),
                        cat2 = c('A','B','C','A','B','C',
                                 'A','B','C','A','B','C',
                                 'A','B','C','A','B','C',
                                 'A','B','C','A','B','C',
                                 'A','B','C','A','B','C'),
                        num1 = runif(30, min = 0.0, 5.0),
                        num2 = floor(runif(30, min = -10, max = 10)),
                        text1 = sprintf("text value %s", seq(1:30)),
                        num3 = runif(30, min = -100, max = 100),
                        cat3 = rep(c("Mon", "Tue", "Wed", "Thu", "Fri"),
                                   times = 6),
                        text2 = sprintf("text instance #[%s]", seq(1:30)),
                        stringsAsFactors = TRUE
                        )

input_empty <- data.frame()
date <- c('1-2-2019', '1-3-2019','1-4-2019','1-5-2019','1-6-2019','1-7-2019')
input_none <- data.frame(t1 = c('hi', 'there', 'my', 'name', 'is', 'bob'),
                         stringsAsFactors = FALSE)
input_none$date < as.Date(date, format = "%m-%d-%y")


test_that("Output type of categorize() is correct", {
  output <- categorize(input)
  expect_equal(typeof(output), 'list')
  expect_equal(typeof(output$numeric), 'character')
  expect_equal(typeof(output$categorical), 'character')
})

test_that("Output of categorical list is correct", {
  output = categorize(input)
  expect_true(all(c(output$categorical %in% list('cat1', 'cat2', 'cat3'),
                    list('cat1', 'cat2', 'cat3') %in% output$categorical)))
})

test_that("Output of numerical list is correct", {
  output <- categorize(input)
  expect_true(all(c(output$numeric %in% list('num1', 'num2', 'num3'),
                    list('num1', 'num2', 'num3') %in% output$numeric)))
})

test_that("All factors should be classified as categorical", {
  output <- categorize(input_vec)
  expect_true(all(c(output$categorical %in% list('cat1',
                                                 'cat2',
                                                 'cat3',
                                                 'text1',
                                                 'text2'),
                    list('cat1',
                         'cat2',
                         'cat3',
                         'text1',
                         'text2') %in% output$categorical)))
})

test_that("max_cat influences categorization", {
  output <- categorize(input, max_cat = 3)
  expect_true(all(c(output$categorical %in% list('cat2'),
                    list('cat2') %in% output$categorical)))
  expect_true(all(c(output$numeric %in% list('num1', 'num2','num3','cat1'),
                    list('num1', 'num2','num3','cat1') %in% output$numeric)))
})

test_that("Invalid inputs throw errors", {
  expect_error(categorize('hello!'),
               "Error: Input for df must be of class data.frame")
  expect_error(categorize(c(1,2,3,2,1,2,3)),
               "Error: Input for df must be of class data.frame")
  expect_error(categorize(input, -10),
               "Error: max_cat must be a positive integer")
  expect_error(categorize(input, 1.3),
               "Error: max_cat must be a positive integer")
})

test_that("Empty list should return for empty / inapplicable input",
          {
  output_empty <- categorize(input_empty, max_cat = 2)
  output_none <- categorize(input_none, max_cat = 2)
  expect_equal(output_empty, list(numeric=character(0),
                                  categorical=character(0)))
  expect_equal(output_none, list(numeric=character(0),
                                 categorical=character(0)))
})

