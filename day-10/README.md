# 📊 Day 10 — Simple KPI Tracking Sheet: Superstore Sales, Live

> 45-Day Data Analytics Internship · Level 1 · Day 10
> Tool: Microsoft Excel (Tables + structured references)
> Dataset: Sample Superstore — 9,994 order lines · 21 columns
> Theme: turn raw transactions into business-ready KPIs that update themselves

---

## 🎯 Task

Build a **one-page KPI summary** (revenue, units sold, average order value, top product)
that **updates automatically** from raw order data.

**Deliverables (as assigned):**
- A single-tab KPI summary sheet ✅
- Formulas that recalculate automatically as new rows are added ✅ (proven with a live test)

**Hints followed:**
- ✅ 5 KPIs max for the first version
- ✅ `SUM` / `SUMIFS` / `AVERAGE` only — zero manual totals
- ✅ Consistent number formatting (currency, percent, whole numbers)

---

## 🗂 Solution: Workbook Structure (`Day-10_Superstore_KPI_Tracker.xlsx`)

| Tab | Role |
|---|---|
| `Orders` | Raw Superstore data as an Excel **Table** named `Orders` (Ctrl+T), frozen header — the single source of truth |
| `KPI Summary` | The one-page dashboard: 5 KPI cards + hidden helper table; every number is a live formula |

*Design note:* the KPI summary is deliberately **one tab**; raw data lives separately so entry
and reporting never mix. (Single-tab-literal variant: paste the same KPI panel above the
table on `Orders` — formulas are unchanged because they reference the table by name.)

---

## 🧮 The Five KPIs & Their Formulas

| # | KPI | Formula | Format | Live value |
|---|---|---|---|---|
| 1 | **Total Revenue** | `=SUM(Orders[Sales])` | Currency `$#,##0` | **$2,297,201** |
| 2 | **Units Sold** | `=SUM(Orders[Quantity])` | Number `#,##0` | **37,873** |
| 3 | **Avg Line Value** | `=AVERAGE(Orders[Sales])` | Currency `$#,##0.00` | **$229.86** |
| 4 | **Profit Margin %** | `=SUM(Orders[Profit])/SUM(Orders[Sales])` | Percent `0.00%` | **12.47%** |
| 5 | **Top Sub-Category** | `=INDEX($A$11:$A$27,MATCH(MAX($B$11:$B$27),$B$11:$B$27,0))` | Text | **Phones** |

**Helper table (rows 10–27, feeds KPI 5):** 17 sub-categories ×
`=SUMIFS(Orders[Sales], Orders[Sub-Category], A11)` dragged down — the `SUMIFS`
pattern that makes a "top product" KPI possible without array formulas.

> **Definition note:** Superstore rows are *order lines* (one Order ID can span several
> lines), so KPI 3 is documented as average value **per order line** — naming the grain
> is part of making a KPI business-ready.

---

## ⚡ Auto-Update: How It Works & How It Was Proven

- Raw data is an **Excel Table**, so every structured reference (`Orders[Sales]`, …)
  **expands automatically** when a row is added — no range resizing, no formula edits.
- **Live test performed:** appended a dummy order (Sales $10,000 · Qty 5) →
  Revenue jumped to $2,307,201 and Units to 37,878 instantly; row deleted → values
  restored. Before/after screenshots saved in `assets/`.

---

## ✅ Verified Outputs

| Check | Result |
|---|---|
| Revenue vs manual column sum | ✅ match ($2,297,201) |
| Add-row / delete-row recalculation | ✅ instant, both directions |
| Top sub-category race | **Phones $330,007** vs Chairs $328,449 — a ~$1.6K photo-finish |
| Runner-up context | Storage $223,844 · Tables $206,966 · Binders $203,413 |
| Margin sanity | 12.47% ≈ Day-5/Day-6 findings (consistent across the internship) |

---

## 🎨 Formatting Rules Applied (hint #3)
- Currency on revenue/avg value, percent on margin, comma numbers on units — one style each
- KPI cards: white fill, thin borders, one accent color per card; gridlines off
- Helper table hidden on the printed page so the summary reads as a dashboard, not a worksheet

## 📚 Lessons Learned
- **Tables beat fixed ranges** for anything "live": `Orders[Sales]` today, `Orders[Sales]` after 10,000 more rows.
- **KPI discipline:** five cards max; each must answer one business question or it's clutter.
- **"Top X" needs a pattern:** helper `SUMIFS` column + `INDEX/MATCH(MAX(...))` — reusable everywhere.
- **Name the grain:** "average order value" means nothing until you say *per order* or *per line*.
- **Formatting is communication:** consistent currency/percent styles are what make numbers look like decisions.

---

## 📁 Folder Contents
```
day-10-kpi-tracker/
├── README.md
├── Day-10_Superstore_KPI_Tracker.xlsx        # Orders tab + KPI Summary tab
├── data/Sample - Superstore.csv              # input (9,994 order lines)
├── assets/..                                 # KPI summary, Orders tab, auto-update test screenshots
└── docs/Day_10_Internship_Report_.pdf        # day-10 report of the task
```

## 🔁 How to Reproduce
1. Open the workbook, or rebuild: paste CSV → `Ctrl+T` → name table `Orders` →
   add the 5 KPI formulas + 17-row `SUMIFS` helper → format → hide helper.
2. **Google Sheets variant:** open-ended ranges instead of tables —
   `=SUM(Orders!R2:R)`, `=SUM(Orders!S2:S)`, `=AVERAGE(Orders!R2:R)`,
   `=SUM(Orders!U2:U)/SUM(Orders!R2:R)`, and
   `=INDEX(QUERY(Orders!P2:R,"select Col1, sum(Col3) group by Col1 order by sum(Col3) desc limit 1"),1,1)` for the top line.
3. Test auto-update: add any row to `Orders` and watch every card move.

## 🔗 Series

[Day 9 – Descriptive Statistics](../day-9/) · 

**Day 10 – KPI Tracking Sheet** ·
LinkedIn post: [link](https://lnkd.in/p/eBGr_m_g)