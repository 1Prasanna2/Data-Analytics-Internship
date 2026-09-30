# Online Retail II – SQL Business Analysis

## Overview

This project focuses on analyzing the **Online Retail II dataset using SQL** to answer practical business questions related to sales performance, customers, products, revenue trends, and returns.

The analysis was performed using SQL queries on the retail transaction data. The queries were structured to validate the data, calculate business KPIs, identify trends, analyze customers and products, and measure the impact of returns.

The completed query outputs were organized into an HTML report for review and documentation.

---

## Objectives

The main objectives of this SQL analysis were to:

- Validate the quality of the transaction data.
- Measure overall sales and customer performance.
- Identify the strongest countries and products by revenue.
- Analyze monthly and weekly revenue patterns.
- Measure customer retention and revenue concentration.
- Identify high-value customers.
- Measure the financial impact of returns.
- Segment customers using RFM analysis.

---

## SQL Work Completed

### 0. Data Guard

**Business Question:**  
Is the dataset valid for analysis, and how many records represent sales versus returns or cancellations?

**Work Done:**  
SQL was used to check invalid dates, total records, valid sales transaction lines, and return/cancellation records before performing the business analysis.

**Achievement:**  
The dataset was validated and the transaction data was separated into sales and return-related records for further analysis.

---

### 1. Revenue / Orders / AOV / Customers

**Business Question:**  
What is the overall business performance in terms of revenue, orders, average order value, and customers?

**Work Done:**  
SQL aggregation functions and `COUNT(DISTINCT ...)`, `SUM()`, and calculated metrics were used to determine total orders, sales lines, revenue, average order value, and unique customers.

**Achievement:**  
The analysis established the main business KPIs:
- Revenue: **17.74M**
- Orders: **36,969**
- Customers: **5,878**
- Average Order Value: **479.95**

---

### 2. Top 10 Countries by Revenue

**Business Question:**  
Which countries generate the highest revenue and contribute the most orders?

**Work Done:**  
Sales were grouped by country and ranked using `GROUP BY`, `SUM()`, `COUNT(DISTINCT ...)`, and `ORDER BY`.

**Achievement:**  
The analysis identified the leading markets by revenue. The **United Kingdom** was the largest market with approximately **14.72M** in revenue.

---

### 3. Monthly Revenue + Month-over-Month %

**Business Question:**  
How does revenue change from month to month, and which months show significant increases or declines?

**Work Done:**  
SQL was used to aggregate revenue by month. The `LAG()` window function was then used to compare each month's revenue with the previous month and calculate the month-over-month percentage change.

**Achievement:**  
The analysis identified monthly revenue trends and significant increases and declines, including a **47.6% month-over-month increase in September 2011** and a **55.4% decline in December 2011**.

---

### 4. Top 10 Stock Codes by Revenue

**Business Question:**  
Which products generate the highest revenue, and how many units of these products are sold?

**Work Done:**  
Products were grouped by stock code and analyzed using revenue and total unit calculations. The results were sorted in descending order of revenue.

**Achievement:**  
The analysis identified the highest-revenue products. **REGENCY CAKESTAND 3 TIER** generated the highest revenue at approximately **286.49K**.

---

### 5. Revenue Share of Top 1% / Top 10% Customers

**Business Question:**  
How concentrated is the company's revenue among its highest-value customers?

**Work Done:**  
Customer-level revenue was calculated and customers were ranked into percentile groups using the `NTILE()` window function. The revenue contribution of the top 1% and top 10% was then calculated.

**Achievement:**  
The analysis showed that:
- Top **1%** of customers contributed approximately **31.9%** of revenue.
- Top **10%** of customers contributed approximately **64.0%** of revenue.

---

### 6. Return Value and Return Rate vs Sales

**Business Question:**  
What is the financial impact of returns compared with total sales?

**Work Done:**  
SQL was used to calculate total sales, returned value, and the return rate using transaction quantities and prices.

**Achievement:**  
The analysis identified approximately **1.53M** in returned value against **17.74M** in sales, resulting in a **return rate of 8.61%**.

---

### 7. Basket Size: Mean / Median / P90 Order Value

**Business Question:**  
What is the typical order size and how large can high-value orders become?

**Work Done:**  
Each invoice was aggregated into an order-level basket. SQL statistical functions were then used to calculate average units, average order value, median order value, 90th percentile order value, and maximum order value.

**Achievement:**  
The analysis provided a broader view of order size and highlighted the difference between typical orders and unusually large orders.

Key results included:
- Average Order Value: **479.95**
- Median Order Value: **305.25**
- P90 Order Value: **851.67**
- Maximum Order Value: **168,469.60**

---

### 8. Repeat-Purchase Rate

**Business Question:**  
What proportion of customers make more than one purchase, and what is the average number of orders per customer?

**Work Done:**  
SQL counted distinct invoices for each customer and identified customers with more than one order.

**Achievement:**  
The analysis found:
- Total customers: **5,878**
- Repeat customers: **4,255**
- Repeat-purchase rate: **72.4%**
- Average orders per customer: **6.29**

---

### 9. Top 20 Customers by Lifetime Revenue

**Business Question:**  
Which customers have generated the highest lifetime revenue for the business?

**Work Done:**  
Customer-level revenue and order counts were calculated using `GROUP BY`, `SUM()`, and `COUNT(DISTINCT ...)`, followed by descending ranking.

**Achievement:**  
The analysis identified the 20 highest-value customers. The highest-revenue customer generated approximately **608.82K** across **145 orders**.

---

### 10. Revenue by Weekday

**Business Question:**  
Which days of the week generate the highest revenue and number of orders?

**Work Done:**  
SQL extracted the weekday from transaction timestamps and aggregated revenue and distinct orders for each day.

**Achievement:**  
The analysis identified weekly purchasing patterns. **Thursday** generated the highest revenue at approximately **3.84M**.

---

### 11. Top 10 Most-Returned Stock Codes

**Business Question:**  
Which products or transaction categories contribute the highest return value?

**Work Done:**  
Negative quantities were treated as returns and grouped by stock code. SQL calculated units returned and return value, then ranked the results.

**Achievement:**  
The analysis identified the transaction categories with the largest return values, including **Manual**, **AMAZON FEE**, and **PAPER CRAFT, LITTLE BIRDIE**.

---

### 12. RFM Segmentation (5-Tile Scores)

**Business Question:**  
How can customers be segmented based on how recently, how frequently, and how much they purchase?

**Work Done:**  
SQL calculated:
- **Recency** – days since the customer's latest purchase.
- **Frequency** – number of distinct orders.
- **Monetary** – total customer spending.

The `NTILE(5)` window function was used to assign five-level scores for each RFM component. Customers were then grouped according to their RFM score combinations.

**Achievement:**  
The analysis created a structured customer segmentation framework that can be used to distinguish customers according to purchasing recency, frequency, and monetary value.

---

## SQL Techniques Used

The project applied several important SQL techniques, including:

- `SELECT`, `WHERE`, `GROUP BY`, `ORDER BY`
- Aggregate functions such as `SUM()`, `COUNT()`, `AVG()`, `MEDIAN()`, and `MAX()`
- `COUNT(DISTINCT ...)`
- Common Table Expressions (`WITH`)
- Window functions such as `LAG()` and `NTILE()`
- Conditional aggregation using `FILTER`
- Date functions such as `DATE_TRUNC`, `DATEDIFF`, and `DAYNAME`
- Statistical calculations such as median and percentile
- Ranking and top-N analysis

---

## Overall Outcome

The SQL analysis transformed raw retail transaction data into business-focused insights covering:

- **Sales performance**
- **Geographic revenue distribution**
- **Product performance**
- **Revenue trends**
- **Customer retention**
- **Customer value and concentration**
- **Order and basket behavior**
- **Returns and their financial impact**
- **Customer segmentation**

The final result was a collection of **12 SQL-based business analyses**, with each query answering a specific business question and producing measurable results for use in the internship report.

LINKEDIN: [link](https://lnkd.in/p/dmkzthS6)