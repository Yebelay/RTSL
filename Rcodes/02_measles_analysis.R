# 02_measles_analysis.R(Analysis of measles laboratory data)

library(tidyverse)
library(readxl)

# Load data
measles_data <- read_excel("data/measles_lab.xlsx") %>% select(1:8) 

measles_summary <- measles_data %>% 
  rename(Region = `Province Of Residence`,  Result = `IgM Results`) %>%
  group_by(Region, Result) %>%
  summarise(Count = n(), .groups = "drop")

library(dplyr)

measles_summary <- measles_data %>%
  rename(Region = `Province Of Residence`, Result = `IgM Results`) %>%
  group_by(Region) %>%
  mutate(Result = case_when(
    Result == "1" ~ "Positive",
    Result == "2" ~ "Negative",
    Result == "3" ~ "Indeterminate",
    Result == "4" ~ "Not done",
    Result == "5" ~ "Pending",
    Result == "9" ~ "Unknown",
    TRUE ~ as.character(Result))) %>%
  group_by(Region, Result) %>%
  summarise(Count = n(), .groups = "drop")


# Create visualization
measles_plot <- ggplot(measles_summary, aes(x = Region, y = Count, fill = Result)) +
  geom_bar(stat = "identity", position = "stack") +
  scale_fill_manual(values = c(
    "Negative" = "blue",
    "Positive" = "red",
    "Not done" = "lightgray",
    "Indeterminate" = "#4dbd05",
    "Pending" = "#9b45a3",
    "Unknown" = "gray" )) +
  theme_minimal() + 
  labs(title = "Measles Laboratory Test Results by Region",
       x = "", y = "", fill = "") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))


# Save plot
ggsave(here("outputs", "figures", "measles_plot.png"), measles_plot, 
       width = 8, height = 6, dpi = 300)

# Save data
write.csv(measles_summary, here("outputs", "tables", "measles_summary.csv"), row.names = FALSE)



