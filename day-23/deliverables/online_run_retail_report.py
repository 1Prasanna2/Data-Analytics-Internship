import duckdb
import pandas as pd
import traceback
from pathlib import Path
from html import escape

FILE = "data/online_retail_II.csv"

con = duckdb.connect()

# ---------------------------------------------------------
# SETUP
# ---------------------------------------------------------

con.execute(f"""
CREATE OR REPLACE TEMP VIEW r AS
SELECT *,
       TRY_CAST("InvoiceDate" AS TIMESTAMP) AS ts
FROM read_csv_auto('{FILE}', header=true);
""")

con.execute("""
CREATE OR REPLACE TEMP VIEW tx AS
SELECT *
FROM r
WHERE "Customer ID" IS NOT NULL
  AND ts IS NOT NULL
  AND "Quantity" > 0
  AND "Price" > 0;
""")

con.execute("""
CREATE OR REPLACE TEMP VIEW ret AS
SELECT *
FROM r
WHERE "Quantity" < 0
   OR starts_with("Invoice", 'C');
""")

# ---------------------------------------------------------
# GUARD
# ---------------------------------------------------------

GUARD = (
    "0 · DATA GUARD",
    """
SELECT count(*) FILTER (WHERE ts IS NULL) AS bad_dates,
       count(*) AS total_rows,
       (SELECT count(*) FROM tx) AS sales_lines,
       (SELECT count(*) FROM ret) AS return_lines,
       any_value("InvoiceDate") AS sample_date
FROM r;
""",
)

# ---------------------------------------------------------
# QUERIES
# ---------------------------------------------------------

QUERIES = [
    (
        "1 · Revenue / orders / AOV / customers",
        """
SELECT count(DISTINCT "Invoice") AS orders,
       count(*) AS sales_lines,
       round(sum("Quantity"*"Price"), 2) AS revenue,
       round(
           sum("Quantity"*"Price")
           / count(DISTINCT "Invoice"),
           2
       ) AS avg_order_value,
       count(DISTINCT "Customer ID") AS customers
FROM tx;
""",
    ),
    (
        "2 · Top 10 countries by revenue",
        """
SELECT "Country",
       round(sum("Quantity"*"Price"), 2) AS revenue,
       count(DISTINCT "Invoice") AS orders
FROM tx
GROUP BY 1
ORDER BY revenue DESC
LIMIT 10;
""",
    ),
    (
        "3 · Monthly revenue + month-over-month %",
        """
WITH m AS (
    SELECT date_trunc('month', ts) AS mo,
           sum("Quantity"*"Price") AS rev
    FROM tx
    GROUP BY 1
)
SELECT mo,
       round(rev,2) AS revenue,
       round(
           100.0 *
           (rev - lag(rev) OVER (ORDER BY mo))
           / nullif(lag(rev) OVER (ORDER BY mo),0),
           1
       ) AS mom_pct
FROM m
ORDER BY mo;
""",
    ),
    (
        "4 · Top 10 stock codes by revenue",
        """
SELECT "StockCode",
       any_value("Description") AS product,
       round(sum("Quantity"*"Price"),2) AS revenue,
       sum("Quantity") AS units
FROM tx
GROUP BY 1
ORDER BY revenue DESC
LIMIT 10;
""",
    ),
    (
        "5 · Revenue share of top 1% / top 10% customers",
        """
WITH c AS (
    SELECT "Customer ID",
           sum("Quantity"*"Price") AS rev
    FROM tx
    GROUP BY 1
),
t AS (
    SELECT rev,
           ntile(100) OVER (ORDER BY rev DESC) AS pct
    FROM c
)
SELECT
    round(
        100.0 *
        sum(rev) FILTER (WHERE pct <= 1)
        / (SELECT sum(rev) FROM c),
        1
    ) AS top1pct_share,

    round(
        100.0 *
        sum(rev) FILTER (WHERE pct <= 10)
        / (SELECT sum(rev) FROM c),
        1
    ) AS top10pct_share
FROM t;
""",
    ),
    (
        "6 · Return value and return rate vs sales",
        """
SELECT
    (
        SELECT round(sum("Quantity"*"Price"),2)
        FROM tx
    ) AS sales,

    (
        SELECT round(-sum("Quantity"*"Price"),2)
        FROM ret
        WHERE "Quantity" < 0
    ) AS returned_value,

    round(
        100.0 *
        (
            SELECT -sum("Quantity"*"Price")
            FROM ret
            WHERE "Quantity" < 0
        )
        /
        (
            SELECT sum("Quantity"*"Price")
            FROM tx
        ),
        2
    ) AS return_rate_pct;
""",
    ),
    (
        "7 · Basket size: mean / median / p90 order value",
        """
WITH b AS (
    SELECT "Invoice",
           sum("Quantity") AS units,
           sum("Quantity"*"Price") AS val
    FROM tx
    GROUP BY 1
)
SELECT
    round(avg(units),2) AS avg_units,
    round(avg(val),2) AS avg_order_value,
    round(median(val),2) AS median_order_value,
    round(quantile_cont(val,0.9),2) AS p90_order_value,
    round(max(val),2) AS max_order_value
FROM b;
""",
    ),
    (
        "8 · Repeat-purchase rate",
        """
WITH c AS (
    SELECT "Customer ID",
           count(DISTINCT "Invoice") AS inv
    FROM tx
    GROUP BY 1
)
SELECT
    count(*) AS total_customers,
    count(*) FILTER (WHERE inv > 1) AS repeat_customers,
    round(
        100.0 *
        count(*) FILTER (WHERE inv > 1)
        / count(*),
        1
    ) AS repeat_rate_pct,
    round(avg(inv),2) AS avg_orders_per_customer
FROM c;
""",
    ),
    (
        "9 · Top 20 customers by lifetime revenue",
        """
SELECT
    "Customer ID",
    round(sum("Quantity"*"Price"),2) AS lifetime_revenue,
    count(DISTINCT "Invoice") AS orders
FROM tx
GROUP BY 1
ORDER BY lifetime_revenue DESC
LIMIT 20;
""",
    ),
    (
        "10 · Revenue by weekday",
        """
SELECT
    dayname(ts) AS weekday,
    round(sum("Quantity"*"Price"),2) AS revenue,
    count(DISTINCT "Invoice") AS orders
FROM tx
GROUP BY 1
ORDER BY revenue DESC;
""",
    ),
    (
        "11 · Top 10 most-returned stock codes",
        """
SELECT
    "StockCode",
    any_value("Description") AS product,
    sum(-"Quantity") AS units_returned,
    round(sum(-"Quantity"*"Price"),2) AS return_value
FROM ret
WHERE "Quantity" < 0
GROUP BY 1
ORDER BY return_value DESC
LIMIT 10;
""",
    ),
    (
        "12 · RFM segmentation (5-tile scores)",
        """
WITH ref AS (
    SELECT max(ts) AS latest
    FROM tx
),
c AS (
    SELECT
        "Customer ID",
        datediff(
            'day',
            max(ts),
            (SELECT latest FROM ref)
        ) AS recency_days,
        count(DISTINCT "Invoice") AS frequency,
        sum("Quantity"*"Price") AS monetary
    FROM tx
    GROUP BY 1
),
s AS (
    SELECT *,
           ntile(5) OVER (
               ORDER BY recency_days DESC
           ) AS r5,
           ntile(5) OVER (
               ORDER BY frequency
           ) AS f5,
           ntile(5) OVER (
               ORDER BY monetary
           ) AS m5
    FROM c
)
SELECT
    r5,
    f5,
    m5,
    count(*) AS customers,
    round(avg(monetary),2) AS avg_monetary
FROM s
GROUP BY 1,2,3
ORDER BY customers DESC
LIMIT 15;
""",
    ),
]

# ---------------------------------------------------------
# CREATE HTML REPORT
# ---------------------------------------------------------

sections = []

for title, sql in [GUARD] + QUERIES:

    try:
        df = con.execute(sql).df()

        # Format dataframe as HTML
        table_html = (
            df.style.hide(axis="index")
            .set_table_attributes('class="output-table"')
            .to_html()
        )

        section = f"""
        <section class="query-section">

            <h2>{escape(title)}</h2>

            <h3>SQL Query</h3>

            <pre><code>{escape(sql.strip())}</code></pre>

            <h3>Query Output</h3>

            {table_html}

        </section>
        """

    except Exception as e:

        section = f"""
        <section class="query-section">

            <h2>{escape(title)}</h2>

            <h3>SQL Query</h3>

            <pre><code>{escape(sql.strip())}</code></pre>

            <h3>Error</h3>

            <pre>{escape(str(e))}</pre>

        </section>
        """

        traceback.print_exc()

    sections.append(section)


html = f"""
<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">

<title>Online Retail II - SQL Business Analysis</title>

<style>

@page {{
    size: A4 landscape;
    margin: 15mm;
}}

body {{
    font-family: Arial, sans-serif;
    margin: 30px;
    color: #222;
}}

h1 {{
    text-align: center;
    margin-bottom: 10px;
}}

.subtitle {{
    text-align: center;
    color: #666;
    margin-bottom: 40px;
}}

.query-section {{
    page-break-before: always;
    margin-bottom: 30px;
}}

.query-section:first-of-type {{
    page-break-before: auto;
}}

h2 {{
    border-bottom: 2px solid #333;
    padding-bottom: 8px;
}}

h3 {{
    margin-top: 20px;
}}

pre {{
    background: #f4f4f4;
    padding: 15px;
    border: 1px solid #ddd;
    border-radius: 5px;
    white-space: pre-wrap;
    font-family: Consolas, monospace;
    font-size: 12px;
}}

.output-table {{
    border-collapse: collapse;
    width: 100%;
    font-size: 11px;
}}

.output-table th {{
    background: #eaeaea;
    font-weight: bold;
    border: 1px solid #999;
    padding: 7px;
}}

.output-table td {{
    border: 1px solid #bbb;
    padding: 7px;
}}

.output-table tr:nth-child(even) {{
    background: #f8f8f8;
}}

</style>

</head>

<body>

<h1>Online Retail II – SQL Business Analysis</h1>

<div class="subtitle">
SQL Queries and Query Outputs
</div>

{''.join(sections)}

</body>
</html>
"""

output_file = Path("online_retail_sql_report.html")

output_file.write_text(html, encoding="utf-8")

print(f"Report created: {output_file.resolve()}")

con.close()
