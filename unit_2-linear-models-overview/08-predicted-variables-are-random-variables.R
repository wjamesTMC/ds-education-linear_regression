# -------------------------------------------------------------------------------------------
#
# Predicted Variables are Random Variables
#
# -------------------------------------------------------------------------------------------

# Set up
library(tidyverse)
library(dslabs)
library(ggplot2)
library(Lahman)               # Contains all the baseball statistics
ds_theme_set()
library(HistData)

# Set up for the data
data("GaltonFamilies")
galton_heights <- GaltonFamilies %>%
  filter(childNum == 1 & gender == "male") %>%
  select(father, childHeight) %>%
  rename(son = childHeight)

# Once we fit our model, we can obtain predictions of y by plugging the
# estimates into the regression model. For example, if the father's height is x,
# then our prediction for y-- which we'll denote with a y hat on top of the y--
# for the son's height will be the following. We're just plugging in beta-- the
# estimated betas into the equation. If we plot y hat versus x, we'll see the
# regression line. Note that the prediction y hat is also a random variable, and
# mathematical theory tells us what the standard errors are. If we assume the
# errors are normal or have a large enough sample size to use the Central Limit
# Theorem, we can construct confidence intervals for our predictions, as well.
# In fact, the ggplot layer geom_smooth(), when we set method equals to lm --
# we've previously shown this for several plots -- plots confidence intervals
# around the predicted y hat. Let's look at an example with this code.

galton_heights %>% ggplot(aes(son, father)) +
  geom_point() +
  geom_smooth(method = "lm")

# You can see the regression line. Those are the predictions, and you see a band
# around them. Those are the confidence intervals. The R function predict takes
# an lm object as input and returns these predictions. We can see it here in
# this code which produces this plot,

galton_heights %>%
  mutate(Y_hat = predict(lm(son ~ father, data = .))) %>%
  ggplot(aes(father, Y_hat)) +
  geom_line() 

# ...and if requested the standard errors and other information from which we
# can construct confidence intervals can be obtained from the predict function.
# You can see it by running this code.

fit <- galton_heights %>% lm(son ~ father, data = .)
Y_hat <- predict(fit, se.fit = TRUE)
names(Y_hat)
# [1] "fit"            "se.fit"         "df"             "residual.scale"

# ----------------------------------------------------------------------------------
#
# Exercises
#
# ----------------------------------------------------------------------------------

# Which R code(s) below would properly plot the predictions and confidence
# intervals for our linear model of sons’ heights? Select ALL that apply.

# [1]
galton_heights %>% ggplot(aes(father, son)) +
  geom_point() +
  geom_smooth()

# [2] ** Correct
galton_heights %>% ggplot(aes(father, son)) +
  geom_point() +
  geom_smooth(method = "lm")

# [3] ** Correct
model <- lm(son ~ father, data = galton_heights)
predictions <- predict(model, interval = c("confidence"), level = 0.95)
data <- as.tibble(predictions) %>% bind_cols(father = galton_heights$father)

ggplot(data, aes(x = father, y = fit)) +
  geom_line(color = "blue", size = 1) + 
  geom_ribbon(aes(ymin=lwr, ymax=upr), alpha=0.2) + 
  geom_point(data = galton_heights, aes(x = father, y = son))

# [4]
model <- lm(son ~ father, data = galton_heights)
predictions <- predict(model)
data <- as.tibble(predictions) %>% bind_cols(father = galton_heights$father)

ggplot(data, aes(x = father, y = fit)) +
  geom_line(color = "blue", size = 1) + 
  geom_point(data = galton_heights, aes(x = father, y = son))