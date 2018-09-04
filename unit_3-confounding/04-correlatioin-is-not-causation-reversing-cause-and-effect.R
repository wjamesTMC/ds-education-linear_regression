# -----------------------------------------------------------
#
# Correlation is Not Causation: reversing cause and effect
#
# -----------------------------------------------------------

# Another way associations are confounded with causation
# is when the cause and effect are reversed.
# An example of this is claiming that tutoring
# makes students perform worse because they test lower
# than peers that are not tutored.
# Here, the tutoring is not causing the low test, but the other way around.
# A form of this claim was actually made in an op ed in the New York Times,
# titled "Parental Involvement is Overrated".
# Consider this quote from the article.
# "When we examine whether regular help with homework
# had a positive impact on children's academic performance,
# we were quite startled by what we found.
# Regardless of family social class, racial, or ethnic background,
# or child's grade level, consistent homework
# help almost never improved test scores or grades.
# Even more surprising to us was that when parents regularly helped with homework,
# kids usually performed worse."
# A very likely possibility is that children needing regular parental help
# get this help because they don't perform well in school.
# To see another example, we're going to use one of the data sets
# that we've seen in this course.
# Specifically, we can easily construct an example of cause and effect reversal
# using the father and son height data.
# Note that if we fit the following model to the father and son height data,
# with x representing the father height, and y representing the son height,
# we do get a statistically significant result.
# You can see that with this simple code.
# This model fits the data very well.
# However, if we look at the mathematical formulation of the model,
# it could easily be incorrectly interpreted
# as to suggest that the son being tall caused the father to be tall.
# But given what we know about genetics and biology,
# we know it's the other way around.
# The model is technically correct.
# The estimates and p-value were obtained correctly as well.
# What is wrong here is simply the interpretation.