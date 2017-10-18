################################################################################
#                                                    
# HSE workshop 2017-10-18
# Creating maps with ggplot2
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#                                                  
################################################################################

# Erase all objects in memory
rm(list = ls(all = TRUE))

# load required packages
library(tidyverse) # data manipulation and viz
library(lubridate) # easy manipulations with dates
library(ggthemes) # themes for ggplot2
library(viridis) # the best color palette
library(forcats) # good for dealing with factors
library(stringr) # good for dealing with text strings

library(rgdal) # deal with shapefiles
library(tmap) # this is a useful package; we take it for read_shape()
library(tmaptools)

library(eurostat)

# there is quite a useful cheatsheet for the package
# http://ropengov.github.io/eurostat/articles/cheatsheet.html

# let's try to search
search_eurostat("life expectancy") %>% View

# Not nearly as cool as we'd like
# better go to 
# http://ec.europa.eu/eurostat/data/database
# OR
# http://ec.europa.eu/eurostat/web/regions/data/database

# download the dataset found manually
df <- get_eurostat("demo_r_mlifexp")

# if the automated download does not work, the data can be grabbed manually at
# http://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing

# time series length
df$time %>% unique()

# ages
df$age %>% unique()

# subset (filter) only life exp at birth
e0 <- df %>% filter(age=="Y_LT1", nchar(paste(geo))==4) %>% 
        droplevels()


################################################################################
# Download geodata
# Eurostat official shapefiles for regions
# http://ec.europa.eu/eurostat/web/gisco/geodata/reference-data/administrative-units-statistical-units

# geodata will be stored in a directory "geodata"
ifelse(!dir.exists('geodata'),
       dir.create('geodata'),
       paste("Directory already exists"))

f <- tempfile()
download.file("http://ec.europa.eu/eurostat/cache/GISCO/geodatafiles/NUTS_2013_20M_SH.zip", destfile = f)
unzip(f, exdir = "geodata/.")
NUTS_raw <- read_shape("geodata/NUTS_2013_20M_SH/data/NUTS_RG_20M_2013.shp")
# there are several shapefiles; we chose the one that contains NUTS codes

# the same operation using rgdal::readOGR
# NUTS_raw <- readOGR("geodata/NUTS_2013_20M_SH/data/NUTS_RG_20M_2013.shp")

# attributive table
NUTS_raw@data %>% View

# colnames to lower case
names(NUTS_raw@data) <- tolower(names(NUTS_raw@data))

NUTS_raw@data %>% View

# let's have a look
plot(NUTS_raw)


# change coordinate system to LAEA Europe (EPSG:3035)
epsg3035 <- "+proj=laea +lat_0=52 +lon_0=10 +x_0=4321000 +y_0=3210000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"

NUTS <- spTransform(NUTS_raw, CRS(epsg3035)) 

# now
plot(NUTS)

# Much better!

NUTS@data %>% View

NUTS0 <- NUTS[NUTS$stat_levl_==0,]
plot(NUTS0)

NUTS2 <- NUTS[NUTS$stat_levl_==2,]
plot(NUTS2)




# make the geodata ready for ggplot
gd2 <- fortify(NUTS2, region = "nuts_id")


# create a blank map
basemap <- ggplot()+
        geom_polygon(data = gd2,
                     aes(x = long, y = lat, group = group),
                     fill = "grey90",color = "grey90")+
        coord_equal(ylim = c(1350000,5450000), xlim = c(2500000, 6600000))+
        theme_map()+
        theme(panel.border = element_rect(color = "black",size = .5,fill = NA),
              legend.position = c(1, 1),
              legend.justification = c(1, 1),
              legend.background = element_rect(colour = NA, fill = NA),
              legend.title = element_text(size = 15),
              legend.text = element_text(size = 15))+
        scale_x_continuous(expand = c(0,0)) +
        scale_y_continuous(expand = c(0,0)) +
        labs(x = NULL, y = NULL)

basemap


# let's add neighbouring countries
f <- tempfile()
download.file("http://ec.europa.eu/eurostat/cache/GISCO/geodatafiles/CNTR_2010_20M_SH.zip", destfile = f)
unzip(f, exdir = "geodata/.")
WORLD <- read_shape("geodata/CNTR_2010_20M_SH/CNTR_2010_20M_SH/Data/CNTR_RG_20M_2010.shp")

WORLD@data %>% View

# colnames to lower case
names(WORLD@data) <- tolower(names(WORLD@data))

plot(WORLD)

# filter only Europe and the neighbouring countries
eu_subset <- c("AT", "BE", "BG", "CH", "CZ", "DE", "DK", 
               "EE", "EL", "ES", "FI", "FR", "HU", "IE", "IS", "IT", "LT", "LV", 
               "NL", "NO", "PL", "PT", "SE", "SI", "SK", "UK", "IM", "FO", "GI", 
               "LU", "LI", "AD", "MC", "MT", "VA", "SM", "HR", "BA", "ME", "MK", 
               "AL", "RS", "RO", "MD", "UA", "BY", "RU", "TR", "CY", "EG", "LY", 
               "TN", "DZ", "MA", "GG", "JE")

EU <- WORLD[WORLD$cntr_id %in% eu_subset,]

plot(EU)

# reproject the shapefile to a pretty projection for mapping Europe
NEIGH <- spTransform(EU, CRS(epsg3035))

plot(NEIGH) # nice!


# create a blank map
basemap <- ggplot()+
        geom_polygon(data = fortify(NEIGH),
                     aes(x = long, y = lat, group = group),
                     fill = "grey90",color = "grey90")+
        coord_equal(ylim = c(1350000,5450000), xlim = c(2500000, 6600000))+
        theme_map()+
        theme(panel.border = element_rect(color = "black",size = .5,fill = NA),
              legend.position = c(1, 1),
              legend.justification = c(1, 1),
              legend.background = element_rect(colour = NA, fill = NA),
              legend.title = element_text(size = 15),
              legend.text = element_text(size = 15))+
        scale_x_continuous(expand = c(0,0)) +
        scale_y_continuous(expand = c(0,0)) +
        labs(x = NULL, y = NULL)


################################################################################
# Ready to play!

basemap +
        geom_map(map = gd2, data = e0,
                 aes(map_id = geo, fill = values))

# better colors
basemap +
        geom_map(map = gd2, data = e0,
                 aes(map_id = geo, fill = values))+
        scale_fill_viridis(option = "B")
#
#
# What's wrong?
#
#


plot(NUTS2)
# remove the overseas region's data

gd2c <- gd2 %>% filter(long  %>% between(2500000, 6600000),
                     lat %>% between(1350000,5450000)) %>% 
        droplevels()

ggplot()+
        geom_map(map = gd2, data = e0,
                 aes(map_id = geo, fill = values))+
        scale_fill_viridis(option = "B")+
        expand_limits(x = gd2$long, y = gd2$lat)+
        coord_equal()

# only core Europe
basemap +
        geom_map(map = gd2c, data = e0,
                 aes(map_id = geo, fill = values))+
        scale_fill_viridis(option = "B")


#
#
# What else is forgotten?
#
#


# we forgot about sex!
basemap +
        geom_map(map = gd2c, data = e0 %>% filter(year(time)==2015, sex=="T"),
                 aes(map_id = geo, fill = values))+
        scale_fill_viridis(option = "B", direction = -1)

basemap +
        geom_map(map = gd2c, data = e0 %>% filter(year(time)==2015),
                 aes(map_id = geo, fill = values))+
        scale_fill_viridis(option = "B", direction = -1)+
        facet_wrap(~sex, ncol = 3)+
        theme(legend.position = "right")




################################################################################
# A PROBLEM: nested polygons

# let's crop Czech Republic
gdcz <- gd2c %>% filter(str_sub(id, 1, 2)=="CZ")



base_cz <- ggplot()+
        geom_polygon(data = gdcz,
                     aes(x = long, y = lat, group = group),
                     fill = "grey90",color = "grey10")+
        theme_map()

base_cz


# a subset of e0 for both sex in 2015
e0t2015 <- e0 %>% filter(year(time)==2015, sex=="T") %>% 
        droplevels()

base_cz +
        geom_map(map = gdcz, data = e0t2015,
                 aes(map_id = geo, fill = values))


#
#
# There is no Prague!
#
#

# The not-so-elegant solution; comes from SO
# https://stackoverflow.com/a/32186989/4638884

gghole <- function(fort){
        poly <- fort[fort$id %in% fort[fort$hole,]$id,]
        hole <- fort[!fort$id %in% fort[fort$hole,]$id,]
        out <- list(poly,hole)
        names(out) <- c('poly','hole')
        return(out)
}


# now plot the subsets one by one as separate layers: first the polygons with
# holes, then polygons without holes

base_cz +
        geom_map(map = gghole(gdcz)[[1]], data = e0t2015,
                 aes(map_id = geo, fill = values))

base_cz +
        geom_map(map = gghole(gdcz)[[2]], data = e0t2015,
                 aes(map_id = geo, fill = values))


base_cz +
        geom_map(map = gghole(gdcz)[[1]], data = e0t2015,
                 aes(map_id = geo, fill = values))+
        geom_map(map = gghole(gdcz)[[2]], data = e0t2015,
                 aes(map_id = geo, fill = values))

#
#
# What about the color range?
#
#

e0t2015$values %>% range

# a subset of e0 for both sex in Czech Rep in 2015
e0t2015cz <- e0 %>% filter(year(time)==2015, 
                         sex=="T",
                         str_sub(geo, 1, 2)=="CZ") %>% 
        droplevels()

e0t2015cz$values %>% range

base_cz +
        geom_map(map = gghole(gdcz)[[1]], data = e0t2015cz,
                 aes(map_id = geo, fill = values))+
        geom_map(map = gghole(gdcz)[[2]], data = e0t2015cz,
                 aes(map_id = geo, fill = values))



#
#
# A small challenge now: map the TFR of one country of Europe
#
#




################################################################################
# animation

# https://github.com/dgrtwo/gganimate
devtools::install_github("dgrtwo/gganimate")

# we also need one prog that proceeds animation 
# https://www.imagemagick.org/script/binary-releases.php

# some more 
install.packages("animation")
library(animation)
# Thank you guys from SO!
# https://stackoverflow.com/a/41394446/4638884
magickPath <- shortPathName("C:\\Program Files\\ImageMagick-7.0.3-Q16\\magick.exe")
ani.options(convert=magickPath)

library(gganimate)


gg <- basemap +
        geom_map(map = gghole(gd2c)[[1]], data = e0 %>% filter(sex=="T"),
                 aes(map_id = geo, fill = values, frame = time))+
        geom_map(map = gghole(gd2c)[[2]], data = e0 %>% filter(sex=="T"),
                 aes(map_id = geo, fill = values, frame = time))+
        scale_fill_viridis(option = "B", direction = -1)

gganimate(gg, "output.gif")

# The result stored online
# http://i.imgur.com/gLLHSWU.gif




################################################################################
# A bit of magic: interactive plots with PLOTLY

library(plotly)

# let's create a basic plot
q <- qplot(data = mtcars, hp, mpg, color = cyl %>% factor)
q
# now, magic
ggplotly(q)


# let's try with maps
gg_cz <- base_cz +
        geom_map(map = gghole(gdcz)[[1]], data = e0t2015cz,
                 aes(map_id = geo, fill = values))+
        geom_map(map = gghole(gdcz)[[2]], data = e0t2015cz,
                 aes(map_id = geo, fill = values)) 

gg_cz

ggplotly(gg_cz)

pl_cz <- ggplotly(gg_cz)
htmlwidgets::saveWidget(pl_cz, "cz-ggplotly.html")


# a more complicated map
gg_eu <- basemap +
        geom_map(map = gghole(gd2c)[[1]], data = e0t2015,
                 aes(map_id = geo, fill = values))+
        geom_map(map = gghole(gd2c)[[2]], data = e0t2015,
                 aes(map_id = geo, fill = values))+
        scale_fill_viridis(option = "B", direction = -1)

pl_eu <- ggplotly(gg_eu, width = 8, height = 8)
htmlwidgets::saveWidget(pl_eu, "eu-ggplotly.html")
