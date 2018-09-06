# --------------------------------------------------------------------------------
#
# Bivariate Normal Distribution
#
# --------------------------------------------------------------------------------

library(tidyverse)
library(dslabs)
library(dplyr)
library(ggplot2)
library(Lahman)
library(HistData)

data("GaltonFamilies")

# When a pair of random variables is approximated by a bivariate normal
# distribution, the scatterplot looks like ovals, like American footballs. They
# can be thin. That's when they have high correlation. All the way up to a
# circle shape when they have no correlation.

# A more technical way to define the bivariate normal distribution is the
# following. First, this distribution is defined for pairs. So we have two
# variables, x and y. And they have paired values. They are going to be
# bivariate normally distributed if the following happens. If x is a normally
# distributed random variable, and y is also a normally distributed random
# variable--and for any grouping of x that we can define, say, with x being
# equal to some predetermined value, which we call here in this formula little
# x--  then the y's in that group are approximately normal as well.

# When we fix x in this way, we then refer to the resulting distribution of the
# y's in the group--defined by setting x in this way--as the conditional
# distribution of y given x. We write the notation like this for the conditional
# distribution and the conditional expectation.

# fY|X=x is the conditional distribution

# and E(Y | X = x) is the conditional expected value

# If we think the height data is well-approximated by the bivariate normal 
# distribution, then we should see the normal approximation hold for each 
# grouping. Here, we stratify the son height by the standardized father 
# heights and see that the assumption appears to hold. Here's the code that 
# gives us the desired plot.

# Note: you have to run the code below before you can run the code in the lesson
galton_heights <- GaltonFamilies %>%
  filter(childNum == 1 & gender == "male") %>%
  select(father, childHeight) %>%
  rename(son = childHeight)

# This is the code referenced in the lesson - note the resulting plot
galton_heights %>%
  mutate(z_father = round((father - mean(father)) / sd(father))) %>%
  filter(z_father %in%-2:2) %>%
  ggplot() +
  stat_qq(aes(sample = son)) +
  facet_wrap(~z_father)

# Now, we come back to defining correlation. Galton showed -- using
# mathematical statistics--that when two variables follow a bivariate
# normal distribution, then for any given x the expected value of the 
# y in pairs for which x is set at that value is mu y plus rho x minus mu
# x divided by sigma x times sigma y.

# E(Y|X = x) = uy + p((X - ux) / (ox))oy

# Note that this is a line with slope rho times sigma y divided by sigma x
#         Slope: p(oy / ox)
# and intercept mu y minus n times mu x. 
#         intercept: uy - mux

# And therefore, this is the same as the regression line we saw in a previous 
# video. This can be written like this.

# E(Y|X = x) - uy / oy = p((X - ux) / (ox))

# So in summary, if our data is approximately bivariate, then the conditional
# expectation--which is the best prediction for y given that we know the 
# value of x--is given by the regression line.
