# -----------------------------------------------------------
#
# Correlation is Not Causation: Simpson's Paradox
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

# We have just seen an example of Simpson's paradox. It is called a paradox
# because we see the sign of the correlation flip when we computed on the entire
# population and when we computed on specific strata. Now, we're going to use a
# very illustrative simulated example to show you how this can happen. Suppose
# you have three variables-- x, y, and z. Here's a scatter plot of y versus x.

# You can see that x and y are negatively correlated. However, once we stratify
# by z-- the confounder which we haven't looked at yet-- we see that another
# pattern emerges. 

# This plot, the different strata defined by disease, are shown in different
# colors. If you compute the correlation in each strata, you see that the
# correlations are now positive. So it's really z that is negatively correlated
# with x. If we stratify by z, the x and y are actually positively correlated.
# This is an example of Simpson's paradox.