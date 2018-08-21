# -----------------------------------------------------------
#
# Linear Models
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

# Since Galton's original development, regression has become one of the most
# widely used tools in data science. One reason for this has to do with the fact
# that regression permits us to find relationships between two variables while
# adjusting for others, as we have just shown for bases on balls and home runs.
# This has been particularly popular in fields where randomized experiments are
# hard to run, such as economics and epidemiology. When we're not able to
# randomly assign each individual to a treatment or control group, confounding
# is particularly prevalent. For example, consider estimating the effect of any
# fast foods on life expectancy using data collected from a random sample of
# people in some jurisdiction. Fast food consumers are more likely to be
# smokers, drinkers, and have lower incomes. Therefore, a naive regression model
# may lead to an overestimate of a negative health effect of fast foods. 

# So how do we adjust for confounding in practice? We can use regression. We
# have described how, if data is by bivariate normal, then the conditional
# expectation follow a regression line, that the conditional expectation as a
# line is not an extra assumption, but rather a result derived from the
# assumption, that they are approximately bivariate normal. However, in practice
# it is common to explicitly write down a model that describes the relationship
# between two or more variables using what is called a linear model.

# We know that linear here does not refer to lines exclusively, but rather to
# the fact that the conditional expectation is a linear combination of known
# quantities. Any combination that multiplies them by a constant and then adds
# them up with, perhaps, a shift. For example:

#                  2 + 3x - 4y + 5z

# is a linear combination of x, y, and z: Beta0 + Beta1x1 + Beta2x2..

#                  Bo + B1x1 + B2x2

# ...is a linear combination of x1 and x2. The simplest linear model is a constant
# beta 0. The second simplest is a line, beta 0 plus beta 1x. For Galton's data,
# we would denote and observe fathers' heights with x1 through xn. Then we model
# any son heights we are trying to predict with the following model.

#                  Yi = B0 + B1xi + Ei, i = 1, ..., N

# Here, the little xi's are the father's heights, which are fixed not random,
# due to the conditioning. We've conditioned on these values. And then Yi big Yi
# is the random son's height that we want to predict. We further assume that the
# errors that are denoted with the Greek letter for E, epsilon, epsilon i, are
# independent from each other, have expected value 0, and the standard
# deviation, which is usually called sigma, does not depend on i. 

# It's the same for every individual. We know the xi, but to have a useful model
# for prediction, we need beta 0 and beta 1. We estimate these from the data.
# Once we do, we can predict the sons' heights from any father's height, x. Note
# that if we further assume that the epsilons are normally distributed, then
# this model is exactly the same one we derived earlier for the bivariate normal
# distribution.

# A somewhat nuanced difference is that in the first approach, we assumed the
# data was a bivariate normal, and the linear model was derived, not assumed. In
# practice, linear models are just assumed without necessarily assuming
# normality. The distribution of the epsilons is not specified. But
# nevertheless, if your data is bivariate normal, the linear model that we just
# showed holds. If your data is not bivariate normal, then you will need to have
# other ways of justifying the model.

# One reason linear models are popular is that they are interpretable. In the
# case of Galton's data, we can interpret the data like this.

#       Due to inherited genes, the son's height prediction grows
#       by B1 (beta 1) for each inch we increase the father's height x. 

# Because not all sons with fathers of height x are of equal height, we need the
# term epsilon, which explains the remaining variability. This remaining
# variability includes the mother's genetic effect, environmental factors, and
# other biological randomness.

# Note that given how we wrote the model, the intercept beta 0 is not very
# interpretable, as it is the predicted height of a son with a father with no
# height. Due to regression to the mean, the prediction will usually be a bit
# larger than 0, which is really not very interpretable. To make the intercept
# parameter more interpretable, we can rewrite the model slightly in the
# following way.

#       Yi = B0 + B1(xi - x) + Ei, i = 1, ..., N

# Here, we have changed xi to xi minus the average height x bar. We have
# centered our covariate xi. In this case, beta 0, the intercept, would be the
# predicted height for the average father for the case where xi equals x bar.

# -----------------------------------------------------------------
# EXERCISES
# -----------------------------------------------------------------

# Question 1
lm(son ~ father, data = galton_heights)
plot(son ~ father, data = galton_heights)

# Note that the left hand is the dependent variable and the right hand is the
# independent variable. Much like y = bx + c means that y ~ x.

# Call:
#   lm(formula = son ~ father, data = galton_heights)
# 
# Coefficients:
# (Intercept)       father  
#   35.7125         0.5028 

lm(father ~ son, data = galton_heights)
plot(father ~ son, data = galton_heights)

# Question 2

# We want the intercept term for our model to be more interpretable, so we run
# the same model as before but now we subtract the mean of fathers’ heights from
# each individual father’s height to create a new variable centered at zero.

galton_heights <- galton_heights %>%
  mutate(father_centered=father - mean(father))

# We run a linear model using this centered fathers’ height variable.

lm(son ~ father_centered, data = galton_heights)

# Call:
#   lm(formula = son ~ father_centered, data = galton_heights)
# 
# Coefficients:
#   (Intercept)    father_centered  
# 70.45          0.50  

# Interpret the numeric coefficient for the intercept.