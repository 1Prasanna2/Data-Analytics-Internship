-- Time to Second Purchase — overall
WITH SecondPurchase AS
(
    SELECT
        Customer_ID,
        MIN(
            CASE
                WHEN PurchaseNumber = 1
                THEN InvoiceDate
            END
        ) AS FirstPurchaseDate,

        MIN(
            CASE
                WHEN PurchaseNumber = 2
                THEN InvoiceDate
            END
        ) AS SecondPurchaseDate

    FROM dbo.customer_purchase_history

    GROUP BY
        Customer_ID
),

T2 AS
(
    SELECT
        Customer_ID,

        DATEDIFF(
            DAY,
            FirstPurchaseDate,
            SecondPurchaseDate
        ) AS T2Days

    FROM SecondPurchase

    WHERE SecondPurchaseDate IS NOT NULL
),
T2Stats AS
(
    SELECT
        T2Days,

        COUNT(*) OVER () AS Converters,

        AVG(
            CAST(T2Days AS DECIMAL(18,2))
        ) OVER () AS MeanT2Days,

        PERCENTILE_CONT(0.5)
        WITHIN GROUP (
            ORDER BY T2Days
        )
        OVER () AS MedianT2Days

    FROM T2
)

SELECT TOP 1
    Converters,
    CAST(MeanT2Days AS DECIMAL(10,2)) AS MeanT2Days,
    CAST(MedianT2Days AS DECIMAL(10,2)) AS MedianT2Days
FROM T2Stats;




-- T2 by 30/60/90/180/365 days
WITH Windows AS
(
    SELECT 30 AS WindowDays
    UNION ALL SELECT 60
    UNION ALL SELECT 90
    UNION ALL SELECT 180
    UNION ALL SELECT 365
),

SecondPurchase AS
(
    SELECT
        Customer_ID,

        MIN(
            CASE
                WHEN PurchaseNumber = 1
                THEN InvoiceDate
            END
        ) AS FirstPurchaseDate,

        MIN(
            CASE
                WHEN PurchaseNumber = 2
                THEN InvoiceDate
            END
        ) AS SecondPurchaseDate

    FROM dbo.customer_purchase_history

    GROUP BY
        Customer_ID
),

T2 AS
(
    SELECT
        Customer_ID,

        DATEDIFF(
            DAY,
            FirstPurchaseDate,
            SecondPurchaseDate
        ) AS T2Days

    FROM SecondPurchase

    WHERE SecondPurchaseDate IS NOT NULL
),

Eligible AS
(
    SELECT
        w.WindowDays,
        t.Customer_ID,
        t.T2Days

    FROM Windows AS w

    INNER JOIN T2 AS t
        ON t.T2Days BETWEEN 0 AND w.WindowDays
),
T2Stats AS
(
    SELECT
        WindowDays,
        T2Days,

        COUNT(*) OVER (
            PARTITION BY WindowDays
        ) AS Converters,

        AVG(
            CAST(T2Days AS DECIMAL(18,2))
        ) OVER (
            PARTITION BY WindowDays
        ) AS MeanT2Days,

        PERCENTILE_CONT(0.5)
        WITHIN GROUP (
            ORDER BY T2Days
        )
        OVER (
            PARTITION BY WindowDays
        ) AS MedianT2Days

    FROM Eligible
)

SELECT DISTINCT
    WindowDays,
    Converters,
    CAST(MeanT2Days AS DECIMAL(10,2)) AS MeanT2Days,
    CAST(MedianT2Days AS DECIMAL(10,2)) AS MedianT2Days

FROM T2Stats

ORDER BY
    WindowDays;
