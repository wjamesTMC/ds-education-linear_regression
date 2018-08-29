# -----------------------------------------------------------
#
# LSE are Random Variables
#
# -----------------------------------------------------------

# Set up
library(tidyverse)
library(rvest)
library(readr)
library(dslabs)
library(ggplot2)
install.packages("Lahman")
library(Lahman)               # Contains all the baseball statistics
ds_theme_set()
install.packages("HistData")  # Contains all the heights data
library(HistData)

data("GaltonFamilies")
galton_heights <- GaltonFamilies %>%
  filter(childNum == 1 & gender == "male") %>%
  select(father, childHeight) %>%
  rename(son = childHeight)

# The LSE are derived from the data, Y1 through Yn, which are random. This
# implies that our estimates are random variables. To see this, we can run a
# Monte Carlo simulation in which we assume that the son and father height data
# that we have defines an entire population. And we're going to take random
# samples of size 50 and compute the regression slope coefficient for each one.
# We write this code,

B <- 1000
N <- 50
lse <- replicate(B, {
  sample_n(galton_heights, N, replace = TRUE) %>%
    lm(son ~ father, data = .) %>% .$coef
})
lse <- data.frame(beta_0 = lse[1,], beta_1 = lse[2,])
lse

# which gives us several estimates of the regression slope. We can see the
# variability of the estimates by plotting their distribution. Here you can see
# the histograms of the estimated beta 0's and the estimated beta 1's.

library(dplyr)
library(dslabs)
library(grid)
install.packages("gridExtra")
library(gridExtra)
p1 <- lse %>% ggplot(aes(beta_0)) + geom_histogram(binwidth = 5, color = "black")
p2 <- lse %>% ggplot(aes(beta_1)) + geom_histogram(binwidth = 0.1, color = "black")

grid.arrange(p1, p2, ncol = 2)

# The reason these look normal is because the central limit theorem applies here
# as well. For large enough N, the least squares estimates will be approximately
# normal with expected value beta 0 and beta 1 respectively.

# The standard errors are a bit complicated to compute, but mathematical theory
# does allow us to compute them, and they are included in the summary provided
# by the lm() function. Here are the estimated standard errors for one of our
# simulated data sets.

sample_n(galton_heights, N, replace = TRUE) %>%
  lm(son ~ father, data = .) %>% summary

# Call:
#   lm(formula = son ~ father, data = .)
# 
# Residuals:
#     Min      1Q  Median      3Q     Max 
# -5.8081 -2.0240  0.1866  1.1814  8.3835 
# 
# Coefficients:
#               Estimate Std. Error t value Pr(>|t|)    
#   (Intercept)  42.3199     9.1394   4.630  2.8e-05 ***
#   father        0.4042     0.1330   3.038  0.00384 ** 
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 2.425 on 48 degrees of freedom
# Multiple R-squared:  0.1613,	Adjusted R-squared:  0.1438 
# F-statistic: 9.232 on 1 and 48 DF,  p-value: 0.003841

# You could see them at the second column in the coefficients table. You can see
# that the standard errors estimates reported by the summary function are
# closed, so the standard errors that we obtain from our Monte Carlo simulation.
# The summary function also reports t-statistics--this is the t value column--
# and p-values. This is the Pr bigger than absolute value of t column.

# The t-statistic is not actually based on the central limit theorem, but rather
# on the assumption that the epsilons follow a normal distribution. Under this
# assumption, mathematical theory tells us that the LSE divided by their
# standard error, which we can see here and here, follow a t distribution with N
# minus p degrees of freedom, with p the number of parameters in our model,
# which in this case is 2.

# The 2p values are testing the null hypothesis that beta 0 is 0 and beta 1 is 0
# respectively. Note that as we described previously, for large enough N, the
# central limit works, and the t distribution becomes almost the same as a
# normal distribution.

# So if either you assume the errors are normal and use the t distribution
# or if you assume that N is large enough to use the central limit theorem,
# you can construct confidence intervals for your parameters.

# We know here that although we will not show examples in this video, hypothesis
# testing for regression models is very commonly used in, for example,
# epidemiology and economics, to make statements such as the effect of A and B
# was statistically significant after adjusting for X, Y, and Z. But it's very
# important to note that several assumptions-- we just described some of them--
# have to hold for these statements to hold.

# ------------------------------------------------------------------------------
# Advanced Note on LSE
# ------------------------------------------------------------------------------

# Although interpretation is not straight-forward, it is also useful to know
# that the LSE can be strongly correlated, which can be seen using this code:
  
lse %>% summarize(cor(beta_0, beta_1))
 
# However, the correlation depends on how the predictors are defined or
# transformed. Here we standardize the father heights, which changes xi to
# xi - x.

B <- 1000
N <- 50
lse <- replicate(B, {
  sample_n(galton_heights, N, replace = TRUE) %>%
    mutate(father = father - mean(father)) %>%
    lm(son ~ father, data = .) %>% .$coef 
})
 
# Observe what happens to the correlation in this case:
   
cor(lse[1,], lse[2,]) 
