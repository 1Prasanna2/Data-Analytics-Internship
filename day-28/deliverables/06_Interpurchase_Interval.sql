-- Interpurchase Interval — IPI
WITH PurchaseIntervals AS
(
    SELECT
        Customer_ID,
        InvoiceDate,

        LAG(InvoiceDate) OVER
        (
            PARTITION BY Customer_ID
            ORDER BY InvoiceDate, Invoice
        ) AS PreviousInvoiceDate

    FROM dbo.customer_orders
),

Intervals AS
(
    SELECT
        Customer_ID,

        DATEDIFF(
            DAY,
            PreviousInvoiceDate,
            InvoiceDate
        ) AS IPIDays

    FROM PurchaseIntervals

    WHERE PreviousInvoiceDate IS NOT NULL
),

IPIStats AS
(
    SELECT
        IPIDays,

        COUNT(*) OVER () AS IntervalCount,

        AVG(
            CAST(IPIDays AS DECIMAL(18,2))
        ) OVER () AS MeanIPIDays,

        PERCENTILE_CONT(0.5)
        WITHIN GROUP
        (
            ORDER BY IPIDays
        )
        OVER () AS MedianIPIDays,

        VARP(
            CAST(IPIDays AS FLOAT)
        ) OVER () AS IPIVariance

    FROM Intervals
)

SELECT TOP 1
    IntervalCount,

    CAST(
        MeanIPIDays AS DECIMAL(10,2)
    ) AS MeanIPIDays,

    CAST(
        MedianIPIDays AS DECIMAL(10,2)
    ) AS MedianIPIDays,

    CAST(
        IPIVariance AS DECIMAL(18,2)
    ) AS IPIVariance

FROM IPIStats;


-- IPI by customer
WITH PurchaseIntervals AS
(
    SELECT
        Customer_ID,
        Invoice,
        InvoiceDate,

        LAG(InvoiceDate) OVER
        (
            PARTITION BY Customer_ID
            ORDER BY InvoiceDate, Invoice
        ) AS PreviousInvoiceDate

    FROM dbo.customer_orders
),

Intervals AS
(
    SELECT
        Customer_ID,

        DATEDIFF(
            DAY,
            PreviousInvoiceDate,
            InvoiceDate
        ) AS IPIDays

    FROM PurchaseIntervals

    WHERE PreviousInvoiceDate IS NOT NULL
),

CustomerIPIStats AS
(
    SELECT
        Customer_ID,
        IPIDays,

        COUNT(*) OVER
        (
            PARTITION BY Customer_ID
        ) AS IntervalCount,

        AVG(
            CAST(IPIDays AS DECIMAL(18,2))
        ) OVER
        (
            PARTITION BY Customer_ID
        ) AS MeanIPIDays,

        PERCENTILE_CONT(0.5)
        WITHIN GROUP
        (
            ORDER BY IPIDays
        )
        OVER
        (
            PARTITION BY Customer_ID
        ) AS MedianIPIDays,

        VARP(
            CAST(IPIDays AS FLOAT)
        ) OVER
        (
            PARTITION BY Customer_ID
        ) AS IPIVariance

    FROM Intervals
)

SELECT DISTINCT
    Customer_ID,
    IntervalCount,

    CAST(
        MeanIPIDays AS DECIMAL(10,2)
    ) AS MeanIPIDays,

    CAST(
        MedianIPIDays AS DECIMAL(10,2)
    ) AS MedianIPIDays,

    CAST(
        IPIVariance AS DECIMAL(18,2)
    ) AS IPIVariance

FROM CustomerIPIStats

WHERE IntervalCount >= 2

ORDER BY
    IPIVariance;