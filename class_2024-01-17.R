# Exercise 1

## Part 1

typeof( c(1, NA+1L, "C") ) # c(double, integer, char) -> char

typeof( c(1L / 0, NA) )    # c(double, logical) -> double

typeof( c(1:3, 5) )        # c(int, double) -> double

typeof( c(3L, NaN+1L) )    # c(int, double) -> double

typeof( c(NA, TRUE) )      # c(logic, logic) -> logical


## Part 2

### Character > Double > Integer > Logical


# Exercise 2

f = function(x) {
  x = as.numeric(x)
  # Check small prime
  if (x > 10 || x < -10) {
    stop("Input too big")
  } else if (x %in% c(2, 3, 5, 7)) {
    cat("Input is prime!\n")
  } else if (x %% 2 == 0) {
    cat("Input is even!\n")
  } else if (x %% 2 == 1) {
    cat("Input is odd!\n")
  }
}

f(1)

f(3)

f(8)

f(-1)

f(-3)

f(11)

f(1:2)

f("0")

f("3")

f("zero")



