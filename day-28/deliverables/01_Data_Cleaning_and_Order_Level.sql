-- order-level foundation
CREATE OR ALTER VIEW customer_orders AS
SELECT
	Customer_ID,
    Invoice,
    MIN(InvoiceDate) AS InvoiceDate,
    SUM(Quantity * Price) AS order_revenue
FROM online_retail_II_v2
WHERE Customer_ID IS NOT NULL
  AND Quantity > 0
  AND Price > 0
  AND Invoice NOT LIKE 'C%'
GROUP BY Customer_ID,Invoice;
