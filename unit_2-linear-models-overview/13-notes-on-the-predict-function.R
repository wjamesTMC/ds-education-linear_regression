# Apart from describing relations, models also can be used to predict values for
# new data. For that, many model systems in R use the same function,
# conveniently called predict(). Every modeling paradigm in R has a predict
# function with its own flavor, but in general the basic functionality is the
# same for all of them.

# For example, a car manufacturer has three designs for a new car and wants to
# know what the predicted mileage is based on the weight of each new design. In
# order to do this, you first create a data frame with the new values — for
# example, like this:
     
new.cars <- data.frame(wt=c(1.7, 2.4, 3.6))

# Always make sure the variable names you use are the same as used in the model.
# When you do that, you simply call the predict() function with the suited
# arguments, like this:

predict(Model, newdata=new.cars)
# 1    2    3
# 28.19952 24.45839 18.04503

# So, the lightest car has a predicted mileage of 28.2 miles per gallon and the
# heaviest car has a predicted mileage of 18 miles per gallon, according to this
# model. Of course, if you use an inadequate model, your predictions can be
# pretty much off as well.

# In order to have an idea about the accuracy of the predictions, you can ask
# for intervals around your prediction. To get a matrix with the prediction and
# a 95 percent confidence interval around the mean prediction, you set the
# argument interval to ‘confidence’ like this:
     
predict(Model, newdata=new.cars, interval='confidence')
#        fit      lwr      upr
# 1 28.19952 26.14755 30.25150
# 2 24.45839 23.01617 25.90062
# 3 18.04503 16.86172 19.22834

# Now you know that — according to your model — a car with a weight of 2.4 tons
# has, on average, a mileage between 23 and 25.9 miles per gallon. In the same
# way, you can ask for a 95 percent prediction interval by setting the argument
# interval to ‘prediction’:
     
predict(Model,newdata=new.cars, interval='prediction')
#        fit      lwr      upr
# 1 28.19952 21.64930 34.74975
# 2 24.45839 18.07287 30.84392
# 3 18.04503 11.71296 24.37710

# This information tells you that 95 percent of the cars with a weight of 2.4
# tons have a mileage somewhere between 18.1 and 30.8 miles per gallon —
# assuming your model is correct, of course.

# If you’d rather construct your own confidence interval, you can get the
# standard errors on your predictions as well by setting the argument se.fit to
# TRUE. You don’t get a vector or a matrix; instead, you get a list with an
# element fit that contains the predictions and an element se.fit that contains
# the standard errors.

