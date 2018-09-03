# -----------------------------------------------------------
#
# Correlation is Not Causation: spurious Correclation
#
# -----------------------------------------------------------

# Correlation is not causation is perhaps the most important lesson one learns
# in a statistics class. In this course, we have described tools useful for
# quantifying associations between variables, but we must be careful not to over
# interpret these associations. There are many reasons that a variable x can
# correlate with a variable y, without either being a cause for the other. Here
# we examine common ways that can lead to misinterpreting associations. The
# first example of how we can misinterpret associations are spurious
# correlations. The following comical example underscores that correlation is
# not causation. The example shows a very strong correlation between divorce
# rates and margarine consumption. The correlation is 0.93. Does this mean that
# margarine causes divorces, or do divorces cause people to eat more margarine?
# Of course, the answer to both these questions is no. This is just an example
# of what we call spurious correlations You can see many, many more observed
# examples in this website completely dedicated to spurious correlations.

# http://tylervigen.com/spurious-correlations.

# In fact, that's the title of the website. The cases presented in the spurious
# correlation site are all examples of what is generally called data dredging,
# or data phishing, or data snooping. It's basically a form of what in the
# United States, they call cherry picking. An example of data dredging would be
# if you look through many results produced by a random process, and pick the
# one that shows a relationship that supports the theory you want to defend. A
# Monte Carlo simulation can be used to show how data dredging can result in
# finding high correlations among variables that are theoretically uncorrelated.
# We'll save the results of a simulation into a table like this.

N <- 25
G <- 1000000
sim_data <- tibble(group = rep(1:G, each = N), X = rnorm(N*G), Y = rnorm(N*G))

# The first column denotes group and we simulated one million groups, each with
# 25 observations. For each group, we generate 25 observations which are stored
# in the second and third column. These are just random, independent normally
# distributed data. So we know, because we constructed the simulation, that x
# and y are not correlated. Next, we compute the correlation between x and y for
# each group, and look for the maximum.

res <- sim_data %>%
  group_by(group) %>%
  summarize(r = cor(X, Y))  %>%
  arrange(desc(r))

# Here are the top correlations.

res
# A tibble: 1,000,000 x 2
# group     r
# <int> <dbl>
# 01 135712 0.813
# 02 211530 0.812
# 03 805364 0.801
# 04  10533 0.774
# 05 513209 0.759
# 06 160226 0.754
# 07 558662 0.753
# 08 209620 0.742
# 09 461747 0.741
# 10 888802 0.738
# # ... with 999,990 more rows

# If we just plot the data from this particular group, it shows a convincing
# plot that x and y are, in fact, correlated.

sim_data %>% filter(group == res$group[which.max(res$r)]) %>%
  ggplot(aes(X, Y))  +
  geom_point()  +
  geom_smooth(method = 'lm')

# But remember that the correlations number is a random variable. Here's the
# distribution we just generated with our Monte Carlo simulation.

res %>% ggplot(aes(x=r)) + geom_histogram(binwidth = 0.1, color = "black")

# It is just a mathematical fact that if we observe random correlations that are
# expected to be 0, but have a standard error of about 0.2, the largest one will
# be close to 1 if we pick from among one million. Note that if we performed
# regression on this group and interpreted the p-value, we would incorrectly
# claim this was a statistically significant relation. Here's the code.

sim_data %>% 
  filter(group == res$group[which.max(res$r)])  %>%
  do(tidy(lm(Y ~ X, data = .)))
#         term    estimate std.error statistic      p.value
# 1 (Intercept) -0.06731419 0.1143601 -0.588616 5.618555e-01
# 2           X  0.66527665 0.1099877  6.048648 3.610918e-06

# Look how small the p-value is. This particular form of data dredging is
# referred to as p-hacking. P-hacking is a topic of much discussion because it
# is a problem in scientific publications. Because publishers tend to reward
# statistically significant results over negative results, there's an incentive
# to report significant results. In epidemiology in the social sciences for
# example, researchers may look for associations between an average outcome and
# several exposures, and report only the one exposure that resulted in a small
# p-value. Furthermore, they might try fitting several different models to
# adjust for confounding and pick the one model that yields the smallest
# p-value. In experimental disciplines, an experiment might be repeated more
# than once, and only the one that results in a small p-value are reported. This
# does not necessarily happen due to unethical behavior, but rather to
# statistical ignorance or wishful thinking. In advanced statistics courses,
# you'll learn methods to adjust for what is called the multiple comparison
# problem.


