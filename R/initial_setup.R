################################################################################
#
# Initial R setup 2017-10-16
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#
################################################################################

# To run the code, select it and press CTRL+ENTER

# Install packages --------------------------------------------------------
pkgs <- c('tidyverse', 
          'ggthemes',
          'gganimate',
          'viridis',
          'cowplot',
          'RColorBrewer',
          # maps
          'rgdal',
          'rgeos',
          'maptools',
          'leaflet',
          'tmap',
          'tmaptools',
          'raster',
          'spdplyr',
          # data
          'eurostat',
          'wpp2015',
          'HMDHFDplus',
          'wbstats',
          'gapminder',
          'acs',
          # utils
          'bookdown',
          'rmarkdown',
          'texreg',
          'microbenchmark',
          'swirl'
          )


install.packages(pkgs, dependencies = TRUE) # be patient - it will take a while
