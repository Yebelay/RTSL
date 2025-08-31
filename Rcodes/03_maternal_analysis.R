# 03_maternal_analysis.R( Analysis of maternal deaths data

library(tidyverse)
library(here)
library(readxl)
library(sf)
library(ggplot2)

# Load data
maternal_summary <- read_excel(here("data", "Maternal deaths.xlsx"), sheet = "MD summary")
#names(maternal_summary)

maternal_linelist <- read_excel(here("data", "Maternal deaths.xlsx"), sheet = "MD linelist")


# Summarize the data
weekly_maternal <- maternal_summary %>%
  transmute(
    Region = coalesce(`Region...1`, `Region...4`),  
    Weekly = as.numeric(`Weekly Maternal Death`),
    Cumulative = as.numeric(`Maternal Death Cumulative`)) %>%
  filter(!is.na(Region)) %>% filter(Region != "Total") 

# Clean or recodding causes of death data for misspellings and variations
causes_data <- maternal_linelist %>%
  mutate(`Short Name` = tolower(`Short Name`)) %>%   # make all lower case
  mutate(`Short Name` = case_when(
    `Short Name` %in% c("obstetric haemorrhage", "obstetric hemorrhage") ~ "Obstetric Hemorrhage",
    `Short Name` %in% c("non-obstetric complications", "non-obstetric complication") ~ "Non-Obstetric Complications",
    `Short Name` == "hypertensive disorder" ~ "Hypertensive Disorder",
    `Short Name` == "pregnancy-related infection" ~ "Pregnancy-related Infection",
    `Short Name` == "unanticipated complications" ~ "Unanticipated Complications",
    TRUE ~ `Short Name`)) %>%
  count(`Short Name`) %>%
  mutate(Percentage = round (n / sum(n) * 100))

# Create a bar plot with % labels
maternal_causes_plot <- ggplot(causes_data, aes(x = reorder(`Short Name`, n), y = Percentage)) +
  geom_col(fill = "#0088c9") +
  geom_text(aes(label = paste0(round(Percentage, 1), "%")), 
            hjust = -0.2, size = 4) +
  labs(x = " ", y = "# of maternal deaths", 
       title = " ") +
  theme_minimal(base_size = 14) +
  theme(axis.text.y = element_text(size = 12)) +
  coord_flip()


# Save plot
ggsave(here("outputs", "figures", "maternal_causes_plot.png"), 
       maternal_causes_plot, width = 6, height = 5, dpi = 300)

# Load shapefile 
ethiopia_map <- st_read(here("data", "shapefiles", "eth_admbnda_adm1_csa_bofedb_2021.shp"))

# Merge with maternal data (adjust join key as needed)
map_data <- ethiopia_map %>%
  left_join(weekly_maternal, by = c("ADM1_EN" = "Region"))

# Add annotation label (Region + value)
map_data <- map_data %>%
  mutate(label = paste0(ADM1_EN, " (", Cumulative, ")"))

# Get centroids for placing text
map_centroids <- st_centroid(map_data)

# Create map with
maternal_map <- ggplot(map_data) +
  geom_sf(aes(fill = Cumulative), color = "grey50", size = 0.2) +
  geom_sf_text(data = map_centroids, aes(label = label), 
               size = 3,  fontface = "bold", color = "black", na.rm = TRUE) +
  scale_fill_gradient(low = "#e5d0ff", high = "#6900a3", 
    na.value = "white", name = "Cumulative Maternal Deaths" ) +
  theme_void() + theme(
    legend.position = c(0.4, 0.98), 
    legend.justification = c("right", "top"), 
    legend.box.just = "right",
    legend.box.margin = margin(0, 0, 0, 12),
    legend.key.size = unit(0.5, "cm"), 
    legend.text = element_text(size = 5))


# Save map
ggsave(here("outputs", "figures", "maternal_map_plot.png"), 
       maternal_map, width = 8, height = 6, dpi = 300)

# Save data
write.csv(weekly_maternal, here("outputs", "tables", "weekly_maternal.csv"), row.names = FALSE)
write.csv(causes_data, here("outputs", "tables", "maternal_causes.csv"), row.names = FALSE)

