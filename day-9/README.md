# 📊 Day 9 — Descriptive Statistics Primer: Skew & Spread in the Iris Dataset

> 45-Day Data Analytics Internship · Level 1 · Day 9
> Tools: Python (pandas) ·
> Dataset: Iris — 150 flowers · 3 species · 4 numeric measurements

---

## 🎯 Task

Calculate and interpret **mean, median, mode, standard deviation and percentiles** for the
dataset's key numeric columns, and build intuition for *when* to use each statistic and
*what* it reveals about a distribution.

**Deliverables (as assigned):**
- Summary statistics table for 3–5 columns ✅ (all 4 numeric columns)
- Short write-up on what the numbers reveal about **skew** and **spread** ✅

**Hints followed:**
- ✅ Mean vs median compared to spot skew
- ✅ Standard deviation always reported alongside the mean (and as % of mean)
- ✅ Percentiles checked to describe the middle 50% (IQR)

---

## 📦 Dataset

| Property | Value |
|---|---|
| Source | `data/iris_dataset.csv` |
| Rows | 150 (50 per species — balanced) |
| Numeric columns | sepal length (cm), sepal width (cm), petal length (cm), petal width (cm) |
| Categorical | target: Iris-setosa, Iris-versicolor, Iris-virginica |

---

## 🧮 Method

**Python (pandas)** — `day-9-task-file.ipynb`:

```python
import pandas as pd

df = pd.read_csv('iris_dataset.csv')
num_cols = ['sepal length (cm)', 'sepal width (cm)', 'petal length (cm)', 'petal width (cm)']

stats = pd.DataFrame({
    'Mean':   df[num_cols].mean(),
    'Median': df[num_cols].median(),
    'Mode':   df[num_cols].mode().iloc[0],
    'Std Dev':df[num_cols].std(),
    'Min':    df[num_cols].min(),
    'Q1':     df[num_cols].quantile(0.25),
    'Q3':     df[num_cols].quantile(0.75),
    'Max':    df[num_cols].max(),
    'IQR':    df[num_cols].quantile(0.75) - df[num_cols].quantile(0.25),
})
print(stats.round(2))
```
---

## 📋 1 — Summary Statistics Table

| Metric | Sepal Length | Sepal Width | Petal Length | Petal Width |
|:-------|-------------:|-------------:|-------------:|------------:|
| **Mean**   | 5.84 | 3.05 | 3.76 | 1.20 |
| **Median** | 5.80 | 3.00 | 4.35 | 1.30 |
| **Mode**   | 5.00 | 3.00 | 1.40 | 0.20 |
| **Std Dev**| 0.83 | 0.43 | 1.76 | 0.76 |
| **Std ÷ Mean** | ~14% | ~14% | ~47% | ~63% |
| **Min**    | 4.30 | 2.00 | 1.00 | 0.10 |
| **Q1 (25th)** | 5.10 | 2.80 | 1.60 | 0.30 |
| **Q3 (75th)** | 6.40 | 3.30 | 5.10 | 1.80 |
| **Max**    | 7.90 | 4.40 | 6.90 | 2.50 |
| **IQR**    | 1.30 | 0.50 | 3.50 | 1.50 |

### What each statistic revealed

| Statistic | Finding |
|---|---|
| **Mean vs Median** | Sepals: mean ≈ median → near-symmetric (faint right tail in sepal length). Petals: mean **below** median (3.76 vs 4.35; 1.20 vs 1.30) → **left-skew** from a dense cluster of small values. |
| **Median** | The "typical" flower sits in the versicolor/virginica range for petals — the median ignores the 50 tiny setosa petals that distort the mean. |
| **Mode** | Petal modes (1.40 cm, 0.20 cm) sit at the extreme low end = the exact size of *Iris-setosa* petals → **cluster detector** exposing hidden subgroups. |
| **Std Dev (+ % of mean)** | Sepal width most stable (0.43, ~14% of mean); petal width most variable (0.76, ~63% of mean) — relative spread ranks the features' discriminating power. |
| **Percentiles / IQR** | Middle 50% of petal length spans 1.60–5.10 cm (IQR 3.50 — huge), while sepal width's middle 50% occupies just 2.80–3.30 cm (IQR 0.50 — tight). |

---

## 📝 2 — Write-Up: What the Numbers Reveal About Skew & Spread

**Skew (mean vs median).** The sepal measurements behave almost symmetrically: sepal length
averages 5.84 cm against a median of 5.80 cm, and sepal width 3.05 vs 3.00 — gaps small enough
to call both roughly symmetric, with only a faint right tail in sepal length. The petal
measurements tell a different story: petal length's mean (3.76 cm) sits well **below** its
median (4.35 cm), and petal width repeats the pattern (1.20 vs 1.30). A mean below the median
is the classic signature of **left-skew** — a dense cluster of small values drags the average
down while the median stays anchored among the larger species.

**Spread (std dev + percentiles).** A standard deviation only means something next to its mean.
Sepal width is the most stable feature (0.43 cm, ≈14% of its mean) and sepal length similar
(0.83 cm, ≈14%). The petal measures vary far more: petal length's 1.76 cm is ≈47% of its mean
and petal width's 0.76 cm ≈63% — the widest relative spread of the four. The percentiles
confirm it: the middle 50% of petal length spans 1.60–5.10 cm (IQR = 3.50), a band almost as
wide as the feature's entire mean, while sepal width's middle 50% occupies a tight
2.80–3.30 cm window (IQR = 0.50).

**The hidden story — multimodality.** The modes sharpen the picture: petal length's most
common value (1.40 cm) and petal width's (0.20 cm) sit at the extreme low end — exactly where
*Iris-setosa* clusters. Left-skew + huge IQR + a mode at the small end together signal that the
petal columns are not one smooth bell curve but **stacked clusters, one per species**. Summary
statistics can flag that; only grouping by species (as in the Day-7 charts) can prove it.

> **Takeaway:** sepal features are consistent and near-symmetric; petal features are highly
> variable, left-skewed and multimodal — which is precisely why petal size, not sepal size,
> separates the three species.

---

## 📚 Lessons Learned — When to Use Each Statistic

| Statistic | Use it when… | Watch out for… |
|---|---|---|
| Mean | Symmetric data, no extreme outliers | Pulled by skew/outliers — always pair with median |
| Median | Skewed data or outliers present | Ignores the magnitude of extremes |
| Mode | Categorical/binned data, cluster detection | Weak on raw continuous values (but great subgroup clue here) |
| Std Dev | Spread around the mean | **Never report alone** — quote it with the mean (or as % of mean) |
| Percentiles / IQR | Outlier-robust spread, "middle 50%" | Hides the shape inside the box — pair with a chart |

---

## 📁 Folder Contents
```
day-9-descriptive-statistics/
├── README.md
├── day-9-task-file.ipynb        # pandas script generating the stats table
├── write_up.md                 # polished skew & spread write-up 
├── data/iris_dataset.csv       # input (150 rows)
└── assets/..                   # file screenshots
```

## 🔁 How to Reproduce
1. `python descriptive_stats.py` → prints the rounded summary table, or
2. Excel: paste data → run the formulas above, or Data → Data Analysis → Descriptive Statistics.
3. Compare against `write_up.md` — every claim traces to a cell in the table.

## 🔗 Series
[Day 8 – Sheets Sales Tracker](../day-8-sales-tracker/) ·

**Day 9 – Descriptive Statistics** · 
LinkedIn post: [link](https://lnkd.in/p/dZPm8MU6) 
