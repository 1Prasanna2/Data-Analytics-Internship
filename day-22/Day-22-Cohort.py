# 1. IMPORTS
import sys

print("RUNNING WITH:", sys.executable)
from pathlib import Path
import duckdb 

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# 2. CONFIGURATION

FILE_PATH = Path("data/online_retail_II.csv")  

CUSTOMER_COL = "Customer ID"  
DATE_COL = "InvoiceDate"  
QUANTITY_COL = "Quantity"  
PRICE_COL = "Price"  

OUTPUT_TABLE = "deliverables/cohort_retention_table.csv"
OUTPUT_HEATMAP = "deliverables/cohort_retention_heatmap.png"
OUTPUT_INSIGHTS = "deliverables/cohort_retention_insights.md"


# 3. LOAD
if not FILE_PATH.exists():
    raise FileNotFoundError(f"Dataset not found: {FILE_PATH.resolve()}")

df = pd.read_csv(FILE_PATH, low_memory=False)

print("Shape:", df.shape)


# 4. INSPECT REQUIRED COLUMNS
required_columns = [CUSTOMER_COL, DATE_COL, QUANTITY_COL, PRICE_COL]

missing_columns = [col for col in required_columns if col not in df.columns]

if missing_columns:
    raise ValueError(f"Required columns missing: {missing_columns}")

print("\nColumns:")
print(df.columns.tolist())


# 5. PARSE DATE
df[DATE_COL] = pd.to_datetime(df[DATE_COL], errors="coerce")

invalid_dates = df[DATE_COL].isna().sum()

if invalid_dates > 0:
    raise ValueError(f"{invalid_dates} InvoiceDate values could not be parsed.")


# 6. CLEAN
valid = df.loc[
    df[CUSTOMER_COL].notna() & (df[QUANTITY_COL] >= 0) & (df[PRICE_COL] >= 0)
].copy()

valid["customer_id"] = valid[CUSTOMER_COL].astype(int).astype(str)

print("\nValid rows:", len(valid))
print("Unique customers:", valid["customer_id"].nunique())


# 7. ACTIVITY MONTH
valid["activity_month"] = valid[DATE_COL].dt.to_period("M").dt.to_timestamp()

# 8. LOCAL SQL ENGINE   (DuckDB, in-memory)
connection = duckdb.connect()  

# Only load columns SQL actually needs.
sql_source = valid[["customer_id", "activity_month"]].copy()

# NOTE: activity_month is kept as a native pandas datetime64 (TIMESTAMP).
# DuckDB binds DataFrames directly and understands datetime64, so the old
# ".dt.strftime('%Y-%m-%d')" text conversion is removed.
connection.register(
    "transactions_raw", sql_source
)

# 9. SQL COHORT AGGREGATION   (DuckDB dialect)
sql_query = """
WITH
clean_activity AS (
    SELECT DISTINCT
        customer_id,
        date_trunc('month', activity_month) AS activity_month   -- ← duckdb (was date(...,'start of month'))
    FROM transactions_raw
),

first_purchase AS (
    SELECT
        customer_id,
        MIN(activity_month) AS cohort_month
    FROM clean_activity
    GROUP BY customer_id
),

cohort AS (
    SELECT
        customer_id,
        cohort_month
    FROM first_purchase
),

activity AS (
    SELECT DISTINCT
        a.customer_id,
        c.cohort_month,
        a.activity_month
    FROM clean_activity a
    JOIN cohort c
        ON a.customer_id = c.customer_id
),

period_index AS (
    SELECT
        customer_id,
        cohort_month,
        activity_month,

        (
            year(activity_month) * 12            -- ← duckdb (was CAST(strftime('%Y',...) AS INT))
            + month(activity_month)              -- ← duckdb (was CAST(strftime('%m',...) AS INT))
        )
        -
        (
            year(cohort_month) * 12              -- ← duckdb
            + month(cohort_month)                -- ← duckdb
        )
        AS period_index

    FROM activity
),

counts AS (
    SELECT
        cohort_month,
        period_index,
        COUNT(DISTINCT customer_id) AS active_customers
    FROM period_index
    GROUP BY
        cohort_month,
        period_index
),

retention AS (
    SELECT
        cohort_month,
        period_index,
        active_customers,

        MAX(
            CASE
                WHEN period_index = 0
                THEN active_customers
            END
        ) OVER (
            PARTITION BY cohort_month
        ) AS cohort_size

    FROM counts
)

SELECT
    cohort_month,
    period_index,
    active_customers,
    cohort_size,
    1.0 * active_customers / cohort_size AS retention
FROM retention
ORDER BY
    cohort_month,
    period_index;
"""

retention_long = connection.execute(
    sql_query
).df()  # ← duckdb (was pd.read_sql_query(...))

# 10. CLEAN SQL OUTPUT TYPES

retention_long["cohort_month"] = pd.to_datetime(retention_long["cohort_month"])

print("\nSQL retention rows:", len(retention_long))
print(retention_long.head())


# 11. PIVOT TO COHORT MATRIX

cohort_table = retention_long.pivot_table(
    index="cohort_month", columns="period_index", values="retention"
).sort_index()

# Ensure all expected month columns exist.
max_period = int(retention_long["period_index"].max())

expected_periods = list(range(max_period + 1))

cohort_table = cohort_table.reindex(columns=expected_periods)


# 12. PANDAS CROSS-CHECK   (db-independent — unchanged)


activity_check = valid[["customer_id", "activity_month"]].drop_duplicates().copy()

cohort_map = (
    activity_check.groupby("customer_id")["activity_month"].min().rename("cohort_month")
)

activity_check = activity_check.join(cohort_map, on="customer_id")

activity_check["period_index"] = (
    activity_check["activity_month"].dt.year * 12
    + activity_check["activity_month"].dt.month
) - (
    activity_check["cohort_month"].dt.year * 12
    + activity_check["cohort_month"].dt.month
)

pandas_counts = (
    activity_check.groupby(["cohort_month", "period_index"])["customer_id"]
    .nunique()
    .reset_index(name="active_customers")
)

pandas_cohort_size = (
    activity_check.groupby("cohort_month")["customer_id"]
    .nunique()
    .reset_index(name="cohort_size")
)

pandas_long = pandas_counts.merge(pandas_cohort_size, on="cohort_month")

pandas_long["retention"] = pandas_long["active_customers"] / pandas_long["cohort_size"]

pandas_long = pandas_long.sort_values(["cohort_month", "period_index"]).reset_index(
    drop=True
)

sql_sorted = retention_long.sort_values(["cohort_month", "period_index"]).reset_index(
    drop=True
)

max_difference = np.max(
    np.abs(pandas_long["retention"].to_numpy() - sql_sorted["retention"].to_numpy())
)

print("\nMaximum SQL/Pandas retention difference:", max_difference)

if max_difference != 0:
    raise ValueError("SQL and pandas cohort calculations do not agree.")


# 13. VALIDATE M0   (unchanged)


m0 = cohort_table[0].dropna()

if not np.allclose(m0, 1.0):
    raise ValueError("M0 validation failed: not every cohort has 100% retention.")

print("M0 validation passed:", len(m0), "cohorts at 100%")


# 14. SAVE COHORT TABLE   


cohort_table.to_csv(OUTPUT_TABLE)


# 15. HEATMAP  


# Scale to percent so each annotation is short ("35", not "35.3%") -> no overlap
plot_matrix = cohort_table * 100

plt.figure(figsize=(20, 12))  
sns.heatmap(
    plot_matrix,
    mask=plot_matrix.isna(),  
    annot=True,
    fmt=".0f",  
    annot_kws={"size": 7},  
    cmap="YlGnBu",
    cbar_kws={"label": "Retention (%)"},
    linewidths=0.4,
    linecolor="white",  
    yticklabels=cohort_table.index.strftime(
        "%Y-%m"
    ),  
    xticklabels=cohort_table.columns,  
)

plt.title("Cohort Retention Heatmap\nCohort = First Valid Purchase Month", fontsize=14)
plt.xlabel("Months Since First Purchase", fontsize=11)
plt.ylabel("Cohort Month", fontsize=11)
plt.xticks(rotation=0)
plt.yticks(rotation=0)

plt.tight_layout()
plt.savefig(OUTPUT_HEATMAP, dpi=200, bbox_inches="tight")
plt.show()

# 17. INSIGHTS

mature = cohort_table.dropna(subset=[1, 3, 6])

m1_avg = mature[1].mean()
m3_avg = mature[3].mean()
m6_avg = mature[6].mean()

m1_high = mature[1].idxmax()
m1_low = mature[1].idxmin()

m3_high = mature[3].idxmax()
m3_low = mature[3].idxmin()

m6_high = mature[6].idxmax()
m6_low = mature[6].idxmin()

print("\nAverage retention:")
print("M1:", f"{m1_avg:.2%}")
print("M3:", f"{m3_avg:.2%}")
print("M6:", f"{m6_avg:.2%}")

print("\nStrongest M1 cohort:", m1_high)
print("Weakest M1 cohort:", m1_low)

print("\nStrongest M3 cohort:", m3_high)
print("Weakest M3 cohort:", m3_low)

print("\nStrongest M6 cohort:", m6_high)
print("Weakest M6 cohort:", m6_low)


# 17. SAVE INSIGHTS   (unchanged)


insights_text = f"""
# Cohort Retention Insights

- All {len(m0)} observable cohorts have 100% retention at M0.
- Among the {len(mature)} cohorts observable through M6, average M1 retention is {m1_avg:.2%}.
- Among the same cohorts, average M3 retention is {m3_avg:.2%}.
- Among the same cohorts, average M6 retention is {m6_avg:.2%}.
- Retention is non-monotonic in this transactional dataset; customers can return after skipping months.
- The cohort heatmap must be interpreted with right-censoring in mind because newer cohorts have fewer observable periods.
- Cohort month is a first-valid-purchase proxy for signup because the source contains no signup date.
"""

Path(OUTPUT_INSIGHTS).write_text(insights_text, encoding="utf-8")

print("\nOutputs saved:")
print(OUTPUT_TABLE)
print(OUTPUT_HEATMAP)
print(OUTPUT_INSIGHTS)

connection.close()
