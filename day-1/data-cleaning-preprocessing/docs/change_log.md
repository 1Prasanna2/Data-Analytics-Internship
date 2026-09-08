# 🧹 Data Cleaning Change Log
**Project:** Sample Superstore Analytics  
**Dataset:** SampleSuperstore.csv (13 Columns)  
**Date:** 08-09-2026  
**Author:** Prasanna D Shetty

## 📋 Overview
This document tracks every transformation applied to the raw dataset to produce the final analytical dataset (`SampleSuperstore_Cleaned.csv`). Every change is mapped to a specific data quality issue and justified by business logic.

---

## 🔄 Transformation Pipeline

### Phase 1: Ingestion & Header Standardization
| Target Area | Data Quality Issue | Code Action | Business/Data Rationale |
| :--- | :--- | :--- | :--- |
| **Headers** | Column names contained hidden leading/trailing whitespaces (e.g., `" Discount "`). | `df.columns.str.strip()` | Prevents `KeyError` during downstream analysis and ensures accurate column mapping. |
| **Discount** | Missing values were recorded as the literal string `" -   "` instead of `NaN`. | `pd.read_csv(..., na_values=[' -   ', '-', ...])` | Allows Pandas to correctly cast the column to `float64` for mathematical aggregations instead of treating it as text. |

### Phase 2: String & Categorical Normalization
| Target Column(s) | Data Quality Issue | Code Action | Business/Data Rationale |
| :--- | :--- | :--- | :--- |
| **All String Cols** | Inconsistent trailing spaces in text fields. | `df[col].str.strip()` | Prevents duplicate grouping errors (e.g., `"East"` vs `" East "`). |

### Phase 3: Deduplication
| Target Area | Data Quality Issue | Code Action | Business/Data Rationale |
| :--- | :--- | :--- | :--- |
| **Entire Dataset** | Exact duplicate rows found. | `df.drop_duplicates()` | Removed **17** exact duplicate rows to prevent double-counting of Sales and Profit metrics. |

### Phase 4: Data Type Enforcement
| Target Column(s) | Data Quality Issue | Code Action | Business/Data Rationale |
| :--- | :--- | :--- | :--- |
| **Quantity** | Stored as float/object. | `.astype(int)` | Quantities are discrete units and must be integers. |
| **Sales, Profit, Discount** | Potential string artifacts preventing math operations. | `pd.to_numeric(..., errors='coerce')` | Forces `float64` typing; converts any un-parseable string anomalies into `NaN` for safe handling in Phase 6. |

---

## 📊 Final Dataset Metrics

| Metric | Raw Dataset | Cleaned Dataset | Difference |
| :--- | :--- | :--- | :--- |
| **Total Rows** | 9994 | 9977 | -17 Rows |
| **Total Columns** | 13 | 13 | 0 |
| **Missing Values** | 0 | 0 | Resolved |
| **Duplicate Rows** | 17 | 0 | Resolved |

## 🔒 Rollback Strategy
The original, untouched file is preserved in `data/raw/SampleSuperstore.csv`. This cleaning pipeline is fully reproducible from source to finish by running the Jupyter Notebook / Python script. 
