
generate_data_regression <- function(){
  X <- data.frame(runif(10),runif(10),runif(10))
  colnames(X) <- c("x1","x2","x3")
  y <- 2* X$x1

  d <- list(X,y)
  return (d)

}


generate_data_classification <- function(){
  X <- data.frame(runif(10),runif(10),runif(10))
  colnames(X) <- c("x1","x2","x3")
  y <- ifelse(X$x1>=0.7, 1, 0)


  return (list(X,y))

}
