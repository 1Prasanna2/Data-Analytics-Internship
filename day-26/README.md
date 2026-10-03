# Day 26 – Executive KPI Dashboard

## Overview

Day 26 focused on creating a **one-page executive management dashboard** in **Power BI** using the **Superstore** dataset.

The objective was to create a concise business report that allows management to understand overall performance through a limited set of KPIs, trend analysis, supporting breakdowns, and dynamic filters.

The dashboard was designed with emphasis on:

- Clear KPI definitions
- Limited and relevant visuals
- Dynamic filtering
- Accurate calculations
- Executive-level readability
- Minimal visual clutter

---

## Task Objective

> Create a one-page management dashboard with dynamic filters.

The dashboard was designed as an executive overview rather than a detailed transaction-level report.

---

## Tool Used

- **Power BI**

---

## Dataset

### Superstore

The dashboard uses the Superstore sales dataset supplied for the task.

The dataset supports analysis using business dimensions such as:

- Order Date
- Region
- Category
- Segment
- Product
- Customer

Exact row counts and KPI values depend on the supplied Superstore file.

---

# KPI Design

The dashboard uses a limited set of management KPIs:

1. **Total Revenue**
2. **Total Profit**
3. **Profit Margin**
4. **Total Orders**
5. **Total Customers**

These metrics provide a concise view of sales, profitability, transaction activity, and customer reach.

## KPI Definitions

| KPI | Definition |
|---|---|
| Total Revenue | Sum of the Sales value across transactions |
| Total Profit | Sum of the Profit value across transactions |
| Profit Margin | Total Profit divided by Total Revenue |
| Total Orders | Distinct count of Order ID |
| Total Customers | Distinct count of Customer ID |

---

# DAX Measures

## Total Revenue

```DAX
Total Revenue =
SUM('Orders'[Sales])
```

## Total Profit

```DAX
Total Profit =
SUM('Orders'[Profit])
```

## Profit Margin

```DAX
Profit Margin =
DIVIDE(
    [Total Profit],
    [Total Revenue],
    0
)
```

The result is formatted as a percentage.

## Total Orders

```DAX
Total Orders =
DISTINCTCOUNT('Orders'[Order ID])
```

`DISTINCTCOUNT` is used because one order can contain multiple line-item records. Counting rows directly could therefore overstate the number of orders.

## Total Customers

```DAX
Total Customers =
DISTINCTCOUNT('Orders'[Customer ID])
```

---

# Date Table

A dedicated date table was created to support time-based analysis and previous-year comparison.

```DAX
DimDate =
ADDCOLUMNS(
    CALENDAR(
        MIN('Orders'[Order Date]),
        MAX('Orders'[Order Date])
    ),
    "Year", YEAR([Date]),
    "Month", FORMAT([Date], "MMMM"),
    "MonthNum", MONTH([Date]),
    "Quarter", "Q" & FORMAT([Date], "Q"),
    "YearMonth", FORMAT([Date], "YYYY-MM"),
    "YearMonthSort", YEAR([Date]) * 100 + MONTH([Date])
)
```

The date table must be created using **Modeling → New table**, because the expression returns a table rather than a scalar value.

## YearMonth Sorting

`YearMonth` is produced using `FORMAT()` and is therefore a text field. It is sorted using `YearMonthSort`:

```text
DimDate[YearMonth]
        ↓
Sort by column
        ↓
DimDate[YearMonthSort]
```

This keeps the monthly axis chronological instead of alphabetical.

---

# Date Relationship

The date table is related to the Orders table as follows:

```text
DimDate[Date]  1 ───── *  Orders[Order Date]
```

Recommended relationship configuration:

- Cardinality: **One-to-many**
- Cross-filter direction: **Single**

This allows the date dimension to control time-based analysis.

---

# Year-over-Year Revenue

A previous-year revenue measure was created for the trend comparison:

```DAX
Revenue LY =
CALCULATE(
    [Total Revenue],
    SAMEPERIODLASTYEAR('DimDate'[Date])
)
```

This enables comparison between current-period revenue and the corresponding period from the previous year.

---

# Dashboard Structure

The dashboard follows a single-page executive layout.

## 1. KPI Cards

The top section contains:

- Total Revenue
- Total Profit
- Profit Margin
- Total Orders
- Total Customers

The KPI count is intentionally limited to avoid information overload.

## 2. Revenue Trend

A line chart compares current revenue with previous-year revenue.

### Fields

**Axis**

```text
DimDate[YearMonth]
```

**Values**

```text
Total Revenue
Revenue LY
```

The chart answers:

> How is revenue changing over time compared with the previous year?

## 3. Profit by Category

A category-level visual compares profitability across product categories.

**Axis**

```text
Category
```

**Values**

```text
Total Profit
```

## 4. Sales by Region

A regional visual compares revenue across regions.

**Axis**

```text
Region
```

**Values**

```text
Total Revenue
```

## 5. Top Products

A Top-N product visual highlights the products contributing the most revenue instead of displaying the full product list.

---

# Dynamic Filters

The dashboard includes relevant slicers for interactive analysis:

- Order Date
- Region
- Category
- Segment

The slicers are intended to dynamically update the KPI cards and relevant analytical visuals.

For example, selecting a region should update revenue, profit, margin, orders, customers, trend analysis, category analysis, and product analysis where applicable.

---

# Executive Dashboard Design Principles

## Limited KPI Count

Only high-value management KPIs are displayed. The goal is to communicate business performance quickly rather than show every available metric.

## Visual Hierarchy

The dashboard prioritizes information in this order:

```text
KPIs
  ↓
Performance Trend
  ↓
Business Breakdowns
```

## Minimal Clutter

Unnecessary transaction tables, excessive slicers, and redundant visuals are excluded.

## Consistent Formatting

The dashboard uses consistent titles, number formats, spacing, alignment, and visual hierarchy.

---

# Validation

Validation was performed before finalizing the dashboard.

## KPI Validation

The following were checked against the source data:

```text
Total Revenue
Total Profit
Profit Margin
Total Orders
Total Customers
```

Special attention was given to Orders and Customers because both require distinct counting.

## Date Validation

The date model was checked to confirm that:

- Order Date is recognized correctly.
- The DimDate table covers the required period.
- YearMonth is chronologically sorted.
- The DimDate → Orders relationship is active.
- Previous-year calculations use the date table.

## Filter Validation

The main slicers were tested with selections for:

```text
Region
Category
Segment
Date
```

The KPI cards and analytical visuals should respond consistently to those selections.

---

# Executive Questions Answered

### How is the business performing?

Answered through Total Revenue, Total Profit, and Profit Margin.

### Is revenue changing over time?

Answered through the Revenue Trend visual.

### How does current performance compare with the previous year?

Answered through the Revenue vs Revenue LY comparison.

### Which categories contribute to profitability?

Answered through Profit by Category.

### Which regions are generating sales?

Answered through Sales by Region.

### Which products are major revenue contributors?

Answered through the Top Products visual.

---

# Interview Question 1

## What belongs on an executive dashboard?

An executive dashboard should contain a limited set of high-value KPIs and visuals that summarize business performance, trends, and major business drivers. The information should support quick decision-making rather than provide detailed transaction-level data. This dashboard uses Revenue, Profit, Profit Margin, Orders, Customers, trend analysis, category performance, regional performance, and top products to provide the management view.

---

# Interview Question 2

## How do you avoid clutter?

Clutter can be avoided by limiting the number of KPIs and visuals, removing unnecessary fields, using a clear visual hierarchy, keeping slicers relevant, and avoiding large transaction tables. Each visual should have a defined business purpose, and information that does not help interpret performance should be excluded.

---

# Skills Demonstrated

This task demonstrates practical ability in:

- Power BI dashboard design
- Executive KPI design
- DAX measures
- Distinct counting
- Profitability calculations
- Date-table creation
- Time-series analysis
- Previous-year comparison
- Dynamic slicers
- Dashboard validation
- Visual hierarchy
- Executive reporting

---

# Key Learning

The main learning from Day 26 was that an executive dashboard should prioritize **clarity, relevance, and decision support** rather than trying to display every available metric.

A strong management dashboard combines a small set of well-defined KPIs with a few supporting visuals and dynamic filters while maintaining accurate calculations and a clean one-page layout.

---

## Project Deliverable

```text
Day-26/
│
├── data/Superstore dataset
├── deliverables/Day26_Executive_KPI_Dashboard.pbix
├── assets
├── docs/Day-26-Intern-Report.pdf
└── README.md
```
LINKEDIN: [link](https://lnkd.in/p/dPfyessY)