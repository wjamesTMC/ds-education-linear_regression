# -----------------------------------------------------------
#
# Least Squares Estimate (LSE)
#
# -----------------------------------------------------------

# Set up
library(tidyverse)
library(rvest)
library(readr)
library(dslabs)
library(ggplot2)
install.packages("Lahman")
library(Lahman) # Contains all the baseball statistics
ds_theme_set()

# For linear models to be useful, we have to estimate the unknown parameters,
# the betas. The standard approach in science is to find the values that
# minimize the distance of the fitted model to the data. To quantify, this we
# use the least squares equation. 

# For Galton data, we would write something like this. This quantity is called
# the Residual Sum of Squares, RSS.

#            RSS = E {Yi - (B0 + B1x1)}^2
#                where E is Epsilon

# Once we find the values that minimize the RSS, we call the values the Least
# Squares Estimate, LSE, and denote them, in this case, with beta 0 hat and beta
# 1 hat. Let's write the function that computes the RSS for any pair of values,
# beta 0 and beta 1, for our heights data. It would look like this.

rss <- function(beta0, beta1, data){
  resid <- galton_heights$son - (beta0 + beta1 * galton_heights$father)
  return(sum(resid^2))
}

# So for any pair of values, we get an RSS. So this is a three-dimensional plot
# with beta 1 and beta 2, and x and y and the RSS as a z. To find the minimum,
# you would have to look at this three-dimensional plot. Here, we're just going
# to make a two-dimensional version by keeping beta 0 fixed at 25. So it will be
# a function of the RSS as a function of beta 1. We can use this code to produce
# this plot.

beta1 = seq(0, 1, len=nrow(galton_heights))
results <- data.frame(beta1 = beta1,
                      rss = sapply(beta1, rss, beta0 = 25))
results %>% ggplot(aes(beta1, rss)) + geom_line() +
  geom_line(aes(beta1, rss), col=2)

# We can see a clear minimum for beta 1 at around 0.65. So you could see how we
# would pick the least squares estimates. However, this minimum is for beta 1
# when beta 0 is fixed at 25. But we don't know if that's the minimum for beta
# 0. We don't know if 25 comma 0.65 (25, 0.65) minimizes the equation across all
# pairs. We could use trial and error, but it's really not going to work here.
# Instead we will use calculus. We'll take the partial derivatives, set them
# equal to 0, and solve for beta 1 and beta 0. Of course, if we have many
# parameters, these equations can get rather complex. But there are functions in
# R that do these calculations for us. We will learn these soon. To learn the
# mathematics behind this, you can consult the book on linear models.

beta1 = seq(0, 1, len=nrow(galton_heights))
results <- data.frame(beta1 = beta1,
                      rss = sapply(beta1, rss, beta0 = 36))
results %>% ggplot(aes(beta1, rss)) + geom_line() +
  geom_line(aes(beta1, rss), col=2)
