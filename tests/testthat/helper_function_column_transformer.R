# test dataframes for testing column_transformer

manager <- c("M1", "M2", "M3", "M1", "M2", "M3", "M1", "M2", "M3", "M1")
age <- c(23, 56,34,40, 34,56, 45, 65, 54,43)
sex <- c('M', 'F','M', 'F','M', 'F','M', 'F', 'M', 'F' )
daily_wage<- c(100,200, 100, 60, 80, 140, 320,60, 90, 90)
x_train <- data.frame( manager, age, sex, daily_wage)


manager <- c("M1", "M2", "M3", "M1", "M2", "M3")
age <- c(23, 56,34,40, 34,56)
sex <- c('M', 'F','M', 'F','M', 'F')
daily_wage<- c( 80, 140, 320,60, 90, 90)
x_test <- data.frame( manager, age, sex, daily_wage)

column_list <- list(categorical= c("manager", "sex"), numeric = c("age", "daily_wage" ))
