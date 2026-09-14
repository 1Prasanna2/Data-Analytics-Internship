# 📊 Day 7 — First Chart Story: Turning Numbers into Narrative

> 45-Day Data Analytics Internship · Level 1 · Day 7
> Tool: Microsoft Excel · Dataset: Iris (150 flowers, 3 species, 4 measurements)
> Theme: pick the right basic chart for the question — then let the charts tell one story

---

## 🎯 Task

Take a small dataset and build **3–4 simple charts (bar, line, pie)** that each answer a
specific question, then tie them together into a single narrative.

**Deliverables (as assigned):**
- 3–4 labelled charts, each with a **one-line takeaway**
- A **short paragraph** tying the charts together into one narrative

**Hints followed:**
- ✅ Chart type matched to the *question*, not personal preference
- ✅ Every chart has labelled axes + a descriptive title (pie: % labels instead of axes)
- ✅ Pie chart kept to **3 slices** (≤ 5-slice rule)

---

## 📦 Dataset

| Property | Value |
|---|---|
| Source | `iris_dataset.csv` |
| Size | 150 rows (50 per species — perfectly balanced) |
| Features | sepal length (cm), sepal width (cm), petal length (cm), petal width (cm) |
| Target | species: Iris-setosa, Iris-versicolor, Iris-virginica |
| Key constraint | **No time column** — so no chart here pretends to show a trend over time |

---

## 🗂 Solution: One Workbook, Four Sheets (`Day-7_Iris_Chart_Story.xlsx`)

| Sheet | Purpose |
|---|---|
| `Data` | Untouched Iris source — Excel Table `Iris`, frozen header |
| `Summary` | Species-level aggregates via `COUNTIFS` / `AVERAGEIFS` + transposed profile table (charts read aggregates, never 150 raw rows) |
| `Charts` | The four labelled charts in a 2×2 grid, each with a one-line takeaway text box |
| `Story` | **Deliverable 2:** the narrative paragraph + chart-type rationale table |

---

## 📈 The Four Charts: Question → Type → Why → Takeaway

| # | Question it answers | Chart type | Why this type | One-line takeaway |
|---|---|---|---|---|
| 1 | How is the sample split across species? | **Pie** (3 slices) | Part-of-whole share; ≤ 5-slice rule satisfied | Each species supplies exactly 50 flowers (33%), so no species can skew the comparisons. |
| 2 | Which species has the biggest petals? | **Clustered column** | Comparing magnitudes across discrete groups | Setosa's petals (~1.5 cm) are less than half of versicolor's (~4.3 cm) and a third of virginica's (~5.6 cm) — the cleanest split in the data. |
| 3 | Which measurements separate the species? | **Line with markers** (profile plot) | Compares the *shape* of 3 series across an ordered measurement axis | The species lines separate widely on petal measures but nearly overlap on sepal width — petals carry the identifying signal. |
| 4 | Does sepal width follow the same pattern? | **Clustered bar** (horizontal) | Side-by-side of two metrics per group; long labels read easier horizontally | The twist: setosa — smallest petals — has the widest sepals (~3.4 cm), so sepal width alone would misidentify it. |

> **Chart-type note (documented in-workbook):** Iris has no dates, so the line chart is used as a
> *profile plot* (ordered measurements on the x-axis) — the standard non-time exception for lines.
> A clustered-column fallback was kept in the notes in case a reviewer insists "line = time only".

---

## 📝 The Narrative (Deliverable 2 — `Story` sheet)

> Read together, the four charts tell one story about how to identify an iris. The pie chart
> first confirms the evidence base is fair: 150 flowers split evenly, 50 per species, so no
> species can dominate the averages. The petal-size column chart then reveals the cleanest
> split in the data — setosa's petals average ~1.5 cm against ~4.3 cm (versicolor) and ~5.6 cm
> (virginica), a gap wide enough that petal length alone nearly identifies the species. The
> profile line chart generalises the point: the three species trace clearly separated lines
> across petal length and width but converge on sepal width, meaning sepal width carries little
> identifying signal. The final bar chart shows why that convergence matters: setosa, the
> species with the smallest petals, actually has the *widest* sepals (~3.4 cm), so a rule based
> on sepal width alone would point at the wrong flower. The conclusion ties the story together:
> **petal measurements are the reliable identifiers in this dataset, and any classification
> rule should weight them above sepal width.**

---

## ✅ Verified Numbers (live from the Summary sheet)

| Species | Count | Sepal Length | Sepal Width | Petal Length | Petal Width |
|---|---|---|---|---|---|
| Iris-setosa | 50 | 5.01 | **3.43** | 1.46 | 0.25 |
| Iris-versicolor | 50 | 5.94 | 2.77 | 4.26 | 1.33 |
| Iris-virginica | 50 | 6.59 | 2.97 | 5.55 | 2.03 |

*(All values in cm, species averages — the exact figures behind every chart.)*

---

## 🎨 Labelling & Clutter Rules Applied
- Descriptive titles on all four charts (never "Chart 1")
- Axis titles on charts 2–4; percentage data labels on the pie (no axes needed)
- One-line takeaway text box under every chart
- 2-D only; vertical gridlines removed on column/bar charts; legends only where series > 1
- Default theme colours kept so species colours stay consistent across charts 3 & 4

## 📚 Lessons Learned
- **The type follows the question:** pie = part-of-whole (≤ 5 slices), column/bar = magnitude
  comparison, line = shape/profile across an ordered axis. My first instinct (pie for petal
  comparison) was wrong — and knowing *why* was the actual skill.
- **Charts should read aggregates, not raw rows** — a small `AVERAGEIFS` summary table makes
  every chart stable and auditable.
- Excel quirks that cost time: forgetting the header row in a Ctrl-select gives "Series1/Series2"
  legends; a flipped line chart needs **Chart Design → Switch Row/Column**.
- Reading the four takeaways in order tells the whole story without the charts — that's what
  "turning numbers into narrative" means.

---

## 📁 Folder Contents
```
day-7-iris-chart-story/
├── README.md
├── Day-7_Iris_Chart_Story.xlsx     # Data · Summary · Charts · Story sheets
├── data/iris_dataset.csv           # input (150 rows)
├── assets/..                         # chart screenshots 
└── docs/docs/Day-7-Internship-Report.pdf     # reflection post drafted same day
```

## 🔁 How to Reproduce
1. Open `Day-7_Iris_Chart_Story.xlsx` (or rebuild: import CSV → Table `Iris` → Summary tables
   with `COUNTIFS`/`AVERAGEIFS` → insert the 4 charts from the ranges in the table above →
   label → add takeaways → paste narrative on `Story`).
2. Change any Summary formula and every chart updates — the story is formula-driven, not pasted.

## 🔗 Series
[Day 6 – Excel Formulas](../day-6/) ·

**Day 7 – Iris Chart Story** ·

LinkedIn post: [LinkedIN](https://lnkd.in/p/dRa9bT_q)
