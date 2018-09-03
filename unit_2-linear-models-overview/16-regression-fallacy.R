# -----------------------------------------------------------
#
# Regression Fallacy
#
# -----------------------------------------------------------

# Set up
library(tidyverse)
library(dslabs)
library(dplyr)
library(ggplot2)
library(Lahman)               # Contains all the baseball statistics
ds_theme_set()

# Wikipedia defines the sophomore slump in the following way. A sophomore slump
# or sophomore jinx or sophomore jitters refers to an instance in which a
# second, or sophomore, effort fails to live up to the standard of the first
# effort. It is commonly used to refer to the apathy of students-- second year
# of high school, college, university-- the performance of athletes-- second
# season of play-- singers/bands-- second album-- television shows-- second
# season-- and movies-- sequels or prequels.

# We hear about the sophomore slump often in Major League Baseball. This is
# because in Major League Baseball, the Rookie of the Year-- this is an award
# that's given to the first year player that is judged to have performed the
# best-- usually does not perform as well during their second year. Therefore
# they call this the sophomore slump. Know, for example, that in a recent Fox
# Sports article they asked, will MLB's tremendous rookie class of 2015 suffer a
# sophomore slump. Now does the data confirm the existence of a sophomore slump?
# Let's take a look and examine the data for batting averages to see if the
# observation holds true. The data is available in the Lehman Library, but we
# have to do some work to create a table with the statistics for all the rookies
# of the year. Let's go through them.

# First, we create a table with player ID, their names and their most
# played position, using this code.

playerInfo <- Fielding                     %>%
  group_by(playerID)                       %>%
  arrange(desc(G))                         %>%
  slice(1)                                 %>%
  ungroup                                  %>%
  left_join(Master, by="playerID") %>%
  select(playerID, nameFirst, nameLast, POS)

# Now we will create a table with only the Rookie of the Year Award winners and
# add their batting statistics. We're going to filter out pitchers since
# pitchers are not given awards for batting. And we're going to focus on
# offense. Specifically, we'll focus on batting average since it is the summary
# that most pundits talk about when discussing the sophomore slump. So we write
# this piece of code to do this.

ROY <- AwardsPlayers %>%
  filter(awardID == "Rookie of the Year")%>%
  left_join(playerInfo, by="playerID")  %>%
  rename(rookie_year = yearID)  %>%
  right_join(Batting, by="playerID")  %>%
  mutate(AVG = H/AB) %>%
  filter(POS != "P")

# Now we'll keep only the rookie and sophomore seasons and remove players that
# did not play a sophomore season. And remember, now we're only looking at
# players that won the Rookie of the Year Award. This code achieves what we
# want.

ROY <-ROY %>%
  filter(yearID == rookie_year | yearID == rookie_year + 1)  %>%
  group_by(playerID)  %>%
  mutate(rookie = ifelse(yearID == min(yearID), "rookie", "sophomore"))  %>%
  filter(n() == 2)  %>%
  ungroup  %>%
  select(playerID, rookie_year, rookie, nameFirst, nameLast, AVG)

# Finally, we will use the spread function to have one column for the rookie and
# another column for the sophomore years' batting averages. For that we use this
# simple line of code.

ROY <- ROY %>% spread(rookie, AVG) %>% arrange(desc(rookie))

# Now we can see the top performers in their first year.

ROY
# A tibble: 99 x 6
# playerID  rookie_year nameFirst nameLast rookie sophomore
# <chr>           <int> <chr>     <chr>     <dbl>     <dbl>
#  1 mccovwi01        1959 Willie    McCovey   0.354     0.238
#  2 suzukic01        2001 Ichiro    Suzuki    0.350     0.321
#  3 bumbral01        1973 Al        Bumbry    0.337     0.233
#  4 lynnfr01         1975 Fred      Lynn      0.331     0.314
#  5 pujolal01        2001 Albert    Pujols    0.329     0.314
#  6 troutmi01        2012 Mike      Trout     0.326     0.323
#  7 braunry02        2007 Ryan      Braun     0.324     0.285
#  8 olivato01        1964 Tony      Oliva     0.323     0.321
#  9 hargrmi01        1974 Mike      Hargrove  0.323     0.303
# 10 darkal01         1948 Al        Dark      0.322     0.276
# ... with 89 more rows

# These are the Rookie of the Year Award winners. And we're showing their rookie
# season batting average and their sophomore season batting average. Look
# closely and you will see the sophomore slump. It definitely appears to be
# real. In fact, the proportion of players that have a lower batting average
# their sophomore years is 68%. So is it jitters? Is it a jinx?

# To answer this question, let's turn our attention to all players. We're going
# to look at the 2013 season and 2014 season. And we're going to look at players
# that batted at least 130 times. This is a minimum needed to win the Rookie of
# the Year. We're going to perform a similar operation as we did before to
# construct this data set. Here is the code.

two_years <- Batting %>%
  filter(yearID %in% 2013:2014)  %>%
  group_by(playerID, yearID)  %>%
  filter(sum(AB) >= 130)  %>%
  summarize(AVG = sum(H)/sum(AB))  %>%
  ungroup  %>%
  spread(yearID, AVG) %>%
  filter(!is.na('2013') & !is.na('2014'))  %>%
  left_join(playerInfo, by="playerID")  %>%
  filter(POS != "P")  %>%
  select(-POS) %>%
  arrange(desc('2013'))  %>%
  select(-playerID)

# Now let's look at the top performers of 2013 and then look at their
# performance in 2014.

# <<< insert results when available >>>

# Note that the same pattern arises when we look at the top performers. Batting
# averages go down for the top performers. But these are not rookies. So this
# can't be explained with a sophomore slump. Also know what happens to the worst
# performers of 2013. Here they are.

arrange(two_years, '2013')

# <<< insert results when available >>>

# Their batting averages go up in their second season in 2014. Is this some sort
# of reverse sophomore slump? It is not. There is no such thing as a sophomore
# slump. This is all explained with a simple statistical fact. The correlation
# of performance in two separate years is high but not perfect. Here is the data
# for 2013 performance and 2014 performance.

two_years %>% ggplot(aes('2013', '2014')) +
  geom_point()

# You can see it's correlated. But it's not perfectly correlated. The
# correlation is 0.46.

summarize(two_years, cor('s013', '2014'))
# A tibble: 1 x 1
# 'cor(\'2013\', \'2014\')'
#                     >dbl>
#                     0.460

# The data look very much like a bivariate normal distribution, which means that
# if we were to predict the 2014 batting average, let's call it y, for any given
# player that had a 2013 batting average of x, we would use the regression
# equation, which would be this.

((Y - .255) / 0.32) = 0.46((X - .261) / 0.23)

# Because a correlation is not perfect, regression tells us that on average, we
# expect high performers from 2013 to do a little bit worse in 2014. This is
# regression to the mean. It's not a jinx. It's just due to chance. The rookies
# of the year are selected from the top values of x So it is expected that their
# y will regress to the mean.