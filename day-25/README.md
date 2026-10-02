# Day 25 – Multi-Table Sales Analysis

## Overview

This project performs a multi-table sales analysis using the supplied Northwind-style CSV dataset. The analysis combines order, product, customer, category, supplier, shipper, and order-detail information using relational modeling.

The work was completed using **SQLite** for relational queries and validation and **Power BI** for data modeling, DAX calculations, visualization, and dashboard creation.

The main objective was to understand how multiple related tables can be combined for sales analysis while validating relationships and preventing double counting.

## Task Objectives

- Combine multiple related tables for sales analysis.
- Understand primary-key and foreign-key relationships.
- Calculate sales at the correct transaction grain.
- Validate joins before using the data for reporting.
- Avoid double counting orders and sales.
- Build a Power BI dashboard from the supplied CSV files.
- Identify data-quality and relationship-matching issues.

## Tools Used

- **SQLite** – relational queries, joins, validation, and aggregation.
- **Power BI** – data modeling, DAX measures, visualizations, and dashboard creation.
- **CSV** – source data format.

## Dataset Tables

The supplied dataset contained these seven CSV files:

- `Orders.csv`
- `OrderDetails.csv`
- `Products.csv`
- `Customers.csv`
- `Categories.csv`
- `Suppliers.csv`
- `Shippers.csv`

### Main Relationships

```text
Customers[CustomerID] 1 ─── * Orders[CustomerID]
Orders[OrderID]       1 ─── * OrderDetails[OrderID]
Products[ProductID]   1 ─── * OrderDetails[ProductID]
Categories[CategoryID] 1 ─── * Products[CategoryID]
Suppliers[SupplierID] 1 ─── * Products[SupplierID]
Shippers[ShipperID]   1 ─── * Orders[ShipperID]
```

`OrderDetails` was treated as the **fact-level table** because each row represents an individual order-product line.

## SQL Analysis

SQLite was used to inspect table structures, validate relationships, perform joins, and calculate aggregated results.

The analysis focused on:

1. Counting orders and order-detail records.
2. Checking whether order-detail product IDs matched the product master.
3. Checking whether order customer IDs matched the customer master.
4. Joining tables without losing the original order-detail records.
5. Calculating sales using matched product prices.
6. Using `DISTINCT` / `COUNT(DISTINCT ...)` where required to avoid double counting.
7. Comparing joined results with source-table totals.

### Sales Calculation

Sales were calculated at the order-detail level:

```text
Sales Amount = Product Price × Quantity
```

This preserves the correct transaction grain and avoids calculating sales from an already-aggregated order table.

## Relationship Validation Results

The supplied CSV files were not completely aligned with one another. The analysis therefore used the actual contents of the files rather than assuming every foreign key had a matching master record.

### Record Counts

| Table | Records |
|---|---:|
| OrderDetails | 26 |
| Orders | 21 |
| Products | 25 |

### Product Relationship Check

There were **26 order-detail rows**, but only **9** matched a `ProductID` in the supplied `Products.csv`.

```text
Matched product lines = 9
Total order-detail lines = 26
Product match rate = 34.6%
```

Therefore, **17 order-detail rows did not have a corresponding product record** in the supplied product table. Because product price is required for the sales calculation, product-price-based sales were calculated only for matched product lines.

### Customer Relationship Check

There were **21 orders**, but only **3** order records had a matching `CustomerID` in the supplied `Customers.csv`.

```text
Matched customer orders = 3
Total orders = 21
Customer match rate = 14.3%
```

This indicates that the supplied customer master does not contain customer records for most IDs referenced by `Orders.csv`.

These mismatches were retained as a data-quality finding rather than inventing or modifying IDs.

## Power BI Data Model

All seven CSV files were imported into Power BI separately.

The model was built around the `OrderDetails` fact table and the related master tables.

### Modeling Principle

The dashboard does not use an inner-join approach that removes unmatched order-detail rows. Instead, the relationship model preserves the transaction records and separately measures how many records successfully match the master tables.

## DAX Measures

### Order Detail Count

```DAX
Order Detail Count =
COUNTROWS(OrderDetails)
```

### Total Orders

```DAX
Total Orders =
DISTINCTCOUNT(Orders[OrderID])
```

### Matched Product Lines

```DAX
Matched Product Lines =
CALCULATE(
    COUNTROWS(OrderDetails),
    OrderDetails[Product Match] = "Matched"
)
```

### Product Match Rate

```DAX
Product Match Rate =
DIVIDE(
    [Matched Product Lines],
    [Order Detail Count],
    0
)
```

### Matched Customer Orders

```DAX
Matched Customer Orders =
CALCULATE(
    DISTINCTCOUNT(Orders[OrderID]),
    Orders[Customer Match] = "Matched"
)
```

### Customer Match Rate

```DAX
Customer Match Rate =
DIVIDE(
    [Matched Customer Orders],
    [Total Orders],
    0
)
```

### Total Sales

```DAX
Total Sales =
SUM(OrderDetails[Sales Amount])
```

## Calculated Columns

### Unit Price

```DAX
Unit Price =
RELATED(Products[Price])
```

### Sales Amount

```DAX
Sales Amount =
IF(
    ISBLANK(OrderDetails[Unit Price]),
    BLANK(),
    OrderDetails[Unit Price] * OrderDetails[Quantity]
)
```

### Product Match

```DAX
Product Match =
IF(
    ISBLANK(OrderDetails[Unit Price]),
    "Missing Product",
    "Matched"
)
```

### Customer Match

```DAX
Customer Match =
IF(
    ISBLANK(RELATED(Customers[CustomerName])),
    "Missing Customer",
    "Matched"
)
```

## Dashboard Structure

The Power BI dashboard was designed as a sales overview with relationship-quality checks.

### KPI Cards

- Order Detail Count
- Total Orders
- Product Match Rate
- Customer Match Rate
- Matched Product Sales

### Visuals

- Monthly Sales trend
- Sales by Category
- Top Products by Sales
- Sales by Customer Country
- Matched Customer performance table
- Relationship/data-quality summary

### Slicers

- Order Date
- Country
- Category

The dashboard distinguishes between overall source-table counts and sales/customer analysis based on successfully matched records.

## Preventing Double Counting

One of the main objectives of this task was to understand how joins can cause double counting.

The solution was to respect table grain:

```text
Order
  ↓
OrderDetails
  ↓
Product
```

An order can contain multiple order-detail rows, so counting rows in `OrderDetails` is **not** the same as counting orders.

For example:

```DAX
COUNTROWS(OrderDetails)
```

counts order-detail lines, while:

```DAX
DISTINCTCOUNT(Orders[OrderID])
```

counts unique orders.

This distinction is essential when creating KPIs or aggregating sales.

## Key Findings

### 1. Order and Order-Detail Grain Are Different

The dataset contains **26 order-detail records** across **21 distinct orders**. This demonstrates why order counts should use `DISTINCTCOUNT(OrderID)` rather than counting order-detail rows.

### 2. Product Master Matching Is Incomplete

Only **9 of 26 order-detail rows** matched the supplied product table, giving a **34.6% product match rate**. Product-price-based sales calculations can therefore only be made for the matched subset.

### 3. Customer Master Matching Is Incomplete

Only **3 of 21 orders** matched the supplied customer table, resulting in a **14.3% customer match rate**. Customer-level analysis therefore represents only the matched customer subset.

### 4. Join Validation Is Necessary Before Reporting

The supplied tables should not be assumed to be fully consistent. Checking foreign-key coverage before calculating business KPIs prevented unmatched records from being silently removed by inner joins.

### 5. Relational Modeling Helps Separate Sales Analysis From Data-Quality Issues

The Power BI model preserves the original transaction records while exposing product and customer matching rates separately. This allows the dashboard to show both sales information and the limitations of the source data.

## Data Quality Considerations

The supplied CSV files appear to represent a partial or incomplete relational extract rather than a fully matched Northwind database.

Therefore:

- IDs were not artificially changed.
- Missing master records were not recreated with invented information.
- Unmatched records were retained where possible.
- Match rates were calculated explicitly.
- Sales were not calculated using fabricated product prices.
- Customer-level findings were limited to records with valid customer matches.

## Validation Approach

```text
Load CSV files
     ↓
Inspect table structure
     ↓
Identify primary/foreign-key relationships
     ↓
Count source records
     ↓
Validate join coverage
     ↓
Build relational model
     ↓
Calculate sales at line-item level
     ↓
Validate distinct order counts
     ↓
Build Power BI visuals
     ↓
Review relationship-quality metrics
```

This validation step was important because a technically valid SQL join can still produce misleading business results if the underlying relationships are incomplete.

## What Was Achieved

By completing this task, the analysis demonstrated the ability to:

- Work with multiple related tables.
- Understand fact-table and dimension-table relationships.
- Write relational SQL queries in SQLite.
- Validate foreign-key coverage before reporting.
- Calculate sales at the correct grain.
- Distinguish order counts from order-detail counts.
- Prevent double counting with `DISTINCTCOUNT`.
- Build a relational model in Power BI.
- Create DAX measures and calculated columns.
- Present relationship-quality issues directly in a dashboard.
- Produce business insights while clearly stating limitations in the source data.

## Conclusion

Day 25 focused on applying relational database concepts to a practical sales-analysis problem.

The key learning was that **joining tables is not enough**. Before using joined data for reporting, the relationships must be validated, the grain of each table must be understood, and aggregation logic must be chosen carefully.

The final Power BI dashboard combines sales analysis with relationship-quality checks, keeping the reported results traceable to the supplied CSV data.

## Project Deliverables

```text
Day-25/
│
├── Orders.csv
├── OrderDetails.csv
├── Products.csv
├── Customers.csv
├── Categories.csv
├── Suppliers.csv
├── Shippers.csv
│
├── Day25_MultiSales_Analysis.pbix
└── README.md
```

LINKEDIN: [link](https://lnkd.in/p/dRaZm_4d)