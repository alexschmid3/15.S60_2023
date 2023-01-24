# -------------------------------------------------------------------------
# Hands-On: Data Wrangling and Visualization in R
# By Raluca Cobzaru
# January 24th, 2023
# Credit to Josh Wilde 
# -------------------------------------------------------------------------

########## ----------------------------------------------------------------
# (entering at Hands-on: user-defined functions)
########## ----------------------------------------------------------------

######################
####### Introduction to R, RStudio and the tidyverse
######################

##########
# Exercise 
# 1. Open `wrangling_student.R` in `R`.
# 2. Session -> Set Working Directory -> To Source File Location. 
##########

########## Running Code in RStudio

# To run a command in RStudio, you can either write it in the console or select 
# its line(s) and press Ctrl+Enter/Command+Return.
#
# A multi-line function is considered a single command and will run in its 
# entirety with Ctrl+Enter/Command+Return.
# 
# Note that the cursor automatically moves to the next R command once you press 
# Ctrl+Enter/Command+Return.

########## Clear the Workspace

# Whenever you begin working in R, it is usually (note that I said usually and 
# not always) a good idea to clear your workspace. 
rm(list = ls())

########## Load Packages
# After clearing the workspace, the general convention is to first load in any 
# packages that you intend to use in your script.
# 
# If you did the homework, you already installed the library we need, 
# but if not, install it with: `install.packages('tidyverse')`.
# 
# Now that we have the libraries installed, we'll load them into our current 
# R session:

library(tidyverse)

########## Import and Explore our Data 

# Let's load up the AirBnB data.
raw_listings <- read_csv('data/listings.csv')

# We can look in Environment and see there's actually 3,585 rows of 95 variables!
# 
# The 'summary' command gives summary statistics
summary(raw_listings)  

########## R Data Type Error and User-Defined Functions

# One reason that data exploration and manipulation can be time consuming is 
# that simple calculations can often reveal annoying data errors: 
mean(raw_listings$price)

# R is telling us that the prices are character strings and not numeric.
# 
# Other vector types in R are `logical`, `integer`, `double`, `complex`, 
# `character`, or `raw`.

# The prices were given the type `character` because the column contains 
# punctuation. But, we know they should be doubles so we will write a 
# function to correct this.

# The 'function()' command allows us to create a function as an R object.

# We will use the 'gsub' function to replace all occurrences of a regex pattern 
# with a new pattern.
#
# Tip: If you need a refresher on regular expression patterns, you can call
# ?base::regex (the `base` package includes R's built-in functions)
# 
# The blackslash \ helps us escape special behavior.
# 
# Now we can define a function to remove all dollar signs in the price and cast 
# this column to a double:
clean_price <- function(price) {
  as.numeric(gsub('\\$|,', '', price))
}

# The following shorthand is available for one-liners:
clean_price <- function(price) as.numeric(gsub('\\$|,', '', price))

########## ----------------------------------------------------------------
# (exiting to Hands-on: user-defined functions)
########## ----------------------------------------------------------------


########## ----------------------------------------------------------------
# (entering at Hands-on: Verbs, aggregation, pivoting)
########## ----------------------------------------------------------------

########## Putting the Verbs Together

# Finally, let's combine some of these verbs to make a clean dataset to work with. 

# We want to make sure our data has a correct price column and no missing bedroom 
# or bathroom columns. We'll assign it to a new dataframe named `listings`. 

listings <- raw_listings %>%
  filter(!is.na(bedrooms), 
         !is.na(bathrooms)) %>%
  mutate(nprice = clean_price(price),
         weekly_price = clean_price(weekly_price),
         monthly_price = clean_price(monthly_price))

# The `is.na()` function returns `TRUE` if something is `NA`, so `!is.na()` 
#  (read: "*not* is NA") returns the opposite. (There is also a `is.nan()` 
#                                               function.)

########## Aggregation

# Now, let's see some summary statistics, like the average price for a listing
# Let's take our clean dataset and `summarize` it to find out.
listings %>% 
  summarize(avg_price = mean(nprice))

# But what if we want to group our data by the variable `neighborhood_cleansed` 
# and then calculate a mean for each individual group?

# We can do this using the `group_by` function.
listings %>%
  group_by(neighbourhood_cleansed) %>%
  summarize(avg_price = mean(nprice))

# Whenever we use means, it is a good idea to check for outliers.
# The `n()` function gives a count of how many rows we have in each group, and 
# `median()` does what you would expect.
# For more help, see ?n()

########## 
# Exercise: Output two columns, num_listings and med_price that calculate the number 
# of listings and median price by neighborhood.
########## 

########## 
# ANSWER:
########## 
listings %>%
  group_by(neighbourhood_cleansed) %>%
  summarize(med_price = median(nprice),
            num_listings = n())

########## Putting (More) Verbs Together

# We can also pick a few neighborhoods to look at within the `filter` command
# by using the `%in%` keyword with a list of the neighborhoods we want.
# We use the 'c()' function to combine its arguments in a vector.

listings %>%
  filter(neighbourhood_cleansed %in% c('Downtown', 'Back Bay', 'Chinatown')) %>%
  group_by(neighbourhood_cleansed) %>%
  summarize(avg_price = mean(nprice),
            med_price = median(nprice),
            num_listings = n()) %>%
  arrange(med_price)

# We have now seen: `select`, `filter`, `count`, `summarize`, `mutate`, 
# `group_by`, and `arrange`. This is the majority of the dplyr "verbs" for 
# operating on a single data table (although [there are many more]
# (https://cran.r-project.org/web/packages/dplyr/dplyr.pdf)), 
# but as you can see, learning new verbs is pretty intuitive. 
# What we have already gives us enough tools to accomplish a 
# large swath of data analysis tasks.

########## ----------------------------------------------------------------
# (exiting at Hands-on: Verbs and aggregation)
########## ----------------------------------------------------------------

########## ----------------------------------------------------------------
# (entering at Hands-on: Pivoting)
########## ----------------------------------------------------------------

######## Pivoting

# To pivot **wide** data into a **long** format, we can use the `pivot_longer` 
# function.  

long_price <- listings %>%
  select(id, name, nprice, weekly_price, monthly_price) %>%
  pivot_longer(cols = c("nprice", "weekly_price", "monthly_price"), 
               names_to = "price_type",
               values_to = "price_value") %>%
  filter(!is.na(price_value))

long_price %>% head()  # take a peek

# Let's break down what `pivot_longer` does:
# 
# - The first argument is the columns that we would like to combine.
# - The second argument is the name of the new column which will store the 
# column names from the columns that we are combining. 
# - The third argument is the name of the new column that will contain the 
# values from the column we are combining.

######## 
# Exercise: How could we get `long_price` back into it's original, wide format? 
# (Hint: look at the help for `pivot_wider()`.)
######## 

######## 
# ANSWER: To pivot the data back into its original wide format, we can use `pivot_wider`. 
######## 
long_price %>% 
  pivot_wider(names_from = price_type,
              values_from = price_value) %>%
  head()

# There are lots of times we need this little "trick," so you should get 
# comfortable with it.

########## ----------------------------------------------------------------
# (exiting at Hands-on: Pivoting)
########## ----------------------------------------------------------------

########## ----------------------------------------------------------------
# (entering at Hands-on: Joins and Viz Preview)
########## ----------------------------------------------------------------

######## Joins

# Let's say we have a tidy table of the number of bathrooms and bedrooms for 
# each listing, which we get by doing
rooms <- listings %>%
  select(name, bathrooms, bedrooms) %>%
  pivot_longer(cols = c("bathrooms","bedrooms"), 
               names_to = "room_type",
               values_to = "number")

# Let's say we also have a table of the cleaned daily price for each listing,
# which we can get from:
prices <- listings %>%
  select(name, nprice) %>%
  mutate(price = as.numeric(gsub('\\$|,', '', nprice))) %>%
  select(name, price)

# Now, we can do a full join to add a `price` column.
rooms_prices <- full_join(rooms, prices, by='name')

# This gives us a table with the number of bed/bathrooms separated out in a tidy 
# format. This format is useful because it is amenable to `ggplot`. 

# Visualization is our next topic, 
# and even though the syntax will be foreign, let's take a sneak peak at what we
# can do with tidy data.

########## Visualization Preview

# Let's try a boxplot of price, by number of rooms, and use 
# facets to separate out the two different room types (bedroom and bathroom).  
# (We will also filter out half-rooms just to help clean up the plot.)

rooms_prices %>%
  filter(!is.na(number), number %% 1 == 0) %>%
  mutate(number = as.factor(number)) %>%
  ggplot(aes(x = number, 
             y = price, 
             fill = room_type)) +
  geom_boxplot() +
  facet_grid(~room_type) +
  labs(x = '# of Rooms', 
       y = 'Daily price', 
       fill = 'Room type', 
       title = 'Daily price by room type') + 
  theme_bw()

# This visualization shows us that there is a trend of 
# increasing price with increasing number of bathrooms and bedrooms, but it is 
# not a strict one, and seems to taper off at around 4 bedrooms for example.

# Don't worry about the specifics of the code above - we're getting to that! 
# The takeaway is that by putting our data in tidy format, creating an 
# interesting, interpretable plot with very readable code is simple and fast.

########## ----------------------------------------------------------------
# (exiting at Hands-on: Joins and Viz Preview)
########## ----------------------------------------------------------------

########## ----------------------------------------------------------------
# (entering at Hands-on: ggplot)
########## ----------------------------------------------------------------

######################
####### Visualization
######################

# First, let's use our tidyverse tools to make the dataset we're interested in 
# working with.
# Let's try grouping listings together if they have the same review score and
# the same number of bedrooms, then take the median within each group. Oh, and 
# just filter out those NAs.

by.rating.bedroom <- listings %>%
  filter(!is.na(review_scores_rating)) %>%
  group_by(review_scores_rating, bedrooms) %>%
  summarize(med.price = median(nprice), listings = n()) %>% 
  select(review_scores_rating, bedrooms, listings, everything()) %>% 
  ungroup()

by.rating.bedroom %>% head()

# Now, we can chain this into the `ggplot` function. The 'geom_point()' command 
# creates scatterplots.

by.rating.bedroom %>%
  ggplot(aes(x=review_scores_rating, y=med.price)) +
  geom_point()

######### Aesthetics

# Behold: we specify our Data (`listings`), our Aesthetic mapping (`x` 
# and `y` to columns of the data), and our desired Geometry (`geom_point`).  
# We are gluing each new element together with `+` signs.   Clean, intuitive, 
# and on the way to being pretty. 
# But most importantly, this is much more extensible. Let's see how.

# **Adding aesthetics:** Suppose we want to see these points broken out by the 
# number of bedrooms. One way to get that extra dimension is to color these 
# points by the number of bedrooms. 

by.rating.bedroom %>%
  ggplot(aes(x=review_scores_rating, y=med.price, color=factor(bedrooms))) +
  geom_point()

# That `factor` essentially tells ggplot to treat `bedrooms` as categorical 
# rather than numeric.

######### Geoms

# **Adding geoms:** We can also keep adding additional geoms to the plot to visualize 
# the same data in different ways. 

# In the following example, we throw in a linear best-fit line for each bedroom class. 
# Note that the same x, y, and color aesthetics propagate through all the geoms. 

# The `geom_smooth` command creates a line that represents smoothed conditional means.

by.rating.bedroom %>%
  ggplot(aes(x=review_scores_rating, y=med.price, color=factor(bedrooms))) +
  geom_point() +
  geom_smooth(method = lm)

# `lm` stands for linear smooths. We can also choose other methods, e.g. loess 
# for locally smooths.

########
# Exercise: Let's try an exercise to integrate what we've learned so far, and to
# learn a couple new tricks. 

# Draw a scatterplot of the listings such that
# - Entries are grouped by review_scores_rating
# - The plot is median price against review score
# - Bubbles are blue and 50% transparent (hint: look up geom_point())
# - Size of the bubbles indicate how many reviews received by that group
# - Title is `Median Price Trend by Review Score` and legend has label `# Reviews`
#   (hint: look up labs())
# - Background is white (hint: look up theme_bw())
########

######## 
# ANSWER
########
listings %>%
  filter(!is.na(review_scores_rating)) %>%
  group_by(review_scores_rating) %>%
  summarize(med.price = median(nprice),
            num = n()) %>%
  ggplot(aes(x = review_scores_rating, y=med.price, size=num)) + 
  geom_point(color = 'blue', alpha = 0.5) + 
  labs(title = 'Median Price Trend by Review Score', size = '# Reviews') + 
  theme_bw()

######### Saving a Plot	

# By the way, you can flip back through all the plots you've created in RStudio 
# using the navigation arrows, and it's also always a good idea to "Zoom" in on plots.  	

# When you finally get a plot you like, you can "Export" it to a PDF (recommended), 
# image, or just to the clipboard.

# Another way to save a plot is to use `ggsave()`, which saves the last plot by 
# default, for example: 
ggsave('price_vs_score.pdf') 

# The plot will be saved by default to the working directory. 

######### Exploring `ggplot` geoms

# Other geometries: line plots, box plots, and bar (column) plots
# We will now quickly run through a few of the other geometry options available, 
# but truly, we don't need to spend a lot of time here since each follows the 
# same grammar as before.
# Note that **geoms are stackable** -- we can just keep adding them on top of 
# each other. 

# First let's group the listings by neighbourhood_cleansed and save the summary 
# information that we want to plot into its own object:	
by.neighbor <- listings %>%	
  group_by(neighbourhood_cleansed) %>%	
  summarize(med.price = median(nprice))

######### Line Plots

# We have already seen smooth line plots in some previous example. Let's now see
# a standard line plot by running `geom_line`:
by.neighbor %>%	
  ggplot(aes(x=neighbourhood_cleansed, y=med.price)) + 	
  geom_point() +	
  geom_line(group=1)	

# Because our `x` is not a continuous variable, but a list of neighborhoods, 
# `geom_line` thinks the neighborhoods are categories that each need their own 
# line. Thus, we had to specify `group=1` to group all neighborhoods into one
# category, which corresponds to one line.

# This is misleading, since it falsely implies continuity of price between 
# neighborhoods based on the arbitrary alphabetical ordering. So we switch to 
# column plots.

######### Column Plots

# We use `geom_col` to draw bar charts.  
# Let's rotate the labels on the x-axis so we can read them:
by.neighbor %>%
  ggplot(aes(x=neighbourhood_cleansed, y=med.price)) +
  geom_col() +
  theme(axis.text.x=element_text(angle=60, hjust=1))

# Tip: theme() allows you to customize your plot in detail by specifying 
# elements (size, color, position, margins, etc.) of different plot components, 
# such as backgrounds, axes, legends, etc. 

# Let's clean up this plot a bit:
by.neighbor %>%
  ggplot(aes(x=reorder(neighbourhood_cleansed, med.price), y=med.price)) +
  geom_col(fill='dark red') +
  labs(x=NULL, 
       y='Median price', 
       title='Median daily price by neighborhood') + 
  theme_minimal() + 
  coord_flip()

# The new tools here are:
# - `reorder` (used in the `x` aesthetic), which simply reorders the first 
# argument in order by the last argument
# - `coord_flip`, which is a neat theme function for flipping the x and
# y axes for readability. I recommend using `coord_flip` the end of a plotting
# command to avoid confusion with other functions that take `x` and `y` arguments.

# Again we have an interesting visualization because it raises a couple of questions:

# - What explains the steep dropoff from "South Boston" to "Jamaica Plain"?  
# (Is this a central-Boston vs. peripheral-Boston effect? What would be some 
# good ways to visualize that?)
# - Does this ordering vary over time, or is the South Boston Waterfront always 
# the most high-end?
# - What is the distribution of prices in some of these neighborhoods? (We have 
# tried to take care of outliers by using the median, but we cannot get a good 
# feel for a neighborhood with just a single number.)

######### Plotting Distributions

# For now, let's pick out a few of these high-end neighborhoods and plot a more 
# detailed view of the distribution of price using `geom_boxplot`. We also need 
# to pipe in the full dataset now so we have the full price information, not just 
# the summary info.
listings %>%
  filter(neighbourhood_cleansed %in% c('South Boston Waterfront', 'Bay Village',
                                       'Leather District', 'Back Bay', 'Downtown')) %>%
  ggplot(aes(x=neighbourhood_cleansed, y=nprice)) +
  geom_boxplot() + 
  theme_minimal()

# A boxplot shows
# - the 25th and 75th percentiles (top and bottom of the box)
# - the 50th percentile or median (thick middle line)
# - the max/min values (top/bottom vertical lines)
# - outliers (dots).  

# By simply changing our geometry command, we now see that although the medians 
# were very similar, the distributions were quite different (with Bay Village 
# especially having a "heavy tail" of expensive properties) and there are many 
# extreme outliers ($3000 *a night*?!).

######### Geoms Are Easy to Swap!

# Another slick way to visualize this is with a "violin plot".  We can just change 
# our geometry to `geom_violin` and voila!	
listings %>%	
  filter(neighbourhood_cleansed %in% c('South Boston Waterfront', 'Bay Village', 	
                                       'Leather District', 'Back Bay', 'Downtown')) %>%	
  ggplot(aes(x=neighbourhood_cleansed, y=nprice)) +	
  geom_violin() + 
  theme_minimal()

# The full distribution `stat_ecdf` is another useful tool for visualizing 
# distributions (Naming note: "stats" are essentially geoms that bake in some 
# statistical transformations. There aren't that many of them so we won't worry 
# about that for now). `stat_ecdf` plots the cumulative distribution of vectors
# (i.e. percentiles vs. values), which gives you a lot more information about the 
# distribution at the expense of being a bit harder to read.

# Let's plot the distribution of price by number of bedrooms, and use 
# `coord_cartesian` to limit the x-axis of the plot.
listings %>%
  ggplot(aes(nprice, color=factor(bedrooms))) +
  stat_ecdf() +
  coord_cartesian(xlim = c(0, 1000)) + 
  theme_minimal()

# A couple of interesting findings here:
# - Prices cluster around multiples of $100 (look for the vertical lines). 
# Maybe people should be differentiating on price more!
# - Low-end zero-bedroom units are cheaper than low-end one-bedroom units, but 
# one-bedroom units are cheaper at the high end. Maybe there are different types 
# of zero-bedroom units?

######### Tips and Tricks

# Need a couple extra dimensions in your plot? Try **faceting**, i.e. breaking 
# out your plot into subplots by some variable(s). It's a simple addition to the 
# end of our `ggplot` chain.  

# For example, using the price by room type example, let's plot each histogram 
# in its own facet.

# We would also like to **normalize** the values --- divide each bar height by 
# the total sum of all the bars --- so that each bar represents the fraction of 
# listings with that price range, instead of the count. We can do that with a 
# special mapping in `aes` to make `y` a "density", like so:	
listings %>%
  filter(nprice < 500) %>%
  ggplot(aes(x=nprice, y=..density.., fill=room_type)) +
  geom_histogram(binwidth=50, center=25, position='dodge', color='black') +
  labs(x='Price', y='Frac. of Listings', fill='Room type') +
  facet_grid(.~room_type) + 
  theme_bw()

# A couple notes on the histogram visualization:
# - `dodge` preserves the vertical position of an geom while adjusting the 
# horizontal position. By default, position=`stack` in geom_histogram() 
# (which stacks different-colored types vertically into one bin)
# - For histograms, the aesthetic `fill` controls bin fill color (while `color` 
# controls bin outline color)

# If we interpret the facet layout as an x-y axis, the `.~room_type` formula means 
# layout nothing (`.`) on the y-axis, against `room_type` on the x-axis.  

# Sometimes we have too many facets to fit on one line, and we want to let ggplot
# do the work of wrapping them in a nice way. For this, we can use `facet_wrap()`.

######### Connecting tidy data to `ggplot`

# `ggplot` and the grammar of graphics are very nice on their own, but the 
# integration with the tidyverse is where the magic happens.
# `ggplot` and the tidyverse allow us to cleanly map our data to a visualization.

# Recall the task of plotting the distribution of daily price by number of 
# bedrooms. Let's say we now want the distributions of daily, weekly, and 
# monthly price, with the color of the line showing which type of price it is.
# Before, we could easily set the color as each listing only had one `number of
# bedrooms`. But with price, we would need to do some brute force thing like ... 
# `y1=price, y2=weekly_price, y3=monthly_price`? And `color=` ... ?

# But with the long format data, we can simply specify the color of our line 
# with the `price_type` column, which gives which type of observation it is.
listings %>%
  select(id, name, nprice, weekly_price, monthly_price) %>%
  pivot_longer(cols = c("nprice", "weekly_price", "monthly_price"), 
               names_to = "price_type",
               values_to = "price_value") %>%
  filter(!is.na(price_value)) %>% 
  filter(price_value < 1000) %>%
  ggplot(aes(x=price_value, color=price_type)) +
  stat_ecdf() + 
  theme_minimal() + 
  labs(title = 'Price Distributions', 
       y = 'Empirical CDF',
       x = 'Price',
       color = 'Price Type')

########## ----------------------------------------------------------------
# (exiting at Hands-on: ggplot)
########## ----------------------------------------------------------------

########## ----------------------------------------------------------------
# (entering at Hands-on: Case Study, Part 1)
########## ----------------------------------------------------------------

######################
####### Functional Data Wrangling + Advanced Tips and Tricks
######################

# Let's import a couple of additional packages:

library(broom)     # for retrieving model predictions
library(lubridate) # for manipulating dates and times

# For the analysis we are going to do today, we need two data sets: 
# - The `listings` dataset contains detailed information about each space.
# - The `prices` dataset contains, for each listing, the price-per-person 
# on each data listed in the data set. 

# Suppose we need to import these datasets (again) from the `/data` directory
# Unfortunately, we have a problem: navigate to `/data/listings` and 
# `/data/prices`. What do you see?

# Let's first take a look at a for-loop. We will construct the `prices` dataset 
# by iteratively appending the rows of each dataset in `/data/prices.
names <- list.files('data/prices', full.names = T)

prices <- tibble()
for(name in names){
  df <- read_csv(name)
  prices <- rbind(df, prices)
}

prices %>% head()

# Well, that worked, but we defined a `names` vector that we don't care about
# and wrote five lines to achieve our aim. Let's explore a better approach. 

########## ----------------------------------------------------------------
# (exiting at Hands-on: Case Study, Part 1)
########## ----------------------------------------------------------------

########## ----------------------------------------------------------------
# (entering at Hands-on: Case Study, Part 2)
########## ----------------------------------------------------------------

# Let's try this: 

prices <- list.files('data/prices', full.names = T) %>% 
  map(read_csv) %>% 
  reduce(rbind)

# What do `map()` and `reduce()` do?

########## 
# Exercise: 
# Part a: Working with your partner, inspect the data in the `data/listings` 
# directory. Write a similar command to read in this data and save the resulting
# dataset as `listings`.
# Part b: Generalize the last two code chunks by writing a function `read_all_csv`
# that reads in all files in a given directory and returns a single data frame. 
# You may assume that all given files are in .csv format and have the same columns.
########## 

########## 
# ANSWER:
########## 
# Part a
listings <- list.files('data/listings', full.names = T) %>% 
  map(read_csv) %>% 
  reduce(rbind)

# Part b
read_all_csv <- function(directory){
  list.files(directory, full.names = T) %>% 
    map(read_csv) %>% 
    reduce(rbind)
}
prices   <- read_all_csv('data/prices')
listings <- read_all_csv('data/listings')

# Take a moment to inspect the data by typing the name of each data frame 
# (`prices` and `listings`) in the terminal. Hopefully some of the column names 
# look pretty familiar. The `price_per` column was computed for you by dividing
# the price of the listing on the given date by the number of people that listing
# accommodates. You can see the file `prep_data.R` for the full data preparation 
# process. 

# Time to take a look to see what we have. The first version of our analysis 
# question is: 
#
# > How do AirBnB prices vary over time? 
# 
# For a first pass at this question, let's construct a 
# visualization of the first 2000 rows of the prices data frame using ggplot2. 
# We will use a line plot with lines colored by listing_id.
prices %>%
  head(2000) %>% 
  ggplot() + 
  aes(x = date, 
      y = price_per, 
      color = factor(listing_id)) +
  geom_line() 


########## 
# Exercise: It might be easier to get a big-picture view by plotting the average
# over time. Working with your partner, construct a visualization of 
# the mean over time. 
# - Use `group_by(date) %>% summarize()` to create a data frame holding the mean
# - You probably want `geom_line()` again
# - We are going to come back to this plot, so name it `p`
########## 

########## 
# ANSWER:
########## 
p <- prices %>% 
  group_by(date) %>% 
  summarise(mean_pp = mean(price_per, na.rm = T)) %>% 
  ggplot() +
  aes(x = date, y = mean_pp) + 
  geom_line()
p

# What can be said about the overall evolution of the price curve? What about
# different months or seasons? Do any points stand out?
# How does the average price over time compare to the price of individual listings
# over time?

##########  Modeling
# Now that we know how (in)complete our data is, let's move on to modeling. 
# We want to peel out the seasonal variation present in the data. 
# The seasonal variation should be a smooth curve that varies slowly. 
# LOESS (**LO**cally **E**stimated **S**catterplot **S**moothing) is a simple 
# method for fitting such models. 

# LOESS is easy to use; in fact, it's the default option for `geom_smooth`:
p + geom_smooth()

# Ok, so that's helpful, but we've seen that the seasonal variation is different
# between listings. Eventually, we want to fit a *different* model to *each*
# listing. For now, let's fit a single one. The span is a hyperparameter, a bit
# like lambda in LASSO (more info in ?loess()). 

# Extract a single listing's worth of data and fit a LOESS model:
model_data <- prices %>%       
  filter(listing_id == 5506)

single_model <-  loess(price_per ~ as.numeric(date),  
                       data = model_data, span = .25)

# We can inspect the fitted model using summary():
single_model %>% summary()

# We can get the smoothing curve as the predicted value from the model. 
# The most convenient way to do this is using the `augment()` function from the 
# `broom` package. The output is a data frame containing all the original data, 
# plus the fitted model values, standard errors, and residuals. 
model_preds <- broom::augment(single_model, model_data) 
model_preds %>% head()

# Note that the `augment()` function returns fitted values and residuals, in 
# addition to the original columns. 

########## 
# Exercise: Working with your partner, plot both the `price_per` column and 
# the `.fitted` column against the date, as follows:
# - Both columns as a function of time are plotted on the same plot.
# - The `.fitted` line plot is colored red.
# Hint: You'll need to use geom_line() twice, with a different y aesthetic in 
# each geom. Recall that multiple geoms are stackable using the `+` operator.
########## 

########## 
# ANSWER:
########## 
model_preds %>%
  ggplot(aes(x = date)) + 
  geom_line(aes(y = price_per)) + 
  geom_line(aes(y = .fitted), color = 'red')

#  Now, how can we do this many times, for each listing? 
#  If you said `map()`, you are absolutely on point. However, we need a strange 
#  trick to get there...

########## ----------------------------------------------------------------
# (exiting at Hands-on: Case Study, Part 2)
########## ----------------------------------------------------------------

########## ----------------------------------------------------------------
# (entering at Hands-on: Case Study, Part 3)
########## ----------------------------------------------------------------

##########  Nesting
prices_nested <- prices %>% 
  nest(data = -listing_id)

# What just happened? Maybe we should inspect things a bit: 

prices_nested$data[[1]] # hey look, it's a data frame! 

########## ----------------------------------------------------------------
# (exiting at Hands-on: Case Study, Part 3)
########## ----------------------------------------------------------------

########## ----------------------------------------------------------------
# (entering at Hands-on: Case Study, Part 4)
########## ----------------------------------------------------------------

# Now we define our LOESS modeling function. Its first argument is a
# data frame, and its second argument is the span hyperparameter. What kind 
# of object does it return? 
my_loess <- function(data, span){
  loess(price_per ~ as.numeric(date),
        data = data, 
        span = span)
}

# Our next step is to use `map()` to model each of the data frames in the 
# data column of prices_nested. Note that we are fitting 
# `nrow(prices_nest) = 1,705` distinct models simultaneously with this command. 
prices_with_models <- prices_nested %>% 
  mutate(model = map(data, my_loess, span = .25))
prices_with_models

# Just like there are data frames in the data column, there are statistical 
# models in the model column. Let's inspect that column to make sure it has 
# in it what we'd expect. 
prices_with_models$model[[1]] %>% summary()

# Once you're comfortable with that, it's time to extract predictions from 
# the models. We'll use purrr::map2 and broom::augment to do this. map2 is just
# like map, but it iterates over two lists simultaneously. We do this because
# the augment function requires both the model and the original data. 
prices_with_preds <- prices_with_models %>%
  mutate(preds = map2(model, data, augment))
prices_with_preds

# Hey look, another list column of data frames! You may want to inspect this 
# column too, for example: 
prices_with_preds$preds[[1]] %>% head()

# Now we're ready to get out of bizarro land. Use `unnest` to return to the 
# original dataframe columns 
prices_modeled <- prices_with_preds %>% 
  select(listing_id, preds) %>% 
  unnest(cols = preds) 

# The first three columns are exactly where we started, but the last two are 
# new: they give the model predictions (and prediction uncertainty) that we've
# generated. Let's rename the .fitted column "trend" instead:
prices_modeled <- prices_modeled %>% 
  rename(trend = .fitted) 

########## 
# Exercise: Now, working with a partner, construct a visualization of the model 
# predictions against the actual prices for the first 3000 rows, as follows:
# - You'll need to use geom_line() twice, with a different y aesthetic in each.
# - Color the trend plots in red.
# - Use facet_grid() to show each listing and its model in a separate plot. The
# facet grid should have a single date axis and multiple price axes
# (hint: recall that `~` controls the axes in the facet layout).
# - For added visibility, scale the y-axis of each listing plot using `scales = 'free_y'`
# in facet_grid().
########## 

########## 
# ANSWER:
########## 
prices_modeled %>% 
  head(3000) %>% 
  ggplot(aes(x = date, group = listing_id)) +
  geom_line(aes(y = price_per)) +
  geom_line(aes(y = trend), color = 'red') +
  facet_grid(listing_id~., scales = 'free_y') + 
  theme(strip.text.x = element_blank())

########## ----------------------------------------------------------------
# (exiting at Hands-on: Case Study, Part 4)
########## ----------------------------------------------------------------
