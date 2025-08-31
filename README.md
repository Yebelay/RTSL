# **Epidemiological Bulletin – Reproducible Scripts**
- This repository contains reproducible R scripts and supporting files used to generate automated epidemiological bulletins.

  ## 📂 Repository Structure

- data/: Contains all raw datasets (weekly_data_by_region.csv, measles_lab.xlsx, maternal_deaths.xlsx and shapefiles)
- R/: All R scripts for analysis(01_weekly_analysis.R, 02_measles_analysis.R, and 03_maternal_analysis.R)
- **epidemiological_bulletin.qmd** to generate bulletins in Word and export in PDF also.
- *custom-reference.docx* - this is the template of the document created in Word, as Word in Quarto is not supported with SCC
- outputs/: All generated results, plots, and tables. sunfolders: figures/ and  tables/

🚀 **Workflow**
**1. Run analysis scripts (in order):**
  - 01_weekly_analysis.R → processes weekly_data_by_region
  - 02_measles_analysis.R → processes measles_lab
  - 03_maternal_analysis.R → processes maternal deaths + shapefiles
- Outputs (tables and figures) will be saved automatically inside the outputs/ folder.
- 
**2. Generate the bulletin:**
   - Run epidemiological_bulletin.qmd (root folder) to produce the automated bulletin.

*The file compiles to Word, which can then be exported as PDF*
