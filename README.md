Causes of Death
===============

How do the leading causes of death change by State?

The Center for Disease Control and Prevention (CDC) tracks and publishes
the leading causes of death, percent of total deaths, and death rates
(<https://www.cdc.gov/nchs/nvss/mortality/lcwk5_hr.htm>).

From this data I have collected the top-5 leading causes of death for
each State:

    ## # A tibble: 6 x 6
    ##   State   `Cause 1`   `Cause 2`  `Cause 3`       `Cause 4`       `Cause 5`      
    ##   <chr>   <chr>       <chr>      <chr>           <chr>           <chr>          
    ## 1 Alabama Heart Dise~ Cancer     Chronic Lower ~ Cerebrovascula~ Accident       
    ## 2 Alaska  Cancer      Heart Dis~ Accident        Chronic Lower ~ Suicide        
    ## 3 Arizona Heart Dise~ Cancer     Accident        Chronic Lower ~ Alzheimers     
    ## 4 Arkans~ Heart Dise~ Cancer     Chronic Lower ~ Accident        Cerebrovascula~
    ## 5 Califo~ Heart Dise~ Cancer     Cerebrovascula~ Alzheimers      Chronic Lower ~
    ## 6 Colora~ Cancer      Heart Dis~ Accident        Chronic Lower ~ Cerebrovascula~

We want to present this data in a concise way. One way to achieve this
is using a choropleth (a thematic map displaying statistical
information).

There are many different packages capable of creating choropleths in R.

In this case we want to display the mainland States of the USA. The
"map"-function from the "maps" package is sufficient for our purposes.

    States <- st_as_sf(maps::map("state", plot = FALSE, fill = TRUE)) %>%
      mutate(ID = str_to_title(ID)) %>%
      as_tibble() %>%
      rename(State = ID)

We can now join the "Causes of Death"-tibble to our simple-features map
multipolygons:

    States %<>% left_join(Causes_of_Death)

Finally, we can use ggplot2 to create our choropleth:

    ggplot(data=Causes_of_Death) +
      geom_sf(aes(geometry=geom,
                  fill=Cause),
              lwd=0.5,
              color=NA) +
      scale_fill_manual(values = c("#1F77B4",
                                   "#FF7F0E",
                                   "#2CA02C",
                                   "#D62728",
                                   "#BCBD22",
                                   "#17BECF",
                                   "#9467BD"),
        breaks = c("Heart Disease",
                   "Cancer",
                   "Accident",
                   "Chronic Lower Respiratory Disease",
                   "Cerebrovascular Disease",
                   "Alzheimers",
                   "Diabetes")) +
      facet_wrap(~ Rank, nrow=3) +
      ggtitle("Leading Causes of Death by State",
              subtitle = bquote(bold("Source:") ~"https://www.cdc.gov/nchs/nvss/mortality/lcwk5_hr.htm")) +
      theme(strip.text = element_text(size=10,
                                      hjust=0.45),
            strip.background = element_rect(size=1,
                                            fill=NA),
            axis.ticks = element_blank(),
            axis.text = element_blank(),
            legend.text = element_text(color = "black",
                                       family="Arial Rounded MT Bold",
                                       size=7),
            legend.title = element_blank(),
            legend.key.size = unit(0.28,"cm"),
            legend.justification=c(1,0), 
            legend.position=c(1.01, -0.01),  
            legend.background = element_blank(),
            panel.grid = element_blank(),
            panel.background = element_rect(fill="white"),
            plot.background = element_rect(fill="white"),
            plot.title = element_text(family="Arial Rounded MT Bold",
                                      size=9),
            plot.subtitle = element_text(family="Arial",
                                         size=7))

<img src="Cause of Death by State.png"/>
