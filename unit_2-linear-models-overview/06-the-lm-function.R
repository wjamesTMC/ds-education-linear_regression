# -----------------------------------------------------------
#
# The lm Function
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

# In r, we can obtain the least squares estimates using the lm function. To fit
# the following model where Yi is the son's height and Xi is the father height,
# we would write the following piece of code. 

fit <- lm(son ~ father, data = galton_heights)
fit

# This gives us the least squares estimates, which we can see in the output of
# r.

# Call:
#   lm(formula = son ~ father, data = galton_heights)
# 
# Coefficients:
#   (Intercept)       father  
# 35.7125       0.5028  

# The general way we use lm is by using the tilde character to let lm know which
# is the value we're predicting that's on the left side of the tilde, and which
# variables we're using to predict-- those will be on the right side of the
# tilde. The intercept is added automatically to the model. So you don't have to
# include it when you write it.

# The object fit that we just computed includes more information about the least
# squares fit. We can use the function summary to extract more of this
# information, like this.

summary(fit)

# Call:
#   lm(formula = son ~ father, data = galton_heights)
# 
# Residuals:
#     Min      1Q  Median      3Q     Max 
# -5.9022 -1.4050  0.0922  1.3422  8.0922 
# 
# Coefficients:
#             Estimate Std. Error t value Pr(>|t|)    
# (Intercept) 35.71249    4.51737   7.906 2.75e-13 ***
# father       0.50279    0.06533   7.696 9.47e-13 ***
#   ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 2.22 on 177 degrees of freedom
# Multiple R-squared:  0.2507,	Adjusted R-squared:  0.2465 
# F-statistic: 59.23 on 1 and 177 DF,  p-value: 9.473e-13

# To understand some of the information included in this summary, we need to
# remember that the LSE are random variables. Mathematical statistics gives us
# some ideas of the distribution of these random variables. And we'll learn some
# of that next.

# ------------------------------------------------------------------
# EXERCISE
# ------------------------------------------------------------------

# Run a linear model in R predicting the number of runs per game based on the
# number of bases on balls and the number of home runs. Remember to first limit
# your data to 1961-2001.
#
# What is the coefficient for bases on balls?

library(dslabs)
library(ggplot2)
install.packages("Lahman")
library(Lahman) # Contains all the baseball statistics
ds_theme_set()

Teams %>% filter(yearID %in% 1961:2001) %>%
  mutate(R_per_game = R/G, BB_per_game = BB/G) %>%
  ggplot(aes(BB_per_game, R_per_game)) +
  geom_point(alpha = 0.5)

fit <- lm(R_per_game ~ BB_per_game, data = Teams)
fit
summary(fit)