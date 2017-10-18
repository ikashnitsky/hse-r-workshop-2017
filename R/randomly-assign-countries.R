
set.seed(911)

hereweare <- c()

nstud <- length(hereweare)

countries <- data_frame(nuts2 = e0$geo %>% unique() %>% as.character()) %>% 
        mutate(nuts0 = str_sub(nuts2, 1, 2)) %>% 
        group_by(nuts0) %>% 
        summarise(n = n()) %>% 
        ungroup() %>% 
        arrange(desc(n))

countries <- countries$nuts0[1:nstud]

df_assign <- data_frame(email = hereweare,
                        country = sample(countries)) 

df_assign %>% View
        
        