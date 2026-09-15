 
# 📊 Day 8 — Sales Tracker in Google Sheets

> 45-Day Data Analytics Internship · Level 1 · Day 8
> Tool: Google Sheets — named ranges, ARRAYFORMULA, SUMIFS date-rollups, data validation
> Dataset: Retail Sales — 1,000 transactions (2023)
> Live deliverable:[Sheet_Link](https://docs.google.com/spreadsheets/d/1RO6Myu8aEOsJ8z3dTFJn-PbSsdDo_sWY4Ul7ye3tKfs/edit?usp=sharing) 
---

## 🎯 Task

Build a **lightweight sales tracker** that auto-calculates **daily / weekly / monthly totals**
from raw entries — structured for *ongoing* data entry, not a one-off analysis.

**Deliverables (as assigned):**
- A tracker template with formulas for daily/weekly/monthly totals
- Sample data entered, with totals **verified against a manual check**

**Hints followed:**
- ✅ Raw entry tab kept separate from the summary tab
- ✅ `SUMIFS` with **date ranges** for weekly/monthly rollups
- ✅ **Data validation** on entry columns to prevent bad data at the door

---

## 📦 Dataset

| Property | Value |
|---|---|
| Source | `retail_sales_dataset.csv` |
| Size | 1,000 transactions (IDs 1–1000) |
| Grain | one row = one transaction |
| Columns | Transaction ID · Date · Customer ID · Gender · Age · Product Category · Quantity · Price per Unit · Total Amount |
| Categories | Beauty · Clothing · Electronics |
| Period | Jan–Dec 2023 — **plus one stray 2024-01-01 entry (ID 650)** that the tracker automatically surfaced |

---

## 🗂 Solution: A Three-Tab Tracker

| Tab | Role | Contents |
|---|---|---|
| `RawEntries` | Data entry only — never summarized here | 1,000 rows + 2 helper columns (`Week Start`, `Month`) via ARRAYFORMULA; frozen header; 5 named ranges; data validation on entry columns |
| `Lists` | Dropdown sources | Categories (Beauty/Clothing/Electronics), Genders (Male/Female) |
| `Summary` | Auto-aggregation dashboard | KPI cards · Daily · Weekly · Monthly rollups · Category breakdown · manual-verification block |

### Architecture decisions
- **Entry ≠ summary:** raw rows stay untouched; all math lives on `Summary` (hint #1).
- **Named ranges** (`EntryDates`, `EntrySales`, `EntryCategory`, `EntryWeek`, `EntryMonth`) so every formula reads like a sentence.
- **Helper columns, not repeated math:** `Week Start` (Monday-based) and `Month` key computed once per row with ARRAYFORMULA.
- **SUMIFS with date ranges** (`">="&start`, `"<"&start+7` / `EDATE` month bounds) for weekly & monthly rollups (hint #2).
- **ARRAYFORMULA + SORT/UNIQUE/FILTER** so rollup tables **auto-expand** as new dates appear — the "ongoing entry" requirement.
- **Data validation with "Reject input"** on Date, Category, Gender, Quantity and Price (hint #3).

---

## 🧮 Formula Reference

**Named ranges (with buffer rows for future entry):**
`EntryDates = RawEntries!$B$2:$B$1002` · `EntrySales = RawEntries!$I$2:$I$1002` ·
`EntryCategory = RawEntries!$F$2:$F$1002` · `EntryWeek = RawEntries!$J$2:$J$1002` ·
`EntryMonth = RawEntries!$K$2:$K$1002`

**Helpers (RawEntries):**
```
J2  =ARRAYFORMULA(IF(B2:B="","",B2:B-WEEKDAY(B2:B,2)+1))   // Monday of that week
K2  =ARRAYFORMULA(IF(B2:B="","",TEXT(B2:B,"YYYY-MM")))     // month key "2023-11"
```

**Summary — KPIs:**
```
=SUM(EntrySales)                      // Grand Total Sales
=COUNTA(EntryDates)                   // Total Transactions
=AVERAGE(EntrySales)                  // Avg Order Value
=SUMIFS(EntrySales,EntryDates,D3)     // Pick-a-Date card (input in D3)
```

**Summary — rollups (date-range SUMIFS):**
```
Daily   list: =SORT(UNIQUE(FILTER(EntryDates,EntryDates<>"")))
Daily   sum : =ARRAYFORMULA(IF(A7:A="","",SUMIFS(EntrySales,EntryDates,A7:A)))
Weekly  list: =SORT(UNIQUE(FILTER(EntryWeek,EntryWeek<>"")))
Weekly  sum : =ARRAYFORMULA(IF(F7:F="","",SUMIFS(EntrySales,EntryDates,">="&F7:F,EntryDates,"<"&F7:F+7)))
Monthly list: =SORT(UNIQUE(FILTER(EntryMonth,EntryMonth<>"")))
Monthly sum : =ARRAYFORMULA(IF(K7:K="","",SUMIFS(EntrySales,EntryDates,">="&DATEVALUE(K7:K&"-01"),EntryDates,"<"&EDATE(DATEVALUE(K7:K&"-01"),1))))
Category sum: =SUMIFS(EntrySales,EntryCategory,P7)
```

---

## 🔒 Data Validation Rules (garbage-in prevention)

| Column | Rule | On invalid |
|---|---|---|
| Product Category | Dropdown from `Lists!$A$2:$A$4` | Reject input |
| Quantity | Whole number ≥ 1 | Reject input |
| Price per Unit | Number ≥ 0 | Reject input |

---

## ✅ Manual Verification (Deliverable 2)

| Check | Method | Result |
|---|---|---|
| Grand total vs raw column | `=IF(SUM(EntrySales)=SUM(RawEntries!I2:I1002),"✅ MATCH","❌ ERROR")` | ✅ MATCH |
| Monthly rollups = grand total | `=IF(SUM(L7:L)=SUM(EntrySales),"✅ MATCH","❌ ERROR")` | ✅ MATCH |
| Weekly rollups = grand total | same pattern on weekly column | ✅ MATCH |
| Daily rollups = grand total | same pattern on daily column | ✅ MATCH |
| Spot dates | 3 dates hand-added from the CSV vs `SUMIFS` | ✅ equal |
| Category total | `SUMIFS(…,"Clothing")` vs filtered CSV sum | ✅ equal |
| **Stray-entry catch** | Monthly rollup shows `2024-01` = 1 txn / $30 (ID 650) inside a 2023 dataset | 🚩 flagged to data owner |

---

## 📤 Save · Share · Protect Workflow
- Renamed `Day-8_SalesTracker_RetailSales`; confirmed "All changes saved in Drive" (Sheets auto-saves).
- **Exports:** `.xlsx` (repo + portal) and PDF of the Summary tab.
- **Sharing:** file-level link, *Anyone with the link → Viewer*; parent folder kept **Restricted** (per-item sharing = only this sheet is exposed); verified via incognito test.
- **Protection:** Summary tab protected; helper columns J:K protected from edits.

## 📸 Assets (screenshots for repo/LinkedIn)
`raw_entries.png` · `validation_dropdown.png` · `validation_reject.png` ·
`summary_kpis.png` · `rollups_verified.png` · `formula_view.png` (Ctrl+`) · optional `pickadate.gif`

---

## 💡 What the Tracker Revealed
- The rollups reconcile to the cent across daily + weekly + monthly views — the date-range SUMIFS logic is sound.
- The **stray 2024-01-01 transaction** appeared automatically in the monthly rollup: live aggregation doubles as data-quality monitoring.
- Validation rejects (text in Quantity, free-typed categories) prove the tracker survives real, messy humans.

## 📚 Lessons Learned
- Separate entry from aggregation or the sheet dies on day two of real use.
- `SUMIFS` date criteria must be concatenated (`">="&date`); month bounds via `DATEVALUE` + `EDATE`.
- In Google Sheets "saving" is automatic — the real skills are **naming, versioning, exporting and sharing safely**.
- Hidden tabs are *not* private; share the file, never the folder.

---

## 📁 Folder Contents
```
day-8-sales-tracker/
├── README.md
├── data/retail_sales_dataset.csv          # input (1,000 transactions)
├── Day-8_SalesTracker_RetailSales.xlsx    # exported copy of the sheet
├── assets/assets/Day-8-SpreadSheet-Assets.pdf           # screenshots + GIF listed above
└── docs/Internship Report_ Day-8 Sales Tracker.pdf      # internship report for day-8
```

## 🔁 How to Reproduce
1. New Sheet → paste CSV into `RawEntries` → add helper columns J/K → define the 5 named ranges.
2. Build `Lists` tab → apply the 5 validation rules.
3. Build `Summary`: KPIs → daily → weekly → monthly → category → verification block (formulas above).
4. Protect Summary + helpers → name version → export `.xlsx`/PDF → make blank template copy → share Viewer link.

## 🔗 Series
[Day 7 – Iris Chart Story](../day-7-iris-chart-story/) · 

**Day 8 – Google Sheets Sales Tracker** ·
LinkedIn post: [link](https://lnkd.in/p/duyyqFhE)