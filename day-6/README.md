# 📊 Day 6 — Excel Formulas & Functions Fundamentals

> 45-Day Data Analytics Internship · Level 1 · Day 6
> Tools: Microsoft Excel — Tables, Named Ranges, VLOOKUP/XLOOKUP, INDEX/MATCH, IF/IFS/IFERROR, SUMIFS/COUNTIFS/AVERAGEIFS, Text functions
> Dataset: Sample Superstore (9,994 order lines)

---

## 🎯 Task

Practice core Excel functions used in real analyst work — lookups, logic, conditional aggregation and text handling — on a live transactional dataset.

**Deliverables (as assigned):**
- A workbook demonstrating **each function on live data**
- A **Note** tab with **Short notes** on when to use each formula

**Hints followed:**
- ✅ Lookup functions practiced before nested IFs
- ✅ Named ranges used so formulas read like sentences
- ✅ Edge cases tested: blank cells, text-vs-number mismatches, trailing spaces, zero denominators

---

## 🗂 Solution: One Workbook, Eight Sheets (`Day-6-Excel-Formulas -Functions.xlsx`)

| Sheet | Purpose | Highlights |
|---|---|---|
| `Data` | Untouched source | Excel Table `tblSales`, frozen header, 11 named ranges (`SalesAmt`, `ProfitAmt`, `RegionAmt`, `DiscAmt`, …) |
| `Ref` | Tiny reference tables | Discount band table (`Bands`, sorted ascending for approximate match) + Region × Category profit matrix built with `SUMIFS` |
| `Lookups` | Lookup family on live data | Exact `VLOOKUP`, `XLOOKUP` with not-found fallback, `INDEX/MATCH`, two-way `INDEX/MATCH`, band lookup via `VLOOKUP(…,TRUE)` vs `XLOOKUP(…,-1)` |
| `Logic` | Decision functions | `IF`, nested `IF` (3 tiers), `IFS`, `IF+AND`, `IFERROR` on 15 live orders + hardcoded branch tests |
| `Aggregates` | Conditional math | `SUMIFS` / `COUNTIFS` / `AVERAGEIFS` driven by two **dropdown input cells** (Data Validation) + 4-region summary table |
| `Text` | Text toolkit | `&`, `TEXTJOIN`, `PROPER`, `LEFT/RIGHT`, `LEN`-based ZIP validation, `SUBSTITUTE`, `TEXT` |
| `EdgeCases` | Proof, not claims | Blank ≠ 0, text-in-numeric, number-as-text, trailing spaces, div/0 — each detected and fixed with a formula |
| `Notes` | **Deliverable 2** | When-to-use rules for every function family, cross-linked to the sheet that proves each rule |

---

## 🧮 Function Coverage Map

| Family | Demonstrated at | Example |
|---|---|---|
| VLOOKUP (exact + approximate) | `Lookups!B11`, `C17:C26` | `=VLOOKUP(B17,Bands,2,TRUE)` |
| XLOOKUP | `Lookups!B12`, `D17:D26` | `=XLOOKUP($B$10,$A$4:$A$7,$C$4:$C$7,"Region not found")` |
| INDEX/MATCH (1-way & 2-way) | `Lookups!B13`, `B14` | `=INDEX(Ref!$E$2:$G$5,MATCH("West",…),MATCH("Furniture",…))` |
| IF / nested IF / IFS / AND | `Logic!E:J` | `=IFS(B2=0,"n/a",C2/B2>=0.2,"High",…,TRUE,"Loss")` |
| IFERROR | `Logic!J`, `Aggregates!F` | `=IFERROR(C2/B2,"check data")` |
| SUMIFS / COUNTIFS / AVERAGEIFS | `Aggregates!B4:B9` + summary | `=SUMIFS(SalesAmt,RegionAmt,$B$1,CategoryAmt,$B$2)` |
| Text functions | `Text!F:N` | `=TEXTJOIN(" / ",TRUE,B2,C2,D2)` · `=IF(LEN(E2)=5,"OK","CHECK ZIP")` |
| Edge detection | `EdgeCases!E:F` | `=SUMPRODUCT(--(TRIM(D2:D6)="West"))` |

---

## ✅ Verified Outputs (live from the workbook)

**KPIs:** Sales **$2,297,201** · Profit **$286,397** · Margin **12.5%** · Orders **9,994** · Loss-making orders **1,871 (18.7%)**

| Region | Sales | Profit | Orders | Loss Orders | Margin |
|---|---|---|---|---|---|
| West | $725,458 | $108,418 | 3,203 | 318 | 14.9% |
| East | $678,781 | $91,523 | 2,848 | 553 | 13.5% |
| Central | $501,240 | $39,706 | 2,323 | 741 | **7.9%** |
| South | $391,722 | $46,749 | 1,620 | 259 | 11.9% |

**Targeted metrics (dropdown-driven):** Loss-making *Tables* orders = **203** · Avg discount on loss-making Consumer orders = **47.5%** · Loss $ at discount ≥ 40% = **−$125,346** · West × Furniture profit (two-way lookup) = **$11,505**

---

## 🧪 Edge Cases Tested (and what they proved)

| Case | Detection | Result | Fix |
|---|---|---|---|
| Blank sales cell | `ISBLANK` | TRUE | Flag as missing — blank ≠ 0 |
| `"abc"` in Sales | `ISTEXT` | TRUE | Clean/exclude — SUM skips it silently |
| `'250.5` number-as-text | `ISNUMBER` | FALSE | `VALUE()` → 250.5 |
| `" West "` trailing spaces | exact-match test | FALSE | `TRIM()` before matching |
| Zero sales | `IFERROR(C/B,…)` | div/0! | `IF` guard / `IFERROR` fallback |
| `SUM` over mixed block | `=SUM(B2:B6)` | 100 | Text + blank silently ignored |
| `COUNTIFS` exact vs trimmed | 1 vs 2 | mismatch | `SUMPRODUCT(--(TRIM(…)="West"))` |

---

## 💡 Insights the Formulas Surfaced
- **Central is the margin problem child** (7.9% vs West's 14.9%) despite mid-tier volume.
- **18.7% of orders lose money**, and discounts ≥ 40% account for **−$125,346** of it.
- Loss-making Consumer orders carry an average **47.5% discount** — the policy lever, not demand, is the issue.
- **Tables** alone contributes 203 loss-making orders — the single worst sub-category.

## 📚 Lessons Learned
- `XLOOKUP` match mode **−1 = exact-or-next-smaller** (band lookups); `1` = next-larger. One character cost an hour.
- `COUNTIFS`/`SUMIFS` never trim for you — clean text before matching.
- `SUM` ignoring text/blanks is a feature that hides errors; test inputs, don't trust totals.
- Named ranges turn `$M$2:$M$9994` gymnastics into readable, auditable formulas.
- `TEXT()` returns display-only strings — never aggregate them.

---

## 📁 Folder Contents
```
day-6-excel-formulas/
├── README.md
├── Day-6-Excel-Formulas -Functions.xlsx      # 8-sheet workbook (both deliverables)
├── data/                          # Sample Superstore input CSV
├── assets/                        # sheet screenshots (Aggregates, Lookups, Logic, EdgeCases, Notes)
└── docs/Day_6_Internship_Report.pdf    # reflection post drafted same day
```

## 🔁 How to Reproduce
1. Open `Day-6-Excel-Formulas -Functions.xlsx` (or rebuild: import CSV → Table `tblSales` → define named ranges → build Ref tables → add sheets in order Lookups → Logic → Aggregates → Text → EdgeCases → Notes).
2. Change `Aggregates!B1:B2` dropdowns or `Lookups!B10` to see every formula react on live data.
3. Review `Notes` sheet for the when-to-use rules (Deliverable 2).

## 🔗 Series
 [Day 5 – Excel Analytics](../day-5-excel-analytics/) ·
 
**Day 6 – Excel Formulas** ·
LinkedIn post: [LinkedIN](https://lnkd.in/p/drmdC7kh)