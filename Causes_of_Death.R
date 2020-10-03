library(tidyverse)
library(magrittr)

library(readxl)

library(viridis)

library(extrafont)
#font_import()

library(maps)
library(sf)
library(ggplot2)

rm(list = ls())

# Set work directory
#setwd("Google Drive/Projects/Causes of Death/")

# Read data
Causes_of_Death <- list.files(pattern="Top 5") %>%
  read_xlsx() %>%
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
          color="#002240") +
  scale_fill_discrete(breaks = c("Heart Disease", "Cancer",
                                 "Accident", "Chronic Lower Respiratory Disease",
                                 "Cerebrovascular Disease",
                                 "Alzheimers",
                                  "Diabetes",
                                  "Suicide")) +
  facet_wrap(~ Rank, nrow=5) +
#  guides(fill = guide_legend(reverse=TRUE)) +
  ggtitle("Leading Causes of Death by State") +
  theme(axis.ticks = element_blank(),
        axis.text = element_blank(),
        panel.grid = element_blank(),
        panel.background = element_rect(fill="white"),
        plot.background = element_rect(fill="white"))



ggsave("Cause of Death by State.png", device="png")
