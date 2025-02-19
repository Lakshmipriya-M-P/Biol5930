# Biol5930
# Biol5930 - Data Cleaning Project

## 📌 Overview
This repository contains scripts and data for cleaning BRF deer pellet data.

## 📂 Repository Structure:
- `/data/raw/` → Contains unmodified raw data
- `/data/processed/` → Contains cleaned data
- `/scripts/` → R scripts for data cleaning
- `/docs/` → Project notes and metadata
- `.github/workflows/` → GitHub Actions automation

## 🛠 Running the Cleaning Script
```bash
Rscript scripts/data_cleaning.R

mv BRF_deer_pellet_data_RAW.csv data/raw/
mv BRF_deer_pellet_data_clean.csv data/processed/
mv BRF_deer_pellet_transect_locations.csv data/raw/
mv BRF pellet data cleaning.R scripts/data_cleaning.R
mv edi.1805.1.xml docs/metadata/
mv edi.1805.1-report.xml docs/

git add .
git commit -m "Reorganized repository structure"
git push origin main

