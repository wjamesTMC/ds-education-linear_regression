# -----------------------------------------------------------
#
# do() function
#
# -----------------------------------------------------------

# Set up
library(tidyverse)
library(dslabs)
library(ggplot2)
library(Lahman)
ds_theme_set()

# Set up the data for use later on
dat <- Teams %>% filter(yearID %in% 1961:2001) %>%
  mutate(HR = round(HR/G, 1),
         BB = BB/G,
         R = R/G  ) %>%
  select(HR, BB, R) %>%
  filter(HR >= 0.4 & HR <= 1.2)

# In this video, we'll describe the very useful do( ) function. The tidyverse
# functions know how to interpret group tibbles. Furthermore, to facilitate
# stringing commands through the pipe, tidyverse functions consistently return
# data frames. Since this assures that the output of one is accepted as the
# input of another. But most of our functions do not recognize group tibbles,
# nor do they return data frames. The lm( ) function is an example. The do( )
# function serves as a bridge between our functions, such as lm( ) and the
# tidyverse. The do( ) function understands group tibbles and always returns a
# data frame. So let's try to use the do( ) function to fit a regression line to
# each home run strata. We would do it like this.

dat %>%
  group_by(HR) %>%
  do(fit = lm(R ~ BB, data = .))
# Source: local data frame [9 x 2]
# Groups: <by row>
#   
#   # A tibble: 9 x 2
#        HR fit     
# * <dbl> <list>  
#   1   0.4 <S3: lm>
#   2   0.5 <S3: lm>
#   3   0.6 <S3: lm>
#   4   0.7 <S3: lm>
#   5   0.8 <S3: lm>
#   6   0.9 <S3: lm>
#   7   1   <S3: lm>
#   8   1.1 <S3: lm>
#   9   1.2 <S3: lm>

# Notice that we did in fact fit a regression line to each strata. But the do( )
# function would create a data frame with the first column being the strata
# value. And a column named fit. We chose that name. It could be any name. And
# that column will contain the result of the lm( ) call. Therefore, the return
# table has a column with lm( ) objects in the cells, which is not very useful.
# Also note that if we do not name a column, then do( ) will return the actual
# output of lm( ), not a data frame. And this will result in an error since do(
# ) is expecting a data frame as output. If you write this, you will get the
# following error.

dat %>%
  group_by(HR) %>%
  do(lm(R ~ BB, data = .))
# Error: Results 1, 2, 3, 4, 5, ... must be data frames, not lm

# For a useful data frame to be constructed, the output of the function, inside
# do( ), must be a data frame as well. We could build a function that returns
# only what you want in the form of a data frame. We could write for example,
# this function.

get_slope <- function(data) {
  fit <- lm(R ~ BB, data = data)
  data.frame(slope = fit$coefficients[2],
             se = summary(fit)$coefficient[2,2])
}

# And then we use to do( ) without naming the output, since we are already
# getting a data frame. We can write this very simple piece of code

dat %>%
  group_by(HR) %>%
  do(get_slope(.))

# and now we get the expected result. 

# A tibble: 9 x 3
# Groups:   HR [9]
# HR slope     se
# <dbl> <dbl>  <dbl>
# 1   0.4 0.734 0.208 
# 2   0.5 0.566 0.110 
# 3   0.6 0.412 0.0974
# 4   0.7 0.285 0.0705
# 5   0.8 0.365 0.0652
# 6   0.9 0.261 0.0754
# 7   1   0.511 0.0749
# 8   1.1 0.454 0.0855
# 9   1.2 0.440 0.0801

# We get the slope for each strata and the standard error for that slope. If we
# name the output, then we get a column containing the data frame. So if we
# write this piece of code, now once again, we get one of these complex tibbles
# with a column having a data frame in each cell. Which is again, not very
# useful.

dat %>%
  group_by(HR) %>%
  do(slope = get_slope(.))
# Source: local data frame [9 x 2]
# Groups: <by row>
  
# A tibble: 9 x 2
# HR slope               
# * <dbl> <list>              
#   1   0.4 <data.frame [1 x 2]>
#   2   0.5 <data.frame [1 x 2]>
#   3   0.6 <data.frame [1 x 2]>
#   4   0.7 <data.frame [1 x 2]>
#   5   0.8 <data.frame [1 x 2]>
#   6   0.9 <data.frame [1 x 2]>
#   7   1   <data.frame [1 x 2]>
#   8   1.1 <data.frame [1 x 2]>
#   9   1.2 <data.frame [1 x 2]>
  
# All right. Now we're going to cover one last feature of do( ). If the data
# frame being returned has more than one row, these will be concatenated
# appropriately. Here's an example in which return both estimated parameters.
# The slope and intercept. We write this piece of code.

get_lse <- function(data) {
  fit <- lm(R ~ BB, data = data)
  data.frame(term = names(fit$coefficients),
             slope = fit$coefficients,
             sd = summary(fit)$coefficient[,2])
}

# And now we use the do( ) function as we used it before, and get a very useful
# tibble, giving us the estimates of the slope and intercept, as well as the
# standard errors.

dat %>%
     group_by(HR) %>%
     do(get_lse(.))

# A tibble: 18 x 4
# Groups:   HR [9]
#      HR term        slope     sd
#   <dbl> <fct>       <dbl>  <dbl>
# 1   0.4 (Intercept) 1.36  0.631 
# 2   0.4 BB          0.734 0.208 
# 3   0.5 (Intercept) 2.01  0.344 
# 4   0.5 BB          0.566 0.110 
# 5   0.6 (Intercept) 2.53  0.305 
# 6   0.6 BB          0.412 0.0974
# 7   0.7 (Intercept) 3.21  0.225 
# 8   0.7 BB          0.285 0.0705
# 9   0.8 (Intercept) 3.07  0.213 
# 10   0.8 BB          0.365 0.0652
# 11   0.9 (Intercept) 3.54  0.252 
# 12   0.9 BB          0.261 0.0754
# 13   1   (Intercept) 2.88  0.255 
# 14   1   BB          0.511 0.0749
# 15   1.1 (Intercept) 3.21  0.300 
# 16   1.1 BB          0.454 0.0855
# 17   1.2 (Intercept) 3.40  0.291 
# 18   1.2 BB          0.440 0.0801

# Now, if you think this is all a bit too complicated, you're not alone. To
# simplify things, we're going to introduce the broom package, which was
# designed to facilitate the use of model fitting functions such as lm( ) with
# the tidyverse.

# -----------------------------------------------------------------------------
#
# # Exercise #2
#
# -----------------------------------------------------------------------------

# You want to take the tibble dat, which we’ve been using in this video, and run
# the linear model R ~ BB for each strata of HR. Then you want to add three new
# columns to your grouped tibble: the coefficient, standard error, and p-value
# for the BB term in the model.
# 
# You’ve already written the function get_slope, shown below.

get_slope <- function(data) {
  fit <- lm(R ~ BB, data = data)
  sum.fit <- summary(fit)
  
  data.frame(slope = sum.fit$coefficients[2, "Estimate"], 
             se = sum.fit$coefficients[2, "Std. Error"],
             pvalue = sum.fit$coefficients[2, "Pr(>|t|)"])
}

# What additional code could you write to accomplish your goal?

dat %>% 
  group_by(HR) %>% 
  do(get_slope)

dat %>% 
  group_by(HR) %>% 
  do(get_slope(.))

dat %>% 
  group_by(HR) %>% 
  do(slope = get_slope(.))

dat %>% 
  do(get_slope(.))