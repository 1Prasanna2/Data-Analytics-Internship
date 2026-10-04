-- Q1: Multi-KPI Performance Table for Sales Reps
-- Combining FactResellerSales + DimEmployee + DimSalesTerritory + DimDate

USE AdventureWorksDW2022
GO

CREATE OR ALTER VIEW vw_SalespersonPerformance AS 
SELECT
	 e.EmployeeKey,
	 CONCAT_WS(' ', e.FirstName, e.MiddleName, e.LastName) AS SalesPersonName,
	 e.Title AS JobTitle,
	 st.SalesTerritoryRegion AS Territory,
	 st.SalesTerritoryCountry AS Country,
	 st.SalesTerritoryGroup AS TerritoryGroup,

	 -- Volume Metrics
	 SUM(frs.SalesAmount) AS TotalRevenue,
	 COUNT(DISTINCT frs.SalesOrderNumber) AS TotalOrders,
	 SUM(frs.OrderQuantity) AS TotalUnits,

	 -- Profitability Metrics
	 SUM(frs.SalesAmount - frs.TotalProductCost) AS TotalProfit,
	 ROUND(
		SUM(frs.SalesAmount - frs.TotalProductCost) * 100.0 / NULLIF(SUM(frs.SalesAmount),0),
	 2) AS ProfitMarginPct,

	 -- Efficiency Metrics
	 ROUND(SUM(frs.SalesAmount) / NULLIF(COUNT(DISTINCT frs.SalesOrderNumber),0), 2) AS AvgOrderValue,
	 ROUND(
		SUM(frs.SalesAmount - frs.TotalProductCost) / NULLIF(COUNT(DISTINCT frs.SalesOrderNumber),0),
	 2) AS AvgProfitPerOrder,

	 -- Risk Metrics (Unprofitable Orders)
	 SUM(CASE WHEN (frs.SalesAmount - frs.TotalProductCost) < 0 THEN 1 ELSE 0 END) AS NegativeProfitOrders,
	 ROUND(
		 SUM(CASE WHEN (frs.SalesAmount - frs.TotalProductCost) < 0 THEN 1 ELSE 0 END) * 100.0 / 
		 NULLIF(COUNT(DISTINCT frs.SalesOrderNumber),0),
	 2) AS NegOrderPct,

	 -- Time Intelligence (YoY Growth)
	 SUM(CASE WHEN d.CalendarYear = 2013 THEN frs.SalesAmount ELSE 0 END) AS Revenue_2013,
	 SUM(CASE WHEN d.CalendarYear = 2012 THEN frs.SalesAmount ELSE 0 END) AS Revenue_2012,
	 ROUND(
			(SUM(CASE WHEN d.CalendarYear = 2013 THEN frs.SalesAmount ELSE 0 END) -
			 SUM(CASE WHEN d.CalendarYear = 2012 THEN frs.SalesAmount ELSE 0 END)) * 100.0 / 
			 NULLIF(SUM(CASE WHEN d.CalendarYear = 2012 THEN frs.SalesAmount ELSE 0 END), 0),
	 2) AS YoYGrowthPct
FROM 
	FactResellerSales frs
JOIN 
	DimEmployee e ON frs.EmployeeKey = e.EmployeeKey
JOIN 
	DimSalesTerritory st ON e.SalesTerritoryKey = st.SalesTerritoryKey
JOIN 
	DimDate d ON frs.OrderDateKey = d.DateKey
WHERE
	    e.Title NOT LIKE '%Manager%' 
    AND e.Title NOT LIKE '%Director%'
    AND st.SalesTerritoryRegion IS NOT NULL   
GROUP BY 
	e.EmployeeKey, e.FirstName, e.MiddleName, e.LastName, e.Title, 
    st.SalesTerritoryRegion, st.SalesTerritoryCountry, st.SalesTerritoryGroup;
GO

--QUERY 2: Normalized Composite Score + Rankings
CREATE OR ALTER VIEW vw_SalespersonRanking AS
WITH normalized AS (
	 SELECT
			EmployeeKey,
			SalesPersonName,
			JobTitle,
			Territory,
			Country,
			TerritoryGroup,
			TotalRevenue,
			TotalProfit,
			ProfitMarginPct,
			AvgOrderValue,
			YoYGrowthPct,
			NegOrderPct,

			-- Normalize each metric to 0-100
			ROUND((TotalRevenue - MIN(TotalRevenue) OVER()) * 100.0 / 
				   NULLIF(MAX(TotalRevenue) OVER() - MIN(TotalRevenue) OVER(),0),2) AS RevScore,
			ROUND((ProfitMarginPct - MIN(ProfitMarginPct) OVER()) * 100.0 / 
				   NULLIF(MAX(ProfitMarginPct) OVER() - MIN(ProfitMarginPct) OVER(),0),2) AS MarginScore,
			ROUND((AvgOrderValue - MIN(AvgOrderValue) OVER()) * 100.0 / 
				   NULLIF(MAX(AvgOrderValue) OVER() - MIN(AvgOrderValue) OVER(),0),2) AS AOVScore,
			ROUND((YoYGrowthPct - MIN(YoYGrowthPct) OVER()) * 100.0 / 
				   NULLIF(MAX(YoYGrowthPct) OVER() - MIN(YoYGrowthPct) OVER(),0),2) AS GrowthScore,

			-- Invert negative order %
			ROUND((MAX(NegOrderPct) OVER() - NegOrderPct ) * 100.0 / 
				   NULLIF(MAX(NegOrderPct) OVER() - MIN(NegOrderPct) OVER(),0),2) AS RiskScore
	FROM vw_SalespersonPerformance
)
SELECT
		EmployeeKey,
		SalesPersonName,
		JobTitle,
		Territory,
		Country,
		TerritoryGroup,
		TotalRevenue,
		TotalProfit,
		ProfitMarginPct,
		AvgOrderValue,
		YoYGrowthPct,
		NegOrderPct,

		-- Composite Score 
		ROUND((RevScore + MarginScore + AOVScore + GrowthScore + RiskScore) / 5,2) AS CompositeScore,
		
		-- Overall Rank by composite score
		RANK() OVER(ORDER BY (RevScore + MarginScore + AOVScore + GrowthScore + RiskScore) DESC) AS OverallRank,

		-- Individual KPI ranks for transparency
		RANK() OVER(ORDER BY TotalRevenue DESC) AS RevenueRank,
		RANK() OVER(ORDER BY ProfitMarginPct DESC) AS MarginRank,
		RANK() OVER(ORDER BY AvgOrderValue DESC) AS AOVRank,
		RANK() OVER(ORDER BY YoYGrowthPct DESC) AS GrowthRank,
		RANK() OVER(ORDER BY NegOrderPct DESC) AS RiskRank
FROM normalized
--ORDER BY OverallRank;
GO

-- QUERY 3: Export ranking table to CSV (via SSMS Results to File)
SELECT * FROM vw_SalespersonRanking;

-- Verify TotalRevenue
SELECT SUM(SalesAmount) AS ManualRevenue
FROM FactResellerSales
WHERE EmployeeKey = 281;
-- Should match Excel's TotalRevenue for Michael Blythe

-- Verify ProfitMarginPct
SELECT 
    ROUND((SUM(SalesAmount) - SUM(TotalProductCost)) * 100.0 / SUM(SalesAmount), 2) AS ManualMargin
FROM FactResellerSales
WHERE EmployeeKey = 281;
-- Should match Excel's ProfitMarginPct