-- Computing QoQ and YoY growth rates using window functions

WITH RegionalQuarterly AS(
	SELECT
		s.Region,
		c.YearQuarterLabel,
		c.CalendarYear,
		c.CalendarQuarter,
		SUM(s.Sales) AS CurrentRevenue,
		SUM(s.Profit) AS CurrentProfit,
		COUNT(DISTINCT s.[Order_ID]) AS CurrentOrders
	FROM Superstore s
	JOIN dim_Calendar c ON s.[Order_Date] = c.FullDateAlternateKey
	WHERE S.Region IS NOT NULL AND s.Sales > 0
	GROUP BY s.Region, c.YearQuarterLabel, c.CalendarYear, c.CalendarQuarter
),
WithLags AS(
	SELECT
		*,
		/*
		LAG(..., 1) = previous quarter (QoQ comparison)
		LAG(..., 4) = same quarter last year (YoY comparison)
		*/
		LAG(CurrentRevenue,1) OVER(PARTITION BY Region ORDER BY CalendarYear, CalendarQuarter) AS PrevQ_Revenue,
		LAG(CurrentRevenue,4) OVER(PARTITION BY Region ORDER BY CalendarYear, CalendarQuarter) AS YoY_Prev_Revenue,
		LAG(CurrentRevenue,1) OVER(PARTITION BY Region ORDER BY CalendarYear, CalendarQuarter) AS PrevQ_Orders,
		LAG(CurrentRevenue,4) OVER(PARTITION BY Region ORDER BY CalendarYear, CalendarQuarter) AS YoY_Prev_Orders
	FROM RegionalQuarterly
)

SELECT * FROM WithLags ORDER BY Region, CalendarYear, CalendarQuarter;


-- Final Growth Metrics Table
WITH RegionalQuarterly AS(
	SELECT
		s.Region,
		c.YearQuarterLabel,
		c.CalendarYear,
		c.CalendarQuarter,
		SUM(s.Sales) AS CurrentRevenue,
		SUM(s.Profit) AS CurrentProfit,
		COUNT(DISTINCT s.[Order_ID]) AS CurrentOrders
	FROM dbo.Superstore s
	JOIN dim_Calendar c ON s.[Order_Date] = c.FullDateAlternateKey
	WHERE s.Region IS NOT NULL AND s.Sales > 0
	GROUP BY s.Region, c.YearQuarterLabel, c.CalendarYear, c.CalendarQuarter
),
WithLags AS(
	SELECT
		*,
		/*
		LAG(..., 1) = previous quarter (QoQ comparison)
		LAG(..., 4) = same quarter last year (YoY comparison)
		*/
		LAG(CurrentRevenue,1) OVER(PARTITION BY Region ORDER BY CalendarYear, CalendarQuarter) AS PrevQ_Revenue,
		LAG(CurrentRevenue,4) OVER(PARTITION BY Region ORDER BY CalendarYear, CalendarQuarter) AS YoY_Prev_Revenue,
		LAG(CurrentRevenue,1) OVER(PARTITION BY Region ORDER BY CalendarYear, CalendarQuarter) AS PrevQ_Orders,
		LAG(CurrentRevenue,4) OVER(PARTITION BY Region ORDER BY CalendarYear, CalendarQuarter) AS YoY_Prev_Orders
	FROM RegionalQuarterly
)
SELECT 
	wl.Region,
	wl.YearQuarterLabel,
	wl.CurrentRevenue,
	wl.PrevQ_Revenue,
	wl.YoY_Prev_Revenue,
	
	ROUND(wl.CurrentRevenue - COALESCE(wl.PrevQ_Revenue, 0), 2) AS QoQ_Dollar_Change,
	ROUND(wl.CurrentRevenue - COALESCE(wl.YoY_Prev_Revenue, 0), 2) AS YoY_Dollar_Change,

	CASE
		WHEN wl.PrevQ_Revenue IS NULL OR wl.PrevQ_Revenue = 0 THEN NULL
		ELSE ROUND((wl.CurrentRevenue - wl.PrevQ_Revenue) * 100.0 / wl.PrevQ_Revenue, 2)
	END AS QoGrowthPct,

    CASE 
        WHEN wl.YoY_Prev_Revenue IS NULL OR wl.YoY_Prev_Revenue = 0 THEN NULL 
        ELSE ROUND((wl.CurrentRevenue - wl.YoY_Prev_Revenue) * 100.0 / wl.YoY_Prev_Revenue, 2)
    END AS YoYGrowthPct,

	CASE 
        WHEN wl.CurrentRevenue < 5000 THEN 'SMALL_BASE_WARNING' 
        ELSE 'OK'
    END AS BaseSizeFlag,

	wl.CurrentOrders,
    wl.CurrentProfit,
    ROUND(wl.CurrentProfit * 100.0 / NULLIF(wl.CurrentRevenue, 0), 2) AS ProfitMarginPct

FROM WithLags wl
ORDER BY wl.Region, wl.CalendarYear, wl.CalendarQuarter;