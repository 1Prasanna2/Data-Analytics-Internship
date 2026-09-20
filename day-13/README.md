# 📊 Day 13 — Duplicate Record Check: Detect, Document, Clean

> 30-Day Data Analytics Internship · Level 1 · Day 13
> Tools: Python (pandas + openpyxl) · Excel (conditional formatting, COUNTIF, Remove Duplicates)
> Dataset: `EDA_Practice_Customer_Orders_150.xlsx` — 150 synthetic order records, 16 columns,
> intentionally injected with blanks, encoded missing markers, duplicates, outliers and mixed types
> Theme: a duplicate is only an error once you've confirmed the dataset's grain

---

## 🎯 Task

Find duplicate records and document them.

**Deliverables (as assigned):**
- Duplicate report ✅ (`Day-13_Duplicate_and_Cleaning_Report.xlsx`)
- Cleaned copy ✅ (`Customer_Orders_Cleaned.csv`)

---

## 📦 Dataset & Setup Quirk

The Excel file opens with **3 junk rows** (title, description, blank) before the real header,
so every read uses `pd.read_excel(..., skiprows=3)`. Columns: `Order_ID … Returned` (16).
The file's grain is **one row per order**, which makes any repeated `Order_ID` a true error —
the exact opposite of Superstore, where an Order ID legitimately repeats across order lines.

---

## 🧭 Progress: How This Was Completed

1. **Concept first.** Duplicates were classified into three levels before any code ran:
   full-row copies (errors), key repeats that are legitimate (order lines / repeat buyers),
   and key repeats that are errors (double-entered IDs).
2. **Pipeline ported to Excel input.** The Superstore CSV script was adapted to
   `.xlsx` — which surfaced a `ModuleNotFoundError: No module named 'openpyxl'`
   (pandas' Excel engine). Fixed with `pip install openpyxl`; script re-ran clean.
3. **Duplicates found & documented.** Full-row comparison flagged **3 exact double-entries:
   `ORD1022`, `ORD1043`, `ORD1090`** (each appearing twice, all fields identical) →
   150 rows → **147 unique orders**.
---

**Excel cross-check:** Conditional Formatting → Duplicate Values on `Order_ID`,
helper `=COUNTIF($A$2:$A2,$A2)` (>1 = repeat copy), and Data → Remove Duplicates
popup count — all three agreed with pandas.

---

## 📋 Deliverable 1 — Duplicate Report

| Check | Count | Verdict |
|---|---|---|
| Full-row duplicates (all 16 cols) | **3** (`ORD1022`, `ORD1043`, `ORD1090`) | ❌ Error — removed |
| `Order_ID` repeats | 3 (same records) | ❌ Confirms double-entry, not multi-line orders |
| Rows before → after | 150 → **147** | cleaned copy |

Report workbook sheets: `Duplicate_Summary` (checks + counts) · `Flagged_Duplicates`
(both copies of each pair, for eyeballing).

## 🧹 Deliverable 2 — Cleaned Copy: Issue Census & Decision Log

| Issue | Where (examples) | Action | Justification |
|---|---|---|---|
| Exact duplicate rows | ORD1022 / ORD1043 / ORD1090 | Removed (keep first) | Identical copies add no information |
| Encoded markers | City `Missing` (ORD1069, ORD1108…), Payment `Unknown` (ORD1054, ORD1092…), Discount `N/A` (ORD1075, ORD1117…) | Standardized → NaN | `isnull()` can't see text markers; honest null counts first |
| Comma-text prices | `Unit_Price`, `Total_Amount` | Strip commas → float | Type fix; values unchanged; SUMs now work |
| Blank money fields | ORD1068, ORD1086, ORD1005, ORD1120, ORD1030 | Reconstruct via Qty×Price×(1−Disc%) where possible | Arithmetic = evidence, not invention |
| Blank `Customer_Age` | ORD1050, ORD1073, ORD1097… | Median impute + `Customer_Age_WasMissing` flag | Outlier-safe; flag preserves the information |
| Blank categoricals | Gender, Product_Category, Returned | Fill `"Unknown"` | Honest category beats a silent mode |
| Blank `Customer_Rating` / `Delivery_Days` | ORD1063, ORD1101, ORD1085… | **Left null** | Optional feedback — imputing would fabricate opinions |

## 📝 Audit Note (kept with the deliverables)

> Duplicate detection ran at two levels on the 150-record file. Full-row comparison flagged
> three exact double-entries (ORD1022, ORD1043, ORD1090), removed to leave 147 unique orders;
> because the grain is one row per order, repeated Order IDs are errors here — unlike
> Superstore, where they are legitimate order lines. Encoded markers were standardized to
> true nulls *before* counting so null statistics are honest; comma-prices were type-fixed and
> totals recomputed arithmetically where siblings allowed. Remaining nulls follow a per-column
> policy — reconstruct, impute-with-flag, explicit "Unknown", or intentionally leave — and every
> removal and fill is logged. Nothing was dropped or filled silently.

---

## 📚 Lessons Learned
- **Duplicate ≠ error:** confirm the grain before deleting key repeats — the same `Order_ID`
  repeat is a bug in this file and a feature in Superstore.
- `duplicated(keep=False)` shows *both* copies — review before you remove.
- Encoded missing markers hide from `isnull()`; count blanks **and** markers.
- `openpyxl` is pandas' Excel engine — a `ModuleNotFoundError` is one `pip install` away.
- Excel's hidden `~$` lock files break `git add`; ignore them with `~$*` in `.gitignore`.
- **"Cleaned" ≠ "complete":** missing-value handling is a separate, justified decision layer.

## 📁 Folder Contents
```
day-13-duplicate-check/
├── README.md
├── duplicate_check.ipynb      # duplicate pipeline (this task)
├── deliverables/Day-13_Duplicate_and_Cleaning_Report.xlsx
├── deliverables/Customer_Orders_Cleaned.csv 
├── data/EDA_Practice_Customer_Orders_150.xlsx
└── docs/
```

## 🔁 How to Reproduce
1. `pip install pandas openpyxl`
2. `python duplicate_check.ipynb` → report workbook + cleaned CSVs
3. Excel cross-check: duplicate conditional formatting + `COUNTIF` occurrence column +
   Remove Duplicates popup — expect the same count of 3.

## 🔗 Series
[Day 12 – Missing Values](../day-12-missing-values/) ·

**Day 13 – Duplicate Check** 
· LinkedIn post: [link](https://lnkd.in/p/dnzX2qBJ)