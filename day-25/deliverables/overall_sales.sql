SELECT
    ROUND(SUM(p.Price * od.Quantity), 2) AS TotalSales,
    COUNT(DISTINCT od.OrderID) AS TotalOrders,
    COUNT(DISTINCT o.CustomerID) AS TotalCustomers,
    SUM(od.Quantity) AS UnitsSold,
    ROUND(
        SUM(p.Price * od.Quantity)
        / COUNT(DISTINCT od.OrderID),
        2
    ) AS AverageOrderValue
FROM orderdetails od
JOIN orders o
    ON od.OrderID = o.OrderID
JOIN products p
    ON od.ProductID = p.ProductID;