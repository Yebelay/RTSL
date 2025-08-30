# 01_weekly_analysis (Analysis of weekly disease surveillance data)

library(tidyverse)
library(here)
library(janitor)

# Load data
weekly_data <- read.csv(here("data", "weekly_data_by_region.csv")) %>% clean_names()

# Set the current or reporte week and year
current_week <- 34
current_year <- 2024

# Filter data for week 34
week_data <- weekly_data %>%
  filter(period == paste0(current_year, "W", current_week))

# Filter data for cumulative totals
cumulative_data <- weekly_data %>%
  filter(grepl(paste0("^", current_year), period)) %>%
  filter(as.numeric(gsub(paste0(current_year, "W"), "", period)) <= current_week)

# Calculate summary statistics for the week
week_summary <- week_data %>%
  summarise(
    AFP_suspected = sum(afp_suspected, na.rm = TRUE),
    Anthrax_suspected = sum(anthrax_suspected, na.rm = TRUE),
    Cholera_suspected = sum(cholera_suspected, na.rm = TRUE),
    Diarrhoea_suspected = sum(diarrhoea_non_bloody_suspecteded, na.rm = TRUE),
    Malaria_suspected = sum(malaria_suspected, na.rm = TRUE),
    Measles_suspected = sum(measles_suspected, na.rm = TRUE),
    Typhoid_suspected = sum(typhoid_fever_suspected, na.rm = TRUE),
    Monkeypox_suspected = sum(monkeypox_suspected, na.rm = TRUE),
    Plague_suspected = sum(plague_suspected, na.rm = TRUE),
    
    AFP_tested = sum(afp_sent_to_lab, na.rm = TRUE),
    Anthrax_tested = sum(anthrax_sent_to_lab, na.rm = TRUE),
    Cholera_tested = sum(cholera_sent_to_lab, na.rm = TRUE),
    Diarrhoea_tested = sum(diarrhoea_non_bloody_sent_to_lab, na.rm = TRUE),
    Malaria_tested = sum(malaria_sent_to_lab, na.rm = TRUE),
    Measles_tested = sum(measles_sent_to_lab, na.rm = TRUE),
    Typhoid_tested = sum(typhoid_fever_sent_to_lab, na.rm = TRUE),
    Monkeypox_tested = sum(monkeypox_sent_to_lab, na.rm = TRUE),
    Plague_tested = sum(plague_sent_to_lab, na.rm = TRUE),
    
    AFP_confirmed = sum(afp_confirmed, na.rm = TRUE),
    Anthrax_confirmed = sum(anthrax_confirmed, na.rm = TRUE),
    Cholera_confirmed = sum(cholera_confirmed, na.rm = TRUE),
    Diarrhoea_confirmed = sum(diarrhoea_non_bloody_confirmed, na.rm = TRUE),
    Malaria_confirmed = sum(malaria_confirmed, na.rm = TRUE),
    Measles_confirmed = sum(measles_confirmed, na.rm = TRUE),
    Typhoid_confirmed = sum(typhoid_fever_confirmed, na.rm = TRUE))

# Calculate cumulative summary
cumulative_summary <- cumulative_data %>%
  summarise(
    AFP_suspected = sum(afp_suspected, na.rm = TRUE),
    AFP_tested = sum(afp_sent_to_lab, na.rm = TRUE),
    AFP_confirmed = sum(afp_confirmed, na.rm = TRUE),
    Anthrax_suspected = sum(anthrax_suspected, na.rm = TRUE),
    Anthrax_tested = sum(anthrax_sent_to_lab, na.rm = TRUE),
    Anthrax_confirmed = sum(anthrax_confirmed, na.rm = TRUE),
    Cholera_suspected = sum(cholera_suspected, na.rm = TRUE),
    Cholera_tested = sum(cholera_sent_to_lab, na.rm = TRUE),
    Cholera_confirmed = sum(cholera_confirmed, na.rm = TRUE),
    Diarrhoea_suspected = sum(diarrhoea_non_bloody_suspecteded, na.rm = TRUE),
    Diarrhoea_tested = sum(diarrhoea_non_bloody_sent_to_lab, na.rm = TRUE),
    Diarrhoea_confirmed = sum(diarrhoea_non_bloody_confirmed, na.rm = TRUE),
    Malaria_suspected = sum(malaria_suspected, na.rm = TRUE),
    Malaria_tested = sum(malaria_sent_to_lab, na.rm = TRUE),
    Malaria_confirmed = sum(malaria_confirmed, na.rm = TRUE),
    Measles_suspected = sum(measles_suspected, na.rm = TRUE),
    Measles_tested = sum(measles_sent_to_lab, na.rm = TRUE),
    Measles_confirmed = sum(measles_confirmed, na.rm = TRUE),
    Typhoid_suspected = sum(typhoid_fever_suspected, na.rm = TRUE),
    Typhoid_tested = sum(typhoid_fever_sent_to_lab, na.rm = TRUE),
    Typhoid_confirmed = sum(typhoid_fever_confirmed, na.rm = TRUE),
    Monkeypox_suspected = sum(monkeypox_suspected, na.rm = TRUE),
    Monkeypox_tested = sum(monkeypox_sent_to_lab, na.rm = TRUE),
    Plague_suspected = sum(plague_suspected, na.rm = TRUE),
    Plague_tested = sum(plague_sent_to_lab, na.rm = TRUE))

# Save summaries
write.csv(week_summary, here("outputs", "tables", "week_summary.csv"), row.names = FALSE)
write.csv(cumulative_summary, here("outputs", "tables", "cumulative_summary.csv"), row.names = FALSE)

# Generate disease distribution by region for the week
disease_by_region <- week_data %>%
  select(org_unit_name, 
         afp_suspected, anthrax_suspected, cholera_suspected, 
         measles_suspected, diarrhoea_non_bloody_suspecteded,
         malaria_suspected, typhoid_fever_suspected) %>%
  pivot_longer(cols = -org_unit_name, names_to = "Disease", values_to = "Cases") %>%
  filter(Cases > 0)

write.csv(disease_by_region, here("outputs", "tables", "disease_by_region.csv"), row.names = FALSE)

message("Weekly analysis completed!")
