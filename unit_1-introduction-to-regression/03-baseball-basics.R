# -----------------------------------------------------------
#
# Baseball Basics
#
# -----------------------------------------------------------

# Terms
# (1) Plate appearance (PA)
# (2) Outcomes
#     (a) An out (Failure)
#     (b) Reaching base (Success)
#     A home run is the best possible outcome (results in a run)
# (3) There is chance involved in all this
# (4) When you hit the ball, you want to pass as many bases as possible

# The 5 ways to succeed
# (1) Base on balls (a walk)
# (2) A single
# (3) A double
# (4) A triple
# (5) A home run

# Getting to home once on base
# (1) Another batter hits successfully
# (2) Stealing

# Historical statistics
# The batting average has been considered the most important
# An at bat = number of times you get a hit or make an out
# Note that bases on balls are excluded (not = hits)
# Batting average = H / AB (hits divided by at bats)
# 
# Success rates vary from player to player fropm ~20% to 38%
# Key insight: batting average ignores bases on balls
# However, the number of stolen bases is counted
#    But note that stealing bases also produces outs
#    Do they help a t3eam?
#    Can we use data science to determine if it is better
#    to pay for a base on balls or a stolen base?
# This hard because so much depends on the other team members

# We can examine team-level statistics (how do teams with many
# stolen bases compare with teams with few?). What about bases
# on balls? We have the data to examine this.