library(tidyverse)
library(magrittr)
library(readxl)
library(viridis)

library(extrafont)
#font_import()

library(transformr)
library(tweenr)
library(maps)
library(sf)
library(ggplot2)


rm(list = ls())

# Set work directory
#setwd("Google Drive/Projects/Causes of Death/")

# Read data
Causes_of_Death <- list.files(path="Data/V2/", pattern="Leading_Causes", full.names = TRUE) %>%
  read_csv() %>%
  as_tibble()

# Lengthen the tibble
Causes_of_Death %<>% pivot_longer(cols = contains("Cause"),
                                  names_to = "Rank",
                                  values_to = "Cause")

# Format columns
Causes_of_Death %<>% mutate(Rank = str_replace_all(Rank,
                                                   "Cause ",
                                                   ""),
                            Rank = as.numeric(Rank),
                            Cause = as.factor(Cause),
                            State = str_to_title(State))

# Read USA multipolygons from the Maps package
USA <- st_as_sf(maps::map("usa", plot=FALSE, fill=TRUE)) %>%
  mutate(ID = str_to_title(ID))

# Read State multipolygons from the Maps package
States <- st_as_sf(maps::map("state", plot = FALSE, fill = TRUE)) %>%
  mutate(ID = str_to_title(ID)) %>%
  as_tibble() %>%
  rename(State = ID)

# Join States and Causes_of_Death
Causes_of_Death %<>% left_join(States) %>%
  filter(!st_is_empty(geom))

# Simple plot of State boundaries
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


ggsave("Cause of Death by State.png", device="png", width=6.4, height=4)
