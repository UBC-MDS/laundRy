
generate_data_regression <- function(){
  set.seed(1234)
  X <- data.frame(runif(10),runif(10),runif(10))
  colnames(X) <- c("x1","x2","x3")
  y <- 2* X$x1

  d <- list(X,y)
  return (d)

}


generate_data_classification <- function(){
  set.seed(1234)
  X <- data.frame(runif(10),runif(10),runif(10))
  colnames(X) <- c("x1","x2","x3")
  y <- ifelse(X$x2>=0.7, 1, 0)


  return (list(X,factor(y)))

}


generate_data_wrong <- function(){

  X <- c(1,2,3)
  y <- ifelse(X>=0.7, 1, 0)


  return (list(X,y))

}

generate_data_wrong_one <- function(){

  X <- data.frame(runif(10),runif(10),runif(10))
  colnames(X) <- c("x1","x2","x3")
  y <- ifelse(X$x2>=0.7, 1, 0)


  return (list(X,y))

}


