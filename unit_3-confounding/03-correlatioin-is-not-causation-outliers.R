# -----------------------------------------------------------
#
# Correlation is Not Causation: Outliers
#
# -----------------------------------------------------------

# Set Up
library(tidyverse)
library(tidyr)
library(dslabs)
library(dplyr)
library(broom)
library(ggplot2)
ds_theme_set()

falling_object <- rfalling_object()

# Another way that we can see high correlations when there's no causation is
# when we have outliers. Suppose we take measurements from two independent
# outcomes, x and y, and we standardize the measurements. However, imagine we
# made a mistake and forgot to standardize entry 23. We can simulate such data
# using the following code.

set_seed(1)
x <- rnorm(100, 100, 1)
y <- rnorm(100, 84, 1)
x[-23] <- scale(x[-23])
y[-23] <- scale(y[-23])

# The data looks like this.

tibble(x,y) %>% ggplot(aes(x,y)) + geom_point(alpha = 0.5)
cor(x, y)
# [1] 0.9874885

# Not surprisingly, the correlation is very high. That one point, that one
# outlier, is making the correlation be as high as 0.99. But again, this is
# driven by that one outlier. If we remove this outlier, the correlation is
# greatly reduced to almost 0, which is what it should be. Here's what we get if
# we remove entry 23.

cor(x[-23], y[-23])
# [1] -0.08476749

# So one way to deal with outliers is to try to detect them and remove them. But
# there is an alternative way to the sample correlation for estimating the
# population correlation that is robust to outliers. It is called Spearman
# correlation. The idea is simple. Compute the correlation on the ranks of the
# values, rather than the values themselves. Here's a plot of the ranks plotted
# against each other for that data set that includes the outlier. Note that the
# one point that's very large is just at the 100th location. It is no longer
# really out there and pulling the correlation towards 1. So if we compute the
# correlation of the ranks,

cor(rank(x), rank(y))
# [1] -0.05275728

# we get something much closer to 0, as we see here.
# Spearman correlation can also be calculated with the correlation
# function, but using the method argument to tell
# [? cor ?] which correlation to compute.

cor(x, y, method = "spearman")
# [1] -0.05275728

# There are also methods for robust fitting of linear models, which you can
# learn about in, for example, this book.


#      Robust Statistics: Edition 2
#      Peter J. Huber, Elvezio M. Ronchetti

