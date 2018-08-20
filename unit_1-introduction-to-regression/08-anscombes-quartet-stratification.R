# -----------------------------------------------------------
#
# Anscombe's Quartet/Stratification
#
# -----------------------------------------------------------

library(tidyverse)
library(dslabs)
library(dplyr)
library(ggplot2)
install.packages("Lahman")
library(Lahman)
install.packages("HistData")
library(HistData)

# Correlation is not always a good summary of the relationship
# between two variables. A famous example used to illustrate this are
# the following for artificial data sets, referred to as Anscombe's 
# quartet. All of these pairs have a correlation of 0.82.

# Correlation is only meaningful in a particular context.
# To help us understand when it is that correlation is meaningful 
# as a summary statistic, we'll try to predict the son's height using 
# the father's height. This will help motivate and define linear 
# regression. We start by demonstrating how correlation can be useful 
# for prediction. Suppose we are asked to guess the height of a randomly 
# selected son.

# Because of the distribution of the son height is approximately normal,
# we know that the average height of 70.5 inches is a value with the 
# highest proportion and would be the prediction with the chances of 
# minimizing the error. 

# But what if we are told that the father is 72 inches?   Do we still 
# guess 70.5 inches for the son?  The father is taller than average, 
# specifically he is 1.14 standard deviations taller than the average 
# father. So shall we predict that the son is also 1.14 standard 
# deviations taller than the average son?   It turns out that this would 
# be an overestimate.

# To see this, we look at all the sons with fathers who are about 72 
# inches. We do this by stratifying the father's side. We call this a 
# conditional average, since we are computing the average son height 
# conditioned on the father being 72 inches tall. A challenge when using 
# this approach in practice is that we don't have many fathers that are 
# exactly 72. In our data set, we only have eight.

# If we change the number to 72.5, we would only have one father who is 
# that height. This would result in averages with large standard errors,
# and they won't be useful for prediction for this reason.

# But for now, what we'll do is we'll take an approach of creating strata
# of fathers with very similar heights. Specifically, we will round 
# fathers' heights to the nearest inch. This gives us the following 
# prediction for the son of a father that is approximately 72 inches tall.
# We can use this code and get our answer, which is 71.84.

conditional_avg <- galton_heights %>% filter(round(father) == 72) %>%
  summarize(avg = mean(son)) %>% .$avg
conditional_avg
# [1] 71.83571

galton_heights %>% mutate(father_strata = factor(round(father))) %>%
  ggplot(aes(father_strata, son)) +
  geom_boxplot() +
  geom_point()

galton_heights %>%
  mutate(father = round(father)) %>%
  group_by(father) %>%
  summarize(son_conditional_avg = mean(son)) %>%
  ggplot(aes(father, son_conditional_avg)) +
  geom_point()

r <- galton_heights %>% summarize(r = cor(father, son)) %>% .$r
galton_heights %>%
  mutate(father = round(father)) %>%
  group_by(father) %>%
  summarize(son = mean(son)) %>%
  mutate(z_father = scale(father), z_son = scale(son)) %>%
  ggplot(aes(z_father, z_son)) +
  geom_point() +
  geom_abline(intercept = 0, slope = r)


mu_x <- mean(galton_heights$father)
mu_y <- mean(galton_heights$son)
s_x <- sd(galton_heights$father)
s_y <- sd(galton_heights$son)
r < cor(galton_heights$father, galton_heights$son)
m <- r * s_y / s_x
b <- mu_y - m * mu_x

galton_heights %>%
  ggplot(aes(father, son)) +
  geom_point(alpha = 0.5) +
  geom_abline(intercept = b, slope = m)


galton_heights %>%
  ggplot(aes(scale(father), scale(son))) +
  geom_point(alpha = 0.5) +
  geom_abline(intercept = 0, slope = r)