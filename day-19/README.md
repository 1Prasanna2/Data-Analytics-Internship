# 📊 Day 19 — Top 10 Products by Sales: Rank, Sort, and Respect the Ties

> 45-Day Data Analytics Internship · Level 1 · Day 19
> Primary tool: **Microsoft Excel** (Tables, dynamic-array spills, SUMIF / LARGE / COUNTIF / INDEX-MATCH, bar chart)
> Supporting tool: **Python + pandas** — *validation only*, not a parallel build
> Dataset: Sample Superstore — 9,994 order lines · ~1,862 unique products
> Theme: ranking and sorting — and the discipline of never letting a tie decide a leaderboard silently

---

## 🎯 Task

**Identify the top 10 products by sales.**

**Deliverables (as assigned):**
- Top-10 table ✅ (`Top_10` output block — Rank · Product Name · Total Sales · % of Total · Tie flag · Cumulative %)
- Chart ✅ (horizontal bar, rank 1 at top)

**Hints followed:**
- ✅ Sorted **descending** by aggregated product sales
- ✅ **Checked ties** at the cutoff with `LARGE()` + `COUNTIF()` and documented the decision

**Tool split (as required):** Excel develops and presents the deliverable; Python independently
recomputes the same ranking, detects the cutoff tie, and produces supporting findings — so a match
between two different implementations is the proof the Excel answer is right.

---

## 📦 Dataset

| Property | Value |
|---|---|
| Source | `data/Sample - Superstore.csv` |
| Rows | 9,994 **order lines** (one row = one product on one order — *not* one order) |
| Grouping key | `Product Name` (human-readable; verified it doesn't split a product across IDs) |
| Measure | `Sales` (summed per product) |
| Grain note | Ranking is done **after** collapsing lines → products; you rank at the grain the question asks at |

---

## 🗂 Workbook Structure (`Day-19_Top_10_Products.xlsx`)

| Tab | Role | Editable? |
|---|---|---|
| `Data` | Raw Superstore → Excel Table **`Superstore`**, frozen header, untouched | ❌ source |
| `Master` | The live **engine**: unique products + sales + % + gap-free rank + tie flag (a *spill* in A–E) + cutoff box (F–G) | ❌ read-only spill |
| `Top_10` | The **deliverable**: 10-row output table (J–O / A–F) + the bar chart anchored beside it | ✅ |

> 🔑 **The one architectural rule that makes this work:** the master list in `Master!A3:E…` is a
> **dynamic-array spill** — Excel *owns* every cell in it. You cannot type into it, sort it, or
> filter it. So the Top-10 output is built in a **separate, editable zone** that pulls from the
> spill read-only via `INDEX/MATCH`/`LARGE`. Mixing the two is the single most common way this
> build breaks (see §Bugs).

---

## 🧮 Method — Excel (the primary build)

### Zone 1 — Master engine (`Master` tab, row 3 spills downward on its own; do NOT drag or sort)

| Cell | Formula | What it produces |
|---|---|---|
| A3 | `=SORT(UNIQUE(Superstore[Product Name]))` | every unique product, alphabetical |
| B3 | `=SUMIF(Superstore[Product Name], $A$3#, Superstore[Sales])` | total sales per product |
| C3 | `=$B$3#/$G$2` | % of grand total |
| D3 | `=MAP($B$3#, $A$3#, LAMBDA(s, n, SUMPRODUCT(($B$3#>s)*1) + SUMPRODUCT(($B$3#=s)*($A$3#<n)) + 1))` | **gap-free ordinal rank 1…N** (alphabetical tie-break) |
| E3 | `=IF($B$3#=$G$3, "TIE AT CUTOFF", "")` | flags any product sitting exactly on the cutoff |

**Cutoff box (F–G, the three cells that drive the tie decision):**

| Cell | Formula | Meaning |
|---|---|---|
| G2 | `=SUM(Superstore[Sales])` | grand total (denominator for every %) |
| G3 | `=LARGE($B$3#,10)` | the **10th-largest** sales value = the Top-10 boundary |
| G4 | `=COUNTIF($B$3#,$G$3)` | **1** = no tie; **≥2** = tie at the cutoff |

> Why D3 is a `MAP/LAMBDA` and not a plain `RANK.EQ`: `RANK.EQ` *skips* numbers on ties (two 5s then
> 7), which would make the extraction in Zone 2 return `#N/A` at the skipped slot. The `MAP` version
> guarantees every product a **unique** position 1,2,3,… with no gaps and no duplicates — so the
> Top-10 lookup can never break. (You're on Excel 365 — `UNIQUE`/`SORT` already proved that — so
> `MAP`/`LAMBDA` is available.)

### Zone 2 — Top-10 output (`Top_10` tab; ranks typed by hand, formulas return single values → fully editable)

Headers row 1; type `1`…`10` down the rank column; paste the row-2 formulas and drag to row 11.

| Col | Header | Formula (row 2, drag ↓ to 11) | Pulls |
|---|---|---|---|
| A | Rank | *(type 1…10)* | the position you want on each line |
| B | Product Name | `=INDEX(Master!$A$3#, MATCH($A2, Master!$D$3#, 0))` | the product holding ordinal rank = A2 |
| C | Total Sales | `=LARGE(Master!$B$3#, $A2)` | the A2-th largest sales value |
| D | % of Total | `=$C2/Master!$G$2` | that product's share of grand total |
| E | Tie? | `=IF(COUNTIF(Master!$B$3#,$C2)>1,"TIE","")` | marks a shared sales value |
| F | Cumulative % | `=SUM($D$2:D2)` | running share (concentration read) |

> **Row-alignment rule (the bug that bites everyone):** the number inside `$A{n}` must equal the
> row the formula sits on, and the first formula row must equal the first rank row. If your ranks
> start in row 2 but the formula in row 2 reads `$A3`, every line grabs the *next* rank down and
> the bottom line looks for a rank that doesn't exist → `#N/A`. The fix is to make the row match.
> (And never paste this formula into the *same* column as the ranks — that's a circular reference.)

**Formats:** C → Currency `$#,##0.00` · D, F → Percent `0.00%` · A → Number `0`. Bold row 1, thin
border around the block, optional data-bar conditional format on C.

---

**How it validates Excel (not replaces it):**

| Excel construct | pandas equivalent | What the comparison proves |
|---|---|---|
| `SUMIF` over `UNIQUE` | `groupby().sum()` | same per-product totals |
| `LARGE(range,10)` | `ps.loc[9,"Total Sales"]` | same cutoff value |
| `COUNTIF(range,cutoff)` | `(Sales==cutoff).sum()` | same tie conclusion |
| `MAP` ordinal rank | `rank(method="min")` | same ordering at the boundary |

If the four agree, the Excel table is confirmed by an independent implementation — stronger evidence
than either tool alone, because it's unlikely both made the same mistake. If they *disagree*, the
cause is almost never the math; it's dirty input (trailing spaces, text-numbers) — which is exactly
why both pipelines `strip`/`TRIM` names and confirm `Sales` is numeric **before** comparing.

---

## 🔀 Tie Handling (the hint that separates a report from an analysis)

Three situations, and the decision for each:

| Situation | What you see | Action |
|---|---|---|
| No tie at cutoff | `G4 = 1` | Strict Top-10 (10 rows) **is** the answer. Write: *"No tie at the cutoff."* |
| Tie exactly at rank 10 | `G4 ≥ 2`, tied products straddle the boundary | Strict table keeps one (alphabetical tie-break via D3); **also** publish an extended list |
| Multiple ties crossing cutoff | several products share the 10th value | Extended list is mandatory, else you arbitrarily exclude equal performers |

**Strict vs including-ties — and the choice documented:**

- **Strict Top 10** = exactly 10 rows, deterministic tie-break (alphabetical by product name). Clean,
  matches the literal brief, but can exclude an equally-performing product.
- **Top 10 including ties** = every product with `Sales ≥ G3` (may be 11, 12…). Fair, shows maturity,
  but is no longer literally "10".

> **Decision for this deliverable:** ship the **strict Top 10** as the primary table (it answers the
> brief exactly), run the tie check in `G4`, and **only if `G4 ≥ 2`** attach an extended
> *"Top 10 including ties"* list built from the master with
> `=SORT(FILTER(Master!$A$3#, Master!$B$3# >= Master!$G$3), , -1)`. The `Tie?` column inside the
> strict table already flags any shared value, so a reviewer sees the tie without opening the
> extension. One sentence under the table records the rule:
> *"Strict Top 10 shown (alphabetical tie-break at the cutoff). Cutoff tie count (G4) = [value]; if
> >1, the extended including-ties list is provided so equally-performing products aren't dropped."*

---

## ✅ Verified Checkpoints (structure I can state; product rows come from YOUR file)

> ⚠️ I have **intentionally left the ten product rows as placeholders** below. Your `Master`/`Top_10`
> tabs compute them. Do **not** copy product names or sales from any external source — the tie
> outcome and exact ordering depend on your live sums, and fabricating them would void the whole
> "check ties" exercise. Fill these from your workbook, then cross-check against
> `python_top10_strict.csv`.

| Rank | Product Name | Total Sales | % of Total | Tie? | Cumulative % |
|---:|---|---:|---:|---|---:|
| 1 | *[from your Top_10 tab]* | *[…]* | *[…]* | | *[…]* |
| 2 | *[…]* | *[…]* | *[…]* | | *[…]* |
| … | … | … | … | … | … |
| 10 | *[…]* | *[…]* | *[…]* | *[TIE?]* | *[…]* |

**The facts that ARE fixed and that your file must reproduce (reconciliation targets):**

| Check | Expected | Why it's a checkpoint |
|---|---|---|
| Order lines in source | **9,994** | `=COUNTA(Superstore[Order ID])` |
| Unique products | **~1,862** | `=ROWS(Master!$A$3#)` — the spill length |
| Grand total sales | **$2,297,200.86** | `=Master!$G$2` = `=SUM(Superstore[Sales])` |
| Sum of ALL product sales = grand total | ✅ | every line belongs to exactly one product |
| Top-10 cumulative % (F11) | *[your value]* | the concentration stat — a headline finding |
| Cutoff tie count `G4` | *[1 or ≥2]* | drives the strict-vs-extended decision |
| Excel Top-10 ≡ Python Top-10 | ✅ | names, values, order, tie count all match |

If `ROWS($A$3#)` ≠ your unique count or the product-sum ≠ grand total, a product name has a trailing
space or `Sales` is text somewhere — fix the *source* (`TRIM` / `VALUE`), the spill refreshes.

---

## 📈 Chart Design (from the editable zone only — never from the spill)

- **Type:** horizontal **Clustered Bar** (product names are long → bars read far better than columns).
- **Source:** `Top_10` name column + Total Sales column (e.g. `B1:B11` + `C1:C11`).
- **Title:** `Top 10 Products by Total Sales` · subtitle: `Ranked by summed sales across all order lines`.
- **Axes:** value axis `Total Sales ($)`, category axis `Product`.
- **Labels:** data labels outside-end, currency `$#,##0`; legend removed (one series).
- **Order:** rank 1 at the **top** → Format Axis → **Reverse axis** (matches the table, reads high→low).
- **Discipline (Day-7 rule):** products are discrete groups → bar/column, *not* a line (no time axis)
  and *not* a pie (we rank 10 items, not show one share-of-whole; and a 10-slice pie breaks the ≤5 rule).

---

## 🔍 Findings & Interpretation (fill from your live numbers — 3–5 observations)

1. **Highest-selling product** — *[name]*, *[value]*, *[x.x%]* of all sales; it alone is the revenue anchor.
2. **Concentration** — the Top 10 together are *[F11 = xx.x%]* of total sales. High → revenue depends on a
   few SKUs (stockout risk, priority for supply/marketing); low → sales are diversified across the catalog.
3. **Steepness of the drop-off** — gap between rank 1 and rank 10 is *[value]*; a big gap means the leaders
   truly lead, a small one means the "top tier" is a crowded plateau.
4. **Tie outcome** — cutoff value *[G3]*, tied products *[G4]*; *[no tie → strict = extended]* / *[tie →
   extended list of N products attached]*.
5. **Revenue ≠ profit caveat** — this ranks by *sales*; from Day 16 I know the sales leader isn't
   automatically the profit leader (discounts can make a top seller lose money), so the honest next step
   is a profit/margin overlay on these same 10 — flagged, not fabricated here.

---

## 🛠 Two Bugs I Hit (and the fix) — kept in the README because they're the real lesson

| Symptom | Root cause | Fix |
|---|---|---|
| Excel popup **"You can't change part of an array"** when extracting the Top 10 | I tried to *type ranks into* / *sort* the `Master!A3:E…` **spill** — Excel owns those cells | Build the output in a **separate editable zone** (`Top_10`) that reads the spill via `INDEX/MATCH`/`LARGE`; never write into a spill |
| `#N/A` on the last row / wrong products in the lookup | **Off-by-one row**: formula in row *n* read `$A{n+1}` (ranks started a row above the formula), or the formula was pasted into the *same* column as the ranks (circular ref) | Make the row in `$A{n}` equal the formula's own row; put the lookup in the column *next to* the ranks |

Both are consequences of one principle: **a dynamic array is read-only infrastructure; outputs live
beside it, not inside it.**

---

## 🗣 Interview-Ready Answers

**Assigned Q1 — How do you handle ties?**
- I check the cutoff explicitly: in Excel `LARGE(range,10)` gives the 10th value and `COUNTIF` tells me
 how many products share it; in pandas it's `ps.loc[9]` and `(Sales==cutoff).sum()`. If count = 1 there's no tie and the strict Top 10 stands. If ≥2 I either apply a documented tie-break (here alphabetical,
 baked into a gap-free `MAP` rank so the lookup never throws `#N/A`) for a strict 10-row table, **and**
 publish an extended "including ties" list so equally-performing products aren't silently dropped. The
 rule I always state: a tie excluded by sort order alone is misleading, so I surface it either way.

**Assigned Q2 — Why use Top 10 analysis?**
- It finds the biggest contributors so the business can prioritise — stock the leaders, focus marketing
 where it already converts, and watch concentration risk (if 10 products are most of revenue, a stockout> or a discount change on one of them moves the whole top line). It also tells you whether revenue is
 concentrated or spread, which changes how you manage the catalog.

**Anticipated reviewer Q3 — Each row is an order *line*; what did you sum, and why group by name not ID?**
- I summed order lines into per-product totals (`SUMIF`/`groupby`) before ranking, because the question is
 "per product". I grouped by `Product Name` for a human-readable list, and verified the name→ID mapping
 wouldn't split one product's sales across two rows — if it had, I'd group by `Product ID` and join the name back for display. You rank at the grain the question is asked at.

**Anticipated reviewer Q4 — Excel and Python disagree — which do you trust?**
- Neither by default. I made them logically equivalent (`SUMIF`↔`groupby`, `LARGE`↔`loc[9]`,
 `COUNTIF`↔`==cutoff`), compared names/values/order/tie-count, and treated a match as confirmation —
 two independent implementations agreeing is stronger than one. Disagreements usually trace to dirty
 input (spaces, text-numbers), not the formula, which is why both pipelines clean names first.

**Anticipated reviewer Q5 — Is "best-selling by revenue" the same as "best product"?**
- No. Revenue ranks importance to the top line; profit ranks contribution to the bottom line. From Day 16
 I know a top seller can be a profit villain if it's heavily discounted (the ≥40% discount cliff from
 Days 11/15). So this list is a *prioritisation starting point*, and I'd pair it with profit/margin and a
 loss-line count before calling any product "best".

---

## 📚 Lessons Learned
- **A spill is infrastructure, not a worksheet** — never type into, sort, or filter a dynamic array;
  outputs live beside it and read it via `INDEX/MATCH`/`LARGE`.
- **`RANK.EQ` skips on ties** → use a gap-free ordinal rank (`MAP`/`LAMBDA` or `SUMPRODUCT` fill-down)
  so a Top-N extraction can't return `#N/A`.
- **Row alignment is a real bug class** in lookup tables — the `$A{n}` row must equal the formula's row.
- **Ties are a decision, not an accident** — check the cutoff, pick strict or including-ties, and write
  the rule down.
- **Two tools, one logic** — Python validates Excel by reproducing the *same* operations; a match across
  independent implementations is the strongest evidence a number is right.
- **Rank at the grain the question asks** — lines → products, summed before sorted.
- **Revenue-leader ≠ profit-leader** — a Top-10-by-sales is a prioritisation input, not a verdict.

---

## 📁 Folder Contents
```
day-19-top-10-products/
├── README.md
├── Day-19_Top_10_Products.xlsx        # Data · Master (spill engine + cutoff) · Top_10 (output + chart)
├── day19_top10_validation.ipynb          # pandas validator (NOT a parallel build)
├── cross-check/    
├── data/Sample - Superstore.csv       # input (9,994 order lines)
├── assets/                            # Top_10 table + bar chart + Python-output screenshots
└── docs/Day-19-Internship_Report.pdf
```

## 🔁 How to Reproduce
1. Paste CSV into `Data` → `Ctrl+T` → name table `Superstore` → freeze row 1.
2. On `Master`, paste the five row-3 spill formulas (A3–E3) and the three cutoff cells (G2–G4);
   confirm the spill fills (~1,862 rows) and C shows %, D shows 1…N with no gaps.
3. On `Top_10`, type 1–10 in the rank column, paste the row-2 lookup formulas, drag to row 11 —
   **keep them out of the `Master` spill** (this is what avoids the array popup).
4. Read `G4`: if 1, the strict table is final; if ≥2, build the extended including-ties list and
   attach it. Write the one-line tie decision under the table.
5. Insert the horizontal bar chart from the name + sales columns; reverse the axis so rank 1 is on top.
6. Run `python day19_top10_validation.py`; diff `python_top10_strict.csv` against your `Top_10` block —
   names, values, order and tie count must all match. Fill the findings placeholders from your live numbers.

## 🔗 Series

[Day 18 – Region Performance](../day-18-region-performance/) ·

**Day 19 – Top 10 Products** · LinkedIn post: [link](https://lnkd.in/p/d9trrwiB)