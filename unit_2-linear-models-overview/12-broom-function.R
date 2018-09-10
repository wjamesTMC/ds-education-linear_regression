# -----------------------------------------------------------
#
# broom() function
#
# -----------------------------------------------------------

# Set up
library(tidyverse)
library(dslabs)
library(dplyr)
library(ggplot2)
library(Lahman)
ds_theme_set()

Teams %>%
  filter(yearID %in% 1961:2001) %>%
  mutate(Singles = (H-HR-X2B-X3B) / G, BB = BB / G, HR = HR / G) %>%
  summarize(cor(BB, HR), cor(Singles, HR), cor(BB, Singles))

dat <- Teams %>% filter(yearID %in% 1961:2001) %>%
  mutate(HR_strata = round(HR/G, 1),
         BB_per_game = BB/G,
         R_per_game = R/G) %>%
  filter(HR_strata >= 0.4 & HR_strata <= 1.2)

# The original task we ask for in a previous video was to provide an estimate
# and a confidence interval for the slope estimates of each strata. The broom
# packs will make this quite easy. Broom has three main functions all of which
# extract information from the object returned by the function LM, and return it
# in a tidy verse friendly data frame. These functions are tidy, glance and
# augment. The tidy function returns estimates and related information as a data
# frame. Here's an example.

library(broom)
fit <- lm(R ~ BB, data = dat)
tidy(fit)
# term    estimate   std.error statistic       p.value
# 1 (Intercept) 282.5771342 16.49340299  17.13274  1.598540e-57
# 2          BB   0.7646106  0.03151078  24.26505 1.564413e-101

# We can add other important summaries, such as confidence intervals, using
# arguments like this.

tidy(fit, conf.int = TRUE)
#   term           estimate   std.error statistic       p.value
# 1 (Intercept) 282.5771342 16.49340299  17.13274  1.598540e-57
# 2          BB   0.7646106  0.03151078  24.26505 1.564413e-101

# Because the outcome is a data frame, we can immediately use it with do to
# string together the commands that produce the table we are after. So this
# piece of code will generate what we wanted to see.

dat %>%
  group_by(HR) %>%
  do(tidy(lm(R ~ BB, data = .), conf.int = TRUE))
# A tibble: 282 x 8
# Groups:   HR [149]
#       HR term        estimate std.error statistic p.value conf.low conf.high
# <int> <chr>          <dbl>     <dbl>     <dbl>   <dbl>    <dbl>     <dbl>
#  1    39 (Intercept)  431           NaN       NaN     NaN      NaN       NaN
#  2    45 (Intercept)  394           NaN       NaN     NaN      NaN       NaN
#  3    47 (Intercept)  378           NaN       NaN     NaN      NaN       NaN
#  4    49 (Intercept)  452           NaN       NaN     NaN      NaN       NaN
#  5    50 (Intercept)  464           NaN       NaN     NaN      NaN       NaN
#  6    55 (Intercept)  407           NaN       NaN     NaN      NaN       NaN
#  7    56 (Intercept)  461           NaN       NaN     NaN      NaN       NaN
#  8    57 (Intercept)  172.          NaN       NaN     NaN      NaN       NaN
#  9    57 BB             0.579       NaN       NaN     NaN      NaN       NaN
# 10    58 (Intercept)  601           NaN       NaN     NaN      NaN       NaN
# # ... with 272 more rows
# There were 25 warnings (use warnings() to see them)

# Because a data frame is returned, we can filter and select the rows and
# columns we want. So this simple piece of code gives us exactly the table we
# asked for. We have filtered away the intercept rows, and only show the columns
# we care about, the estimate and the confidence intervals.

dat %>%
  group_by(HR) %>%
  do(tidy(lm(R ~ BB, data = .), conf.int = TRUE)) %>%
  filter(term == "BB") %>%
  select(HR, estimate, conf.low, conf.high)
# A tibble: 133 x 4
# Groups:   HR [133]
#      HR estimate  conf.low conf.high
#   <int>    <dbl>     <dbl>     <dbl>
# 1    57    0.579  NaN         NaN   
# 2    61    1.20    -1.31        3.71
# 3    63    1.10    -7.19        9.38
# 4    64    1.03    -0.0159      2.08
# 5    65    3.58   NaN         NaN   
# 6    66    2.25   NaN         NaN   
# 7    67    1.35    -6.10        8.79
# 8    69    0.525  NaN         NaN   
# 9    70    1.65    -0.376       3.68
# 10    71    1.40    -0.617       3.42
# # ... with 123 more rows
# There were 25 warnings (use warnings() to see them)

# Furthermore, a table like this makes visualization with ggplot quite easy. So
# this piece of code produces this nice plot, which provides very useful
# information.

dat %>%
  group_by(HR) %>%
  do(tidy(lm(R ~ BB, data = .), conf.int = TRUE)) %>%
  filter(term == "BB") %>%
  select(HR, estimate, conf.low, conf.high) %>%
  ggplot(aes(HR, y = estimate, ymin = conf.low, ymax = conf.high)) +
  geom_errorbar() +
  geom_point()

# Now we return to discussing our original task of determining if slopes change.
# The plot we just made using do and broom shows that the confidence intervals
# overlap, which provides a nice visual confirmation that our assumption that
# the slopes do not change with home run strata, is relatively safe.

# Earlier we mentioned two other functions from the broom package, glance and
# augment. Glance and augment relate to model specific and observation specific
# outcomes, respectively.

# Here we can see the model fit summary the glance returns. You can learn more
# about these summaries in any regression textbook. We'll see an example of
# augment in a future video.

glance(fit)
#   r.squared adj.r.squared   sigma statistic       p.value df    logLik      AIC      BIC
# 1 0.3833803     0.3827291 74.7262  588.7926 1.564413e-101  2 -5439.397 10884.79 10899.36
#   deviance df.residual
# 1  5288053         947

# -----------------------------------------------------------------------------------------
# 
# Excercise 2
# 
# -----------------------------------------------------------------------------------------

# You want to know whether the relationship between home runs and runs per game
# varies by baseball league. You create the following dataset:
  
  dat <- Teams %>% filter(yearID %in% 1961:2001) %>%
  mutate(HR = HR/G,
         R = R/G) %>%
  select(lgID, HR, BB, R) 

# What code would help you quickly answer this question?

dat %>% 
  group_by(lgID) %>% 
  do(tidy(lm(R ~ HR, data = .), conf.int = T)) %>% 
  filter(term == "HR") 
# A tibble: 2 x 8
# Groups:   lgID [2]
#   lgID  term  estimate std.error statistic  p.value conf.low conf.high
#   <fct> <chr>    <dbl>     <dbl>     <dbl>    <dbl>    <dbl>     <dbl>
# 1 AL    HR        1.90    0.0734      25.9 1.28e-95     1.75      2.04
# 2 NL    HR        1.76    0.0671      26.2 1.16e-95     1.62      1.89

dat %>% 
  group_by(lgID) %>% 
  do(glance(lm(R ~ HR, data = .)))
# A tibble: 2 x 12
# Groups:   lgID [2]
# lgID    r.squared adj.r.squared sigma statistic  p.value    df logLik   AIC   BIC deviance df.residual
# <fct>       <dbl>         <dbl> <dbl>     <dbl>    <dbl> <int>  <dbl> <dbl> <dbl>    <dbl>       <int>
# 1 AL        0.561         0.560 0.411      668. 1.28e-95     2  -278.  562.  574.     88.6         524
# 2 NL        0.579         0.578 0.347      685. 1.16e-95     2  -180.  365.  378.     60.0         498

dat %>% 
  do(tidy(lm(R ~ HR, data = .), conf.int = T)) %>% 
  filter(term == "HR")
#   term estimate  std.error statistic       p.value conf.low conf.high
# 1   HR 1.844751 0.04905907  37.60266 4.272065e-195 1.748484  1.941019

dat %>% 
  group_by(lgID) %>% 
  do(mod = lm(R ~ HR, data = .))
# Source: local data frame [2 x 2]
# Groups: <by row>
#   
#   # A tibble: 2 x 2
#   lgID  mod     
# * <fct> <list>  
#   1 AL    <S3: lm>
#   2 NL    <S3: lm>