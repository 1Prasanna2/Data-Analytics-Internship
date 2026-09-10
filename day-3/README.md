# 📊 Day 3 — Sales Performance Dashboard (Superstore)

**45-Day Data Analytics Internship · Level 1 · Day 3 of 30**
**Intern:** Prasanna D Shetty · **Date:** 10-09-2026 · **Tool:** Power BI Desktop 
**Data:** Cleaned Sample Superstore — output of Day 1

---

## 🎯 Task Objective
Turn the cleaned dataset and Day-2 insights into an **interactive dashboard a stakeholder can actually use**:
- Sales performance by **product**, **region** (and **month**, where date data allows)
- Minimum **3 visuals** + **1 slicer/filter**
- A **one-page note** explaining how to read the dashboard

## 📦 Dataset
| Item | Detail |
|---|---|
| Source | `../day-1/data-cleaning-preprocessing/data/cleaned/` (Day-1 cleaned CSV) |
| Grain | One row per order line |
| Size | ~9,977 rows × 13 columns |
| Caveat | Extract ships **without an order date** — see *Limitations* |

## 📐 Design Principles
1. **Question-first visuals** — every visual title states the question it answers.
2. **KPIs first, drill-downs second** — headline numbers → product → region → trend.
3. **One color language** (same as Day-2 EDA): 🔵 blue = Sales · 🟢 green = Profit · 🔴 red = Loss · 🟠 orange = Discount.
4. **Self-serve** — slicers let any stakeholder filter without asking the analyst.

## 📊 Dashboard Contents
| Element | Type | Question it answers |
|---|---|---|
| Total Sales · Total Profit · Profit Margin % · Units Sold | 4 KPI cards | How is the business doing overall? |
| Sales vs Profit by Category | Clustered column | Which product families convert revenue into profit? |
| Profit by Sub-Category | Bar, conditional red/green | Exactly which products lose money? |
| Sales vs Profit by Region | Clustered column | Where is profit generated vs. only volume? |
| Region · Category (+ Month in v2) | Slicers | Self-serve filtering |

## 🔍 Key Insights Visible in the Dashboard
1. **The discount trap:** order lines discounted ≥ 40% are overwhelmingly loss-making — profit bars flip red exactly where discount intensity spikes.
2. **Furniture's profit gap:** Furniture drives ~a third of sales but the smallest profit share; **Tables & Bookcases** show red bars.
3. **Technology carries the margin:** Phones, Copiers and Accessories deliver the highest profit per sales dollar.
4. **Regional split:** West & East lead profit; Central's volume is dragged down by heavily discounted Furniture orders.

## 📁 Folder Structure
```
day-3/
├── README.md                      ← this file
├── Day3_SalesDashboard.pbix       ← interactive dashboard (or .xlsx)
├── docs/
│   └── how_to_read_dashboard.md   ← one-page stakeholder note
├── assets/
│   ├── dashboard_overview.png     ← default view screenshot
│   └── dashboard_filtered.png     ← view with slicers applied
└── data/
    └── (only if used) superstore_with_month.csv
```

## ▶️ How to Open
- **Power BI:** open `Day3_SalesDashboard.pbix` in Power BI Desktop (free). Data is embedded — no setup needed.
- **Excel alternative:** open the `.xlsx`, click *Enable Editing*, go to the **Dashboard** tab, and use the slicers on the right.

## 📖 How to Read It (60-second version)
1. Start at the **KPI cards** — overall health at a glance.
2. Read **left → right**: category mix → sub-category winners/losers → regional split.
3. **Green = earning, red = losing** — any red bar is a candidate for a pricing/discount review.
4. **Click a slicer** (Region / Category) — every visual and KPI recalculates instantly.
5. **Hover** any bar for exact Sales, Profit and Margin tooltips.

## 🧮 Measures (DAX reference)
```dax
Total Sales     = SUM(Sales[Sales])
Total Profit    = SUM(Sales[Profit])
Units Sold      = SUM(Sales[Quantity])
Profit Margin % = DIVIDE([Total Profit], [Total Sales])
Avg Discount %  = AVERAGE(Sales[Discount])             
Loss Lines      = CALCULATE(COUNTROWS(Sales), Sales[Profit] < 0)
Top Region      = VAR t = TOPN(1, VALUES(Sales[Region]), [Total Sales], DESC)
                  RETURN MINX(t, Sales[Region]) 
```

## ⚠️ Limitations & Next Steps
- The provided extract contains **no order date**, so a true month-over-month trend is not possible in v1; a month slicer/trend will be added in v2 once a dated extract is available (documented, not silently faked).
- Dashboard shows **correlation, not causation** — the discount insight flags where to investigate, not proof of cause.

## 🔗 Related Work
- **Day 1 — Data Cleaning & Preprocessing:** [repo link]
- **Day 2 — Exploratory Data Analysis:** [repo link]
- **One-page reading note:** `docs/docs/Dashboard_Navigator_User_Guide.pdf`
- **LinkedIn post:** 

## ✅ Deliverables Checklist
- [x] Interactive dashboard file (`.pbix`)
- [x] ≥ 3 visuals (4 + KPI card row)
- [x] ≥ 3 slicer (Region + Category)
- [x] ≤ 4 KPIs, consistent color coding
- [x] One-page "how to read" note