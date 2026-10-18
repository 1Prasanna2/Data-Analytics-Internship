# Did faster vaccination rollout blunt later‑wave deaths?

*A focused, method‑first analysis of the COVID‑19 catalog — Python (Pandas/Matplotlib/Seaborn)
for the pipeline, Power BI. Built around one sharp
question rather than a generic "cases vs deaths" dashboard.*

> **The angle.** Most public COVID dashboards plot new cases and new deaths on the same
> calendar day and call the wobble a trend. That is an artifact: a person usually dies
> **weeks** after infection, so a same‑day comparison mostly tracks *testing volume*, not the
> disease. This project aligns each death to the infections that caused it, normalizes
> everything per‑million so a country of 9 M isn't compared unfairly to one of 1.4 B, and then
> asks the one question an acquisition or policy team can actually act on — *does how FAST a
> nation vaccinated predict how HARD its later waves hit?*

---

## The answer, in one breath (scoped honestly)

Among the **[n]** countries in our seven‑nation set that reached 50% of adults fully
vaccinated inside the study window, the faster rollouts *tended* to pair with milder later
waves — but the relationship is loose (rank correlation **[rho]**, n = **[n]**) and older
populations plus thinner hospital systems tend to be the slow‑vaccinating, high‑death ones
too. The honest read is an **association worth testing**, not a verdict; the full evidence,
the confounders plotted on the same chart, and the falsifiers live in
[`deliverables/insights.md`](deliverables/insights.md), and the one‑page decision view in
[`deliverables/executive_summary.pdf`](deliverables/executive_summary.pdf).

*(Why the headline is a question and not a conclusion: with a handful of points and two
confounders co‑moving with speed, a confident "vaccination caused fewer deaths" would be
wrong about *why* — and you cannot set a budget on a wrong "why." See the scope guard below.)*

---

## Why you can trust the method (the traps we handled, before any result)

These five are the difference between this and a tutorial clone; each is documented with its
parameter in [`deliverables/ASSUMPTIONS.md`](deliverables/ASSUMPTIONS.md).

1. **Real countries only.** The raw panel has **429,435 rows**, but **34,124** of them are
   *not* countries — they are Our World in Data's summary lines for the whole planet, the
   continents, and income blocs (`OWID_WRL`, `OWID_AFR`, `OWID_LMC`, …). We removed them,
   leaving **395,311 genuine country‑day rows**, so "per country" never secretly counts the
   world as one entry.
2. **Deaths lagged to their cause.** Each death is aligned to infections **~[LAG] days
   earlier**, and the shift *direction* is verified empirically (the death↔case correlation
   peaks at a [LAG]‑day gap, not at zero — if it had peaked at zero, the alignment was
   backwards). This is the single reason the focused question is meaningful at all.
3. **Rolling means from `new_*`, never diffs of totals.** Cumulative totals get retroactively
   backfilled, so `diff(total_cases)` injects fake spikes; we roll the clean daily columns
   (and their per‑million forms) instead.
4. **Calendar‑safe index.** OWID has genuine reporting gaps (a country that reported nothing
   on a date has *no row* that day), so a 7‑day roll or a 21‑day shift on a gappy index moves
   by *rows*, not *days*. We reindex every country to a continuous daily calendar before any
   window or lag, making "21 rows" equal "21 days" by construction.
5. **Censored right edge trimmed.** The most recent ~14 days of every metric are
   under‑reported, so a 7‑day mean over them reads as a fake "decline"; we drop that tail
   (window ends **[cutoff]**) and say so on every chart.

Plus the fairness the brief demands: all cross‑country comparisons are **per‑million /
per‑100**, and the focused scatter puts **median age** and **continent** on the same plot
(as dot size and colour) so demographics can't hide inside the trend.

---

## Repository layout (INPUT → CODE → OUTPUT → STORY)

```
covid-rollout-impact/
├── README.md                  ← you are here (the index + the question)
├── data/
│   ├── raw/owid-covid-data.csv        ← the ONLY true source (429,435 × 67)
│   └── processed/                     ← generated intermediates (tiny, committed)
│       ├── covid_clean.parquet        ← notebook 01 output (calendar‑safe, rolled, normalized)
│       ├── covid_derived.parquet      ← notebook 02 output (lag, CFR, doubling, waves)
│       ├── covid_tidy_long.parquet    ← melted long form for BI metric‑switchers
│       ├── country_rollout_vs_death.csv  ← per‑country scalars (the scatter's inputs)
│       └── dash_fact.csv / dash_country.csv / dash_tidy_long.csv  ← dashboard sources
│
├── notebooks/                 ← CODE, numbered = run order = reproducibility
│   ├── 01_data_insights.ipynb         ← load, profile, OWID_ exclusion, subset, roll, normalize
│   ├── 02_derived_metrics.ipynb       ← the 21‑day lag, lagged vs naive CFR, doubling time, waves, rollout speed
│   └── 03_signature_chart.ipynb       ← the focused scatter + small multiples (reads 02's outputs)
│
├── dashboard/                 ← the interactive product (two equivalent front‑ends)
│   ├── covid.pbix                     ← Power BI report (Pages: The Answer / Trends / CFR & Waves)
│   └── README.md                      ← how to open + the slicer×page contract + the data model
│
├── assets/
│   ├── figures/                       ← static charts the notebooks emit (the scatter PNG, etc.)
│   └── dashboard/                     ← screenshots of the three interactive pages
│
└── deliverables/              ← STORY = the four graded artifacts
    ├── executive_summary.pdf          ← 1‑page decision view (the brief's deliverable 4)
    ├── insights.md                    ← 3–5 plain‑language insights (deliverable 2)
    └── ASSUMPTIONS.md                 ← cleaned‑dataset documentation (deliverable 1's other half)
```

The **cleaned dataset** itself (deliverable 1) is `data/processed/covid_clean.parquet`,
documented by `deliverables/ASSUMPTIONS.md`; the **interactive dashboard** (deliverable 3) is
`dashboard/` (the `.pbix` and/or `app.py`), evidenced by `assets/dashboard/`.

---


## Deliverables mapped to the brief

| Brief deliverable | Where it lives |
|---|---|
| Cleaned dataset + documented assumptions | `data/processed/covid_clean.parquet` + `deliverables/ASSUMPTIONS.md` |
| 3–5 key insights, plain language | `deliverables/insights.md` |
| Interactive dashboard (Power BI / Tableau) **or** notebook with charts | `dashboard/` (`.pbix` + `app.py`) and `notebooks/03_signature_chart.ipynb`; screenshots in `assets/dashboard/` |
| 1‑page executive summary PDF | `deliverables/executive_summary.pdf` |

---

## Data & assumptions (the file‑level facts, no slots)

The panel is **429,435 country‑day rows × 67 columns** spanning the pandemic's start through
2024 (exact min/max printed by `describe()` in notebook 01). After removing the **34,124**
non‑country aggregate rows we keep **395,311** real rows; the seven‑nation study set is
**11,726** rows. Case/death columns are nearly complete (`new_cases` 410,159 and
`new_deaths` 410,608 non‑null), which is why we gate *per metric* rather than dropping whole
rows — a country can be usable for a cases chart while blank for a vaccines chart. The
excess‑mortality columns are **96.88% null** (13,411 non‑null), so the robustness cross‑check
we hoped for is unavailable for most of the set and is disclosed, not estimated on a stub
(see `insights.md`, Insight 5). Full parameter list (`LAG`, `TAIL`, `ROLL`, the reindex
rationale, the aggregate exclusion) is in `deliverables/ASSUMPTIONS.md`.

**Raw‑file size decision:** `owid-covid-data.csv` is the full extract (tens of MB). If it is
≤ ~30 MB, commit it under `data/raw/` so `Restart & Run All` works on a fresh clone; if it is
larger, gitignore it and rely on the `curl` line above (the tiny `data/processed/` outputs are
always committed so the dashboard and notebook 03 can run without the raw file).

---

## What this cannot tell you (scope guard — keep this in any downstream use)

- **Association, not causation.** Six‑odd points, with age and health‑system capacity
  co‑moving with rollout speed. The scatter supports a hypothesis, never a verdict.
- **Reported ≠ internal reality.** Case, death and vaccination figures are third‑party
  reported metadata — not a health system's own infection, degree, or completion telemetry.
  Any policy or budget move implied here must be validated against that internal data first.
- **The right edge is censored.** The window ends **[cutoff]** (~14 days before the file's
  latest date); a "decline" there is a reporting artifact, not a trend.
- **n is small and honest.** One or more of the seven countries drop off the scatter for
  lacking a 50%‑vax crossing or post‑50% death data in window (the exact `n` and the dropped
  name(s) come from notebook 03's print — expected to include South Africa, whose full‑vax
  coverage stayed under 50%). We do not pad them back in.

---

## Reproducibility

Run order `01 → 02 → 03`; the per‑country scalars behind the focused question are emitted by
`02_derived_metrics.ipynb` into `data/processed/country_rollout_vs_death.csv`. The committed
state is the **Restart & Run All**‑clean notebook set at commit **`[hash]`** — every figure in
`assets/` and every number in `deliverables/` is reproducible from these cells with no manual
steps.

---

LINKEDIN: [link](https://lnkd.in/p/d4DcmNzr)