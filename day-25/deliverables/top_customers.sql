SELECT
    o.CustomerID,
    c.CustomerName,
    c.Country,

    ROUND(
        SUM(p.Price * od.Quantity),
        2
    ) AS TotalSales,

    COUNT(DISTINCT o.OrderID) AS TotalOrders,

    ROUND(
        SUM(p.Price * od.Quantity)
        / COUNT(DISTINCT o.OrderID),
        2
    ) AS AverageOrderValue

FROM orderdetails od

JOIN orders o
    ON od.OrderID = o.OrderID

JOIN customers c
    ON o.CustomerID = c.CustomerID

JOIN products p
    ON od.ProductID = p.ProductID

GROUP BY
    o.CustomerID,
    c.CustomerName,
    c.Country

ORDER BY
    TotalSales DESC

LIMIT 10;