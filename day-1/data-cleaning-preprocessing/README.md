# 📊 Data Cleaning & Business Analytics: Sample Superstore

## 🎯 Project Objective
The objective of this project (Internship Task 1) was to take a raw, messy retail dataset, audit it for quality issues, clean it, and perform some preprocessing tasks to uncover actionable business insights. 

## 📦 The Dataset 
**Sample Superstore Dataset** (Retail Sales & Profitability)
- **Initial State:** 13 columns, mixed data types, hidden whitespace in headers, string-encoded missing values, and truncated geographic identifiers.
- **Final State:** Fully standardized, logically validated.

## ⚙️ Process
1. Initial data quality assessment
2. Handled missing values (imputation/dropping)
3. Removed duplicates
4. Standardized formats
5. Corrected data types

## 🛠️ Tech Stack
- **Python** (Pandas, NumPy)
- **Environment** (Jupyter Notebook / VS Code)

## 🔍 Key Findings
- **Column Name Issue**: Initial spaces found in the column name Discount that hindered while loading the data in the Notebook       
- **Duplicated Rows**: Found ***17*** duplicated rows in the dataset of SampleSuperStore.csv
- **Removal of Duplicated Rows**: Removed the duplicate rows present in the dataset for avoid redundancy problems.

## 📃Raw Dataset and Clean Dataset Path
If in case any issues arise during the EDA and any further we can anytime fallback to the original raw dataset for references
Raw:- ***data/raw/SampleSuperstore.csv***

Path:- ***data/clean/Cleaned_SampleSuperstore.csv***

## 📁 Repository Structure
```text
├── data/
│   ├── raw/              # Original untouched CSV
│   └── cleaned/          # Final production-ready CSV
├── notebooks/            # Step-by-step Jupyter notebooks
├── docs/                 # Documentation (Change Log & Write-up)
└── README.md