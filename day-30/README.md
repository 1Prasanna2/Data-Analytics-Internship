# Regional Growth Analysis

## Overview

This task analyzes regional sales performance over time to understand how revenue, orders, profit, and growth are changing across business regions.

The analysis uses quarterly time periods and compares each region against both the previous quarter (QoQ) and the same quarter in the previous year (YoY).

The work combines SQL Server and Excel to prepare a validated regional growth table, summarize regional performance, and visualize revenue trajectories.

## Objective

The main objective is to identify:

- Which regions generate the most revenue.
- How regional revenue changes from quarter to quarter.
- How regional revenue changes compared with the same quarter in the previous year.
- Which regions show strong or weak growth periods.
- How revenue performance relates to profit, profit margin, and order volume.
- Where management may need to investigate growth or decline.

## Tools Used

**SQL Server** was used for time-period preparation, regional aggregation, growth calculations, validation, and analytical output.

**Excel** was used for PivotTable summarization and the regional revenue trajectory visualization.

## Data Preparation

A dedicated calendar table was created to provide consistent quarterly time periods. The calendar covers **2014-01-01 to 2017-12-31** and contains date, year, quarter, year-quarter label, month number, and month name fields. The sales data was joined to this calendar so each order date could be assigned to a consistent quarter. The calendar also supports consistent ordering of the quarterly analysis. The SQL source shows this calendar construction and date coverage explicitly. fileciteturn7file1L1-L15

The source data was validated to ensure that sales records could be mapped to the calendar. The validation query is designed to confirm that unmapped order dates return zero. fileciteturn7file1L46-L52

## Regional Quarterly Aggregation

The sales data was aggregated at **Region + Year + Quarter** level. For each region and quarter, the analysis calculates:

- Current Revenue
- Current Profit
- Current Orders

Only records with a valid region and positive sales are included in the growth analysis. The SQL groups revenue, profit, and distinct orders by region and quarter. fileciteturn7file0L34-L46

## Growth Analysis

### Quarter-over-Quarter Growth

Previous-quarter revenue is retrieved separately for each region using a window-function comparison. This allows current quarterly revenue to be compared with the immediately preceding quarter. fileciteturn7file0L49-L59

The calculation is:

**QoQ Growth % = (Current Revenue − Previous Quarter Revenue) / Previous Quarter Revenue × 100**

A positive value indicates growth versus the previous quarter, while a negative value indicates a decline.

### Year-over-Year Growth

The same region's revenue is compared with the corresponding quarter from the previous year using a four-quarter lag. fileciteturn7file0L53-L59

The calculation is:

**YoY Growth % = (Current Revenue − Previous Year Revenue) / Previous Year Revenue × 100**

This provides a longer-term comparison and helps distinguish sustained changes from normal quarter-to-quarter fluctuations.

### Dollar Change

Absolute changes are also calculated:

**QoQ Dollar Change = Current Revenue − Previous Quarter Revenue**

**YoY Dollar Change = Current Revenue − Previous Year Revenue**

This is useful because a large percentage change can sometimes result from a small comparison base.

## Base-Size Check

A base-size flag is included for quarters where current revenue is below **$5,000**. These observations are marked as a small-base warning.

This is important when interpreting unusually high growth percentages. Both percentage growth and absolute revenue should be considered before making a management decision.

## Excel Analysis

An Excel PivotTable summarizes quarterly revenue by region. The summarized regional revenue totals are:

| Region | Total Revenue |
|---|---:|
| Central | **$501,239.89** |
| East | **$678,781.24** |
| South | **$391,721.91** |
| West | **$725,457.82** |
| **Grand Total** | **$2,297,200.86** |

The totals show that **West generated the highest revenue**, followed by East, Central, and South.

## Revenue Trajectory Visualization

A line chart was created to compare quarterly revenue trajectories for:

- Central
- East
- South
- West

The visualization makes it easier to identify periods of rapid growth, decline, and changes in regional momentum.

The underlying PivotTable covers quarters from **2014-Q1 through 2017-Q4**.

## Key Observations

### 1. West is the largest revenue contributor

West generated approximately **$725.46K**, the highest total revenue among the four regions shown in the PivotTable. This represents roughly **31.6%** of the summarized total revenue.

### 2. East is the second-largest contributor

East generated approximately **$678.78K**, representing roughly **29.6%** of total summarized revenue.

### 3. South has the lowest total revenue

South generated approximately **$391.72K**, or roughly **17.1%** of the summarized revenue. This makes South a useful region for further investigation, while recognizing that low total revenue alone does not prove weak performance.

### 4. Regional growth can change sharply between quarters

The growth table contains both positive and negative QoQ and YoY periods. For example, Central shows approximately **153.75% QoQ growth in 2014-Q3**, followed by approximately **-23.80% in 2014-Q4**. East shows approximately **220.16% QoQ growth in 2014-Q2**. These changes demonstrate why regional performance should be evaluated across a sequence of periods rather than from one quarter alone. fileciteturn7file0L49-L80

### 5. Revenue growth should be considered with profitability

The regional analysis also contains current profit and profit margin, so revenue growth can be interpreted alongside profitability. Strong sales growth does not automatically imply stronger business performance if profit or margin deteriorates.

## Business Uses

### Regional Resource Allocation

Management can identify high-performing regions and use the results as one input when considering sales, operational, or marketing resource allocation.

### Underperforming Region Investigation

Regions with persistent weak growth can be investigated further for factors such as demand, customer mix, product mix, pricing, or order activity. These are investigation areas rather than conclusions established directly by this dataset.

### Growth Monitoring

QoQ and YoY measures help distinguish short-term movement from longer-term regional performance.

### Profitability Monitoring

Comparing revenue growth with profit and profit margin helps prevent management from treating revenue growth as the only indicator of success.

### Regional Planning

Quarterly revenue trajectories can support sales planning, regional targets, performance reviews, and management reporting.

## Interpretation of Negative Growth

Negative growth percentages are valid results.

For example, a QoQ growth value of **-65.04%** means current-quarter revenue was 65.04% lower than the previous quarter. It is a performance signal, not a data-quality error.

Likewise, negative YoY growth indicates that the current quarter performed below the corresponding quarter in the previous year.

## Validation and Quality Notes

The first quarter of a region's available history has no previous-quarter comparison, so the growth percentage is correctly unavailable for that period. Similarly, the early periods do not have a valid four-quarter YoY comparison.

A small-base warning is used to prevent overinterpretation of large growth percentages generated from small revenue amounts.

One SQL validation point should be addressed before using order-growth fields in later analysis: the source query labels `PrevQ_Orders` and `YoY_Prev_Orders`, but currently applies `LAG()` to `CurrentRevenue` rather than `CurrentOrders`. If those order-growth fields are used, they should be corrected to lag the order measure. The revenue growth calculations shown in the analysis use the appropriate revenue field. fileciteturn7file0L24-L27

## Chart Label Validation

The Excel chart title currently reads:

**“Regional Revenue Trajectory (2016–2019)”**

However, the underlying table and calendar shown in the analysis cover **2014–2017**. The chart title should therefore be changed to:

**“Regional Revenue Trajectory (2014–2017)”**

before final submission.

This is a presentation-label issue rather than an underlying revenue-calculation issue.

## Overall Outcome

The analysis converts regional sales transactions into a structured quarterly performance view.

The summarized revenue totals show that **West is the largest revenue contributor at $725,457.82**, while **South is the smallest at $391,721.91**. The quarterly analysis also shows substantial changes in regional performance across time, demonstrating the value of combining QoQ and YoY comparisons with revenue, order count, profit, and margin.

## Conclusion

Regional Growth Analysis provides a practical framework for monitoring geographic sales performance over time.

By combining a consistent calendar, quarterly regional aggregation, QoQ growth, YoY growth, absolute dollar changes, base-size checks, profit, and order metrics, the analysis gives management a more complete view of regional performance and identifies areas that may require further investigation.

The final output supports decisions around regional investment, growth monitoring, sales planning, performance reviews, and profitability management.

LINKEDIN: [link](https://lnkd.in/p/digtGxHu)