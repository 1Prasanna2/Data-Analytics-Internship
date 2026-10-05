USE Online_Retail_II;
GO

DROP TABLE IF EXISTS dbo.customer_rfm;
GO

WITH SnapshotDate AS
(
    SELECT
        MAX(InvoiceDate) AS AnalysisDate
    FROM dbo.customer_orders
),

RFM_Base AS
(
    SELECT
        o.Customer_ID,

        DATEDIFF(
            DAY,
            MAX(o.InvoiceDate),
            s.AnalysisDate
        ) AS RecencyDays,

        COUNT(DISTINCT o.Invoice) AS Frequency,

        SUM(o.order_revenue) AS MonetaryValue

    FROM dbo.customer_orders AS o

    CROSS JOIN SnapshotDate AS s

    GROUP BY
        o.Customer_ID,
        s.AnalysisDate
),

RFM_Scored AS
(
    SELECT
        Customer_ID,
        RecencyDays,
        Frequency,
        MonetaryValue,

        -- Lower recency = better, therefore reverse the score
        6 - NTILE(5) OVER
        (
            ORDER BY RecencyDays ASC
        ) AS RecencyScore,

        NTILE(5) OVER
        (
            ORDER BY Frequency ASC
        ) AS FrequencyScore,

        NTILE(5) OVER
        (
            ORDER BY MonetaryValue ASC
        ) AS MonetaryScore

    FROM RFM_Base
)

SELECT
    Customer_ID,
    RecencyDays,
    Frequency,
    CAST(MonetaryValue AS DECIMAL(18,2)) AS MonetaryValue,

    RecencyScore,
    FrequencyScore,
    MonetaryScore,

    CONCAT(
        RecencyScore,
        FrequencyScore,
        MonetaryScore
    ) AS RFM_Score,

    RecencyScore
        + FrequencyScore
        + MonetaryScore AS RFM_TotalScore,

    CASE

        WHEN RecencyScore >= 4
         AND FrequencyScore >= 4
         AND MonetaryScore >= 4
            THEN 'Champions'

        WHEN RecencyScore >= 3
         AND FrequencyScore >= 4
         AND MonetaryScore >= 3
            THEN 'Loyal Customers'

        WHEN RecencyScore >= 4
         AND FrequencyScore BETWEEN 2 AND 3
         AND MonetaryScore >= 2
            THEN 'Potential Loyalists'

        WHEN RecencyScore >= 4
         AND FrequencyScore <= 2
            THEN 'Recent Customers'

        WHEN RecencyScore <= 2
         AND FrequencyScore >= 4
         AND MonetaryScore >= 4
            THEN 'Cannot Lose Them'

        WHEN RecencyScore <= 2
         AND FrequencyScore >= 3
         AND MonetaryScore >= 3
            THEN 'At Risk'

        WHEN RecencyScore <= 2
         AND FrequencyScore <= 2
         AND MonetaryScore >= 2
            THEN 'Needs Attention'

        WHEN RecencyScore = 1
         AND FrequencyScore = 1
         AND MonetaryScore = 1
            THEN 'Hibernating'

        ELSE 'Others'

    END AS Segment

INTO dbo.customer_rfm

FROM RFM_Scored;
GO

SELECT TOP 20 *
FROM dbo.customer_rfm
ORDER BY RFM_TotalScore DESC;