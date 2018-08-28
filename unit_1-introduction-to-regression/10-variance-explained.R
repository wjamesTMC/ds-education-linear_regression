# -----------------------------------------------------------
#
# Variance Explained
#
# -----------------------------------------------------------

# The theory we've been describing also tells us that the standard deviation of
# the conditional distribution that we described in a previous video is Var of Y
# given X equals sigma y times the square root of 1 minus rho squared.
#
# Var(Y | X = x) = oy(sqrt(1- p^2))
#
# This is where statements like x explains such and such percent of the
# variation in y comes from.

# Note that the variance of y is sigma squared. That's where we start. If we
# condition on x, then the variance goes down to 1 minus rho squared times sigma
# squared y. So from there, we can compute how much the variance has gone down.
# It has gone down by rho squared times 100%. So the correlation and the amount
# of variance explained are related to each other. But it is important to
# remember that the variance explained statement only makes sense when the data
# is approximated by a bivariate normal distribution.