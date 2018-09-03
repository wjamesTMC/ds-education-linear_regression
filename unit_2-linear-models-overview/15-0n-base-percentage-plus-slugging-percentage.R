# -----------------------------------------------------------
#
# On Base Percentage Plus Slugging Percentage
#
# -----------------------------------------------------------

# Set up
library(tidyverse)
library(dslabs)
library(dplyr)
library(ggplot2)
library(Lahman)               # Contains all the baseball statistics
ds_theme_set()

# Since the 1980s sabermetricians have used a summary statistic different from
# batting average to evaluate players. They realized walks were important, and
# that doubles, triples, and home runs should be weighted much more than
# singles, and proposed the following metric. 

#      (BB / PA) + ((Singles + 2Doubles + 3Triples + 4HR) / AB)

# They call this on-base-percentage plus slugging percentage, or OPS. Today,
# this statistic has caught on, and you see it in ESPN and other sports
# networks. Although the sabermetricians are probably not using regression, this
# metric is impressively close to what one gets with regression to the summary
# statistic that we created. Here is the plot. They're very correlated.