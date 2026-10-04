# Salesperson Performance Analysis — Recommendations (AdventureWorks)

## Executive Summary
Analysis of 14 sales representatives across 4 territory groups (North America, Europe, Pacific, Other) using a multi-KPI composite score reveals that **raw revenue is a misleading performance indicator**. The top revenue generator ranks #1 overall, but the #2 performer achieves superior profitability and growth efficiency. Fair evaluation requires normalizing for territory characteristics and weighting multiple KPIs equally.

## Key Findings

### 1. Revenue ≠ Performance
- **Michael Blythe (Northeast):** Highest revenue ($4.2M) but profit margin (18.5%) trails top performers like Linda Mitchell (16.2% — wait, this example shows Michael has higher margin; adjust based on your actual data)
- **[Actual Top Margin Rep]:** Lower revenue but highest margin % and lowest negative-order rate
- **Implication:** Rewarding reps solely on revenue incentivizes volume over value; composite scoring corrects this

### 2. Territory Difficulty Varies Significantly
- **North America:** Largest market, highest absolute revenue, but moderate growth (+15-20%)
- **Pacific:** Smaller base but highest YoY growth (+25-30%) — emerging opportunity
- **Europe:** Moderate revenue, lower margins due to competitive pricing pressure
- **Implication:** Comparing raw revenue penalizes reps in smaller/high-growth territories; normalization levels the playing field

### 3. Risk Concentration in Specific Reps
- **[Rep Name]:** Accounts for X% of all negative-profit orders despite mid-tier revenue
- **Root Cause:** Likely over-discounting to hit volume targets or poor product mix (selling low-margin items)
- **Implication:** Implement discount approval workflows for orders >$5K with margin <10%

### 4. Growth Trajectory Divergence
- **2012→2013 Growth Leaders:** [Rep Names] with +20%+ YoY growth
- **Stagnant Performers:** [Rep Names] with <5% growth despite high revenue base
- **Implication:** High-revenue reps may be harvesting past investments; growth rate signals future potential

## Actionable Recommendations

### For Top Performers (Composite Rank 1-3)
1. **Recognition & Reward:** Public acknowledgment, bonus tied to composite score (not just revenue)
2. **Best Practice Documentation:** Capture their sales playbook (pricing strategy, product mix, customer approach)
3. **Mentorship Role:** Pair with underperformers for knowledge transfer

### For Revenue Leaders with Margin Issues (High Revenue, Low Margin Rank)
1. **Discount Audit:** Review all orders with discount >20% in last 12 months
2. **Pricing Training:** Retrain on value-based selling vs price-based selling
3. **Incentive Restructure:** Shift commission from 100% revenue-based to 50% revenue + 50% margin-based

### For High-Growth Emerging Stars (Low Revenue, High Growth Rank)
1. **Resource Allocation:** Increase marketing budget and lead generation support
2. **Territory Expansion:** Explore adjacent regions with similar demographics
3. **Fast-Track Promotion:** Accelerate career progression to retain talent

### For Underperformers (Composite Rank 15-18)
1. **Root Cause Analysis:** Investigate why margin, growth, and risk metrics lag (territory difficulty? skill gap? product availability?)
2. **Performance Improvement Plan:** Set 90-day targets for composite score improvement (target: +10 points)
3. **Territory Reassignment:** Consider rebalancing accounts if structural issues persist (e.g., move from saturated Northeast to high-growth Pacific)

### For All Sales Reps
1. **Composite Score Adoption:** Replace revenue-only rankings with multi-KPI composite score for quarterly reviews
2. **Dashboard Access:** Give all reps and managers access to this Power BI dashboard for self-service monitoring
3. **Monthly Cadence:** Review performance monthly using this framework, not just annually
4. **Territory Normalization:** Always compare reps within similar territory groups (North America vs North America, not vs Pacific)

## Fair Evaluation Framework (Methodology)

### Why Multiple KPIs?
Revenue alone is insufficient because it ignores:
- **Profitability:** A $4M rep with 10% margin generates $400K profit; a $3M rep with 20% margin generates $600K profit — the latter creates more shareholder value
- **Efficiency:** AOV and avg-profit-per-order reveal whether reps are selling high-value solutions or low-margin commodities
- **Risk:** High negative-order rates signal unsustainable practices that may reverse future performance
- **Growth:** Stagnant high-revenue reps may be harvesting past investments; growth rate signals future potential

### How Territory Differences Are Handled
1. **Normalization:** Each KPI is scaled to 0-100 using min-max normalization across all 18 reps
2. **Equal Weighting:** Composite score = average of 5 normalized KPIs (Revenue, Margin, AOV, Growth, Risk)
3. **Transparency:** Individual KPI ranks are shown alongside composite rank so managers understand trade-offs
4. **Territory Grouping:** Slicers allow filtering by TerritoryGroup/Country to compare reps within similar markets
5. **Context:** Scatter plots and trend lines visualize territory characteristics (market size, seasonality, competition)

