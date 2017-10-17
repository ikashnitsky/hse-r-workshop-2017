################################################################################
# 
# HSE R 2017-10-17
# ggplot - assignment
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#
################################################################################


# ASSIGNMENT
# 0. Register at HMD.
# 0. Download 1x1 lifetables for your country
# 1. Compare age-specific mortality rates (mx) in the first and last available years
# 2. Compare male and female mortality in the these two dates   
# 3 (opt). Compare male moratality of your country in 2010 to that of Japan.
# 4. write a brief report (you may use Word or R-notebook)
# 5. Send to ilya.kashnitsky@gmail.com (topic: "R assignment")


# Erase all objects in memory
rm(list = ls(all = TRUE))

# load the packages
library(tidyverse)
library(ggthemes)       # lots of themes to play with
library(viridis)        # nice print and color-blind friendly color palettes
# feel free to load and use other packages


### SOME HINTS

# How to read-in HMD data - example on Russian data
df <- read_table('data/bltper_1x1_RUS.txt', skip = 2)

# Detect first and last available years
range(df$Year)

# Save plots
ggsave(filename = "name_of_the_file.png", plot = your_ggplot_object,
       width = 10, height = 7)
# width and height are in inches. Try to play with these parameters
