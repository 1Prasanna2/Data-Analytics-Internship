-- RPR + Purchase Frequency for 30/60/90/180/365 days
WITH Windows AS
(
    SELECT 30 AS WindowDays
    UNION ALL SELECT 60
    UNION ALL SELECT 90
    UNION ALL SELECT 180
    UNION ALL SELECT 365
),

CustomerWindowMetrics AS
(
    SELECT
        w.WindowDays,
        c.Customer_ID,

        COUNT(DISTINCT
            CASE
                WHEN DATEDIFF(
                        DAY,
                        c.AcquisitionDate,
                        o.InvoiceDate
                     ) BETWEEN 0 AND w.WindowDays
                THEN o.Invoice
            END
        ) AS OrdersInWindow

    FROM Windows AS w

    CROSS JOIN dbo.customer_acquisition AS c

    LEFT JOIN dbo.customer_orders AS o
        ON o.Customer_ID = c.Customer_ID
       AND DATEDIFF(
            DAY,
            c.AcquisitionDate,
            o.InvoiceDate
       ) BETWEEN 0 AND w.WindowDays

    GROUP BY
        w.WindowDays,
        c.Customer_ID
)

SELECT
    WindowDays,

    COUNT(*) AS ActiveCustomers,

    SUM(
        CASE
            WHEN OrdersInWindow >= 2 THEN 1
            ELSE 0
        END
    ) AS RepeatCustomers,

    CAST(
        100.0 *
        SUM(
            CASE
                WHEN OrdersInWindow >= 2 THEN 1
                ELSE 0
            END
        )
        /
        NULLIF(COUNT(*), 0)
        AS DECIMAL(10,2)
    ) AS RPR_Percent,

    SUM(OrdersInWindow) AS TotalOrders,

    CAST(
        1.0 * SUM(OrdersInWindow)
        /
        NULLIF(COUNT(*), 0)
        AS DECIMAL(10,2)
    ) AS PurchaseFrequency

FROM CustomerWindowMetrics

GROUP BY
    WindowDays

ORDER BY
    WindowDays;