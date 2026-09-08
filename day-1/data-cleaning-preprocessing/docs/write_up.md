# 📄 Data Cleaning Write-Up — Sample Superstore (Cleaned Dataset)

**File:** `data/cleaned/SampleSuperstore_Cleaned.csv`
**Source:** `data/raw/SampleSuperstore.csv`
**Author:** Prasanna D Shetty · **Date:** 08-09-2026 · **Tools:** Python, Pandas, NumPy

---

## 1. Executive Summary
The raw Superstore extract contained **7** distinct data quality issues across
four categories: schema/formatting errors, encoded missing values. After cleaning, the dataset
went from **9994** rows to **9977** rows (**17** rows removed,
**0.17%** of data), with **zero missing values, zero duplicates, and 100% pass rate
on all validation checks**. The file is now analysis-ready.

## 2. Dataset Overview
- **Grain:** One row per sales transaction line item.
- **Columns (13):** Ship Mode, Segment, Country, City, State, Postal Code, Region,
  Category, Sub-Category, Sales, Quantity, Discount, Profit.
- **Scope note:** This extract contains no Order ID or date columns, so
  order-level deduplication and time-series checks were out of scope.

| Metric | Raw | Cleaned |
|---|---|---|
| Rows | 9994 | 9977 |
| Columns | 13 | 13 |
| Missing cells | 0 | 0 |
| Duplicate rows | 17 | 0 |

## 3. Issues Found & How Each Was Resolved

**Issue 1 — Whitespace in column headers**
- *Found:* The discount column was named `" Discount "` (leading/trailing spaces),
  which breaks column references (`KeyError`).
- *Resolved:* `df.columns = df.columns.str.strip()`.
- *Rationale:* Schema hygiene; prevents silent reference failures downstream.

**Issue 2 — Missing values encoded as sentinel strings**
- *Found:* **4798** missing discounts were stored as the literal text `" -   "`,
  forcing the column to load as `object` (text) instead of numeric.
- *Resolved:* Declared `na_values=[' -   ', '-', ' ', '']` at load time, then
  imputed remaining nulls with `0.0`.
- *Rationale:* In retail transaction data, a blank discount means *no discount
  was applied*, so `0.0` is the business-correct value — not a guess.

**Issue 3 — Exact duplicate rows**
- *Found:* **17** fully duplicated transaction rows.
- *Resolved:* `df.drop_duplicates()`.
- *Rationale:* Duplicates inflate Sales/Profit totals; with no Order ID present,
  exact-row duplication cannot be legitimate.

**Issue 4 — Incorrect data types**
- *Found:* `Quantity` loaded as float and financial columns risked object dtype
  due to string artifacts.
- *Resolved:* `Quantity → int64`; `Sales`, `Profit`, `Discount → float64` via
  `pd.to_numeric(errors='coerce')`.
- *Rationale:* Correct types are required for aggregation and visualization.

## 4. Null-Handling Decisions (case by case)
| Column | Strategy | Why |
|---|---|---|
| Discount | **Impute** (0.0) | Non-numeric_value('-') = no discount applied (business rule) |

## 5. Cleaned File Schema (Data Dictionary)
| Column | Dtype | Description | Valid Range / Values |
|---|---|---|---|
| Ship Mode | object | Delivery speed | Same Day, First/Second/Standard Class |
| Segment | object | Customer type | Consumer, Corporate, Home Office |
| Country | object | Country | United States |
| City / State | object | Location | Title case / UPPER case |
| Postal Code | object | 5-digit ZIP string | `^\d{5}$` |
| Region | object | Sales region | Central, East, South, West |
| Category / Sub-Category | object | Product hierarchy | 3 categories / 17 sub-categories |
| Sales | float64 | Gross revenue (USD) | > 0 |
| Quantity | int64 | Units sold | > 0 |
| Discount | float64 | Discount rate | 0.0 – 1.0 |
| Profit | float64 | Net profit (USD) | May be negative (legitimate losses) |

## 6. Post-Cleaning Validation (all passed ✅)
```python
checks = {
    "No missing values":   df.isnull().sum().sum() == 0,
    "No duplicate rows":   df.duplicated().sum() == 0,
    "ZIP format valid":    df['Postal Code'].str.fullmatch(r'\d{5}').all(),
    "Discount in [0,1]":   df['Discount'].between(0, 1).all(),
    "Sales > 0":           (df['Sales'] > 0).all(),
    "Quantity > 0":        (df['Quantity'] > 0).all(),
}
assert all(checks.values()) 
