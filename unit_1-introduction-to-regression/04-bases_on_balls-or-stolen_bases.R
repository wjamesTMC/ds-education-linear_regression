# -----------------------------------------------------------
#
# Bases on Balls - or Stolen Bases?
#
# -----------------------------------------------------------

library(tidyverse)
library(rvest)
library(readr)

# Questions to answer
# (1) Do teams that hit more home runs score more runs?
#     Examine data from 1961-2001
#         This is when the league went to 162 games
#         ...and we are building a team in 2002
#
#     We will use a scatterplot:

library(dslabs)
library(ggplot2)
install.packages("Lahman")
library(Lahman) # Contains all the baseball statistics
ds_theme_set()
Teams %>% filter(yearID %in% 1961:2001) %>%
  mutate(HR_per_game = HR/G, R_per_game = R/G) %>%
  ggplot(aes(HR_per_game, R_per_game)) +
  geom_point(alpha = 0.5)

# The plot shows a very strong association - teams with more
# home runs tend to score more runs
#
# (2) What about stolen bases?

Teams %>% filter(yearID %in% 1961:2001) %>%
  mutate(SB_per_game = SB/G, R_per_game = R/G) %>%
  ggplot(aes(SB_per_game, R_per_game)) +
  geom_point(alpha = 0.5)

# Here the relationship is not so clear.
#
# (3) The relationship between bases on balls and runs

Teams %>% filter(yearID %in% 1961:2001) %>%
  mutate(BB_per_game = BB/G, R_per_game = R/G) %>%
  ggplot(aes(BB_per_game, R_per_game)) +
  geom_point(alpha = 0.5)

# Although the relationship is not as strong as it was for
# home runs, we do see a pretty strong relationship here.
# Now it could be that home runs also cause the bases on balls.
#
# So it might appear that a base on balls is causing runs when
# in fact, it's home runs that are causing both. This is called
# CONFOUNDING.

# From the exercises, calculating at bats per game

Teams %>% filter(yearID %in% 1961:2001 ) %>%
  mutate(AB_per_game = AB/G, R_per_game = R/G) %>%
  ggplot(aes(AB_per_game, R_per_game)) + 
  geom_point(alpha = 0.5)

# Linear regression will help us parse all this out and quantify the associations.
# This will then help us determine what players to recruit.
# Specifically, we will try to predict things
# like how many more runs will the team score if we
# increase the number of bases on balls but keep the home runs fixed.
# Regression will help us answer this question, as well.