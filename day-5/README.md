# 📊 Day 5 — Excel Data Analytics: Sample Superstore

> 45-Day Data Analytics Internship · Level 1 · Day 5
> Tools: Microsoft Excel — Tables, Named Ranges, SUMIFS / COUNTIFS / AVERAGEIFS, PivotTables, Sorting & Filtering
> Input: `data/SampleSuperstore.csv` (output of Day 1 cleaning)

---

## 🎯 Task

Analyze a structured dataset end-to-end using core Excel tools.

**Requirements (as assigned):**
- Excel workbook with a **raw-data tab**, a **working/formula tab**, and a **summary tab**
- **3–5 PivotTables** answering different business questions
- A **one-paragraph summary** of key findings
- Use `SUMIFS / COUNTIFS / AVERAGEIFS` before reaching for array formulas
- Freeze headers, name ranges, and keep raw data untouched on its own tab

---

## 📦 Dataset

| Property | Value |
|---|---|
| Source | Cleaned Sample Superstore (Day 1 output) |
| Grain | One row per order line |
| Size | 9,994 order lines × 21 columns |
| Dimensions | Ship Mode, Segment, Country, City, State, Postal Code, Region, Category, Sub-Category |
| Measures | Sales, Quantity, Discount, Profit |
| Known gap | No order-date column → a month-trend pivot was not possible (see Limitations) |

---

## 🗂 Solution: Workbook Structure (`Day5_Superstore_Excel_Analytics.xlsx`)

| Tab | Purpose | Key Contents |
|---|---|---|
| `RawData` | Protected source of truth | Data pasted as an Excel Table named **`RawData`** 
, top row frozen, **never edited** |
| `Working` | Formula-driven analysis | KPI cells built with `SUM`, `SUMIFS`, `COUNTIFS`, `AVERAGEIFS`; discount-band profit analysis |
| `PivotsTables` | Five PivotTables, one business question each | Sorted/filtered pivots + value filters for loss-makers |
| `Summary` | Executive view | KPI strip, one-paragraph findings summary, recommendations |

### Process, step by step
1. **Import & protect** — pasted the cleaned CSV into `RawData`, converted to Table `RawData`, froze the header row, and left it untouched so every number downstream is auditable.
2. **Name & reference** — all formulas use structured references (`RawData[Sales]`, `RawData[Profit]`, …) so ranges auto-expand and formulas stay readable.
3. **Build KPIs with conditional formulas** — total/average metrics via `SUM`, segment- and category-level cuts via `SUMIFS`, loss counts via `COUNTIFS`, and discount behaviour via `AVERAGEIFS` (no array formulas needed).
4. **Build PivotTables** — five pivots on `PivotsTables`, each framed as a business question; used **sort largest→smallest**, **Top-10 filters**, and **value filters (Profit < 0)** to surface loss-makers.
5. **Summarize** — KPI strip + written findings + recommendations on `Summary`.

### Formula reference (Working tab)
```excel
Total Sales            =SUM(RawData[Sales])
Total Profit           =SUM(RawData[Profit])
Profit Margin %        =IFERROR(SUM(RawData[Profit])/SUM(RawData[Sales]),0)
Units Sold             =SUM(RawData[Quantity])
Order Lines            =ROWS(RawData)
Loss-Making Lines      =COUNTIFS(RawData[Profit],"<0")
Loss Rate %            =COUNTIFS(RawData[Profit],"<0")/ROWS(RawData)
Sales – Furniture      =SUMIFS(RawData[Sales],RawData[Category],"Furniture")
Profit – West          =SUMIFS(RawData[Profit],RawData[Region],"West")
```

---

## 📊 The Five PivotTables (Deliverable 2)

| # | Pivot | Business Question | Layout | Answer |
|---|---|---|---|---|
| 1 | Sales & Profit by Category | Which categories *sell* vs which actually *earn*? | Rows: Category · Values: Σ Sales, Σ Profit · sorted by Sales ↓ | Furniture ≈ ⅓ of sales but only ~10% margin vs ~13–14% for Technology & Office Supplies |
| 2 | Sales & Profit by Region | Where is performance strongest? | Rows: Region · Values: Σ Sales, Σ Profit · sorted ↓ | West & East lead sales and profit; Central & South lag on margin |
| 3 | Profit by Sub-Category | Which products lose money? | Rows: Category → Sub-Category · Values: Σ Profit · sorted ascending + value filter < 0 | **Tables** is the largest cumulative loss driver |
| 4 | Profit by Discount band | Does discounting pay? | Rows: Discount (0 / 0.2 / 0.4 / 0.6 / 0.8) · Values: Σ Sales, Σ Profit, Count | Average margin turns **negative at ≥ 40% discount**; 0–20% lines are consistently profitable |
| 5 | Segment × Ship Mode | Who buys, and how do we ship it? | Rows: Segment · Columns: Ship Mode · Values: Σ Sales | Consumer + Standard Class dominate the revenue mix |

---

## 🔍 Key Findings (Deliverable 3 — one-paragraph summary)

> Analyzing 9,977 cleaned Superstore order lines in Excel shows a healthy top line (≈ $2.29M sales) but a thin ≈ 12.5% profit margin, with roughly **one in five order lines sold at a loss**. The `SUMIFS/COUNTIFS/AVERAGEIFS` analysis and five PivotTables reveal the problem is concentrated, not general: Furniture generates about a third of sales yet converts at only ~10% margin, and **Tables is the single largest cumulative loss driver**. Discount is the switch — order lines discounted **40% or more turn negative on average**, while 0–20% discount lines are consistently profitable, and the deepest single losses sit in heavily discounted Tables, Machines and Binders orders. Regionally, West and East lead both sales and profit while Central and South lag on margin. The clear action is **discount governance**: cap discounts around 30–40% (stricter for Furniture), require approval for loss-priced lines, and re-focus promotional spend on high-margin Technology and Office Supplies.

**Supporting snapshot** (as computed live in the workbook):

| Metric | Value |
|---|---|
| Order lines analyzed | 9,994 |
| Total Sales | ≈ $2.29M |
| Total Profit | ≈ $286K |
| Profit Margin | ≈ 12.5% |
| Loss-making order lines | ≈ 1 in 5 |
| Discount on loss lines vs profitable lines | ≈ 0.4+ vs ≈ 0.1 |

---

## 💡 Recommendations
1. **Cap discounts** at ~30–40% overall and stricter for Furniture/Tables.
2. **Approval rule** for any order line priced below cost.
3. **Re-allocate promo spend** toward Technology & Office Supplies; review Central/South pricing mix.

---

## ⚠️ Limitations & Notes
- The cleaned extract contains **no order-date column**, so the suggested "sales trend by month" pivot was replaced with the **discount-band pivot** (Pivot 4), which answers the more decision-relevant question in this dataset.
- **Negative profits were kept** — they are real business losses, not data errors (Day 1 decision).
- All figures are computed live by formulas/PivotTables; numbers in this README are a submission-time snapshot.

---

## 📁 Folder Contents
```
day-5-excel-analytics/
├── README.md
├── Data Analytics.xlsx   # 4-tab workbook (deliverable 1–3)
├── data/
│   └── SampleSuperstore.csv       # input 
├── docs/
│   └── Day_5_Internship_Report.pdf
└── assets/
    └── pivot-tables_tab.png
    └── raw_data_tab.png
    └── summary_tab.png
    └── working-formula_tab.png            #screenshots
```

## 🔁 How to Reproduce
1. Open `Day5_Superstore_Excel_Analytics.xlsx` (or rebuild: import CSV → Table `RawData` → freeze header → add Working-tab formulas → insert the 5 pivots → summarize).
2. Refresh all PivotTables (Data → Refresh All) to recompute from `RawData`.

## 📚 Lessons Learned
- Named Tables + structured references make every formula auditable and self-expanding.
- `SUMIFS/COUNTIFS/AVERAGEIFS` covered every KPI need — no array formulas required.
- Sorting and value-filtering a pivot (Profit < 0) finds loss-makers faster than scanning 9,977 rows.
- Protecting the raw tab is what makes the whole workbook trustworthy.

## 🔗 Series

[Day 4 – Visual Story](../day-4/) ·

**Day 5 – Excel Analytics** ·
LinkedIn post: [https://lnkd.in/p/dKRT5mut]