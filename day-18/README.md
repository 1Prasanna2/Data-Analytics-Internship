# 📊 Day 18 — Region Performance: Comparing Sales *and* Profit by Region

> 45-Day Data Analytics Internship · Level 1 · Day 18
> Tool: Microsoft Excel (Tables, SUMIFS / COUNTIFS, RANK.EQ, clustered column + combo chart)
> Dataset: Sample Superstore — 9,994 order lines · 4 regions
> Theme: grouping and comparison — and the discipline of never ranking on one metric alone

---

## 🎯 Task

**Compare sales across regions.**

**Deliverables (as assigned):**
- Region summary ✅ (`Region_Summary` tab — 4 regions × sales, profit, margin, lines, ranks)
- Bar chart ✅ (clustered column comparing Sales vs Profit by region)

**Hints followed:**
- ✅ Compared **both Sales and Profit** (plus margin and per-line profit)
- ✅ **Ranked the regions** — on sales, on profit, on margin, *and* a composite rank
---

## 📦 Dataset

| Property | Value |
|---|---|
| Source | `data/Sample - Superstore.csv` |
| Rows | 9,994 order lines (one row = one order line, *not* one order) |
| Grouping field | `Region` (Central, East, South, West) |
| Measures | `Sales`, `Profit`; counts from `Order ID` / row count |
| Grain note | "Order Lines" is the honest label for a row count here (Day 13 grain lesson) |

---

## 🗂 Workbook Structure (`Day-18_Region_Performance.xlsx`)

| Tab | Role |
|---|---|
| `Data` | Raw Superstore paste → Excel Table **`Superstore`**, frozen header, untouched |
| `Region_Summary` | The region table (rows 4–7), totals/check row 8, validation rows 10–12, and the bar chart anchored beside it |

All formulas use **structured references** (`Superstore[Sales]`, `Superstore[Region]`) so the
summary recalculates if the source changes — the same auto-updating habit from Days 8 / 10 / 14.

---

## 🧮 Method — the exact Excel formulas

Layout on `Region_Summary`: headers row 3; regions in `A4:A7` = `Central / East / South / West`
(type them exactly as they appear in the data — no trailing spaces, matching case).

| Col | Header | Formula (row 4, fill down to row 7) | Format |
|---|---|---|---|
| A | Region | *(typed)* | text |
| B | Total Sales | `=SUMIFS(Superstore[Sales], Superstore[Region], $A4)` | Currency `$#,##0` |
| C | Total Profit | `=SUMIFS(Superstore[Profit], Superstore[Region], $A4)` | Currency `$#,##0` |
| D | Profit Margin | `=IFERROR(C4/B4, "")` | Percent `0.0%` |
| E | Order Lines | `=COUNTIFS(Superstore[Region], $A4)` | Number `#,##0` |
| F | Avg Profit / Line | `=IFERROR(C4/E4, "")` | Currency `$#,##0.00` |
| G | Sales Rank | `=IF($B4="","",RANK.EQ($B4,$B$4:$B$7,0))` | Number `0` |
| H | Profit Rank | `=IF($C4="","",RANK.EQ($C4,$C$4:$C$7,0))` | Number `0` |
| I | Margin Rank | `=IF($D4="","",RANK.EQ($D4,$D$4:$D$7,0))` | Number `0` |
| J | Composite Score | `=IFERROR(AVERAGE(G4:I4),"")` | Number `0.00` |
| K | Final Rank | `=IF($J4="","",RANK.EQ($J4,$J$4:$J$7,1))` | Number `0` |

> 🔑 Two rank-direction details that matter: `RANK.EQ(…,0)` = **descending** (rank 1 = biggest)
> for the raw metrics, but the composite score uses `RANK.EQ(…,1)` = **ascending**, because for an
> *average of ranks* a **lower** score is better. Getting this backwards silently flips your whole
> leaderboard — it's the most common bug in this build.

**Totals / control row (row 8):**

| Cell | Formula |
|---|---|
| B8 | `=SUM(B4:B7)` |
| C8 | `=SUM(C4:C7)` |
| D8 | `=IFERROR(C8/B8,"")` |
| E8 | `=SUM(E4:E7)` |
| F8 | `=IFERROR(C8/E8,"")` |

**Validation block (rows 10–12) — the trust layer:**

| Cell | Formula | Expected |
|---|---|---|
| A10 | `=IF(ABS(B8-SUM(Superstore[Sales]))<0.01,"✅ MATCH","❌ CHECK")` | ✅ |
| A11 | `=IF(ABS(C8-SUM(Superstore[Profit]))<0.01,"✅ MATCH","❌ CHECK")` | ✅ |
| A12 | `=IF(E8=COUNTA(Superstore[Region]),"✅ MATCH","❌ CHECK")` | ✅ (9,994) |

If any check fails, the usual culprits are a region name that doesn't exactly match the data, a
trailing space, or a blank region row — fix the *label*, not the formula.

**Sorting & formatting:** sort `A3:K7` by **Total Sales, largest → smallest** before charting, so
the bars read high-to-low. Add a green→red **color scale** on `D4:D7` (margin) and a simple
rule on the rank columns (value 1 = green, value 4 = red). Turn gridlines off.

---

## 📈 The Bar Chart (Deliverable 2)

**Primary — clustered column, Sales vs Profit by region:**
- Select `A3:C7` → *Insert → Charts → Clustered Column*
- Title: `Sales vs Profit by Region`
- X-axis title `Region`, Y-axis title `Amount ($)`; legend on (two series); data labels on
- Two bars per region make the **scale-vs-value** contrast visible at a glance

---

## ✅ Verified Outputs (from your live workbook — re-confirm in your file)

These are the figures your `SUMIFS`/`COUNTIFS` produced (consistent with the Day-6 and Day-16
reconciliation). Treat them as a checkpoint, not as gospel — your current file is the source of truth.

| Region | Total Sales | Total Profit | Margin | Order Lines | Avg Profit / Line | Sales Rank | Profit Rank | Margin Rank | Composite | **Final Rank** |
|:---|--:|--:|--:|--:|--:|:--:|:--:|:--:|:--:|:--:|
| West | $725,458 | $108,418 | 14.9% | 3,203 | $33.85 | 1 | 1 | 1 | 1.00 | **1** |
| East | $678,781 | $91,523 | 13.5% | 2,848 | $32.14 | 2 | 2 | 2 | 2.00 | **2** |
| Central | $501,240 | $39,706 | 7.9% | 2,323 | $17.09 | 3 | 4 | 4 | 3.67 | **4** |
| South | $391,722 | $46,749 | 11.9% | 1,620 | $28.86 | 4 | 3 | 3 | 3.33 | **3** |
| **TOTAL / CHECK** | **$2,297,201** | **$286,397** | **12.5%** | **9,994** | **$28.66** | — | — | — | — | — |

*(Avg profit/line = Total Profit ÷ Order Lines; company benchmark = $28.66/line.)*

---

## 🔍 Insights — reading the table, not just filling it

- **Highest sales:** West ($725K). **Lowest sales:** South ($392K).
- **Highest profit:** West ($108K). **Lowest profit:** Central ($40K).
- **The "sales-alone misleads" case — Central:** it has the **3rd-highest sales** but the
  **worst profit and worst margin** (7.9%, vs the 12.5% company average). If you ranked only by
  sales, Central would look like a solid mid-tier region; profit and margin reveal it's actually
  the weakest performer. This is the single best answer to *"why compare profit with sales?"*
- **The "smaller but healthier" case — South:** it has the **lowest sales** yet **beats Central
  on both profit and margin** (11.9% vs 7.9%). A region can be small and still efficient — and
  the composite rank correctly places South (3rd) *above* Central (4th) despite South selling less.
- **West & East are the genuine engines:** both above the company margin, both top-2 on every
  metric — scale *and* efficiency together.
- **Per-line view:** West/Earn ~$33–34 profit per line vs Central's ~$17 — Central earns roughly
  *half* as much per transaction as the leaders, which is the operational root of its weak margin.

> One-line synthesis: **sales rank tells you market size; profit and margin rank tell you business
> health — and the two disagree exactly where it matters most (Central vs South).**

---

## 📚 Lessons Learned
- **One metric lies; three metrics argue honestly.** The Central-vs-South flip is the proof.
- **Rank direction is a real bug source** — descending for raw values, ascending for an average-of-ranks.
- **Control totals first** (the three ✅ checks): a region summary that doesn't sum back to the
  grand total means a label mismatch, not a formula error.
- **Name the grain:** "Order Lines" ≠ "Orders" in Superstore; mislabeling it would overstate volume.
- **Chart type follows the question** (Day 7): discrete-group comparison → column, with an optional
  margin line on a secondary axis to add the efficiency dimension.
- **Structured references** keep the whole sheet live and auditable.

---

## 📁 Folder Contents
```
day-18-region-performance/
├── README.md
├── Day-18_Region_Performance.xlsx     
├── data/Sample - Superstore.csv       
├── assets/                            
└── docs/day-18_linkedin_post.md
```

## 🔁 How to Reproduce
1. Paste the CSV into `Data` → `Ctrl+T` → name the table `Superstore` → freeze row 1.
2. On `Region_Summary`, type the four region names in `A4:A7` (exact match to the data).
3. Fill the formula columns B→K exactly as listed; add the totals row 8 and the three validation
   checks in rows 10–12 — confirm all ✅ before going further.
4. Sort `A3:K7` by Total Sales (largest→smallest); apply the margin color scale and rank highlights.
5. Insert the clustered column chart from `A3:C7` (title + axis labels); optionally build the
   combo chart from `A3:D7`.
6. Read the insights off your own numbers — the Central/South contrast should fall out directly.

## 🔗 Series

[Day 17 – Monthly Sales Trend](../day-17-monthly-sales-trend/) ·

 **Day 18 – Region Performance** ·
LinkedIn post: [link](https://lnkd.in/p/diQ5vfm3)