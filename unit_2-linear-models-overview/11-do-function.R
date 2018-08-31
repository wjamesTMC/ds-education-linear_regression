

In this video, we'll describe the very useful do( ) function.
The tidyverse functions know how to interpret group tibbles.
Furthermore, to facilitate stringing commands through the pipe,
tidyverse function consistently return data frames.
Since this assures that the output of 1 is accepted as the input of another.
But most our functions do not recognize group tibbles,
nor do they return data frames.
The lm( ) function is an example.
The do( ) function serves as a bridge between our functions,
such as lm( ) and the tidyverse.
The do( ) function understands group tibbles and always returns a data
frame.
So let's try to use the do( ) function to fit a regression line to each home
run strata.
We would do it like this.
Notice that we did in fact fit a regression line to each strata.
But the do( ) function would create a data frame with the first column being
the strata value.
And a column named fit.
We chose that name.
It could be any name.
And that column will contain the result of the lm( ) call.
Therefore, the return table has a column with lm( ) objects in the cells,
which is not very useful.
Also note that if we do not name a column,
then do( ) will return the actual output of lm( ), not a data frame.
And this will result in an error since do( ) is expecting a data frame
as output.
If you write this, you will get the following error.
For a useful data frame to be constructed,
the output of the function, inside do( ), must be a data frame as well.
We could build a function that returns only what
you want in the form of a data frame.
We could write for example, this function.
And then we use to do( ) without naming the output,
since we are already getting a data frame.
We can write this very simple piece of code
and now we get the expected result. We get the slope for each strata
and the standard error for that slope.
If we name the output, then we get a column containing the data frame.
So if we write this piece of code, now once again,
we get one of these complex tibbles with a column
having a data frame in each cell.
Which is again, not very useful.
All right.
Now we're going to cover one last feature of do( ).
If the data frame being returned has more than one row,
these will be concatenated appropriately.
Here's an example in which return both estimated parameters.
The slope and intercept.
We write this piece of code.
And now we use the do( ) function as we used it before,
and get a very useful tibble, giving us the estimates of the slope
and intercept, as well as the standard errors.
Now, if you think this is all a bit too complicated, you're not alone.
To simplify things, we're going to introduce the broom package,
which was designed to facilitate the use of model fitting functions such as lm(
) with the tidyverse.