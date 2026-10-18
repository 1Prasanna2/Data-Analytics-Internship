# Key Insights — Did faster vaccination rollout blunt later‑wave deaths?

*A plain‑language read of the COVID‑19 catalog analysis. Written for a non‑technical
reader (a policy or comms lead, not a data scientist). Each insight names the figure or
cell that backs it, the action it implies, and — where relevant — what evidence would
overturn it.*

> **Angle.** We did not build a generic "cases vs deaths" dashboard. We asked one sharp
> question — *does how FAST a country vaccinated predict how HARD its later waves hit?* —
> and the insights below are ordered so the first two earn trust in the data, and the last
> three answer the question honestly (including where the data says "we can't tell yet").

---

## How to finalize this document before submission

Three insights (3, 4, 5) contain `[bracketed slots]`. These are **intentional**: the value
is emitted by a specific print in the notebook, and we will not type a number we have not
watched the pipeline produce. Fill each slot from the named output, then delete this block.
Insights 1 and 2 have **no slots** — they are already provable from the raw file.

| Slot | Fill from | Cited figure / file |
|---|---|---|
| `[LAG]` (infection→death lag, days) | Day‑2 print **[2b] lag‑direction diagnostic** — the `lag_days` row where `pearson_r` peaks | `notebooks/02_derived_metrics.ipynb` |
| `[n]` / `[rho]` (countries plotted / association strength) | Day‑3 **focused‑scatter** print (`plotted n=… of 7`, `Spearman rho = …`) | `assets/figures/focused_scatter_rollout_vs_death.png` |
| `[fast]` / `[slow]` (example countries + their days‑to‑50%) | Day‑2 print **[7] country table**, `days_10_to_50` column | `data/processed/country_rollout_vs_death.csv` |
| `[pre‑50 list]` / `[post‑50 list]` (peaks before vs after 50% vax) | compare each country's wave‑peak date (print **[4]**) against its `date_50pct` (print **[7]**) | same two prints |
| `[excess %]` global / `[per‑country %]` | Day‑2 print **[7]**, `excess_mort_coverage_%` column | `country_rollout_vs_death.csv` |
| `[cutoff]` (trimmed window end) | Day‑1 print **[3]** (`global cutoff …`) | `notebooks/01_data_insights.ipynb` |

---

## Insight 1 — The country comparisons are real countries, not the world wearing a flag
*(data credibility — no slots, fully provable)*

**In plain terms:** the raw dataset we downloaded has **429,435 rows**, but **34,124 of
them are not countries at all** — they are summary lines that Our World in Data adds for
the whole planet ("World"), for continents ("Africa", "Europe"), and for income groups
(e.g. `OWID_LIC`, `OWID_LMC`). We removed those, leaving **395,311 genuine country‑day
rows**. If we had left them in, every chart that says "per country" would have quietly
counted the entire world as one entry and let a continent's total tower over a real
nation's — making a small country look invisible next to "Asia."

**Why it matters for the question:** the focused scatter compares *countries* to each
other. That comparison is only fair if neither axis is secretly a continental aggregate.
Removing these rows is the first thing that makes "Israel vs India" a like‑for‑like read.

**Backed by:** `notebooks/01_data_insights.ipynb` (the `(~iso_code.str.startswith('OWID_'))`
count → 395,311) and `deliverables/ASSUMPTIONS.md` (assumption #1).

**Falsifier:** none needed — this is a structural fact of the file, verifiable by counting
rows whose `iso_code` begins with `OWID_`.

---

## Insight 2 — Missing values are not random gaps; they cluster by metric, so we handle
each metric on its own terms
*(data credibility — no slots on the case/death side, which is the load‑bearing claim)*

**In plain terms:** a naïve "delete every row with a blank" would have destroyed this
analysis, because the blanks are *not* scattered evenly. In the raw panel, the **case and
death columns are almost fully populated — roughly 410,000–411,000 of the 429,435 rows
carry a value** (visible in the column‑completeness report). By contrast, the
**excess‑mortality columns read as empty even in the early rows we sampled**, and the
vaccination series only begins late in 2020 and is patchier still. So a country can be
perfectly usable for a *cases* chart while being blank for a *vaccines* chart — and
throwing the whole row away because one column is empty would punish the columns that
*are* complete.

**Why it matters for the question:** our headline metrics (the lagged fatality rate, the
rollout‑speed number) each read *different* columns. We therefore filter **per metric**,
not per row: the fatality rate uses only titles/rows with enough case *and* death data;
the rollout speed uses only rows with a vaccination value. This is also why we never
difference the cumulative totals to get daily figures — totals get retroactively corrected,
which would inject fake spikes into a "daily" series. *(Note: the ≈410k completeness above
is measured on the full panel before the 34,124 aggregate rows were removed; the
country‑only completeness is marginally lower and is recomputed inside notebook 01.)*

**Backed by:** the `info()` column report in `notebooks/01_data_insights.ipynb`; the
rolling‑from‑`new_*` rule in `deliverables/ASSUMPTIONS.md`.

**Falsifier:** if a future refresh of the file shows the vaccination column as complete as
the case column, the per‑metric gating still holds (it would simply drop fewer rows) — the
*principle* is robust even as the specific counts move.

---

## Insight 3 — We compared deaths to the infections that *caused* them, three weeks
earlier — not to the infections reported the same day
*(the methodology headline — the single biggest reason this is not a tutorial dashboard)*

**In plain terms:** most public COVID dashboards plot new cases and new deaths on the same
calendar day and call the wobble between them a "trend." That is an artifact. A person who
catches the virus usually dies **about [LAG] days later**, so today's deaths are the
consequence of infections from *[LAG] days ago*, not of today's case count. Aligning them
day‑for‑day mostly measures *testing volume*, not the disease. We shifted the death series
back by [LAG] days before drawing any conclusion, and we *checked the shift direction*
empirically (the correlation between deaths and cases peaks at a [LAG]‑day gap, not at
zero — if it had peaked at zero, our alignment would have been backwards).

**Why it matters for the question:** the whole point — "did vaccinating faster reduce
later deaths?" — is a *timing* question. You cannot answer a timing question with a
same‑day comparison; the lag alignment is what makes the focused scatter meaningful at
all. Without it, a country that tested heavily one week would look like it was dying less
the same week, for entirely spurious reasons.

**Backed by:** Day‑2 print **[2b] lag‑direction diagnostic** (the row where `pearson_r`
peaks sets `[LAG]`); the lagged‑vs‑naive CFR panels on the *CFR & Waves* dashboard page
(`assets/dashboard/page-3-visual.png`).

**Falsifier:** if the diagnostic peak lands at 0 days, the shift sign is wrong — fix before
publishing, do not word around it. If it lands at, say, 14 or 28 days, that is a *finding*
(the true interval for this country set differs from the textbook 21), and `[LAG]` should
be set to the empirical peak and noted in `ASSUMPTIONS.md`.

---

## Insight 4 — Among the countries that reached half‑adult vaccination, the faster ones
*tended* to see milder later waves — but with only a handful of points, that is a
hypothesis to test, not a verdict
*(the focused answer, sized honestly)*

**In plain terms:** of the **[n]** countries in our set that actually crossed 50% of adults
fully vaccinated inside the study window, those that got there faster tended to record
**[lower / higher / no clear pattern in]** their worst later‑wave daily death rate (the
rank correlation is **[rho]** across **[n]** countries). On the scatter, "faster" sits on
the right and "fewer later deaths" sits on the bottom, so a down‑to‑the‑right tilt is what
"speed helped" would look like. But there are only [n] dots, and two things travel
*alongside* speed that we did not (and cannot) fully separate: **older populations** and
**thinner hospital systems** tend to be the slow‑vaccinating ones *and* the high‑death
ones. We therefore plot each country's median age as the dot's *size* and its continent as
its *colour*, so a reader can see whether an apparent "speed effect" is really a
demographics effect in disguise. Example anchors: **[fast]** reached 50% in fewest days;
**[slow]** took longest.

**Why it matters for the question:** this is the answer the brief asked for, delivered at
the strength the data supports. The honest version — "associated, n=[n], confounded by age
and capacity" — is *more* useful to a decision‑maker than a confident "vaccination caused
fewer deaths," because the confident version would be wrong about *why*, and you cannot
set a budget on a wrong "why."

**Backed by:** `assets/figures/focused_scatter_rollout_vs_death.png`; Day‑3 scatter print
(`rho`, `n`); Day‑2 print **[7]** (`days_10_to_50`, `peak_deaths_pm_post50`, `median_age`,
`hosp_beds_k`); the *The Answer* dashboard page (`assets/dashboard/page-1-visual.png`).

**Falsifier:** if `|rho|` is small or the cloud is a diffuse blob, write "no clear
pattern," not a forced story — the non‑finding is the senior answer. If the only
bottom‑right (fast + low‑death) dot is also the youngest, highest‑capacity country, the
"effect" is demographics, not speed; say so.

---

## Insight 5 — For several countries the heaviest later deaths arrived *before* half the
adults were vaccinated — and the more robust death measure we hoped to cross‑check with is
not available for this group
*(timing vs level, plus an honest scope limit)*

**In plain terms:** two things temper Insight 4. First, **timing beats pace** for some
places: in **[pre‑50 list]** the worst later‑wave death peak came *before* the country even
reached 50% fully vaccinated, so for those nations the "how fast did you get to 50%?" lever
barely applies to that wave — what mattered was how quickly the *first* doses arrived, not
the sprint to the halfway mark. In **[post‑50 list]**, by contrast, the peak sat after the
50% line, so pace plausibly mattered. (This is exactly what the dotted 50%‑vaccination line
on every panel of the small‑multiples chart shows, country by country.) Second, we wanted
to re‑run the whole comparison using **excess mortality** — a death measure that sidesteps
inconsistent cause‑of‑death reporting — as a robustness check. We could not: excess‑mortality
reporting covers only about **[excess %]** of rows globally and **[per‑country %]** for our
seven countries, so the check would rest on two or three nations and over‑claim. We report
on *reported* deaths and flag the gap, rather than estimate a "robust" result on a stub.

**Why it matters for the question:** it stops the reader from over‑reading Insight 4. A
country whose peak preceded its 50% mark is *not* evidence that speed failed — it is
evidence that speed was never the operative variable for that wave. And disclosing the
missing robustness check is what makes the rest of the findings credible: we show the
limit instead of hiding it.

**Backed by:** small‑multiples panel (`assets/figures/` + the *Trends* page
`assets/dashboard/page-2-visual.png`, dotted 50% line per country); Day‑2 print **[4]**
(wave‑peak dates) vs **[7]** (`date_50pct`); the `excess_mort_coverage_%` column in
`country_rollout_vs_death.csv`.

**Falsifier:** if a later file refresh lifts excess‑mortality coverage to ≥~5 of the 7
countries, *then* run the robustness re‑scatter and strengthen Insight 4 — but only then,
and name which countries it covers. Until then, the limitation stands.

---

## What we did *not* claim (scope guard — keep this line in the exec summary too)

- **Association, not causation.** With n≈[n] and age + hospital capacity co‑varying with
  rollout speed, the scatter supports a hypothesis, not a verdict.
- **Reported ≠ internal reality.** Case, death, and vaccination figures are third‑party
  reported metadata; they are not the platform's or a health system's own
  infection/degree/completion telemetry. Any greenlight or policy move implied here must be
  validated against that internal data first.
- **The right edge is censored.** The study window ends **[cutoff]**, ~14 days before the
  file's latest date, because the most recent days are under‑reported; a "decline" there is
  a reporting artifact, not a trend.
- **n is small and honest.** Six of seven countries appear on the scatter; South Africa is
  correctly absent (no 50%‑vax crossing or no post‑50% death data in window). We did not
  pad it back in.

*Reproducible from `notebooks/01 → 02 → 03` in run order; the per‑country scalars behind
Insights 3–5 are emitted by `02_derived_metrics.ipynb` into
`data/processed/country_rollout_vs_death.csv`. Assumptions and parameters (LAG, TAIL, ROLL,
the aggregate exclusion, the calendar reindex) live in `deliverables/ASSUMPTIONS.md`.*