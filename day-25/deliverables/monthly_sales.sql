SELECT
    strftime('%Y-%m-01', o.OrderDate) AS SalesMonth,

    ROUND(
        SUM(p.Price * od.Quantity),
        2
    ) AS TotalSales,

    COUNT(DISTINCT o.OrderID) AS TotalOrders,

    COUNT(DISTINCT o.CustomerID) AS TotalCustomers

FROM orderdetails od

JOIN orders o
    ON od.OrderID = o.OrderID

JOIN products p
    ON od.ProductID = p.ProductID

GROUP BY
    strftime('%Y-%m-01', o.OrderDate)
ORDER BY
    SalesMonth;