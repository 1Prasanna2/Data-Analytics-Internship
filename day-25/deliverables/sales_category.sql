SELECT
    cat.CategoryName,
    ROUND(
        SUM(p.Price * od.Quantity),
        2
    ) AS TotalSales,
    SUM(od.Quantity) AS UnitsSold
FROM orderdetails od
JOIN products p
    ON od.ProductID = p.ProductID
LEFT JOIN categories cat
    ON p.CategoryID = cat.CategoryID
GROUP BY
    cat.CategoryName
ORDER BY
    TotalSales DESC;