################################################################################
# 
# HSE R 2017-10-17
# show ggplot
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
# 
################################################################################

# Erase all objects in memory
rm(list = ls(all = TRUE))

# load the packages
library(tidyverse)
library(ggthemes)
library(viridis)


################################################################################
# base

# automatic plots for linear model
obj <- lm(data = swiss, Fertility ~ Education)
plot(obj)

# blank map
library(rgdal)
shapefile <- readOGR('data/.', 'shape-france')
plot(shapefile)


################################################################################
# ggplot

# The logic

test <- ggplot(data = mtcars) +
        geom_point(aes(x = hp, y = mpg))+
        xlab('Horse power')

        
ggsave(filename = 'test.png', plot = test)

# geom_point


# geom_smooth

test +
        stat_smooth(aes(x = hp, y = mpg), method = 'lm', 
                    se = FALSE, color = 'red')



# line / path

df_lake <- data.frame(level = LakeHuron %>% unclass() %>% as.numeric(),
                      year=1875:1972)

ggplot(df_lake)+
        geom_line(aes(x = year, y = level, group=1))

ggplot(df_lake)+
        geom_path(aes(x = year, y = level))


library(gapminder)

gapminder %>% 
        select(1:4) %>% 
        group_by(continent, year) %>% 
        summarise(avg_e0 = lifeExp %>% mean) %>% 
        ungroup() %>% 
        ggplot(aes(x = year, y = avg_e0, 
                   color = continent))+
        geom_path(size = 1)+
        theme_minimal(base_family = "mono")
        

gapminder %>% 
        ggplot(aes(x = year, y = lifeExp, 
                   color = continent))+
        geom_jitter(size = 1, alpha = .2, width = .75)+
        stat_summary(geom = "path", fun.y = mean, size = 1)+
        theme_minimal(base_family = "mono")



load('data/Denmark.Rdata')

df %>% 
        filter(year=='y2004', sex=='m', !age%in%c('total','open')) %>% 
        ggplot()+
        geom_line(aes(x = age, y = qx, group = region, color = region))+
        scale_y_continuous(trans = 'log', breaks = c(.0001,.001,.01))+
        theme_few()


# density / ecdf (airquality)

ggplot(airquality)+
        geom_density(aes(x = Temp, color = factor(Month)), size=1)+
        scale_color_viridis(option = "D", discrete = T, end = .8)+
        theme_minimal()+
        theme(legend.position = c(.1,.8))

ggplot(airquality)+
        stat_ecdf(aes(x = Temp, color = factor(Month)), size=1)+
        scale_color_viridis(option = "B", discrete = T, end = .8)+
        theme_fivethirtyeight()+
        theme(legend.position = c(.1,.8))


# boxplot
ggplot(airquality) +
        geom_boxplot(aes(x = factor(Month), y = Temp))

# violin
ggplot(airquality) +
        geom_violin(aes(x = factor(Month), y = Temp, fill = factor(Month)))

# jitter
ggplot(airquality) +
        geom_jitter(aes(x = factor(Month), y = Temp, color = factor(Month)),
                    width = .2)


# faceting
ggplot(airquality)+
        stat_ecdf(aes(x = Temp, color = factor(Month)), size=1)+
        scale_color_viridis(option = "B", discrete = T, end = .8)+
        theme_fivethirtyeight()+
        theme(legend.position = c(.1,.8))+
        facet_wrap(~factor(Month), ncol = 3)

# themes 
test + theme_minimal()
test + theme_bw()
test + theme_light()
test + theme_excel()    # ugly, isn't it?
test + theme_few()      # one of my favorites
test + theme_economist()
test + theme_wsj()
test + theme_fivethirtyeight() # I love this one
test + theme_solarized()
# ... feel free to test them all))

# colors
# Parameter "color" changes the color of lines and points
# Parameter "fill" changes the color of shapes (see the violin example)
# The way you override ggplot's defaults is to use functions
# scale_color_[...] or scale_fill_[...] (use TAB to see options)
# I really recommend viridis colors
# NOTE: with viridis you need to specify "discrete = T" if you coloring
# variable is categirical. 
# The video on viridis https://youtu.be/xAoljeRJ3lU
