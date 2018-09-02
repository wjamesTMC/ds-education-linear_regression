# -----------------------------------------------------------
#
# Building a Better Offensive Metric for Baseball
#
# -----------------------------------------------------------

# Set up
library(tidyverse)
library(dslabs)
library(dplyr)
library(ggplot2)
library(Lahman)               # Contains all the baseball statistics
ds_theme_set()

# Type str(Master) to see the structure of the Master table

Teams %>%
  filter(yearID %in% 1961:2001) %>%
  mutate(Singles = (H-HR-X2B-X3B) / G, BB = BB / G, HR = HR / G) %>%
  summarize(cor(BB, HR), cor(Singles, HR), cor(BB, Singles))

dat <- Teams %>% filter(yearID %in% 1961:2001) %>%
  mutate(HR_strata = round(HR/G, 1),
         BB_per_game = BB/G,
         R_per_game = R/G) %>%
  filter(HR_strata >= 0.4 & HR_strata <= 1.2)

# In trying to answer how well bases on balls predict runs, data exploration let
# us to this model. Here, the data is approximately normal.

#     E[R | BB = x1, HR = x2] = Bo + B1x1 + B2x2

# And conditional distributions were also normal. Thus, we're justified to pose
# a linear model like this. With yi, the runs per game. x1, walks per game. And
# x2, home runs per game.

#     Yi = Bo + B1x1 + B2x2 +Ei

# To use lm here, we need to let it know that we have two predictive variables.
# So we use the plus symbol as follows. Here's a code that fits that multiple
# regression model.

fit <- Teams %>%
  filter(yearID %in% 1961:2001) %>%
  mutate(BB = BB/G, HR = HR/G, R = R/G) %>%
  lm(R ~ BB + HR, data = .)

# Now, we can use the tidy function to see the nice summary.

tidy(fit, conf.int = TRUE)
#          term  estimate  std.error statistic       p.value  conf.low conf.high
# 1 (Intercept) 1.7444018 0.08234949  21.18291  7.300077e-83 1.5828085 1.9059950
# 2          BB 0.3873978 0.02700913  14.34322  1.195862e-42 0.3343982 0.4403974
# 3          HR 1.5611228 0.04895718  31.88751 1.751870e-155 1.4650548 1.6571907

# When we fit the model with only one variable without the adjustment, the
# estimated slopes were 0.735 and 1.844 for bases on ball and home runs,
# respectively.

# But note that when we fit the multivariate model, both these slopes go down
# with the bases on ball effect decreasing much more.

#          term  estimate  std.error statistic       p.value  conf.low conf.high
# 1 (Intercept) 1.7444018 0.08234949  21.18291  7.300077e-83 1.5828085 1.9059950
# 2          BB 0.3873978 0.02700913  14.34322  1.195862e-42 0.3343982 0.4403974
# 3          HR 1.5611228 0.04895718  31.88751 1.751870e-155 1.4650548 1.6571907

# Now, if we want to construct a metric to pick players, we need to consider
# single, doubles, and triples as well. Can we build a model that predicts runs
# based on all these outcomes? Now, we're going to take somewhat of a leap of
# faith and assume that these five variables are jointly normal. This means that
# if we pick any one of them and hold the other four fixed, the relationship
# with the outcome-- in this case, runs per game-- is linear, and the slopes for
# this relationship do not depend on the other four values that were held
# constant. If this is true, if this model holds true, then a linear model for
# our data is the following.

#     Yi = Bo + B1x1 + B2x2 + B3x3 + B4x4 + B5x5+Ei  

# With x1, x2, x3, x4, x5 representing bases on balls per game, singles per
# game, doubles per game, triples per game, and home runs per game,
# respectively.

# Using lm, we can quickly find the least square errors for the parameters using
# this relatively simple piece of code.

fit <- Teams %>%
  filter(yearID %in% 1961:2001) %>%
  mutate(BB = BB/G,
         singles = (H-X2B-X3B-HR)/G,
         doubles = X2B/G,
         triples = X3B/G,
         HR = HR/G,
         R = R/G) %>%
  lm(R ~ BB + singles + doubles + triples + HR, data = .)

# We can again use the tidy function to see the coefficients, the standard
# errors, and confidence intervals.

tidy(fit, conf.int = TRUE)
#          term   estimate  std.error statistic       p.value   conf.low  conf.high
# 1 (Intercept) -2.7692349 0.08620393 -32.12423 5.316854e-157 -2.9383923 -2.6000776
# 2          BB  0.3711735 0.01174347  31.60678 2.078153e-153  0.3481293  0.3942176
# 3     singles  0.5194231 0.01272339  40.82426 9.813525e-217  0.4944561  0.5443901
# 4     doubles  0.7711695 0.02260817  34.11022 8.934839e-171  0.7268057  0.8155333
# 5     triples  1.2397978 0.07680305  16.14256  2.238186e-52  1.0890877  1.3905078
# 6          HR  1.4434012 0.02435224  59.27181  0.000000e+00  1.3956150  1.4911875

# To see how well our metric actually predicts runs, we can predict the number
# of runs for each team in 2002 using the function predict to make the plot.
# Note that we did not use the 2002 year to create this metric. We used data
# from years previous to 2002. And here is the plot.

Teams %>%
  filter(yearID %in% 1961:2001) %>%
  mutate(BB = BB/G,
         singles = (H-X2B-X3B-HR)/G,
         doubles = X2B/G,
         triples = X3B/G,
         HR = HR/G,
         R = R/G) %>%
  mutate(R_hat = predict(fit, newdata = .)) %>%
  ggplot(aes(R_hat, R)) +
  geom_point(alpha = 0.5) +
  geom_text(aes(label=teamID), nudge_x = .05) +
  geom_smooth(method="lm", se=FALSE, color="black")

# Our model does quite a good job, as demonstrated by the fact that points from
# the observed versus predicted plot fall close to the identity line.

# So instead of using batting average or just the number of home runs as a
# measure for picking players, we can use our fitted model to form a more
# informative metric that relates more directly to run production. Specifically,
# to define a metric for player A, we imagine a team made up of players just
# like player A and use our fitted a regression model to predict how many runs
# this team would produce. The formula would look like this.

# -2.769 + 0.371 * BB + 0.519 * singles + 0.771 * doubles + 1.240 * triples + 1.443 * HR

# We're basically sticking in the estimated coefficients into the regression
# formula. However, to define a player's specific metric, we have a bit more
# work to do. Our challenge here is that we have derived the metrics for teams
# based on team-level summary statistics. For example, the home run value that
# is entered into the equation is home runs per game for the entire team. If you
# compute the home runs per game for a player, it will be much lower. As the
# total is accumulated by nine batters, not just one. Furthermore, if a player
# only plays part of the game and gets less opportunity than average, it's still
# considered a game play. So this means that their rates will be lower than they
# should be. For players, a rate that takes into account opportunities is a
# per-plate-appearance rate.

# To make the per-game team rate comparable to the per-plate-appearance player
# rate, we compute the average number of team plate appearances per game using
# this simple piece of code.

pa_per_game <- Batting %>%
  filter(yearID == 2002) %>%
  group_by(teamID) %>%
  summarize(pa_per_game = sum(AB+BB)/max(G)) %>%
  .$pa_per_game %>%
  mean
  
# Now, we're ready to use our metric. We're going to compute the
# per-plate-appearance rates for players available in 2002. But we're going to
# use data from 1999 2001. Because remember, we are picking players in 2002. We
# don't know what has happened yet.

# To avoid small sample artifacts, we're going to filter players with few plate
# interferences. Here is the calculation of what we want to do in one long line
# of code using tidyverse.

players <- Batting %>% filter(yearID %in% 1961:2001) %>%
  group_by(playerID) %>%
  mutate(PA = BB + AB) %>%
  summarize(G = sum(PA)/pa_per_game,
            BB = sum(BB)/G,
         singles = sum(H-X2B-X3B-HR)/G,
         doubles = sum(X2B)/G,
         triples = sum(X3B)/G,
         HR = sum(HR)/G,
         AVG = sum(H)/sum(AB),
         PA = sum(PA)) %>%
  filter(PA == 300) %>%
  select(-G) %>%
  mutate(R_hat = predict(fit, newdata = .))
    
# So we fit our model. And we have player-specific metrics. The player-specific
# predicted runs computer here can be interpreted as a number of runs we would
# predict a team to score if this team was made up of just that player, if that
# player batted every single time. The distribution shows that there's y
# variability across players, as we can see here.

players %>% ggplot(aes(R_hat)) +
  geom_histogram(binwidth = 0.5, color = "black")

# To actually build the teams, we will need to know the players' salaries, since
# we have a limited budget. Remember, we are pretending to be the Oakland A's in
# 2002 with only a $40 million budget. We also need to know the players'
# position. Because we're going to need one shortstop, one second baseman, one
# third baseman, et cetera. For this, we're going to have to do a little bit of
# data wrangling to combine information that is contained in different tables
# from the Lahman library.

# OK, so here we go. We start by adding the 2002 salaries for each player using
# this code.

players <- Salaries %>%
  filter(yearID == 2002) %>%
  select(playerID, salary) %>%
  right_join(players, by = "playerID")

# Next, we're going to add the defensive position. This is a little bit
# complicated, because players play more than one position each year. So here,
# we're going to pick the one position most played by each player using the
# top_n function. And to make sure that we only pick one position in the case of
# ties, we're going to take the first row if there is a tie. We also remove the
# OF position. Because this stands for outfielder, which is a generalization of
# three positions-- left field, center field, right field. We also remove
# pitchers, as they don't bat in the league that the Athletics play. Here is the
# code that does that.

players <- Fielding %>% filter(yearID == 2002) %>%
  filter(!POS %in% c("OF", "P")) %>%
  group_by(playerID) %>%
  top_n(1, G) %>%
  filter(row_number(G) == 1) %>%
  ungroup() %>%
  select(playerID, POS) %>%
  right_join(players, by="playerID") %>%
  filter(!is.na(POS) & !is.na(salary))
 
# Finally, we add their names and last names so we know who we're talking about.
# And here's a code that does that.

players <- Master %>% 
  select(playerID, nameFirst, nameLast, debut) %>%
  right_join(players, by="playerID")

# So now, we have a table with our predicted run statistic, some other
# statistic, the player's name, their position, and their salary. If we look at
# the top 10 players based on our run production statistic, you're going to
# recognize some names if you're a baseball fan.

players %>% select(nameFirst, nameLast, POS, salary, R_hat) %>%
  arrange(desc(R_hat)) %>%
  top_n(10)

# Note the very high salaries of these players in the top 10. In fact, we see
# that players with high metrics have high salaries. We can see that by making a
# plot 

players %>% ggplot(aes(salary, R_hat, color = POS)) +
  geom_point() +
  scale_x_log10()

# we do see some low-cost players with very high metrics. These would be
# great for our team. Unfortunately, these are likely young players that have
# not yet been able to negotiate a salary and are not going to be available in
# 2002. For example, the lowest earner on our top 10 list is Albert Pujols, who
# was a rookie in 2001. Here's a plot with players that debuted before 1997.

players %>% filter(debut < 1998) %>%
  ggplot(aes(salary, R_hat, color = POS)) +
  geom_point() +
  scale_x_log10()

# This removes all the young players. We can now search for good deals by
# looking at players that produce many more runs and others with similar
# salaries. We can use this table to decide what players to pick and keep our
# total salary below the $40 million Billy Beane had to work with.
