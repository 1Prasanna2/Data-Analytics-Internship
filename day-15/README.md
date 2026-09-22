# 📊 Day 15 — Product Count Analysis: COUNTIF / COUNTIFS on Superstore

- 45-Day Data Analytics Internship · Level 1 · Day 15
- Tool: Microsoft Excel (COUNTIF, COUNTIFS, SUMIFS, INDEX/MATCH, PivotTables)
- Dataset: `Sample - Superstore.csv` — 9,994 order lines · 21 columns
- Theme: counting is a skill — lines, unique products, and "top" all depend on definitions

---

## 🎯 Task

Practice **COUNTIF / COUNTIFS** to answer product-count questions.

**Deliverables (as assigned):**
- Product Count Table ✅ (category + sub-category: lines, unique products, sales, share)
- Top category ✅ (stated per metric: by lines *and* by sales)

**Hints followed:**
- ✅ Unique products checked (first-occurrence flag + distinct-count pivot cross-check)
- ✅ PivotTable used as an independent verification layer

---

## 📦 About the File (`Sample - Superstore.csv`)

| Property | Value |
|---|---|
| Grain | One row per **order line** (an order with 3 products = 3 rows) |
| Rows / Columns | 9,994 × 21 |
| Key columns used | `Product ID` (N), `Category` (O), `Sub-Category` (P), `Product Name` (Q), `Sales` (R), `Profit` (U) |
| Cardinality | 3 categories · 17 sub-categories · ≈1,859 unique products · 5,009 unique orders · 793 customers |
| Known quirks | `Order ID` and `Customer ID` repeat **legitimately** (order lines / repeat buyers); 17 full-row duplicate copies exist (Day 13); some raw extracts show concatenated record pairs — always validate column count on import |

---

## 🗂 Solution: Workbook Structure (`Day-15_Superstore_Product_Counts.xlsx`)

| Tab | Role |
|---|---|
| `Data` | Raw paste → Table **`Superstore`** + helper column V `FirstOcc` = `=IF(COUNTIF($N$2:N2,N2)=1,1,0)` (named range) — flags the first line of every Product ID |
| `Counts` | Category table, sub-category table, top-category cards, COUNTIFS practice block, verification notes |
| Pivot (cross-check) | Rows: Category → Sub-Category · Values: Count of Product ID + **Distinct Count** (Data Model) |

---

## 🧮 The Product Count Tables

**Category level (rows 2–4):**

| Column | Formula | Meaning |
|---|---|---|
| B | `=COUNTIF(Superstore[Category],$A2)` | order lines per category |
| C | `=COUNTIFS(Superstore[Category],$A2,FirstOcc,1)` | **unique products** per category |
| D | `=SUMIFS(Superstore[Sales],Superstore[Category],$A2)` | sales (context) |
| E | `=B2/SUM($B$2:$B$4)` | share of lines |

**Expected:** Furniture **2,121** · Office Supplies **6,146** · Technology **1,727** lines (Σ = 9,994 ✅);
unique products per category sum to the global distinct count (≈ **1,859** = `=COUNTIF(FirstOcc,1)`).

**Sub-category level (rows 11–27):** same three formulas across all 17 sub-categories,
plus top-sub-category cards by lines and by sales. Σ checks: lines = 9,994; unique = Σ category uniques.

**COUNTIFS practice block:**
```excel
=COUNTIFS(Superstore[Category],"Technology",Superstore[Profit],"<0")          // loss lines
=COUNTIFS(Superstore[Category],"Office Supplies",Superstore[Discount],">=0.4") // deep-discount lines
=COUNTIFS(Superstore[Category],"Furniture",Superstore[Region],"West",Superstore[Profit],">100")
=COUNTIFS(Superstore[Segment],$A31,Superstore[Category],B$30)                  // 3×3 segment×category matrix
```

---

## 🏆 Deliverable 2 — Top Category (definition stated on-sheet)

| Metric | Formula | Answer |
|---|---|---|
| By order lines | `=INDEX($A$2:$A$4,MATCH(MAX($B$2:$B$4),$B$2:$B$4,0))` | **Office Supplies** (6,146 lines) |
| By sales | `=INDEX($A$2:$A$4,MATCH(MAX($D$2:$D$4),$D$2:$D$4,0))` | **Technology** (≈ $836K) |

> 💡 The "top category" **flips depending on the metric** — Office Supplies wins on volume of
> lines, Technology on dollars (fewer, pricier lines). The sheet states which definition each
> card uses; an undefined "top" is how dashboards mislead.

---

## 🔍 Unique-Product Verification (hint #1 & #2)
1. `FirstOcc` flag sum = `=COUNTIF(FirstOcc,1)` → ≈1,859
2. Σ of column C (category uniques) = same number (each product lives in exactly one category)
---

## 📚 Lessons Learned
- `COUNTIF` = one criterion; `COUNTIFS` = AND-stacked criteria; criteria strings are
  case-insensitive but space-sensitive — copy names from data, never type them.
- **Distinct counts need a pattern:** expanding-range first-occurrence flag is fast and readable;
  `SUMPRODUCT(1/COUNTIF(...))` on 10k rows is a 100M-operation trap.
- "How many products?" has three answers: lines, unique products, unique products *per group* —
  name which one you mean.
- PivotTables are a verification layer, not a replacement: COUNTIF table ↔ pivot counts must agree.
- Flag columns computed once; editing the key column afterwards forces a slow recompute.

## 📁 Folder Contents
```
day-15-product-counts/
├── README.md
├── Day-15_Superstore_Product_Counts.xlsx   # Data (+FirstOcc) · Counts · pivot cross-check
├── data/Sample - Superstore.csv            # input file documented above
├── assets/                                 # count tables + pivot distinct-count screenshots
└── docs/Day 15 Product Count Analysis.pdf
```

## 🔁 How to Reproduce
1. Paste CSV → `Ctrl+T` → name `Superstore` → add `FirstOcc` flag column → name it.
2. Build the two count tables with the COUNTIF/COUNTIFS/SUMIFS trio + INDEX/MATCH top cards.
3. Fill the COUNTIFS practice block and the segment×category matrix.
4. Cross-check with a pivot (Count + Distinct Count via Data Model); confirm all Σ checks.

## 🔗 Series
[Day 14 – Sales Summary](../day-14/) ·

**Day 15 – Product Counts** 
· LinkedIn post: [link](https://lnkd.in/p/dE92-xy7)