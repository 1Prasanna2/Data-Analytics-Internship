# Day 22 — Cohort Retention Basics

## Project Overview

This project analyzes customer cohort retention using Python and SQL on the Online Retail II dataset.

The analysis groups customers into cohorts based on their first valid purchase month and then tracks the percentage of customers who remain active in subsequent months.

> **Important dataset assumption:** The Online Retail II dataset does not contain an actual signup or registration date. Therefore, the customer's **first valid purchase month is used as a proxy for signup/acquisition month**.

Python is used for data preparation, cohort-table assembly, validation, insights, and visualization. SQL is used for the core cohort aggregation, cohort assignment, period indexing, distinct-customer counts, and retention calculation.

---

## Objective

The analysis measures customer retention over time by:

1. Defining monthly customer cohorts.
2. Measuring customer activity after cohort acquisition.
3. Calculating retention for each cohort and month since acquisition.
4. Comparing retention trajectories across cohorts.
5. Identifying retention patterns from the cohort matrix.

---

## Dataset

**Dataset:** Online Retail II

The uploaded dataset contains:

- **1,067,371 rows**
- **8 columns**

Columns:

```text
Invoice
StockCode
Description
Quantity
InvoiceDate
Price
Customer ID
Country
```

### Data quality findings

| Check | Result |
|---|---:|
| Total rows | **1,067,371** |
| Total columns | **8** |
| Missing Customer ID | **243,007** |
| Missing InvoiceDate | **0** |
| Invalid InvoiceDate after parsing | **0** |
| Exact duplicate rows | **34,335** |
| Negative Quantity rows | **22,950** |
| Negative Price rows | **5** |
| Zero Price rows | **6,202** |
| Date range | **2009-12-01 to 2011-12-09** |

For cohort analysis, rows with missing `Customer ID` and rows with negative `Quantity` or negative `Price` were excluded.

After applying the analysis filter:

- **805,620 valid transaction rows**
- **5,881 unique customers**

---

## Tools and Libraries

### Python

Python is used for:

- Data loading and inspection
- Date conversion
- Data cleaning
- Cohort-table assembly
- SQL result validation
- Retention insights
- Heatmap visualization

### pandas

Used for:

- CSV loading
- Data inspection
- Datetime conversion
- Filtering
- Grouping
- Pivoting
- Cross-checking SQL results

### NumPy

Used for:

- Numerical calculations
- Missing-value handling
- Comparing SQL and pandas outputs

### SQLite

A local SQLite engine is used for SQL aggregation without requiring a database server.

SQL is used for:

- Cohort assignment
- Activity-month calculation
- Period indexing
- Distinct customer aggregation
- Cohort-size calculation
- Retention calculation

### Seaborn / Matplotlib

Used to create the cohort retention heatmap.

---

# Analysis Workflow

```text
Online Retail II CSV
        ↓
Data inspection
        ↓
Data cleaning
        ↓
First valid purchase month
        ↓
Customer cohort assignment
        ↓
Activity month
        ↓
Period index
        ↓
SQL cohort aggregation
        ↓
Retention percentage
        ↓
Pandas cohort matrix
        ↓
SQL ↔ Python validation
        ↓
Heatmap + retention insights
```

---

# 1. Data Preparation with Python

The dataset was loaded and inspected using pandas.

`InvoiceDate` was converted to a datetime field before monthly analysis.

The valid analysis population was defined as:

```text
Customer ID is not null
AND Quantity >= 0
AND Price >= 0
```

This removes records that could represent cancellations, returns, or invalid purchase values.

---

# 2. Cohort Definition

The dataset does not contain signup or registration dates.

Therefore, the cohort is defined as:

```text
Customer
   ↓
Earliest valid purchase
   ↓
Calendar month of first purchase
   ↓
Cohort month
```

For example:

```text
Customer A
First valid purchase → March 2010
Cohort → 2010-03
```

This is an acquisition/signup **proxy**, not an actual signup date.

---

# 3. Activity Month

Each valid transaction is converted to its calendar month.

Examples:

```text
2010-03-15 → 2010-03
2010-04-08 → 2010-04
2010-05-21 → 2010-05
```

The dataset spans:

```text
2009-12 through 2011-12
```

for a total of **25 calendar months**.

---

# 4. Period Index

The number of months between the cohort month and the activity month is calculated as:

```text
period_index =
(activity_year × 12 + activity_month)
-
(cohort_year × 12 + cohort_month)
```

This produces:

```text
M0 = first-purchase month
M1 = one month later
M2 = two months later
...
```

For example:

```text
December 2010 → January 2011

(2011 × 12 + 1)
-
(2010 × 12 + 12)
= 1
```

Therefore January 2011 is M1 for the December 2010 cohort.

### Period-index results

- Minimum period index: **0**
- Maximum period index: **24**

Every cohort has:

```text
M0 = 0
```

---

# 5. SQL Cohort Aggregation

SQLite is used for the core retention aggregation.

The SQL workflow follows:

```text
cleaned
   ↓
first_purchase
   ↓
cohort
   ↓
activity
   ↓
period_index
   ↓
counts
   ↓
retention
```

The cohort is assigned using:

```sql
MIN(activity_month)
```

grouped by customer.

The analysis then calculates distinct active customers using:

```sql
COUNT(DISTINCT customer_id)
```

and retention as:

```text
retention =
active_customers / cohort_size
```

The SQL aggregation produced:

**325 cohort-period records**

with the columns:

```text
cohort_month
period_index
active_customers
cohort_size
retention
```

---

# 6. Cohort Retention Matrix

The SQL retention output is pivoted in pandas into the classic cohort matrix.

- **Rows:** Cohort month
- **Columns:** Months since first purchase
- **Values:** Retention percentage

The final matrix contains:

- **25 cohort rows**
- **25 period columns**
- **M0 through M24**

### Example

| Cohort | M0 | M1 | M2 | M3 | M4 | M5 | M6 |
|---|---:|---:|---:|---:|---:|---:|---:|
| 2009-12 | 100.0% | 35.3% | 33.4% | 42.5% | 38.0% | 35.9% | 37.7% |
| 2010-01 | 100.0% | 20.6% | 31.1% | 30.5% | 26.4% | 30.0% | 25.8% |
| 2010-02 | 100.0% | 23.7% | 22.3% | 29.0% | 24.5% | 19.9% | 19.1% |
| 2010-03 | 100.0% | 19.0% | 23.0% | 24.2% | 23.3% | 20.3% | 24.6% |
| 2010-04 | 100.0% | 19.4% | 19.4% | 16.3% | 18.4% | 22.4% | 27.6% |

---

# 7. Consistent Retention Windows

Recent cohorts do not have enough elapsed time for later retention periods to be observed.

Therefore:

```text
Unobservable future period ≠ 0% retention
```

Those cells remain `NaN`.

For M1, M3 and M6 comparisons, the same set of cohorts that are old enough to have all three periods observable is used.

This prevents newer cohorts from being unfairly compared with older cohorts.

---

# 8. Python Cross-Check

The cohort calculation was independently rebuilt in pandas rather than simply reusing the SQL result.

SQL and pandas were compared on:

- Cohort month
- Period index
- Active customer count
- Cohort size
- Retention percentage

### Validation result

```text
SQL active-customer counts: MATCH
SQL cohort sizes:           MATCH
Maximum retention difference: 0.0
```

The independent Python calculation therefore reproduces the SQL result exactly.

---

# 9. Cohort Retention Heatmap

The final cohort matrix is visualized using Seaborn.

### Heatmap configuration

- **X-axis:** Months Since First Purchase
- **Y-axis:** Cohort Month
- **Color:** Retention percentage
- **Annotations:** Percentage values
- **Missing future periods:** Masked
- **Colorbar:** Retention %

The heatmap provides a compact view of cohort-level retention trajectories.

---

# 10. Retention Findings

## M0 retention

All **25 cohorts** have:

**M0 = 100%**

This is expected because the cohort denominator is defined using customers active during their first valid purchase month.

---

## Average retention for comparable cohorts

There are **19 cohorts** with all M1, M3 and M6 periods observable.

| Period | Average Retention |
|---|---:|
| M1 | **20.30%** |
| M3 | **21.41%** |
| M6 | **17.82%** |

Retention is therefore not strictly monotonic across the observed months.

---

## Strongest comparable cohort

The **2009-12 cohort** shows:

| Period | Retention |
|---|---:|
| M1 | **35.29%** |
| M3 | **42.51%** |
| M6 | **37.70%** |

---

## Weakest comparable cohort

The **2010-12 cohort** shows:

| Period | Retention |
|---|---:|
| M1 | **9.21%** |
| M3 | **9.21%** |
| M6 | **5.26%** |

This cohort contains **76 customers**, so its percentages should be interpreted with its smaller cohort size in mind.

---

## Non-monotonic retention

The 2009-12 cohort demonstrates the nature of transactional retention:

```text
M0 → 100.0%
M1 → 35.3%
M2 → 33.4%
M3 → 42.5%
M4 → 38.0%
M5 → 35.9%
M6 → 37.7%
```

Retention can rise after a lower month because customers can skip a purchase month and return later.

This is therefore a **repeat-purchase retention analysis**, not continuous subscription retention.

---

# 11. Key Technical Findings

### First-purchase cohort proxy

Actual signup information is unavailable, so first valid purchase month is used as the cohort acquisition proxy.

### Distinct-customer retention

Retention is measured using distinct customers active in each cohort-period rather than the number of transactions.

### Right-censoring

Recent cohorts have fewer observable future months, so unavailable periods are represented as missing rather than zero.

### Cohort differences

Retention trajectories differ across acquisition cohorts, with early cohorts such as 2009-12 showing stronger observed retention than weaker cohorts such as 2010-12 at comparable periods.

### SQL/Python agreement

The independent SQL and pandas implementations produce identical retention values, with a maximum difference of **0.0**.

---

# 12. Core Python Logic

```python
import pandas as pd
import numpy as np
import sqlite3
import matplotlib.pyplot as plt
import seaborn as sns

df = pd.read_csv(
    "online_retail_II_.csv",
    low_memory=False
)

df["InvoiceDate"] = pd.to_datetime(
    df["InvoiceDate"],
    errors="coerce"
)

valid = df.loc[
    df["Customer ID"].notna()
    & (df["Quantity"] >= 0)
    & (df["Price"] >= 0)
].copy()

valid["customer_id"] = (
    valid["Customer ID"]
    .astype(int)
    .astype(str)
)

valid["activity_month"] = (
    valid["InvoiceDate"]
    .dt.to_period("M")
    .dt.to_timestamp()
)
```

---


# 13. Output Structure

The analysis produces:

```text
cohort_retention_table.csv
cohort_retention_heatmap.png
cohort_retention_insights.md
```

The cohort table contains:

- 25 cohort rows
- M0–M24 retention columns

The heatmap visualizes the same matrix.

The insights summarize the quantified retention patterns.

---

# Conclusion

The Online Retail II transaction data was transformed into a customer cohort-retention analysis using SQL for the core aggregation and Python for data preparation, matrix construction, validation, visualization, and insight extraction.

The final analysis contains **25 monthly cohorts**, **M0–M24 retention periods**, and **325 cohort-period observations**.

The SQL and Python calculations agree exactly, with a maximum retention difference of **0.0**.

The analysis shows a strong initial drop after M0, followed by non-monotonic repeat-purchase behavior across later periods. The results also demonstrate meaningful differences between acquisition cohorts.

The cohort definition remains a **first-purchase-month proxy** because the source dataset does not contain an actual signup or registration date.

LINKEDIN: [link](https://lnkd.in/p/dpWfBGkq)