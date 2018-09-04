# -----------------------------------------------------------
#
# Correlation is Not Causation: Confounders
#
# -----------------------------------------------------------

# Set Up
library(tidyverse)
library(tidyr)
library(dslabs)
library(dplyr)
library(broom)
library(ggplot2)
ds_theme_set()

# Confounders are perhaps the most common reason that leads to associations
# being misinterpreted. If X and Y are correlated, we call Z a confounder if
# changes in Z cause changes in both X and Y. Earlier, when studying baseball
# data, we saw how home runs was a confounder that resulted in higher
# correlation than expected when studying the relationship between bases and
# balls and runs.

# In some cases, we can use linear models to account for confounders, as we did
# in the baseball example. But it is not always possible. Incorrect
# interpretation due to confounders are ubiquitous in the lay press. They are
# sometimes hard to detect. We examined admission data from UC Berkeley majors
# from 1973 that showed that more men were being admitted than women. 44% men
# were admitted compared to 30% women. Here's the data.

data(admissions)
admissions
#     major gender admitted applicants
#  1      A    men       62        825
#  2      B    men       63        560
#  3      C    men       37        325
#  4      D    men       33        417
#  5      E    men       28        191
#  6      F    men        6        373
#  7      A  women       82        108
#  8      B  women       68         25
#  9      C  women       34        593
# 10      D  women       35        375
# 11      E  women       24        393
# 12      F  women        7        341

# The percent of men and women that got accepted can be computed from this data
# using this simple piece of code.

admissions %>% group_by(gender) %>%
     summarize(percentage = round(sum(admitted*applicants)/sum(applicants),1))
# A tibble: 2 x 2
#  gender  percentage
#   <chr>       <dbl>
# 1 men          44.5
# 2 women        30.3

# A statistical test, the chi-squared test that we learned about in a previous
# course, clearly rejects the hypothesis that gender and admissions are
# independent.

admissions %>% group_by(gender) %>%
     summarize(total_admitted = round(sum(admitted/100*applicants)),
               not_admitted = sum(applicants) - sum(total_admitted)) %>%
     select(-gender) %>%
     do(tidy(chisq.test(.)))
# A tibble: 1 x 4
#   statistic  p.value parameter method                                                   
#       <dbl>    <dbl>     <int> <chr>                                                    
# 1      91.6 1.06e-21         1 Pearson's Chi-squared test with Yates' continuity correction
     
# The p value is very small. But closer inspection shows a paradoxical result.
# Here are the percent of admissions by major.

admissions %>% select(major, gender, admitted) %>%
     spread(gender, admitted) %>%
     mutate(women_minus_men = women - men)
#   major men women women_minus_men
# 1     A  62    82              20
# 2     B  63    68               5
# 3     C  37    34              -3
# 4     D  33    35               2
# 5     E  28    24              -4
# 6     F   6     7               1

# Four out of the six majors favor women. But more importantly, all the
# differences are much smaller than the 14% difference that we see when
# examining the totals. The paradox is that analyzing the totals suggest a
# dependence between admissions and gender. But when the data is grouped by
# major, this dependence seems to disappear. What's going on? This actually can
# happen if an uncounted confounder is driving most of the variability.

# So let's define three variables. X is 1 for men and 0 for women, Y is 1 for
# those admitted and 0 otherwise, and Z quantifies how selective the major is. A
# gender bias claim would be based on the fact that this probability is higher
# when X is 1 than when X is 0.

#     Pr(Y = 1|X = x)

# But Z is an important confounder. Clearly, Z is associated with Y, because the
# more selective a major, the lower the probability that someone enters that
# major. But is major selectivity, which we call Z, associated with gender? One
# way to see this is to plot the total percent admitted to a major versus the
# percent of women that make up the applicants. We can see that in this plot.

admissions %>%
     group_by(major) %>%
     summarize(major_selectivity = sum(admitted*applicants)/sum(applicants),
               percent_women_applicants = sum(applicants*(gender=="women")/sum(applicants))*100) %>%
     ggplot(aes(major_selectivity, percent_women_applicants, label = major)) +
     geom_text()

# There seems to be an association. The plot suggests that women were much more
# likely to apply to the two hard majors. Gender and major selectivity are
# confounded. Compare, for example, major B and major E. Major E is much harder
# to enter than major B. And over 60% of applicants to major E were women, while
# less than 30% of the applicants of major B were women.

# The following plot shows the percentage of applicants that were accepted by
# gender.

admissions %>%
     mutate(percent_admitted = admitted*applicants/sum(applicants)) %>%
     ggplot(aes(gender, y = percent_admitted, fill = major)) +
     geom_bar(stat = "identity", position = "stack")

# The color here represents major. It also breaks down the acceptance rates by
# major. The size of the colored bar represent the percent of each major
# students that were admitted to. This breakdown lets us see that the majority
# of accepted men came from two majors, A and B. It also lets us see that few
# women apply to these two easy majors.

# What the plot does not show us is what's the percent admitted by major.
# In this plot, 

admissions %>%
     ggplot(aes(major, admitted, col = gender, size = applicants)) +
     geom_point()

# ...we can see that if we condition or stratify by major, and then look at
# differences, we control for the confounder, and the effect goes away. Now we
# see that major by major, there's not much difference. The size of the dot
# represents the number of applicants, and explains the paradox. We see large
# red dots and small blue dots for the easiest majors, A and B.

# If we first stratify by major, compute the difference, and then average,
# we find that the percent difference is actually quite small.

admissions %>% group_by(gender) %>%
     summarize(average = mean(admitted))
#   A tibble: 2 x 2
#  gender average
#  <chr>    <dbl>
# 1 men      38.2
# 2 women    41.7

# This is actually an example of something t-hat is called Simpson's paradox,
# which we will describe in the next video.

str(admissions)