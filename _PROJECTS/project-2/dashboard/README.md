# Dashboard — Did faster vaccination rollout blunt later‑wave deaths?

Interactive delivery layer for the COVID‑19 rollout‑impact analysis. Two equivalent
front‑ends over the **same** derived data: a Power BI report (`.pbix`). 
Both read the calendar‑safe frame produced by the notebooks — never the
raw OWID extract — so the 21‑day infection→death lag is day‑aligned, not row‑aligned.

- The landing view is the **focused scatter**, not a world map. A per‑million map encodes
- neither the question nor the confounders; the scatter encodes both. This is deliberate.

---

## Open it in 60 seconds

### Power BI (`.pbix`)
1. Double‑click `covid.pbix` (or Power BI Desktop → *File → Open report*).
2. If the source CSVs moved, refresh the links: *Home → Transform data → Edit queries* →
   for each of `dim_country`, `fact_daily` (and `fact_tidy` if present) point the source to
   `../data/processed/dash_*.csv`, then *Close & Apply*.
3. Interact: use the **country slicer** on every page; use the **date‑range slicer** on
   *Trends* and *CFR & Waves* (it intentionally does **not** move the scatter — see contract).

---

## What each page shows

| Tab / page | Title on the visual | Purpose |
|---|---|---|
| **The Answer** | *Did faster vaccination rollout blunt later‑wave deaths?* | Focused scatter: x = days 10%→50% fully vax (reversed, faster→right), y = peak deaths/million after 50%, size = median age, colour = continent. The whole question in one plot. |
| **Trends** | *Compare countries at a glance — cases, deaths & vaccination per million* | 7‑day smoothed time series; this is where the date‑range slicer earns the brief's "compare at a glance." |
| **CFR & Waves** | *Aligning deaths to infections ~21 days earlier changes the fatality story* | Lagged vs naive 28‑d CFR (small multiples per country) + a table of documented wave peaks only. The project's thesis, made interactive. |

---

## The slicer contract (read this before "fixing" the date slicer)

| Page | Visual source | Country slicer | Date‑range slicer | Why it behaves this way |
|---|---|---|---|---|
| The Answer | `dim_country` only | ✅ highlights a dot | ❌ **omitted by design** | axes are full‑period per‑country scalars; `dim_country` has no date column |
| Trends | `fact_daily` (or `fact_tidy`) | ✅ filters lines | ✅ Between on `date` | fact‑grain, varies by day |
| CFR & Waves | `fact_daily` | ✅ | ✅ Between on `date` | fact‑grain |

**The rule that makes this fall out for free:** the model is a *many‑to‑one* relationship
with **Single** cross‑filter, so filters flow *downhill* from the "one" side
(`dim_country`) to the "many" side (`fact_daily`), never uphill. A `fact_daily[date]`
slicer therefore **cannot** reach the scatter on `dim_country` — it is inert there *by
construction*, not by bug. If the scatter ever jumps when you drag the date slider, your
cross‑filter slipped to **Both**; set it back to Single.

---

## The data model (so the grain is auditable)

- **Tables:** `dim_country` (1 row / `iso_code`, from `dash_country.csv`) · `fact_daily`
  (1 row / `iso_code` × `date`, from `dash_fact.csv`) · optional `fact_tidy`
  (1 row / `iso_code` × `date` × `metric`, from `dash_tidy_long.csv`).
- **Relationship:** `fact_daily[iso_code]` (*many*) → `dim_country[iso_code]` (one),
  cross‑filter **Single**. (Add the identical `fact_tidy → dim_country` link if loaded.)
- **Scatter grain:** X / Y / Size are each set to **Don't summarize**, and the **Values**
  well is left **empty** — together these force *one dot per country*. Two same‑colour dots
  (e.g. two Asia, two Europe) are the proof the grain is per‑country, not per‑continent.
- **Honest n:** the scatter shows **6 of 7** countries. South Africa is correctly absent —
  it has no finite 10%→50% crossing *or* no post‑50% death data in the trimmed window.
  This is a data fact, not a loading error; do not pad it back in.

---

*Reproducible from the notebooks in run order `01 → 02 → 03`; the derived inputs this
dashboard reads are emitted by `02_derived_metrics.ipynb`. Commit hash of the
Restart‑&‑Run‑All‑clean state: `<paste after final run>`.* 
