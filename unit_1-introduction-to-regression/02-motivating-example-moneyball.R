# --------------------------------------------------------------------------------
#
# Motivation
#
# --------------------------------------------------------------------------------

# As motivation for this course, we'll go back to 2002 and try to build a
# baseball team with a limited budget. Note that in 2002, the Yankees payroll
# was almost $130 million, and had more than tripled the Oakland A's $40 million
# budget.

# Statistics have been used in baseball since its beginnings. Note that the data
# set we will be using, included in the Lahman Library, goes back to the 19th
# century.

# The batting average, has been used to summarize a batter's success for
# decades. Other statistics such as home runs, runs batted in, and stolen bases,
# we'll describe all this soon, are reported for each player in the game
# summaries included in the sports section of newspapers. And players are
# rewarded for high numbers. Although summary statistics were widely used in
# baseball, data analysis per se was not. These statistics were arbitrarily
# decided on without much thought as to whether they actually predicted, or were
# related to helping a team win.

# In this course, to simplify the example we use, we'll focus on predicting
# scoring runs. We will ignore pitching and fielding, although those are
# important as well. We will see how regression analysis can help develop
# strategies to build a competitive baseball team with a constrained budget.

# In the first, we determine which recorded player specific statistics predict
# runs. In the second, we examine if players were undervalued based on what our
# first analysis predicts.