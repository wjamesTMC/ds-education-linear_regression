# -----------------------------------------------------------
#
# Correlation Coefficient
#
# -----------------------------------------------------------

library(tidyverse)
library(dslabs)
library(dplyr)
library(ggplot2)
install.packages("Lahman")
library(Lahman)
install.packages("HistData")
library(HistData)

# The correlation coefficient is defined for a list of pairs-- x1, y1 through
# xn, yn--with the following formula.
#
#      See 6-correlation-coefficient-figures
#      Figure 1
# 
# Here, mu x and mu y are the averages of x and y, respectively. And sigma x and
# sigma y are the standard deviations. The Greek letter rho is commonly used in
# the statistics book to denote this correlation.
# 
# The reason is that rho is the Greek letter for r, the first letter of the word
# regression.
# 
# Soon, we will learn about the connection between correlation and regression.
# To understand why this equation does, in fact, summarize how two variables
# move together, consider the i-th entry of x is xi minus mu x divided by sigma
# x SDs away from the average.
# 
# Similarly, the yi-- which is paired with the xi--is yi minus mu y divided by
# sigma y SDs away from the average y.
# 
# If x and y are unrelated, then the product of these two quantities will be
# positive.
#
# See Figure 4
#
# That happens when they are both positive or when they are both negative as
# often as they will be negative. That happens when one is positive and the
# other is negative, or the other way around. One is negative and the other one
# is positive. This will average to about 0. The correlation is this average.
# 
# And therefore, unrelated variables will have a correlation of about 0. If
# instead the quantities vary together, then we are averaging mostly positive
# products. Because they're going to be either positive times positive or
# negative times negative. And we get a positive correlation. If they vary in
# opposite directions, we get a negative correlation. Another thing to know is
# that we can show mathematically that the correlation is always between
# negative 1 and 1. To see this, consider that we can have higher correlation
# than when we compare a list to itself. That would be perfect correlation. In
# this case, the correlation is given by this equation,
#
# See figure 5
#
# which we can show is equal to 1. A similar argument with x and its exact
# opposite, negative x, proves that the correlation has to be greater or equal
# to negative 1. So it's between minus 1 and 1. The correlation between father
# and sons' height is about 0.5. You can compute that using this code.

library(HistData)

data("GaltonFamilies")
galton_heights <- GaltonFamilies %>%
  filter(childNum == 1 & gender == "male") %>%
  select(father, childHeight) %>%
  rename(son = childHeight)

galton_heights %>% summarize(cor(father,son))

#   cor(father, son)
# 1        0.5007248

# We saw what the data looks like when the correlation is 0.5. To see what data
# looks like for other values of rho, here are six examples of pairs with
# correlations ranging from negative 0.9 to 0.99.
#
# See Figure 6
#
# When the correlation is negative, we see that they go in opposite direction.
# As x increases, y decreases. When the correlation gets either closer to 1 or
# negative 1, we see the clot of points getting thinner and thinner. When the
# correlation is 0, we just see a big circle of points.
