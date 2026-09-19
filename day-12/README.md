# 📊 Day 12 — Missing Value Identification: Finding What Isn't There

> 45-Day Data Analytics Internship · Level 1 · Day 12
> Tools: Python (pandas) · Excel (COUNTBLANK, SUMPRODUCT+COUNTIF, conditional formatting)
> Datasets: Iris (150 × 5) · Self-generated `EDA_Practice_Customer_Orders_150.xlsx` (150 × 16)
> Theme: inspect missing data honestly — count it, locate it, and touch nothing without justification

---

## 🎯 Task

Identify missing values and summarize **where** they occur.

**Deliverables (as assigned):**
- Missing-value summary ✅ (per-column table, both datasets)
- Short findings ✅ (including why nothing was blindly dropped)

**Hints followed:**
- ✅ Nulls counted **by column** (true blanks *and* encoded markers)
- ✅ **No value removed or imputed without justification** — every action logged

---

## 📦 Datasets

| Dataset | Size | Missingness profile |
|---|---|---|
| Iris | 150 rows × 4 numeric + target | **Zero missing values** — the control case |
| Customer Orders (synthetic, self-generated) | 150 rows × 16 columns | True blanks, encoded markers (`Missing`, `N/A`, `Unknown`), dependent missingness, duplicates (`ORD1022`, `ORD1043`, `ORD1090`) |

---

## 🧮 Method

**Python (pandas)** — `missing_value_check.py`:
```python
import pandas as pd
df = pd.read_excel('EDA_Practice_Customer_Orders_150.xlsx', skiprows=3)

MARKERS = ["Missing", "N/A", "Unknown"]
blank   = df.isnull().sum()                       # true blanks
encoded = df.apply(lambda c: c.isin(MARKERS).sum())  # hidden "missing"
summary = pd.DataFrame({'Blanks': blank, 'Encoded': encoded,
                        'Total Missing': blank + encoded,
                        'Missing %': ((blank + encoded) / len(df) * 100).round(2)})
print(summary)
```

**Excel** — `Missing_Audit` tab (markers listed in `H1:H3`):
```excel
Blanks:   =COUNTBLANK(Orders[Customer_Age])
Encoded:  =SUMPRODUCT(COUNTIF(Orders[City], $H$1:$H$3))
Total:    =B2+C2        % of 150: =D2/150
```
> 🔑 **Key methodological point:** `isnull()` / `COUNTBLANK` alone **under-count** missingness here,
> because `Missing`, `N/A` and `Unknown` are *text*, not nulls. Counting both forms is the whole lesson.

---

## 📋 Deliverable 1 — Missing-Value Summary

**Iris:** every column returns **0 blanks / 0 encoded / 0.00%** — a complete dataset (verified, not assumed).

**Customer Orders** (live counts in the workbook's `Missing_Audit` tab):

| Column | Missing form | Example rows |
|---|---|---|
| Customer_Age | true blank | ORD1050, ORD1073, ORD1097, ORD1123 |
| Gender | true blank | ORD1061, ORD1007, ORD1090, ORD1114 |
| Product_Category | true blank | ORD1020, ORD1079, ORD1111, ORD1047 |
| Unit_Price | true blank | ORD1068, ORD1086, ORD1005, ORD1120 |
| Total_Amount | true blank — **dependent** | exactly the Unit_Price-blank and Discount-`N/A` rows |
| Discount_Pct | encoded `N/A` | ORD1075, ORD1117, ORD1018, ORD1144 |
| City | encoded `Missing` | ORD1069, ORD1108, ORD1139, ORD1014, ORD1042 |
| Payment_Method | encoded `Unknown` | ORD1092, ORD1128 |
| Customer_Rating | true blank | ORD1063, ORD1101, ORD1135 |
| Delivery_Days | true blank | ORD1022, ORD1085, ORD1125 |
| Returned | true blank | ORD1070, ORD1106, ORD1036 |

---

## 📝 Deliverable 2 — Short Findings

1. **Missingness wears two costumes.** True blanks sit in Age, Gender, Rating, Delivery_Days and
   Returned, while City, Payment_Method and Discount_Pct hide their gaps behind the *text*
   markers `Missing`, `Unknown` and `N/A`. A naive null-count would have missed the second
   group entirely.
2. **The missingness is dependent, not random.** `Total_Amount` is blank **exactly where**
   `Unit_Price` is blank or `Discount_Pct = N/A` — the gap is structural (a failed calculation
   downstream), i.e. Missing Not At Random. Dropping those rows would delete a whole
   business pattern, not just "bad data".
3. **Iris needed no action — and that is a finding.** Verifying zero missing values *before*
   cleaning is what prevents pointless (and risky) imputation.


## ⚖️ Decision Log (justification for every action)

| Issue | Action | Justification |
|---|---|---|
| True blanks (Age, Gender, Rating…) | **Flagged, not imputed** | No domain rule justifies inventing values; flags keep the audit trail |
| Encoded markers | Standardized to blank in `Cleaned` + logged | Makes future null-counts honest |
| Dependent-blank Total_Amount | **Recomputed** where Qty × Price × (1−Disc%) is possible; left blank otherwise | Recomputation is evidence-based; fabrication is not |
| Duplicate Order_IDs | Kept first occurrence, second flagged | Identical repeats add no information; conflicts kept for review |

---

## 📚 Lessons Learned
- `isnull()`/`COUNTBLANK` see only *true* nulls — encoded markers are the silent half of missing data.
- **Where** values are missing (patterns, dependencies) matters more than **how many**.
- "Do not remove without justification" is a workflow: inspect → classify (MCAR/MNAR) → log the decision.
- A clean dataset (Iris) is a valid result; proving cleanliness is still analysis.

## 📁 Folder Contents
```
day-12-missing-values/
├── README.md
├── Day-12-Missing_Value_Identification.ipynb    # pandas audit (blanks + encoded markers)
├── Day-12_CustomerOrders_MissingAudit.xlsx      # Raw · Work · Missing_Audit · Cleaned
├── data/iris_dataset.csv
├── data/EDA_Practice_Customer_Orders_150.xlsx
├── assets/                                      # audit tab + duplicate-highlight screenshots
└── docs/Day_12_Missing_Value_Report.pdf
```

## 🔁 How to Reproduce
1. `python missing_value_check.py` → prints the blanks/encoded/total/% summary, or
2. Excel: delete the 3 title rows → table `Orders` → build `Missing_Audit` with the
   COUNTBLANK + SUMPRODUCT(COUNTIF) pair → conditional-format totals > 0 → cross-check
   duplicates with `=COUNTIF($A$2:$A2,$A2)`.

## 🔗 Series
[Day 11 – Sorting & Filtering](../day-11/) 
· **Day 12 – Missing Values** ·
LinkedIn post: [link](https://lnkd.in/p/df7cKQ8u)