# Biol5930: Deer Pellet and Kill Count Analysis (2014–2022)

This repository contains the final project for the Biol5930 course. The goal is to explore whether pellet group counts can predict deer harvest outcomes in Black Rock Forest.

## 📁 Project Structure

- `/data/raw/` – Original pellet and kill datasets
- `/data/processed/` – Cleaned and filtered datasets (2014–2022)
- `/scripts/` – R scripts used for cleaning, analysis, and visualization
- `/figures/` – Output plots used in the report
- `/report/` – Final submission document

## 📊 Methods

- Data cleaned and filtered using `dplyr` and `lubridate`
- Visualization with `ggplot2`
- Pearson correlation analysis used to examine the relationship between pellet and kill counts

## 📈 Final Result

- Pearson correlation: **r = -0.565**, **p = 0.145**
- Visualizations show no strong alignment between observed pellet activity and harvest trends

## 📄 Data Sources

- Pellet Data: [EDI Dataset 1805](https://search.dataone.org/view/https%3A%2F%2Fpasta.lternet.edu%2Fpackage%2Fmetadata%2Feml%2Fedi%2F1805%2F1)
- Kill Data: [EDI Dataset 1873](https://portal.edirepository.org/nis/mapbrowse?scope=edi&identifier=1873)
