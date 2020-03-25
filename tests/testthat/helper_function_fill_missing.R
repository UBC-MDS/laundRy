# Generate data for test cases
df_tr <- data.frame(x = c(4.0, 3.0, NA, 2.0), y = c(2, 2, NA, 1))
df_te <- data.frame(x = c(1.0, 1.0, NA), y = c(1, NA, 1))
list_input <- list("numeric" = c('x'), "categorical" = c('y'))

# Test cases with categorical columns as characters
df_tr_c <- data.frame(x = c(4.0, 3.0, NA, 2.0, 3.0),
                      y = c("a", "a", NA, "b", "c"))
df_te_c <- data.frame(x = c(1.0, 1.0, NA), y = c("a", NA, "b"))
list_input <- list("numeric" = c('x'), "categorical" = c('y'))

# Generate bad data for error test cases
df_tr_2 <- data.frame(x = c(4.0, 3.0, NA, 2.0), y = c(2, 2, NA, 1))
df_te_2 <- data.frame(x = c(1.0, 1.0, NA), z = c(1, NA, 1))
list_input_2 <- list("numeric" = c('x'), "categorical" = c('z'))

df_tr_3 <- data.frame(x = c(4.0, 3.0, NA, 2.0), y = c(2, "a", NA, 1))
