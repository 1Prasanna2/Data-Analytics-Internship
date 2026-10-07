-- Defining Consistent Time Periods
IF OBJECT_ID('dim_Calendar', 'U') IS NOT NULL DROP TABLE dim_Calendar;

CREATE TABLE dim_Calendar(
		DateKey DATE PRIMARY KEY,
		FullDateAlternateKey DATE UNIQUE,
		CalendarYear SMALLINT,
		CalendarQuarter TINYINT,
		YearQuarterLabel CHAR(7),
		MonthNumberOfYear TINYINT,
		EnglishMonthName NVARCHAR(10)
); 


DECLARE @StartDate DATE = '2014-01-01';
DECLARE @EndDate DATE = '2017-12-31'; 


WHILE @StartDate <= @EndDate
BEGIN 
		INSERT INTO dim_Calendar VALUES(
			@StartDate,
			@StartDate,
			YEAR(@StartDate),
			DATEPART(QUARTER, @StartDate),
			CAST(YEAR(@StartDate) AS CHAR(4)) + '-Q' + CAST(DATEPART(QUARTER, @StartDate) AS CHAR(1)),
			MONTH(@StartDate),
			DATENAME(MONTH, @StartDate)
		);
		SET @StartDate = DATEADD(DAY, 1, @StartDate);
END;
GO

SELECT
		s.Region,
		c.YearQuarterLabel,
		SUM(s.Sales) AS TotalRevenue,
		SUM(s.Profit) AS TotalProfit,
		COUNT(DISTINCT s.[Order_ID]) AS TotalOrders
FROM dbo.Superstore s
JOIN dim_Calendar c ON s.[Order_Date] = c.FullDateAlternateKey
WHERE s.Region IS NOT NULL AND s.Sales > 0
GROUP BY s.Region, c.YearQuarterLabel
ORDER BY s.Region, c.YearQuarterLabel;

-- Confirm date coverage
SELECT MIN([Order_Date]), MAX([Order_Date]) FROM dbo.Superstore;
-- Should return 2016-01-01 to 2019-12-31

-- Confirm all orders mapped to quarters
SELECT COUNT(*) FROM dbo.Superstore WHERE [Order_Date] NOT IN (SELECT FullDateAlternateKey FROM dim_Calendar);
-- Must return 0