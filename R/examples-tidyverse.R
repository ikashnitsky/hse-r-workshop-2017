################################################################################
#
# HSE R 2017-10-17
# Tidyverse examples
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
pop <- read_excel()

################################################################################
# Read the data with readxl
library(readxl)

# see the names of the sheets
readxl::excel_sheets('data/data-denmark.xlsx')

deaths <- read_excel(path = 'data/data-denmark.xlsx', sheet = 'deaths')
pop <- read_excel(path = 'data/data-denmark.xlsx', sheet = 'pop')

################################################################################
# Reshaping data with tidyr
pop_w <- rename(.data = pop, population = value)
pop_w <- spread(data = pop_w, region, population)


# to wide format
pop_w <- pop %>% 
        spread(region, value)

# back to long format
pop_l <- pop_w %>% 
        gather(key = "region", value = "value", contains('DK'))

################################################################################
# Basic dplyr functions

# filter
pop_filt <- pop %>% filter(year=='y2003', !sex=='b', value > 20000)

# select
pop_select <- pop %>% select(1,4)


# bind dfs
df_bind <- bind_rows(pop, deaths)


# join
df_joined <- left_join(deaths, pop, by = c("year", "region", "sex", "age"))


# mutate & transmute
df <- df_joined %>% mutate(qx = value.x / value.y)

df_tr <- df_joined %>% transmute(region, sex, qx = value.x / value.y)




# group %>% summarize %>% ungroup
df_sum <- pop %>% group_by(year, sex, age) %>% 
        summarise(mean = mean(value)) %>% 
        ungroup()


# summarise_if(is.numeric, ...)
df_sum_if <- pop %>% 
        spread(year, value) %>% 
        group_by(sex, age) %>% 
        summarise_if(.predicate = is.numeric, .funs = mean)





# now we save the data frame to be used in the ggplot show
df <- inner_join(deaths, pop, by = c('year',"region",'sex','age')) %>% 
        rename(deaths = value.x, pop = value.y) %>% 
        mutate(qx = deaths / pop)

save(df, file = 'data/Denmark.Rdata')
