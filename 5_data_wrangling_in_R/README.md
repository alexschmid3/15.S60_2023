# Data Wrangling and Visualization with R

In this session, we will introduce the R programming language, the RStudio IDE, and basic techniques in data wrangling using R and RStudio.  Specifically, we will cover some basic tools using out-of-the-box R commands, then introduce the powerful framework of the "tidyverse", and finally gain some understanding of the philosophy of this framework to set up deeper exploration of our data.  Throughout, we will be using a publicly available dataset of AirBnB listings.  

We recommend you follow along in class using the `wrangling_student.R` file (to be posted before lecture), which will allow you to live-code along with the session leader and work through un-solved exercises.

<!-- ## Pre-assignment 1: Keeping current

To ensure that you have the most current versions of all files, please fire up a terminal, navigate to the directory into which you cloned the full set of materials for the course, and run `git pull`.  (Refer back to Session 1 if you're having trouble here.)

Before class, it is recommended to skim through the [online session notes].

We recommend you follow along in class using the `wrangling_student.R` file, which will allow you to live-code along with the session leader and work through un-solved exercises. You are welcome to use `wrangling_complete.R' for troubleshooting. -->

## Pre-assignment 1: Download `R` and RStudio

We will be learning the `R` programming language for statistical computation. To interact with `R`, we will use RStudio, the most popular and widely used R IDE, to write and execute `R` commands.

* **Install `R` and RStudio**: Navigate to https://rstudio.com/products/rstudio/download/#download and follow instructions 1 and 2.  
* In step 1, install R by selecting the 'RStudio requires 3.3.0+' hyperlink and following the download R instructions for your operating system.  
* In step 2, install RStudio Desktop by clicking the the "Download RStudio" button.  
* **Test Your Installation**: Open RStudio and type 1+2 into the Console window, and type "Enter".
* Later in the class we will require the most recent version of R (>= 4.2.2). If you already had R installed on your computer, you may have an earlier version. To check and update the R version, you can follow the **Install `R`** instructions above.


## Pre-assignment 2: Installing libraries

We will use three libraries for this session: `tidyr`, `dplyr`, and `ggplot2`. These three packages (and many more!) can all be conveniently loaded using the metalibrary `tidyverse`. To unleash the power of the Tidyverse open RStudio and type the following into the console window and press "Enter":

```
install.packages(c("tidyverse", "lubridate", "broom", "leaflet", "rmarkdown"))
```

You should test that the libraries will load by then running in the console window:

```
library(tidyverse)
library(lubridate)
library(broom)
library(leaflet)
library(rmarkdown)
```

Then test that `dplyr`, `lubridate`, and `broom` work by executing the command:
```
tibble(x = c(1,2,3), y = c(0,1,1.5)) %>% 
  mutate(wday = wday(x)) %>% 
  lm(y~wday, data = .) %>% 
  glance()
```
which should output something like this
```
# A tibble: 1 × 12
  r.squared adj.r.squared sigma statistic p.value    df logLik   AIC   BIC deviance
      <dbl>         <dbl> <dbl>     <dbl>   <dbl> <dbl>  <dbl> <dbl> <dbl>    <dbl>
1     0.964         0.929 0.204        27   0.121     1   2.16  1.68 -1.02   0.0417
# … with 2 more variables: df.residual <int>, nobs <int>
```
(Fewer or more variables will be displayed based on the size of your window.)

Then test that `leaflet` works by executing the command
```
leaflet() %>% addTiles()
```
which should output a world map.

Finally, test that `ggplot` works by executing the command
```
tibble(x=rnorm(1000), y=rnorm(1000)) %>% ggplot(aes(x,y)) + geom_point()
```
which should produce a cloud of points centered around the origin.

**Please submit screenshots of these three outputs to the Pre-Assignment 5 Page on the course Canvas page.**


## Additional Resources

`dplyr` and `tidyr` are well-established packages within the `R` community, and there are many resources to use for reference and further learning. Some of our favorites are below (these links may be outdated but with a quick internet search, you should be able to find the correct webpage as these are all very popular resources).

- Tutorials by Hadley Wickham for `dplyr` [basics](https://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html), [advanced grouped operations](https://cran.r-project.org/web/packages/dplyr/vignettes/window-functions.html), and [database interface](https://cran.r-project.org/web/packages/dplyr/vignettes/databases.html).
- Third-party [tutorial](http://www.dataschool.io/dplyr-tutorial-for-faster-data-manipulation-in-r/) (including docs and a video) for using `dplyr`
- [Principles](http://vita.had.co.nz/papers/tidy-data.pdf) and [practice](https://cran.r-project.org/web/packages/tidyr/vignettes/tidy-data.html) of tidy data using `tidyr`
- (Detailed) [cheatsheet](https://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf?version=0.99.687&mode=desktop) for `dplyr` and `tidyr`
- A useful [cheatsheet](https://stat545-ubc.github.io/bit001_dplyr-cheatsheet.html) for `dplyr` joins
- A [cheatsheet](https://github.com/rstudio/cheatsheets/blob/main/purrr.pdf) for `purrr` functional programming commands
- Any of the [RStudio cheatsheets](https://www.rstudio.com/resources/cheatsheets/), for that matter
- [Comparative discussion](http://stackoverflow.com/questions/21435339/data-table-vs-dplyr-can-one-do-something-well-the-other-cant-or-does-poorly) of `dplyr` and `data.table`, an alternative package with higher performance but more challenging syntax.  
- There are some additional packages that we will not cover in this class but are nonetheless very useful! A few examples: [cowplot](https://wilkelab.org/cowplot/index.html) for combining multiple plots, [janitor](https://github.com/sfirke/janitor) for quick column name cleanup and a nicer table command, and [gt](https://gt.rstudio.com/) for creating publication-quality tables.

## Questions?

Email Raluca at [rcobzaru@mit.edu](mailto:rcobzaru@mit.edu).
