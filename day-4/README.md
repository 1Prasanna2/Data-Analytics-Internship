# 📊 Day 4 — Visual Story: "Where Is Superstore's Profit Leaking?"

> 45-Day Data Analytics Internship · Level 1 · Day 4
> Series: Day 1 (Cleaning) → Day 2 (EDA) → Day 3 (Dashboard) → **Day 4 (Visual Story)**

## 🎯 Task Brief
Create meaningful visualizations that communicate trends, patterns, and business
insights from a structured dataset — turning a set of charts into a clear
narrative aimed at one specific business question.

## ❓ The Central Question
**Why does Superstore's profit lag so far behind its sales — and which
decisions are causing the leak?**

Every page below exists only to answer this question. Nothing else made the cut.

## 📖 The Narrative Arc (5 pages)

| # | Story role | Visual | One-sentence takeaway |
|---|-----------|--------|----------------------|
| 1 | **Context** | KPI cards: Total Sales, Total Profit, Profit Margin %, Loss-making line % | Superstore generates ≈ $2.3M in sales but keeps only ≈ 12.5% as profit — and about 1 in 5 order lines sells at a loss. |
| 2 | **Problem** | Diverging bar: Profit by Sub-Category (green = profit, red = loss) | The losses are not spread evenly: Tables, Bookcases and Machines sell below cost while the rest of the catalogue carries the business. |
| 3 | **Evidence 1** | Combo chart: Profit margin % and loss-line % by discount band | Discounting is the switch — beyond a 40% discount the average order line loses money. |
| 4 | **Evidence 2** | Heat matrix: Category × Discount band (cell = profit margin %) | Furniture turns red at the shallowest discounts, while Technology stays profitable far deeper into discounting. |
| 5 | **Recommendation** | Waterfall: current profit → recovered loss dollars → potential profit, + 3 action bullets | Capping discounts at 40% — 30% for Furniture — recovers most loss dollars without touching a single profitable order. |

## 🔍 Key Insights Carried Into the Story
- ≈ 20% of order lines are loss-making; they concentrate in a few sub-categories.
- Deep discounts (≥ 40%) flip margin negative — discount policy, not demand, is the leak.
- Furniture's ≈ 10% margin is roughly half of Technology's and Office Supplies'.
- The fix is a policy change, not a sales push: recover loss dollars without new volume.

## 🎨 Storytelling & Design Rules Applied
- **One question, one story** — every chart earns its place or was deleted.
- **Arc order:** context → problem → evidence → recommendation.
- **Action titles:** each page title *is* its one-sentence takeaway (skimmable in 30s/page).
- **Clutter removed:** no gridlines, no chart borders, no 3D, no unnecessary legends; direct data labels instead.
- **Consistent colour contract:** blue = sales, green = profit, red = loss, orange = discount — identical on every page.
- **Stable layout grid:** same margins, fonts and footer (page number + source note) throughout.

## 📁 Folder Contents
```
day-4-visual-story/
├── README.md
├── docs/Superstore_Discount_Trap_Report.pdf         # ✅ submitted deliverable (5 pages)
├── Data_Visualizaton_Storytelling.pbix              # editable source (Power BI)
├── assets/                                         # per-page chart exports
│   ├── page-1.png
│   ├── page-2.png
│   ├── page-3.png
│   ├── page-4.png
│   └── page-5.png

```

## 🛠 Tools
Power BI (story pages + export to PDF) · Pandas (validation of figures) ·
Git & GitHub (versioning & submission)

## 🔁 Data Lineage & Reproducibility
- Source: `day-4/data/data/Sample - Superstore.csv` (9,994 rows after cleaning).
- Figures cross-checked against Day 2 EDA notebooks and Day 3 dashboard measures.
- Open `Data_Visualizaton_Storytelling.pbix` to inspect or modify any page;
  re-export via **File → Export → Export to PDF**.

## ✅ Deliverables Checklist
- [x] 4–6 page visual story (5 pages) — PDF submitted
- [x] One clear narrative arc (context → problem → evidence → recommendation)
- [x] Every visual paired with a one-sentence takeaway
- [x] Chart clutter removed (no gridlines / legends / 3D)
- [x] Source file (.pbix) included for review

## 📝 Lessons Learned
- Charts answer questions; **stories change decisions** — page order matters more than chart type.
- Action titles beat descriptive titles: a skimming stakeholder still gets the full argument.
- Constraints create clarity: one question, five pages, one colour contract.
- Removing ink (gridlines, borders, legends) made the message louder, not quieter.

## 🔗 Series
[Day 3 – Dashboard](../day-3/) ·
**Day 4 – Visual Story** ·
LinkedIn post: [LinkedIN](https://tinyurl.com/4z6z5etx)