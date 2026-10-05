
-- Customer Order History
DROP TABLE IF EXISTS dbo.customer_order_summary;
GO

SELECT
    Customer_ID,

    COUNT(DISTINCT Invoice) AS TotalOrders,

    MIN(InvoiceDate) AS FirstPurchaseDate,

    MAX(InvoiceDate) AS LastPurchaseDate,

    SUM(order_revenue) AS LifetimeRevenue,

    DATEDIFF(
        DAY,
        MIN(InvoiceDate),
        MAX(InvoiceDate)
    ) AS CustomerLifespanDays,

    CASE
        WHEN COUNT(DISTINCT Invoice) >= 2 THEN 1
        ELSE 0
    END AS IsRepeatCustomer,

    CAST(
        COUNT(DISTINCT Invoice) * 30.0
        /
        NULLIF(
            DATEDIFF(
                DAY,
                MIN(InvoiceDate),
                MAX(InvoiceDate)
            ),
            0
        )
        AS DECIMAL(18,2)
    ) AS OrdersPer30Days

INTO dbo.customer_order_summary

FROM dbo.customer_orders

GROUP BY
    Customer_ID;
GO

SELECT * FROM customer_order_summary;