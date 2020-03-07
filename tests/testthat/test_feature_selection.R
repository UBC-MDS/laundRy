library(testthat)
library(digest)
library(dplyr)
source("helper_function_selection.R")


test_1 <- function(){
  test_that("Input data for regression is data frame", {
    expect_that(generate_data_regression()[[1]], is_a("data.frame"))

  })
  test_that("Input data for classification is data frame", {
    expect_that(generate_data_classification()[[1]], is_a("data.frame"))

  })

}

test_1()

test_2 <- function(){
  test_that("Test result for regression", {
    X = generate_data_regression()[[1]]
    y = generate_data_regression()[[2]]

    expect_true(feature_selection(X,y,"regression",1) == "x1")

  })


}

test_2()

test_3 <- function(){
  test_that("Test result for classification", {
    X = generate_data_classification()[[1]]
    y = generate_data_classification()[[2]]
    expect_true(feature_selection(X,y,"classification",1) == "x2")

  })

}

test_3()

test_4 <- function(){
  test_that("Test result for Data Frame check", {
    X = generate_data_wrong()[[1]]
    y = generate_data_wrong()[[2]]
    expect_error(feature_selection(X,y,"classification",1) == "Input Data is not Data Frame")

  })

}

test_4()

test_5 <- function(){
  test_that("Test result for Data Frame check", {
    X = generate_data_wrong_one()[[1]]
    y = generate_data_wrong_one()[[2]]
    expect_error(feature_selection(X,y,"classification",1) == "Input Data is not Data Frame")

  })

}

test_5()




