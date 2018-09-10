# --------------------------------------------------------------------------------
#
# Some notes on Tibbles
#
# --------------------------------------------------------------------------------

# Tibbles Tibbles are a modern take on data frames. They keep the features that
# have stood the test of time, and drop the features that used to be convenient
# but are now frustrating (i.e. converting character vectors to factors).
#
# Creating tibble() is a nice way to create data frames. It encapsulates best
# practices for data frames:
#
# It never changes an input’s type (i.e., no more stringsAsFactors = FALSE!).

tibble(x = letters)
#> # A tibble: 26 x 1
#>   x    
#>   <chr>
#> 1 a    
#> 2 b    
#> 3 c    
#> 4 d    
#> # ... with 22 more rows

# This makes it easier to use with list-columns:
     
tibble(x = 1:3, y = list(1:5, 1:10, 1:20))
#> # A tibble: 3 x 2
#>       x y         
#>   <int> <list>    
#> 1     1 <int [5]> 
#> 2     2 <int [10]>
#> 3     3 <int [20]>

# List-columns are most commonly created by do(), but they can be useful to
# create by hand.
#
# It never adjusts the names of variables:

names(data.frame(`crazy name` = 1))
#> [1] "crazy.name"
names(tibble(`crazy name` = 1))
#> [1] "crazy name"

# It evaluates its arguments lazily and sequentially:
     
tibble(x = 1:5, y = x ^ 2)
#> # A tibble: 5 x 2
#>       x     y
#>   <int> <dbl>
#> 1     1  1.00
#> 2     2  4.00
#> 3     3  9.00
#> 4     4 16.00 
#> # ... with 1 more row

# It never uses row.names(). The whole point of tidy data is to store variables
# in a consistent way. So it never stores a variable as special attribute.
#
# It only recycles vectors of length 1. This is because recycling vectors of
# greater lengths is a frequent source of bugs.

# Coercion 

# To complement tibble(), tibble provides as_tibble() to coerce objects into
# tibbles. Generally, as_tibble() methods are much simpler than as.data.frame()
# methods, and in fact, it’s precisely what as.data.frame() does, but it’s
# similar to do.call(cbind, lapply(x, data.frame)) - i.e. it coerces each
# component to a data frame and then cbinds() them all together.
#
# as_tibble() has been written with an eye for performance:

if (requireNamespace("microbenchmark", quiet = TRUE)) {
     l <- replicate(26, sample(100), simplify = FALSE)
     names(l) <- letters
     
     microbenchmark::microbenchmark(
          as_tibble(l),
          as.data.frame(l)
     )
}
#> Loading required namespace: microbenchmark

# The speed of as.data.frame() is not usually a bottleneck when used
# interactively, but can be a problem when combining thousands of messy inputs
# into one tidy data frame.

# Tibbles vs data frames There are three key differences between tibbles and
# data frames: printing, subsetting, and recycling rules.
#
# Printing When you print a tibble, it only shows the first ten rows and all the
# columns that fit on one screen. It also prints an abbreviated description of
# the column type:
     
tibble(x = 1:1000)
#> # A tibble: 1,000 x 1
#>       x
#>   <int>
#> 1     1
#> 2     2
#> 3     3
#> 4     4
#> # ... with 996 more rows

# You can control the default appearance with options:
     
# options(tibble.print_max = n, tibble.print_min = m): 

# If there are more than n rows, print only the first m rows. Use
# options(tibble.print_max = Inf) to always show all rows.

# options(tibble.width = Inf) will always print all columns, regardless of the
# width of the screen.

# Subsetting 

# Tibbles are quite strict about subsetting. [ always returns another tibble.
# Contrast this with a data frame: sometimes [ returns a data frame and
# sometimes it just returns a vector:
                                                                                                                              
df1 <- data.frame(x = 1:3, y = 3:1)
class(df1[, 1:2])
#> [1] "data.frame"
class(df1[, 1])
#> [1] "integer"

df2 <- tibble(x = 1:3, y = 3:1)
class(df2[, 1:2])
#> [1] "tbl_df"     "tbl"        "data.frame"
class(df2[, 1])
#> [1] "tbl_df"     "tbl"        "data.frame"

# To extract a single column use [[ or $:
                                       
class(df2[[1]])
#> [1] "integer"
class(df2$x)
#> [1] "integer"

# Tibbles are also stricter with $. Tibbles never do partial matching, and will throw a warning and return NULL if the column does not exist:
     
df <- data.frame(abc = 1)
df$a
#> [1] 1

df2 <- tibble(abc = 1)
df2$a
#> Warning: Unknown or uninitialised column: 'a'.
#> NULL

#As of version 1.4.1, tibbles no longer ignore the drop argument:
     
data.frame(a = 1:3)[, "a", drop = TRUE]
#> [1] 1 2 3
tibble(a = 1:3)[, "a", drop = TRUE]
#> [1] 1 2 3

# Recycling
# When constructing a tibble, only values of length 1 are recycled. The first
# column with length different to one determines the number of rows in the
# tibble, conflicts lead to an error. This also extends to tibbles with zero
# rows, which is sometimes important for programming:
     
tibble(a = 1, b = 1:3)
#> # A tibble: 3 x 2
#>       a     b
#>   <dbl> <int>
#> 1  1.00     1
#> 2  1.00     2
#> 3  1.00     3

tibble(a = 1:3, b = 1)
#> # A tibble: 3 x 2
#>       a     b
#>   <int> <dbl>
#> 1     1  1.00
#> 2     2  1.00
#> 3     3  1.00

tibble(a = 1:3, c = 1:2)
#> Error: Column `c` must be length 1 or 3, not 2

tibble(a = 1, b = integer())
#> # A tibble: 0 x 2
#> # ... with 2 variables: a <dbl>, b <int>

tibble(a = integer(), b = 1)
#> # A tibble: 0 x 2
#> # ... with 2 variables: a <int>, b <dbl>