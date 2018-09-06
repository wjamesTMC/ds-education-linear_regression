# --------------------------------------------------------------------------------
#
# Confounding: Are BBs More Predictive?
#
# --------------------------------------------------------------------------------

# Set up
library(tidyverse)
library(dslabs)
library(ggplot2)
library(Lahman) # Contains all the baseball statistics
ds_theme_set()

# In a previous video, we found that the slope of the regression line for
# predicting runs from bases on balls was 0.735. So, does this mean that if we
# go and higher low salary players with many bases on balls that increases the
# number of walks per game by 2 for our team? Our team will score 1.47 more runs
# per game? We are again reminded that association is not causation. 

# The data does provide strong evidence that a team with 2 more bases on balls
# per game than the average team scores 1.47 more runs per game, but this does
# not mean that bases on balls are the cause. If we do compute the regression
# line slope for singles, we get 0.449, a lower value. Note that a single gets
# you to first base just like a base on ball. Those that know a little bit more
# about baseball will tell you that with a single, runners that are on base have
# a better chance of scoring than with a base on balls.

# So, how can base on balls be more predictive of runs? The reason this happens
# is because of confounding. Note the correlation between homeruns, bases on
# balls, and singles.

Teams %>%
  filter(yearID %in% 1961:2001) %>%
  mutate(Singles = (H-HR-X2B-X3B) / G, BB = BB / G, HR = HR / G) %>%
  summarize(cor(BB, HR), cor(Singles, HR), cor(BB, Singles))
# cor(BB, HR) cor(Singles, HR) cor(BB, Singles)
# 1   0.4039125       -0.1738404      -0.05605071

# We see that the correlation between bases on balls and homeruns is quite high
# compared to the other two pairs. It turns out that pitchers, afraid of
# homeruns, will sometimes avoid throwing strikes to homerun hitters. As a
# result, homerun hitters tend to have more bases on balls. Thus, a team with
# many homeruns will also have more bases on balls than average, and as a
# result, it may appear that bases on balls cause runs. But it is actually the
# homeruns that caused the runs. In this case, we say that bases on balls are
# confounded with homeruns. But could it be that bases on balls still help? To
# find out, we somehow have to adjust for the homerun effect. Regression can
# help with this.