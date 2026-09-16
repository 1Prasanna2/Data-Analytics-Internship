## What the Numbers Reveal About Skew and Spread

-------

| Metric | Sepal Length | Sepal Width | Petal Length | Petal Width |
|:-------|-------------:|-------------:|-------------:|------------:|
| **Mean**   | 5.84 | 3.05 | 3.76 | 1.20 |
| **Median** | 5.80 | 3.00 | 4.35 | 1.30 |
| **Mode**   | 5.00 | 3.00 | 1.40 | 0.20 |
| **Std Dev**| 0.83 | 0.43 | 1.76 | 0.76 |
| **Q1 → Q3**| 5.10 → 6.40 | 2.80 → 3.30 | 1.60 → 5.10 | 0.30 → 1.80 |
| **IQR**    | 1.30 | 0.50 | 3.50 | 1.50 |

---

- **Skew (mean vs median)**. *Comparing the mean and median of each column exposes the shape of its distribution. The sepal measurements are nearly symmetric: sepal length averages 5.84 cm against a median of **5.80 cm**, and sepal width **3.05 vs 3.00** — the mean sits only barely above the median, indicating a faint right tail where a few unusually large sepals nudge the average up. The petal measurements show the opposite signature: petal length's mean **(3.76 cm)** falls well below its median (4.35 cm), and petal width repeats the pattern **(1.20 vs 1.30)**. A mean below the median is the classic mark of left-skew — a dense cluster of small values (Iris-setosa's tiny petals) drags the average down while the median stays anchored among the larger species.*

- **Spread (std dev + percentiles)**.*A standard deviation only means something next to its mean. Sepal width is the most stable feature in the dataset (std 0.43 cm, ≈14% of its mean) and sepal length similar (0.83 cm, ≈14%) — most flowers sit within about one standard deviation of the average. The petal measures vary far more: petal length's std of **1.76 cm is ≈47%** of its mean and petal width's **0.76 cm ≈63%**, the widest relative spread of the four. The percentiles confirm it: the middle 50% of petal length spans **1.60–5.10 cm (IQR = 3.50)**, a band almost as wide as the feature's entire mean, while sepal width's middle 50% occupies a tight 2.80–3.30 cm window **(IQR = 0.50)**.*

- **What it means together**. *The modes sharpen the story: petal length's most common value (1.40 cm) and petal width's **(0.20 cm)** sit at the extreme low end — exactly where setosa clusters. Left-skew + a huge IQR + a mode at the small end together signal that the petal columns are not one smooth bell curve but stacked clusters, one per species. In short: sepal features are consistent and near-symmetric; petal features are highly variable, left-skewed and multimodal — which is precisely why petal size, not sepal size, separates the three species.*
