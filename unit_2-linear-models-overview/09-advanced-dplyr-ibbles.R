# -----------------------------------------------------------
#
# Advanced dplyr: Tibbles
#
# -----------------------------------------------------------

# Set up
library(tidyverse)
library(dslabs)
library(ggplot2)
install.packages("Lahman")
library(Lahman)               # Contains all the baseball statistics
ds_theme_set()

# Let's go back to baseball. In a previous example, we estimated the regression
# lines to predict runs from bases and balls in different home run strata. We
# first constructed a data frame similar to this. 

dat <- Teams %>% filter(yearID %in% 1961:2001) %>%
  mutate(HR = round(HR/G, 1),
         BB = BB/G,
         R = R/G  ) %>%
  select(HR, BB, R) %>%
  filter(HR >= 0.4 & HR <= 1.2)

# Then, to compute the
# regression line in each strata, since we didn't know the lm function back
# then, we used the formula directly like this. 

dat %>%
  group_by(HR) %>%
  summarize(slope = cor(BB, R)*sd(R)/sd(BB))
# A tibble: 9 x 2
# HR slope
# <dbl> <dbl>
# 1   0.4 0.734
# 2   0.5 0.566
# 3   0.6 0.412
# 4   0.7 0.285
# 5   0.8 0.365
# 6   0.9 0.261
# 7   1   0.511
# 8   1.1 0.454
# 9   1.2 0.440

# We argued that the slopes are similar and that the differences were perhaps
# due to random variation. To provide a more rigorous defense of the slopes
# being the same, which is what led to our multivariate regression model, we
# could compute confidence intervals for each slope. We have not learned the
# formula for this, but the lm function provides enough information to construct
# them. First, note that if we try to use the lm function to get the estimated
# slope like this, we don't get what we want.

dat %>%
  group_by(HR) %>%
  lm(R ~ BB, data = .) %>%
  .$coef
# (Intercept)          BB 
#   2.1986073   0.6377959 

# The lm function ignored the group_by. This is expected, because
# lm is not part of the tidyverse and does not know how to handle the outcome of
# group_by which is a group tibble. We're going to describe tibbles in some
# details now. When summarize receives the output of group_by, it somehow knows
# which rows of the table go with which groups. But where is this information
# stored in the data frame? Let's write some code to see the output of a
# group_by call. 

dat %>% group_by(HR) %>% head()
# A tibble: 6 x 3
# Groups:   HR [5]
# HR    BB     R
# <dbl> <dbl> <dbl>
# 1   0.9  3.56  4.24
# 2   0.7  3.97  4.47
# 3   0.8  3.37  4.69
# 4   1.1  3.46  4.42
# 5   1    2.75  4.61
# 6   0.9  3.06  4.58

# Note that there are no columns with the information needed to
# define the groups. But if you look closely at the output, you notice the line
# "A tibble, 6 by 3." We can learn the class of the return object using this
# line of code, and we see that the class is a "tbl." 

dat %>% group_by(HR) %>% class()
# [1] "grouped_df" "tbl_df"     "tbl"        "data.frame"

# This is pronounced "tibble." It is also a tbl_df. This is equivalent to
# tibble. The tibble is a special kind of data frame. We have seen them before,
# because tidyverse functions such as group_by and also summarize always return
# this type of data frame. The group_by function returns a special kind of
# tibble, the grouped tibble. We will say more about the grouped tibbles later.
# Note that the manipulation verbs, select, filter, mutate, and arrange, don't
# necessarily return tibbles. They preserve the class of the input. If they
# receive a regular data frame, they return a regular data frame. If they
# receive a tibble, they return a tibble. But tibbles are the default data frame
# for the tidyverse. Tibbles are very similar to data frames. You can think of
# them as modern versions of data frames. Next, we're going to describe briefly
# three important differences.
