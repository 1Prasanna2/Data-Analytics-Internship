DROP VIEW IF EXISTS vw_sales_analysis;

CREATE VIEW vw_sales_analysis AS
SELECT
    od.OrderDetailID,
    od.OrderID,
    o.OrderDate,

    o.CustomerID,
    c.CustomerName,
    c.Country AS CustomerCountry,

    od.ProductID,
    p.ProductName,

    p.CategoryID,
    cat.CategoryName,

    p.SupplierID,
    s.SupplierName,

    p.Price AS UnitPrice,
    od.Quantity,

    ROUND(
        p.Price * od.Quantity,
        2
    ) AS SalesAmount

FROM OrderDetails od

INNER JOIN Orders o
    ON od.OrderID = o.OrderID

INNER JOIN Customers c
    ON o.CustomerID = c.CustomerID

LEFT JOIN Products p
    ON od.ProductID = p.ProductID

LEFT JOIN Categories cat
    ON p.CategoryID = cat.CategoryID

LEFT JOIN Suppliers s
    ON p.SupplierID = s.SupplierID;