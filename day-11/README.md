# 📊 Day 11 — Basic Data Sorting & Filtering: Five Questions, One Workbook

> 45-Day Data Analytics Internship · Level 1 · Day 11
> Tools: Excel (AutoFilter, Sort, SUBTOTAL) 
> Dataset: Sample Superstore — 9,994 order lines · 21 columns
> Theme: answer real business questions with nothing but sorts, filters and discipline

---

## Objective
Practice basic data exploration by sorting and filtering a dataset to answer targeted business questions and isolate the root causes of profit loss.

## Tools & Files
* **Tool:** Microsoft Excel
* **Dataset:** Superstore Sales Data
* **Working File:** Day-11_Superstore_SortFilter.xlsx

## Workflow & Deliverables
* **Data Preservation:** Maintained the integrity of the original dataset by keeping the `RawData` sheet strictly unchanged.
* **Exploratory Workspace:** Utilized a dedicated `Work` sheet to apply multi-layered conditional filters, combining categorical dimensions (Region, Sub-Category) with numerical thresholds (Profit, Discount).
* **Documented Findings:** Created an `Answers` sheet detailing 5 specific business queries, the exact filter criteria applied, the final numerical answers, and analytical explanations.

## Business Questions Addressed
1. **Region with the most loss lines?** 
   * **Result:** Central Region (741 loss-making lines).
2. **Loss $ at discount >= 40%?** 
   * **Result:** -$125,346 lost due to aggressive discounting.
3. **Loss-making Tables Lines?** 
   * **Result:** 203 individual transaction lines resulted in losses for the 'Tables' sub-category.
4. **Top sub-category by sales?** 
   * **Result:** 'Phones' ranked as the highest-grossing sub-category ($330,007).
5. **Deepest discount & outcome?** 
   * **Result:** A maximum discount of 80% was identified, which yielded 0 profitable transaction lines.

## Key Analytical Insights
* **Discounting Strategy Flaws:** The data demonstrates a direct correlation between heavy discounting and severe margin degradation. Discounts at or above 40% wipe out significant profit, and 80% discounts guarantee a 100% loss rate.
* **Problematic Inventory:** Despite strong top-line sales in categories like Phones, losses taken on bulky, highly discounted items like Tables in the Central region are severely dragging down net margins.

---

## 📁 Folder Contents
```
day-11-sort-filter/
├── README.md
├── Day-11_Superstore_SortFilter.xlsx       # RawData · Work · Answers
├── data/Sample - Superstore.csv            # input (9,994 order lines)
├── assets/                                 # screenshots
└── docs/Day_11_Internship_Report_.pdf      # report
```

## 🔁 How to Reproduce
1. Open the workbook (filters left active on `Work`), or rebuild:
   paste CSV → `Ctrl+T` → `Superstore` → copy to `Work` → add SUBTOTAL readouts →
   apply each question's filter stack → record answers → cross-check with COUNTIFS/SUMIFS →
   export visible rows to `View_*` tabs.
2. Change any filter on `Work` and watch the readout cells move — exploration is live.

## 🔗 Series
[Day 10 – KPI Tracker](../day-10/) ·


**Day 11 – Sorting & Filtering** · 
LinkedIn post: [link](https://lnkd.in/p/dxnEg394)
