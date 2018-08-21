# -----------------------------------------------------------
#
# Correlation
#
# -----------------------------------------------------------

library(tidyverse)
library(dslabs)
library(dplyr)
library(ggplot2)
install.packages("Lahman")
library(Lahman)

# Up to now in this series, we have focused mainly on univariate variables.
# However, in data science application it is very common to be interested in the
# relationship between two or more variables. We saw this in our baseball
# example in which we were interested in the relationship, for example, between
# bases on balls and runs.

# We introduce the concepts of correlation and regression using a simpler
# example. It is actually the dataset from which regression was born.

# We examine an example from genetics. Francis Galton studied the variation and
# heredity of human traits. Among many other traits, Galton collected and
# studied height data from families to try to understand heredity. While doing
# this, he developed the concepts of correlation and regression, and a
# connection to pairs of data that follow a normal distribution.

# A very specific question Galton tried to answer was, how much of a son's
# height can I predict with the parents height. This is similar to predicting
# runs with bases on balls.

# We have access to Galton's family data through the HistData package. HistData
# stands for historical data. We'll create a data set with the heights of
# fathers and the first sons. The actual data Galton used to discover and define
# regression.

install.packages("HistData")
library(HistData)

data("GaltonFamilies")
galton_heights <- GaltonFamilies %>%
  filter(childNum == 1 & gender == "male") %>%
  select(father, childHeight) %>%
  rename(son = childHeight)

# So we have the father and son height data. Suppose we were to summarize these
# data. Since both distributions are well approximated by normal distributions,
# we can use the two averages and two standard deviations as summaries.

galton_heights %>%
  summarize(mean(father), sd(father), mean(son), sd(son))

#  mean(father) sd(father) mean(son)  sd(son)
# 1     69.09888   2.546555  70.45475 2.557061

# This summary fails to describe a very important characteristic of the data
# that you can see in this figure. The trend that the taller the father, the
# taller the son, is not described by the summary statistics of the average and
# the standard deviation.

galton_heights %>% ggplot(aes(father, son)) +
  geom_point(alpha = 0.5)

# We will learn that the correlation coefficient is a summary of this trend.
