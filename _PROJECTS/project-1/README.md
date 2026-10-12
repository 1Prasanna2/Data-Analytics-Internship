# OTT Streaming Content Trend Analysis — Netflix Catalogue

> **Project type:** Exploratory Data Analysis (EDA)  
> **Tools:** Python, Pandas, NumPy, Matplotlib, Seaborn, Squarify, Jupyter Notebook  
> **Current scope:** Netflix catalogue metadata only

## Project overview

This project explores a Netflix titles catalogue to understand its content mix, rating patterns, release-year trends, genre composition, production-country distribution, popularity signals, and certification-label coverage. The goal is to turn a raw catalogue dataset into evidence-backed findings and practical questions for a content strategy or acquisition team.

The analysis is exploratory. It identifies patterns and data-quality gaps in the available metadata; it does **not** measure Netflix viewing hours, completion rates, retention, licensing costs, acquisition availability, or return on investment.

## Objectives

- Profile catalogue size, format mix, release years, and data completeness.
- Inspect missing values and potential duplicate records or identifiers.
- Compare IMDb rating distributions for movies and shows.
- Explore genre mix and the distribution of titles across production countries.
- Examine associations between IMDb scores, TMDb scores, IMDb votes, and TMDb popularity.
- Review certification-label coverage and make the missing-data limitation visible.
- Convert findings into testable recommendations rather than unsupported business claims.

## Dataset snapshot

The current files contain:

| File | Rows | Purpose |
|---|---:|---|
| `titles.csv` | 5,850 | One row per catalogue title; includes format, release year, genres, production countries, certification, runtime, IMDb and TMDb fields. |
| `credits.csv` | 77,801 | Title-person credit records, including actors and directors; joined to titles using `id`. |

The titles snapshot contains **3,744 movies** and **2,106 shows**, with original release years from **1945 to 2022**. The `titles.id` field is unique in this snapshot.

### Important scope note

Although the project brief mentions Netflix, Prime Video, and Hotstar, this notebook currently analyses **Netflix data only**. Cross-platform comparisons should not be claimed unless comparable datasets from the other services are added and harmonized.

## Repository structure

The notebook currently reads the CSV files from `./data/titles.csv` and `./data/credits.csv`. Arrange the project folder like this:

```text
ott-content-trend-analysis/
├── README.md
├── assets/..
├── docs/ Project-1_INTERN_REPORT.pdf
├── deliverables
│   ├── OTT_Content_Strategy_Memo_Template.pdf
│   ├── SQL Files
│   └── EDA_Project_Netflix.ipynb
├── data/
    ├── titles.csv
    └── credits.csv
```

The notebook saves chart PNGs to its current working directory by default. Move them into `outputs/` or change the `savefig()` paths if you want to keep generated assets organized.

## Analysis workflow

1. **Load and inspect data** — read both CSVs and review columns, types, and sample records.
2. **Data-quality checks** — profile nulls, inspect duplicate titles/IDs, review missing IMDb identifiers, and check how well title records link to credits.
3. **Catalogue overview** — calculate title counts, movie/show mix, rating coverage, recent-release share, and selected director statistics.
4. **Genre and format analysis** — parse the multi-genre field and compare genre composition separately for movies and shows.
5. **Release-period analysis** — compare catalogue counts and IMDb scores by original release year or decade.
6. **Rating and popularity analysis** — examine rating distributions, box plots, score correlations, and title-level popularity patterns.
7. **Country analysis** — compare catalogue volume, median IMDb score, median IMDb votes, and show share by first-listed production country.
8. **Certification coverage** — compare available certification labels by format while retaining missing labels as a separate data-quality category.
9. **Interpretation** — describe what the dataset supports, document limitations, and identify follow-up tests for business decision-making.

## Visualizations included

The notebook creates or explores the following visuals:

- KPI cards for catalogue size, format mix, rating coverage, votes, recent releases, and director indicators.
- Treemaps comparing genre share within movies and shows.
- Release-year and decade trend charts.
- Average IMDb score by decade, with a minimum-vote filter and sample-size labels.
- IMDb score histogram and movie-versus-show box plot.
- Ranked top-genre bar chart.
- Country bubble chart for volume, rating, vote engagement, and show share.
- Distribution checks for raw and `log1p`-transformed IMDb votes and TMDb popularity.
- Spearman correlation heatmap using pairwise-complete observations.
- TMDb popularity versus IMDb score scatter plot.
- 100% stacked certification-mix chart showing all titles and certified-label records separately.

Generated chart filenames in the notebook include `treemap_genre_by_type.png`, `avg_rating_by_decade.png`, `trend_2_quality.png`, `bubble_country_quality_volume.png`, `hist_rating_distribution.png`, `top10_genres_by_type.png`, `boxplot_score_by_type.png`, `dist_check_skew.png`, `corr_heatmap_spearman.png`, `scatter_pop_vs_score.png`, and `cert_mix_100pct.png`.

## Selected findings from the current snapshot

These values are calculated from the current files and should be reproduced after running the notebook.

### 1. Shows have a higher median IMDb score in the filtered subset

For titles with at least **100 IMDb votes** and a non-missing IMDb score:

| Format | Qualifying titles | Median IMDb score |
|---|---:|---:|
| Movies | 3,142 | 6.40 |
| Shows | 1,760 | 7.10 |

The observed median difference is **0.70 points** in favour of shows. This is a descriptive result for the qualifying titles; it does not prove that shows lead to higher viewing, retention, revenue, or acquisition value.

### 2. Popularity and ratings are related, but are not interchangeable

Selected Spearman rank correlations from pairwise-complete records:

| Variables | Spearman ρ | Paired observations |
|---|---:|---:|
| IMDb score vs. TMDb score | 0.63 | 5,145 |
| IMDb score vs. TMDb popularity | 0.09 | 5,293 |
| IMDb votes vs. TMDb popularity | 0.65 | 5,279 |

The IMDb and TMDb scores have a moderate positive rank association in this sample. The association between IMDb score and TMDb popularity is weak, while IMDb votes and TMDb popularity have a stronger positive association. Correlation is not causation; TMDb popularity is not a direct measure of Netflix views.

### 3. Certification-label coverage is substantially lower for movies

| Format | Titles | Missing certification labels | Missing share |
|---|---:|---:|---:|
| Movies | 3,744 | 2,364 | 63.1% |
| Shows | 2,106 | 255 | 12.1% |
| **Total** | **5,850** | **2,619** | **44.8%** |

A missing label does **not** prove that a title is uncertified. It means the dataset does not contain a certification value for that record. Any crosswalk that groups MPA film ratings and TV ratings into common suitability bands is an analyst-defined approximation, not an official equivalence.

## Methodology and interpretation rules

- **Rating eligibility:** Rating-focused comparisons generally use titles with `imdb_votes >= 100` and a non-missing `imdb_score`. Check each chart's cell for its exact filter; not every exploratory chart necessarily uses the same subset.
- **Correlation:** The heatmap uses Spearman correlation. Pairwise-complete observations mean each variable pair can have a different sample size.
- **Popularity:** `tmdb_popularity` is a TMDb metric and must not be described as actual Netflix watch time, audience size, or ROI.
- **Release year:** `release_year` is the title's original release year, not the year Netflix acquired or added it to its catalogue. The latest observed release year is 2022, so the 2020s are incomplete in this snapshot.
- **Lead country:** The country bubble analysis uses the first-listed value in `production_countries` as a lead-country proxy. This is a consistent analytical rule, but not necessarily an official primary-country designation.
- **Genre counting:** A title can have multiple genres. Genre-level counts and percentages may overlap and therefore need not sum to 100% across genres.
- **Certification categories:** The movie and TV label systems differ. Any combined suitability bands must be documented as a custom crosswalk. Label missing data as **“Missing / no label in dataset”** rather than treating it as proof of uncertified status.
- **Director metrics:** Director statistics are descriptive of records and credits in these files; they are not a measure of commercial success or future performance.

## Setup and how to run

### 1. Create an environment

Python 3.10 or newer is recommended.

```bash
python -m venv .venv
```

Activate the environment:

**Windows (PowerShell)**

```powershell
.venv\Scripts\Activate.ps1
```

**macOS/Linux**

```bash
source .venv/bin/activate
```

### 2. Install dependencies

```bash
pip install pandas numpy matplotlib seaborn squarify jupyter ipykernel
```

### 3. Place the data files

Copy the supplied CSVs into a `data/` folder and ensure the filenames match the notebook paths:

```text
data/titles.csv
data/credits.csv
```

If you keep the CSVs somewhere else, update the two `pd.read_csv()` paths in the notebook.

### 4. Run the notebook

```bash
jupyter notebook data_processing.ipynb
```

In Jupyter, select **Kernel → Restart Kernel and Run All Cells**. Review warnings, confirm that each chart renders, and check the printed data-quality summaries. Before submission, re-run the final claims from the source data and document any intentional filter differences.

## Data integrity and reproducibility checklist

Before handing in the project:

- Confirm row counts and title-format counts against the CSV files.
- Check that `titles.id` is non-null and unique.
- Distinguish missing IMDb IDs from genuine duplicated IMDb IDs; null identifiers should not be counted as duplicate IDs.
- Record the filters and sample sizes used for each score or correlation claim.
- Recompute the memo figures from the notebook rather than typing numbers manually.
- Keep missing certification labels visible and use neutral terminology.
- Ensure charts are created by a clean, top-to-bottom notebook run.
- Keep the README's results synchronized with the exact dataset snapshot submitted.

## SQL component

The current notebook performs its main analysis in Python/Pandas. If the internship deliverable requires SQL queries for core aggregations, include the reviewed queries as a separate file such as `sql/core_aggregations.sql` and document the database/table assumptions. Do not describe SQL queries as executed against the dataset unless the SQL script or execution evidence is included in the submission.

## Business relevance and limitations

The results can help formulate hypotheses—for example, whether to investigate highly rated show genres or improve certification metadata coverage—but a catalogue metadata snapshot is not sufficient to make acquisition decisions on its own. Before recommending content investment, combine these findings with platform-specific viewing starts, completion rates, watch time, repeat engagement, audience segment, regional demand, licensing availability, and cost data.

This project demonstrates exploratory analysis and data storytelling. Recommendations should be framed as **observations → business hypotheses → validation tests**, with limitations stated explicitly.

## Deliverables

- EDA notebook with code, charts, and findings.
- Cleaned/validated source data references (`titles.csv`, `credits.csv`).
- Exported chart images for reporting, where required.
- Content strategy memo with three actionable insights, evidence, caveats, proposed actions, and success metrics.
- SQL companion file if required by the internship brief.

---

**Project:** OTT Streaming Content Trend Analysis  
**Dataset analysed in this version:** Netflix catalogue snapshot  
**Status:** Exploratory analysis; business recommendations require validation with platform performance and cost data.

LINKEDIN: [link](https://lnkd.in/p/dKY9EMGC)
