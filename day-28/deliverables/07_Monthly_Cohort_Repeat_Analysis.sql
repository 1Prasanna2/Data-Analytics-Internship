-- Monthly post-acquisition repeat analysis
WITH CustomerMonths AS
(
    SELECT
        Customer_ID,
        Invoice,
        InvoiceDate,
        AcquisitionDate,

        DATEDIFF(
            MONTH,
            AcquisitionDate,
            InvoiceDate
        ) AS MonthsSinceAcquisition

    FROM dbo.customer_purchase_history
)

SELECT
    MonthsSinceAcquisition,

    COUNT(DISTINCT Customer_ID) AS ActiveCustomers,

    COUNT(DISTINCT
        CASE
            WHEN MonthsSinceAcquisition >= 1
            THEN Customer_ID
        END
    ) AS RepeatCustomers,

    CAST(
        100.0 *
        COUNT(DISTINCT
            CASE
                WHEN MonthsSinceAcquisition >= 1
                THEN Customer_ID
            END
        )
        /
        NULLIF(
            COUNT(DISTINCT Customer_ID),
            0
        )
        AS DECIMAL(10,2)
    ) AS RPR_Percent,

    COUNT(DISTINCT Invoice) AS TotalOrders,

    CAST(
        1.0 * COUNT(DISTINCT Invoice)
        /
        NULLIF(
            COUNT(DISTINCT Customer_ID),
            0
        )
        AS DECIMAL(10,2)
    ) AS PurchaseFrequency

FROM CustomerMonths

GROUP BY
    MonthsSinceAcquisition

ORDER BY
    MonthsSinceAcquisition;


-- Better cohort version
WITH CustomerMonths AS
(
    SELECT
        Customer_ID,
        AcquisitionDate,
        Invoice,
        InvoiceDate,

        DATEDIFF(
            MONTH,
            AcquisitionDate,
            InvoiceDate
        ) AS MonthsSinceAcquisition

    FROM dbo.customer_purchase_history
),

CustomerMonthSummary AS
(
    SELECT
        Customer_ID,
        AcquisitionDate,
        MonthsSinceAcquisition,

        COUNT(DISTINCT Invoice) AS OrdersInMonth

    FROM CustomerMonths

    GROUP BY
        Customer_ID,
        AcquisitionDate,
        MonthsSinceAcquisition
)

SELECT
    YEAR(AcquisitionDate) AS AcquisitionYear,
    MONTH(AcquisitionDate) AS AcquisitionMonth,
    MonthsSinceAcquisition,

    COUNT(DISTINCT Customer_ID) AS ActiveCustomers,

    SUM(
        CASE
            WHEN OrdersInMonth >= 2 THEN 1
            ELSE 0
        END
    ) AS RepeatCustomers,

    CAST(
        100.0 *
        SUM(
            CASE
                WHEN OrdersInMonth >= 2 THEN 1
                ELSE 0
            END
        )
        /
        NULLIF(
            COUNT(DISTINCT Customer_ID),
            0
        )
        AS DECIMAL(10,2)
    ) AS RPR_Percent,

    SUM(OrdersInMonth) AS TotalOrders,

    CAST(
        1.0 * SUM(OrdersInMonth)
        /
        NULLIF(
            COUNT(DISTINCT Customer_ID),
            0
        )
        AS DECIMAL(10,2)
    ) AS PurchaseFrequency

FROM CustomerMonthSummary

GROUP BY
    YEAR(AcquisitionDate),
    MONTH(AcquisitionDate),
    MonthsSinceAcquisition

ORDER BY
    AcquisitionYear,
    AcquisitionMonth,
    MonthsSinceAcquisition;


-- A useful Day 28 summary query
SELECT
    OrderType,
    COUNT(*) AS TotalOrders,
    COUNT(DISTINCT Customer_ID) AS Customers,
    CAST(SUM(order_revenue) AS DECIMAL(18,2)) AS Revenue,
    CAST(AVG(order_revenue) AS DECIMAL(18,2)) AS AOV
FROM dbo.order_classification
GROUP BY
    OrderType;