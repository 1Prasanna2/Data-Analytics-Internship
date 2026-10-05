# Day 28 – Customer Repeat Purchase Analysis

## Overview

Day 28 focused on understanding **customer repeat-purchase behavior** using the Online Retail II dataset.

The analysis was designed to answer questions such as:

- How many customers return to purchase again?
- How does repeat behavior change over different observation windows?
- How quickly do customers make their second purchase?
- How regularly do repeat customers purchase?
- Do repeat customers have a higher Average Order Value than first-time customers?
- Which customer segments are the most valuable?
- Which high-value customers may require re-engagement?

The main analytical implementation was performed using **SQL Server**, with **RFM-based customer segmentation** used to convert transaction-level behavior into actionable customer groups.

---

# Dataset

**Source file:** `./data/online_retail_II_v2.csv`

The analysis uses the customer, invoice, quantity, price, and invoice-date information available in the dataset.

The important fields for this project were:

```text
CustomerID
Invoice
InvoiceDate
Quantity
Price
Sales
Description
Country
StockCode
```

The dataset contains transaction line items, so one invoice can contain multiple product rows.

Therefore, a critical modeling decision was made:

> **One distinct valid invoice represents one purchase/order for a customer.**

---

# Tools Used

## SQL Server

Used as the primary analytical tool for:

- Data preparation
- Order-level aggregation
- Customer purchase history
- First-time vs repeat order classification
- Repeat Purchase Rate
- Purchase Frequency
- Time to Second Purchase
- Interpurchase Interval
- RFM scoring
- Customer segmentation
- Segment summary analysis

## Python

Used as a supporting tool where required for validation and exploratory analysis.

---

# Data Preparation

The raw transaction data was converted to an **order-level table** before calculating customer metrics.

A purchase was treated as valid when:

```text
CustomerID is present
Quantity > 0
Price > 0
Invoice is not a cancellation invoice
```

Line-item records were then aggregated by:

```text
CustomerID + Invoice
```

This avoids counting a multi-product invoice as multiple purchases.

---

# Main SQL Analysis Tables

The analysis was organized into reusable tables:

```text
dbo.customer_orders
dbo.customer_order_summary
dbo.order_classification
dbo.customer_acquisition
dbo.customer_purchase_history
dbo.customer_rfm
dbo.rfm_segment_summary
```

### customer_orders

One row per:

```text
Customer + Invoice
```

Contains:

- CustomerID
- Invoice
- InvoiceDate
- OrderRevenue

### customer_order_summary

One row per customer containing:

- Total orders
- First purchase date
- Last purchase date
- Lifetime revenue
- Customer lifespan
- Repeat-customer flag
- Observed orders per 30 days

### order_classification

One row per customer order containing:

- Purchase number
- Order revenue
- First-Time / Repeat classification

### customer_purchase_history

Provides:

- Acquisition date
- Days since acquisition
- Purchase number

This table was used as a common foundation for repeat-purchase timing metrics.

---

# First-Time vs Repeat Purchase Analysis

Orders were chronologically ranked for each customer using:

```sql
ROW_NUMBER() OVER (
    PARTITION BY CustomerID
    ORDER BY InvoiceDate, Invoice
)
```

The classification was:

```text
Purchase 1  → First-Time
Purchase 2+ → Repeat
```

This is preferable to using `MIN(Invoice)` because invoice identifiers are not guaranteed to represent chronological order.

## AOV Comparison

First-time and repeat orders were compared using:

```text
Average Order Value =
Total Order Revenue / Number of Orders
```

### Observed result

- First-time AOV: **412.18**
- Repeat AOV: **480.91**
- Repeat AOV is approximately **16.67% higher**

The result indicates that repeat orders in this dataset have a higher average value than first-time orders.

---

# Repeat Purchase Rate (RPR)

RPR was calculated across multiple post-acquisition observation windows:

- 30 days
- 60 days
- 90 days
- 180 days
- 365 days

The definition used was:

```text
RPR =
Customers with ≥2 purchases in the observation window
----------------------------------------------------
Customers with ≥1 purchase in the observation window
```

Acquisition date was defined as:

> The customer's first valid purchase date.

This is a proxy for acquisition because the Online Retail II dataset does not contain a separate customer signup or marketing-acquisition date.

## Observed RPR

| Observation Window | RPR |
|---:|---:|
| 30 days | **23.61%** |
| 60 days | **38.16%** |
| 90 days | **46.70%** |
| 180 days | **60.24%** |
| 365 days | **69.50%** |

The increasing RPR demonstrates that a larger proportion of customers become repeat purchasers as the observation period becomes longer.

---

# Purchase Frequency (PF)

Purchase Frequency was defined as:

```text
Purchase Frequency =
Total Orders in Window
----------------------
Active Customers in Window
```

Observed purchase frequency increased from:

- **1.36 orders/customer at 30 days**
- to **4.43 orders/customer at 365 days**

This demonstrates increasing purchase activity when customers are observed over longer periods.

---

# Time to Second Purchase (T2)

T2 measures the number of days between the customer's first and second orders.

The primary metric used was the **median T2 among converters**, where converters are customers who made a second purchase.

## Observed results

- Second-purchase converters: **4,255**
- Mean T2: **97.05 days**
- Median T2: **55 days**

The median is lower than the mean, indicating that some customers take substantially longer than typical to make their second purchase.

### Window-based median T2

| Observation Window | Median T2 |
|---:|---:|
| 30 days | **10 days** |
| 60 days | **21 days** |
| 90 days | **30 days** |
| 180 days | **42 days** |
| 365 days | **51 days** |

---

# Interpurchase Interval (IPI)

IPI measures the number of days between consecutive customer orders.

The analysis used SQL Server's `LAG()` function to calculate the previous order date for each customer.

Metrics included:

- Mean IPI
- Median IPI
- IPI variance

## Observed results

Across **31,091 interpurchase intervals**:

- Mean IPI: **51.24 days**
- Median IPI: **24 days**
- IPI variance: **5,738.54 days²**
- 25th percentile: **6 days**
- 75th percentile: **61 days**

The difference between the mean and median indicates a wide spread in customer purchasing intervals.

---

# RFM-Based Customer Segmentation

RFM analysis was included to convert customer purchasing behavior into actionable segments.

## RFM Definitions

### Recency

Number of days since the customer's most recent purchase.

Lower number of days means a more recent purchase.

### Frequency

Number of distinct orders placed by the customer.

### Monetary

Total order revenue generated by the customer.

---

# RFM Scoring

Each dimension was converted to a **1–5 score using quintile-based segmentation**.

### Recency

Higher score = more recent customer.

### Frequency

Higher score = more frequent customer.

### Monetary

Higher score = higher customer value.

The combined RFM score was represented as:

```text
RFM Score = R + F + M
```

and also as a three-digit combination such as:

```text
555
```

A score of `555` represents a customer in the highest scoring quintile for all three dimensions.

---

# RFM Customer Segments

The analysis assigned customers to segments including:

```text
Champions
Loyal Customers
Potential Loyalists
Recent Customers
Cannot Lose Them
At Risk
Needs Attention
Hibernating
Others
```

The segmentation was based on the defined RFM score thresholds.

These segments should be interpreted as **analytical customer groups**, not as independently observed customer categories.

---

# RFM Segment Summary

A segment-level summary table was created containing:

- Customer count
- Customer percentage
- Average recency
- Average frequency
- Average monetary value
- Segment revenue
- Revenue percentage
- Average RFM score

This summary allows customer quantity to be compared with customer value.

---

# Key RFM Finding

The **Champions** segment contained:

- **1,289 customers**
- **21.93% of the customer base**
- Approximately **68.09% of total revenue**

Average Champion metrics were approximately:

- Recency: **19.2 days**
- Frequency: **17.15 orders**
- Monetary value: **9,178.26**

This demonstrates strong concentration of revenue among a relatively small group of recently active, frequent, and high-value customers.

---

# At-Risk / Re-engagement Finding

The **Cannot Lose Them** segment contained:

- **223 customers**
- **3.79% of the customer base**
- Approximately **5.65% of total revenue**

The segment had high historical frequency and monetary value but an average recency of approximately **342 days**.

This makes the segment relevant for re-engagement analysis because historically valuable customers have not purchased recently.

This is an analytical prioritization signal rather than a formal churn prediction.

---

# Key Business Insights

## 1. Repeat purchase behavior develops over time

RPR increased from **23.61% at 30 days** to **69.50% at 365 days**, showing that repeat purchasing continues to accumulate as customers are observed for longer.

## 2. Repeat orders have higher AOV

Repeat orders produced an average order value of **480.91**, compared with **412.18** for first-time orders, approximately **16.67% higher**.

## 3. Second purchases typically occur within a few months

The median T2 was **55 days**, while the mean was approximately **97.05 days**, indicating that some customers return much later than the typical repeat purchaser.

## 4. Purchase intervals are highly variable

The median IPI was **24 days**, while the mean was **51.24 days**, showing that customers do not follow a single uniform purchasing cycle.

## 5. Customer value is concentrated

The Champions segment represented **21.93% of customers but generated approximately 68.09% of revenue**, highlighting the importance of retaining high-value customers.

---

# Interpretation Principles

Several methodological rules were followed throughout the project.

### Negative growth/interval values

Repeat-purchase timing metrics are based on chronological order, so negative intervals should not occur after data preparation. Any negative interval would indicate an ordering or date-quality issue and should be investigated.

### First purchase definition

Because no independent customer acquisition date exists, first valid purchase was used as the acquisition proxy.

### Repeat purchase definition

A repeat customer must have at least two distinct valid invoices.

### Order definition

Multiple product lines on the same invoice represent one purchase/order.

### RFM interpretation

RFM scores are relative to the analyzed customer population because quintile-based scoring was used.


---

# SQL Server Methodology

The overall analysis followed this sequence:

```text
Raw transaction data
        ↓
Data quality filtering
        ↓
Order-level aggregation
        ↓
Customer acquisition date
        ↓
Customer purchase history
        ↓
First vs Repeat classification
        ↓
RPR / Purchase Frequency
        ↓
T2
        ↓
IPI
        ↓
RFM calculation
        ↓
RFM segmentation
        ↓
Segment summary
        ↓
Business insights
```

This approach ensures that all repeat-purchase metrics use a consistent definition of a customer order.

---

# Validation Principles

The analysis was validated by checking:

- CustomerID completeness
- Positive quantity and price
- Cancellation exclusion
- Distinct invoice counting
- Chronological purchase sequencing
- First and second purchase dates
- Consistency of RPR denominators
- Consistency of purchase-frequency denominators
- RFM score ranges
- Segment counts
- Revenue contribution by segment

---

# What Was Achieved

By completing Day 28, the project demonstrated the ability to:

- Convert transaction-level retail data into customer-level metrics.
- Correctly define an order from multi-line invoice data.
- Measure repeat-purchase behavior over multiple observation windows.
- Compare first-time and repeat customer AOV.
- Measure time to second purchase.
- Measure interpurchase intervals and purchasing regularity.
- Build RFM scores and customer segments.
- Identify high-value and potentially at-risk customer groups.
- Translate SQL results into business-oriented retention insights.

---

# Conclusion

Day 28 moved beyond simple sales reporting into **customer behavior and retention analysis**.

The combination of:

```text
RPR
+ Purchase Frequency
+ T2
+ IPI
+ First vs Repeat AOV
+ RFM Segmentation
```

provides a comprehensive view of how customers return, how quickly they return, how regularly they purchase, and how much value different customer groups contribute.

The analysis also demonstrates why customer retention should not be evaluated using a single metric. A customer may purchase frequently but have low monetary value, while another may purchase less frequently but contribute substantial revenue. Combining behavioral and monetary measures provides a more useful basis for customer-retention decisions.

---

# Project Structure

```text
Day-28/
│
├── deliverables/
│   ├── 01_Data_Cleaning_and_Order_Level.sql
│   ├── 02_Customer_Order_Summary.sql
│   ├── 03_First_vs_Repeat_AOV.sql
│   ├── 04_RPR_Purchase_Frequency.sql
│   ├── 05_Time_to_Second_Purchase.sql
│   ├── 06_Interpurchase_Interval.sql
│   ├── 07_RFM_Segmentation.sql
│   └── RFM Segment Summary Table.sql
│
├── Python/
│   └── Day28_RFM_Validation.ipynb
│
│
├── data/
│   └── online_retail_II_v2.csv
│   └── online_retail_II.csv
│
│
├── docs/
│   └── 
└── README.md
```

LINKEDIN: [link](https://lnkd.in/p/d5CSs96d)