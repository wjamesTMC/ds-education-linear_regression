# -----------------------------------------------------------
#
# Measurement Error Models
#
# -----------------------------------------------------------

# Set up
library(tidyverse)
library(tidyr)
library(dslabs)
library(dplyr)
library(broom)
library(ggplot2)
ds_theme_set()

falling_object <- rfalling_object()
str(falling_object)
head(falling_object)

# Up until now, all our linear regression examples have been applied to two or
# more random variables. We assume the pairs are bivariate normal and use this
# to motivate a linear model. This approach covers most of real life examples
# where linear regression is used. The other major application comes from
# measurement error models.

# In these applications, it is common to have a nonrandom covariates, such as
# time. And randomness is introduced from measurement error, rather than
# sampling or natural variability. To understand these models, we're going to
# use a motivation example related to physics. Imagine you are Galileo in the
# 16th century trying to describe the velocity of a falling object. An assistant
# climbs the Tower of Pisa and drops a ball. While several other assistants
# record the position at different times. The falling object data set contains
# an example of what that data would look like.

falling_object %>%
  ggplot(aes(time, observed_distance)) +
  geom_point() +
  ylab("Distance in meters") +
  xlab("Time in seconds")

# The assistant hands the data to Galileo and this is what he sees. He uses
# ggplot to make a plot. Here we see the distance in meters that has dropped on
# the y-axis and time on the x-axis. Galileo does not know the exact equation,
# but from data exploration, by looking at the plot, he deduces that the
# position should follow a parabola, which we can write like this.

# f(x) = Bo + B1x + B2x^2

# The data does not fall exactly on a parabola, but Galileo knows that this is
# due to measurement error. His helpers make mistakes when measuring the
# distance the ball has fallen. To account for this, we write this model.

# Yi = Bo + B1xi + B2x^2i + Ei, i = 1, .... n

# Here, y represents the distance the ball is dropped in meters. Xi represents
# time in seconds. And epsilon represents measurement error. The measurement
# error is assumed to be random, independent from each other and having the same
# distribution from each i. We also assume that there is no bias, which means
# that the expected value of epsilon is 0. Note that this is a linear model
# because it is a linear combination of known quantities. X and x squared are
# known and unknown parameters, the betas. Unlike our previous example, the x's
# are fixed quantities. This is just time. We're not conditioning. Now to pose a
# new physical theory and start making predictions about other falling objects,
# Galileo needs actual numbers, rather than the unknown parameters. The LSE
# squares estimates seem like a reasonable approach. So how do we find the LSE
# squares estimates? Note that the LSE calculations do not require the errors to
# be approximately normal. The lm( ) function will find the betas that minimize
# the residual sum of squares, which is what we want. So we use this code to
# obtain our estimated parameters.

fit <- falling_object %>%
  mutate(y = observed_distance,time_sq = time^2)  %>%
  lm(y ~ time + time_sq, data = .)
tidy(fit)
#          term   estimate std.error   statistic      p.value
# 1 (Intercept) 56.4275647 0.6650355  84.8489541 7.595719e-17
# 2        time -0.3331966 0.9502214  -0.3506516 7.324728e-01
# 3     time_sq -4.9094298 0.2818953 -17.4157911 2.344819e-09

# To check if the estimated parabola fits the data, the broom function augment()
# lets us do this easily. Using this code, we can make the following plot.

augment(fit) %>%
  ggplot() +
  geom_point(aes(time, y)) +
  geom_line(aes(time, .fitted))

# Note that the predicted values go right through the points. Now, thanks to my
# high school physics teacher, I know that the equation for the trajectory of a
# falling object is the following.

# d = h0 + v0t - 0.5 x 9.8t^2

# With h0 and v0, the starting height and starting velocity respectively. The
# data we use follow this equation and added measurement error to simulate an
# observation. Dropping the ball, that means the starting velocity is 0 because
# we start just by dropping it from the Tower of Pisa, which has a height of
# about 56.67 meters. These known quantities are consistent with the parameters
# that we estimated, which we can see using the tidy function. Here they are.

tidy(fit, conf.int = TRUE)
#          term   estimate std.error   statistic      p.value  conf.low conf.high
# 1 (Intercept) 56.4275647 0.6650355  84.8489541 7.595719e-17 54.963832 57.891298
# 2        time -0.3331966 0.9502214  -0.3506516 7.324728e-01 -2.424620  1.758227
# 3     time_sq -4.9094298 0.2818953 -17.4157911 2.344819e-09 -5.529877 -4.288982

# The Tower of Pisa height is within the confidence interval for beta 0. The
# initial velocity of 0 is in the confidence interval for beta 1. Note that the
# p value is larger than 0.05, which means we wouldn't reject the hypothesis
# that the starting velocity is 0. And finally, the acceleration constant is in
# the confidence intervals for negative 2 times beta 2.