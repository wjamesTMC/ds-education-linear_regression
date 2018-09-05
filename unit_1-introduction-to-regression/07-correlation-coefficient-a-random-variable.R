# --------------------------------------------------------------------------------
#
# Correlation Coefficient a Random Variable
#
# --------------------------------------------------------------------------------

library(tidyverse)
library(dslabs)
library(dplyr)
library(ggplot2)
library(Lahman)
library(HistData)

# In most data science applications, we do not observe the population, but
# rather a sample. As with the average and standard deviation, the sample
# correlation is the most commonly used estimate of the population correlation.
# This implies that the correlation we compute and use as a summary is a random
# variable

# A less fortunate geneticist can only afford to take a random sample of 25
# pairs. The sample correlation for this random sample can be computed using
# this code.

set.seed(0)
R <- sample_n(galton_heights, 25, replace = TRUE) %>%
  summarize(cor(father, son))

# We can run a monte-carlo simulation to see the distribution of this random
# variable. Here, we recreate R 1000 times, and plot its histogram.

B <- 1000
N <- 25
R <- replicate(B, {
  sample_n(galton_heights, N, replace = TRUE) %>%
    summarize(r=cor(father, son)) %>% .$r
})
data.frame(R) %>% ggplot(aes(R)) + geom_histogram(binwidth = 0.05, color = "black")
mean(R)
sd(R)

# We see that the expected value is the population correlation, the mean of
# these Rs is 0.5, and that it has a relatively high standard error relative to
# its size, # SD 0.147. This is something to keep in mind when interpreting #
# correlations. It is a random variable, and it can have a # pretty large
# standard error.

# Also note that because the sample correlation is an average of independent 
# draws, the Central Limit Theorem actually applies. Therefore, for a large 
# enough sample size N, the distribution of these Rs is approximately normal.
# The expected value we know is the population correlation.
#
# The standard deviation is somewhat more complex to derive, but this is the 
# actual formula here.
#
# R ~ N(p, sqrt((1-r^2 / N - 2)))
#
# In our example, N equals to 25, does not appear to be large enough to make 
# the approximation a good one, as we see in this ggplot.

# Exercise 1: Instead of running a Monte Carlo simulation with a sample size 
# of 25 from our 179 father-son pairs, we now run our simulation with a sample 
# size of 50. Would you expect the mean of our sample correlation to increase, 
# decrease, or stay approximately the same?
 
B <- 1000
N <- 50
R <- replicate(B, {
  sample_n(galton_heights, N, replace = TRUE) %>%
    summarize(r=cor(father, son)) %>% .$r
})
data.frame(R) %>% ggplot(aes(R)) + geom_histogram(binwidth = 0.05, color = "black")
mean(R)
sd(R)

B <- 1000
N <- 100
R <- replicate(B, {
  sample_n(galton_heights, N, replace = TRUE) %>%
    summarize(r=cor(father, son)) %>% .$r
})
data.frame(R) %>% ggplot(aes(R)) + geom_histogram(binwidth = 0.05, color = "black")
mean(R)
sd(R)