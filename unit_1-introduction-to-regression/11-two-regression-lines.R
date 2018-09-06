# --------------------------------------------------------------------------------
#
# Two Regression Lines
#
# --------------------------------------------------------------------------------

# We computed a regression line to predict the son's height from the father's
# height. We used these calculations-- here's the code--

mu_x <- mean(galton_heights$father)
mu_y <- mean(galton_heights$son)
s_x <- sd(galton_heights$father)
s_y <- sd(galton_heights$son)
r < cor(galton_heights$father, galton_heights$son)
m <- r * s_y / s_x
b <- mu_y - m * mu_x

# to get the slope and the intercept. This gives us the function that the
# conditional expectation of y given x is 35.7 plus 0.5 times x.

# E(Y|X = x) = 35.7 + 0.5x

# So, what if we wanted to predict the father's height based on the son's? It is
# important to know that this is not determined by computing the inverse
# function of what we just saw, which would be this equation here.

# x = {E(Y|x = X) - B} / 0.5

# We need to compute the expected value of x given y. This gives us another
# regression function altogether, with slope and intercept computed like this.

# E(X|Y = y)
m <- r * s_x / s_y
b <- mu_x - m*mu_y

# So now we get that the expected value of x given y, or the expected value of
# the father's height given the son's height, is equal to 34 plus 0.5 y, a
# different regression line.

# So in summary, it's important to remember that the regression line comes from
# computing expectations, and these give you two different lines, depending on
# if you compute the expectation of y given x or x given y.
