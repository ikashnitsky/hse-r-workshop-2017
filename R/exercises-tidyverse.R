################################################################################
#      
# HSE R 2017-10-17
# Tidyverse exercises
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#
################################################################################

# Erase all objects in memory
rm(list = ls(all = TRUE))

# load the package
library(tidyverse)

# set working directory to the one where you have this file
# (only needed if you do not use RStudio project)
setwd('')



################################################################################
# Read the data with readxl
library(readxl)

# see the names of the sheets
readxl::excel_sheets('data/data-denmark.xlsx')

deaths <- read_excel(path = 'data/data-denmark.xlsx', sheet = 'deaths')
pop <- read_excel(path = 'data/data-denmark.xlsx', sheet = 'pop')


################################################################################
# Ex 1. deaths dataframe
# - subset only total number of deaths among men in year 2003 (filter)
# Q: which region had the most




################################################################################
# Ex 2. pop dataframe
# - subset only the year 2004
# - transform to wide format using the column "sex" (spread)
# - get rid of the column for both sex
# - calculate the sex ratio (males to females)
# Q: in which region the SR is higher at ages 15, 45, over75 (coded as "open")




################################################################################
# Ex 3. joined dataframe
# - join the two dataframes (left_join OR inner_join)
# - calculate age specific mortality ratios
# - subset only the ages 15-59 and year 2001
# Q: what is the average ratio of male ASMR to female ASMR in each region? (summarize)



################################################################################
# Ex 4. joined dataframe (df)
# - subset only both sex
# - transform to wide format using the column "year" (spread)
# - calculate the growth of ASMR between 2005 and 2001
# Q: in which region the average growth/decrease in ASMR 