-- First-Time vs Repeat Order Classification
DROP TABLE IF EXISTS dbo.order_classification;
GO

WITH RankedOrders AS
(
    SELECT
        Customer_ID,
        Invoice,
        InvoiceDate,
        order_revenue,

        ROW_NUMBER() OVER
        (
            PARTITION BY Customer_ID
            ORDER BY InvoiceDate, Invoice
        ) AS PurchaseNumber

    FROM dbo.customer_orders
)

SELECT
    Customer_ID,
    Invoice,
    InvoiceDate,
    order_revenue,
    PurchaseNumber,

    CASE
        WHEN PurchaseNumber = 1
            THEN 'First-Time'
        ELSE 'Repeat'
    END AS OrderType

INTO dbo.order_classification

FROM RankedOrders;
GO



-- First-Time vs Repeat AOV
-- B.Q : Do repeat customers have a higher average order value than first-time customers?
SELECT
    OrderType,

    COUNT(*) AS TotalOrders,

    COUNT(DISTINCT Customer_ID) AS Customers,

    CAST(
        SUM(order_revenue)
        AS DECIMAL(18,2)
    ) AS TotalRevenue,

    CAST(
        AVG(order_revenue)
        AS DECIMAL(18,2)
    ) AS AverageOrderValue

FROM dbo.order_classification

GROUP BY
    OrderType

ORDER BY
    CASE
        WHEN OrderType = 'First-Time' THEN 1
        ELSE 2
    END;



-- Customer acquisition table
DROP TABLE IF EXISTS dbo.customer_acquisition;
GO

SELECT
    Customer_ID,
    MIN(InvoiceDate) AS AcquisitionDate

INTO dbo.customer_acquisition

FROM dbo.customer_orders

GROUP BY
    Customer_ID;
GO

-- Add purchase number and days since acquisition
DROP TABLE IF EXISTS dbo.customer_purchase_history;
GO

SELECT
    o.Customer_ID,
    o.Invoice,
    o.InvoiceDate,
    o.order_revenue,
    a.AcquisitionDate,

    DATEDIFF(
        DAY,
        a.AcquisitionDate,
        o.InvoiceDate
    ) AS DaysSinceAcquisition,

    ROW_NUMBER() OVER
    (
        PARTITION BY o.Customer_ID
        ORDER BY o.InvoiceDate, o.Invoice
    ) AS PurchaseNumber

INTO dbo.customer_purchase_history

FROM dbo.customer_orders AS o

INNER JOIN dbo.customer_acquisition AS a
    ON o.Customer_ID = a.Customer_ID;
GO
