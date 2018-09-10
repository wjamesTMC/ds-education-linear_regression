# -----------------------------------------------------------
#
# Tibbles: Differences from Data Frames
#
# -----------------------------------------------------------

# Set up
library(tidyverse)
library(dslabs)
library(ggplot2)
library(Lahman)
ds_theme_set()

# In this video, we're going to describe some of the main differences between
# tibbles and data frames. First, the print method for tibble is much more
# readable than that of a data frame. To see this, type teams on your console
# after loading the Baseball Lahman Database. And you will see a very, very long
# list of columns and rows. It's barely readable. Teams is a data frame with
# many rows and columns. That's why you see that. Nevertheless, the output just
# shows everything wraps around and is hard to read. It is so bad that we don't
# even print it here. We'll let you print it on your own screen. 

Teams
 
# Now if you convert this data frame to a tibble data frame...

as_tibble(Teams)

# ...the output is much more readable. Here's an example. That's the first main
# difference between tibbles and data frames. A second one is that if you subset
# the columns of a data frame, you may get back an object that is not a data
# frame. Here's an example. If we subset the 20th column, we get back an
# integer. That's not a data frame. With tibbles, this is not the case. Here's
# an example.

class(Teams[,20])
# [1] "integer" 

# If we subset a tibble, we get back a tibble This is useful in the tidyverse
# since functions require data frames as input. Now whenever you want to access
# the original vector that defines a column in a tibble, for this, you actually
# have to use the accessor dollar sign. Here's an example.

class(as_tibble(Teams)$HR)
# [1] "integer" 

# A related feature to this is that tibbles will give you a warning if you try
# to access a column that does not exist. That's not the case for data frames.
# For example, if we accidentally write hr in lowercase instead of uppercase,
# with a data frame, all we get is a NULL. No warning. This can make it quite
# hard to debug code. In contrast, if it's a tibble, and you try to access the
# lowercase hr column, which doesn't exist, you actually get a warning.

as_tibble(Teams)$hr
# NULL
# Warning message:
#   Unknown or uninitialised column: 'hr'. 

# A third difference is that while columns of a data frame need to be a vector
# of number strings or Boolean, tibbles can have more complex objects, such as
# lists or functions. Also note that we can create tibbles with the tibble
# function. So, look at this line of code. We're creating a column that actually
# has functions in it.

tibble(id = c(1, 2, 3), func = c(mean, median, sd))

# You can see the output here. 
# # > tibble(id = c(1, 2, 3), func = c(mean, median, sd))
# # A tibble: 3 x 2
# id func  
# <dbl> <list>
#   1     1 <fn>  
#   2     2 <fn>  
#   3     3 <fn>
   
# Finally, the last difference we describe is that tibbles can be grouped.
# The function group_by( ) returns a special kind of tibble, a grouped tibble. This
# class stores information that lets you know which rows are in which groups.
# The tidyverse functions, in particular the summarize functions, are aware of
# the group information. In the example we showed, we saw that the ln function,
# which is not part of the tidyverse, does not know how to deal with group
# tibbles. The object is basically converted to a regular data frame, and then
# the function runs ignoring the groups. This is why we only get one pair of
# estimates, as we see here. To make these non-tidyverse function better
# integrate with a tidyverse, we will learn a new function, the function do().