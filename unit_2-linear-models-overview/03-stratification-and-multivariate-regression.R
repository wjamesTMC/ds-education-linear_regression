# -----------------------------------------------------------
#
# Stratification and Multivariate Regression
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

# To try to determine if bases on balls is still useful for creating runs, a
# first approach is to keep home runs fixed at a certain value and then examine
# the relationship between runs and bases on balls. As we did when we stratified
# fathers by rounding to the closest inch, here, we can stratify home runs per
# game to the closest 10th. We filtered our strata with few points. We use this
# code to generate an informative data set. 

dat <- Teams %>% filter(yearID %in% 1961:2001) %>%
  mutate(HR_strata = round(HR/G, 1),
         BB_per_game = BB/G,
         R_per_game = R/G) %>%
  filter(HR_strata >= 0.4 & HR_strata <= 1.2)

# And then, we can make a scatter plot for each strata. A scatterplot of runs
# versus bases on balls. This is what it looks like.

dat %>%
  ggplot(aes(BB_per_game, R_per_game)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm") +
  facet_wrap(~HR_strata)

# Remember that the regression slope for predicting runs with bases
# on balls when we ignore home runs was 0.735. But once we stratify by home
# runs, these slopes are substantially reduced. We can actually see what the
# slopes are by using this code. We stratify by home run and then compute the
# slope using the formula that we showed you previously. 

dat %>%
  group_by(HR_strata) %>%
  summarize(slope = cor(BB_per_game, R_per_game) * sd(R_per_game) / sd(BB_per_game))
# A tibble: 9 x 2
# HR_strata slope
# <dbl> <dbl>
# 1       0.4 0.734
# 2       0.5 0.566
# 3       0.6 0.412
# 4       0.7 0.285
# 5       0.8 0.365
# 6       0.9 0.261
# 7       1   0.511
# 8       1.1 0.454
# 9       1.2 0.440

# These values are closer to the slope we obtained from singles, which is 0.449.
# Which is more consistent with our intuition. Since both singles and bases on
# ball get us to first base, they should have about the same predictive power.

# Now, although our understanding of the application-- our understanding of
# baseball-- tells us that home runs cause bases on balls and not the other way
# around, we can still check if, after stratifying by base on balls, we still
# see a home run effect or if it goes down. We use the same code that we just
# used for bases on balls. But now, we swap home runs for bases on balls to get
# this plot.

dat <- Teams %>% filter(yearID %in% 1961:2001) %>%
  mutate(BB_strata = round(BB/G, 1),
         HR_per_game = HR/G,
         R_per_game = R/G) %>%
  filter(BB_strata >= 2.8 & BB_strata <= 3.9)

dat %>%
  ggplot(aes(HR_per_game, R_per_game)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm") +
  facet_wrap(~BB_strata)

# In this case, the slopes are the following.

dat %>%
  group_by(BB_strata) %>%
  summarize(slope = cor(HR_per_game, R_per_game) * sd(R_per_game) / sd(HR_per_game))
# A tibble: 12 x 2
# BB_strata slope
# <dbl> <dbl>
#   1       2.8  1.53
#  2       2.9  1.57
#  3       3    1.52
#  4       3.1  1.49
#  5       3.2  1.58
#  6       3.3  1.56
#  7       3.4  1.48
#  8       3.5  1.63
#  9       3.6  1.83
# 10       3.7  1.45
# 11       3.8  1.70
# 12       3.9  1.30

# You can see they are all around 1.5, 1.6,
# 1.7. So they do not change that much from the original slope estimate, which
# was 1.84. Regardless, it seems that if we stratify by home runs, we have an
# approximately bivariate normal distribution for runs versus bases on balls.
# Similarly, if we stratify by bases on balls, we have an approximately normal
# bivariate distribution for runs versus home runs. 

# So what do we do? It is somewhat complex to be computing regression lines for
# each strata. We're essentially fitting this model that you can see in this
# equation

# e[r | bb = X1, HR = x2] = B0 + B1(x2)x1 + B2(x1)x2

# with the slopes for x1 changing for different values of x2 and vice versa.
# Here, x1 is bases on balls. And x2 are home runs. Is there an easier approach?
# Note that if we take random variability into account, the estimated slopes by
# strata don't appear to change that much. If these slopes are in fact the same,
# this implies that this function beta 1 of x2 and the other function beta 2 of
# x1 are actually constant. Which, in turn, implies that the expectation of runs
# condition on home runs and bases on balls can be written in this simpler
# model.

# E[R] BB = x1, HR = x2] = B0 + B1x1 + B2x2

# This model implies that if the number of home runs is fixed, we observe
# a linear relationship between runs and bases on balls. And that the slope of
# that relationship does not depend on the number of home runs. Only the slope
# changes as the home runs increase. The same is true if we swap home runs and
# bases on balls. In this analysis, referred to as multivariate regression, we
# say that the bases on balls slope beta 1 is adjusted for the home run effect.
# If this model is correct, then confounding has been accounted for. But how do
# we estimate beta 1 and beta 2 from the data? For this, we'll learn about
# linear models and least squares estimates.