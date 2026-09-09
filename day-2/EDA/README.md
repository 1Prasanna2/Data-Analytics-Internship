# 📊 Superstore Sales Analysis

Exploratory analysis of a cleaned **Sample Superstore** retail dataset
(U.S. orders across regions, segments, and product categories) to understand
sales, discounting, and profitability.

## 📁 Repository contents
| Path | Description |
|---|---|
| `Cleaned_SampleSuperstore.csv` | Cleaned dataset, 13 columns |
| `notebooks/` | Exploratory analysis (pandas / matplotlib) |

## 🧾 Dataset
- **Dimensions:** Ship Mode, Segment, Country, City, State, Postal Code, Region, Category, Sub-Category
- **Measures:** Sales, Quantity, Discount, Profit

## 🔝 TOP 3 INSIGHTS
**1. Aggressive Discounting (>20%) Erases $156K in Net Profit**
    
* **Observation:** Nearly 1 in 5 orders (**18.7%** / 1,869 lines) operate at a net loss, destroying **$156,113** in potential bottom-line earnings.
    
* **Root Cause:** Discounting past the **20% threshold** reliably pushes transaction margins into negative territory, hitting a peak average loss of **-$310.70 per order** at the 50% discount level.
    
* **Strategic Action:** Enforce an automated pricing guardrail capping promotional discounts at a maximum of 20%, which would instantly reclaim up to $156K in lost profits.


**2. Extreme Product Polarization (Copiers vs. Tables & Machines)**

* **Observation:** Volume does not equal profitability. **Copiers** delivers the company's highest profit (**$55,618** profit, **37.2% margin**) with zero loss-making transactions on low volume (68 orders). Conversely, **Tables** is a major profit sink (**-$17,725** loss), and **Machines** returns a negligible **1.8% margin** ($3,385 profit on $189K sales) due to severe loss spikes on discounted high-ticket sales (max loss of -$6,600).

* **Strategic Action:** Shift marketing incentives toward high-yield products like Copiers and Phones, while restricting discounts on Machines and restructuring base pricing for Tables.


**3. Severe Regional Margin Disparity in the Central Region**

* **Observation:** The West and East regions drive **69.8%** of total profits with strong profit margins (**13.5%–14.9%**). In contrast, the Central region generates over $500K in sales but contributes only **13.9%** of overall profit share due to a weak **7.9% profit margin**.

* **Strategic Action:** Conduct a regional sales audit in the Central territory to curb localized over-discounting and align regional operational margins with the West and East standards.

## 🔍 Questions explored
1. Which regions and categories drive the most profit?
2. How does discount level affect profit?
3. Which sub-categories are consistently unprofitable?
4. How do Consumer / Corporate / Home Office segments compare?


##  Getting started
```bash
git clone https://github.com/YOUR-USERNAME/superstore-analysis.git
cd superstore-analysis
pip install pandas matplotlib seaborn jupyter
jupyter notebook
```

## 📌 Key insights
- Deep discounts (≥ 0.6–0.8) almost always produce negative profit, especially in Furniture and Binders.
- Technology (Phones, Copiers, Accessories) delivers the highest profit per order.
- A small number of large orders dominate total sales (e.g., Copiers/Machines).

## 🛠 Tools
***Python · pandas · matplotlib · seaborn***
