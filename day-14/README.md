# 📊 Day 14 — Basic Sales Summary: Three KPIs, Triple-Verified

> 45-Day Data Analytics Internship · Level 1 · Day 14
> Tool: Microsoft Excel (structured references + live formulas)
> Dataset: Sample Superstore — 9,994 order lines · 21 columns
> Theme: a business summary is only as good as the checks behind it

---

## 🎯 Task

Calculate **total sales, average sales and transaction count** from raw order data.

**Deliverables (as assigned):**
- Summary sheet ✅ (single tab, three KPI cards)
- 3 KPIs ✅ (all formula-driven, zero hardcoded values)

**Hints followed:**
- ✅ Formulas only — `SUM` / `AVERAGE` / `COUNT` on a named table
- ✅ Totals verified **manually** — four independent checks, all ✅

---

## 🗂 Solution: Workbook Structure (`Day-14_Superstore_Sales_Summary.xlsx`)

| Tab | Role |
|---|---|
| `Data` | Raw Superstore paste → Excel Table **`Superstore`**, frozen header, untouched |
| `Summary` | One-page summary: title banner, 3 KPI cards, manual-verification block, status-bar note |

---

## 🧮 The Three KPIs

| KPI | Formula | Format | Live value |
|---|---|---|---|
| **Total Sales** | `=SUM(Superstore[Sales])` | Currency `$#,##0.00` | **$2,297,200.86** |
| **Average Sales** | `=AVERAGE(Superstore[Sales])` | Currency `$#,##0.00` | **$229.86** |
| **Transaction Count** | `=COUNT(Superstore[Sales])` | Number `#,##0` | **9,994** |

**Grain note (documented on-sheet):** one "transaction" here = one **order line**;
the 9,994 lines belong to 5,009 unique Order IDs (established on Day 13). Naming the
grain is what keeps an "average" from becoming a misstatement.

---

## ✅ Manual Verification Block (the hint that builds trust)

| Check | Method | Result |
|---|---|---|
| Hand-sum of first 10 sales vs Excel | Calculator: 261.96 + 731.94 + 14.62 + 957.58 + 22.37 + 48.86 + 7.28 + 907.15 + 18.50 + 114.90 = **$3,085.15** vs `=SUM(Data!R2:R11)` = **$3,085.16** | ✅ MATCH (1¢ = cent-rounding of the ten line values; tolerance ≤ $0.01) |
| Internal consistency | `Avg × Count = Total` → 229.86 × 9,994 ≈ 2,297,200.86 | ✅ MATCH |
| Count agreement | `COUNT` vs `COUNTA(Order ID)` vs `ROWS(table)` | ✅ all = 9,994 |
| Status-bar cross-check | Select `R2:R9995` on Data → status bar reads Sum 2,297,200.86 / Average 229.86 / Count 9,994 | ✅ MATCH |

> 💡 **The one-cent story:** the hand-sum and the Excel sum differ by exactly $0.01 because
> the manual path adds *cent-rounded* line values while `SUM` keeps full precision.
> The lesson kept in the audit note: manual verification proves **digits and magnitude**,
> not bitwise equality — so checks use a rounding tolerance, not `=`.

---

## 🎨 Formatting Rules Applied
- Currency on money KPIs, comma-number on the count — one style per measure
- KPI cards: bordered, accent-filled, label / value / caption stacked
- Gridlines off; verification block visually separated; status-bar note as a footer banner

## 💡 What the Three Numbers Say
- **$2.297M** of sales sits in the file, but the **$229.86 average line** is a mask, not a
> portrait: line values run from under $1 to ~$10K (Day 9's spread lesson), so the mean
> must always travel with its spread.
- **9,994 transactions** at line grain vs 5,009 at order grain — the same "count" question
  has two correct answers depending on definition; the sheet states which one it uses.

## 📚 Lessons Learned
- **Formulas, never typed numbers** — the summary recalculates if a single data cell changes.
- **Verify in layers:** hand arithmetic → internal consistency (avg × count = total) →
  Excel's own status bar. Three independent paths agreeing is what makes a number reportable.
- **Rounding tolerance is part of check design** — a 1¢ gap is rounding, not error.
- **Structured references** (`Superstore[Sales]`) keep formulas readable and auto-expanding.
- **Name the grain** before naming the KPI.

---

## 📁 Folder Contents
```
day-14-sales-summary/
├── README.md
├── Day-14_Superstore_Sales_Summary.xlsx   # Data tab + Summary tab
├── data/Sample - Superstore.csv           # input (9,994 order lines)
├── assets/                                # Summary tab + Data tab screenshots
└──docs/Day_14_Basic_Sales_Summary_Report.pdfN
```

## 🔁 How to Reproduce
1. Paste CSV into `Data` → `Ctrl+T` → name table `Superstore` → freeze row 1.
2. Build `Summary`: three KPI formulas above + verification block
   (`=IF(ABS(hand−excel)<=0.01,"✅ MATCH","❌ CHECK")`, `=IF(ABS(avg*count−total)<0.01,…)`,
   count-agreement `AND(COUNT=COUNTA, COUNT=ROWS)`).
3. Format cards, switch gridlines off, add the status-bar footer note.
4. Change any Sales cell on `Data` → watch all three KPIs and every check react live.

## 🔗 Series

[Day 13 – Duplicate Check](../day-13/) · 

**Day 14 – Basic Sales Summary** ·
LinkedIn post: [link](https://lnkd.in/p/d2ipNQiT)