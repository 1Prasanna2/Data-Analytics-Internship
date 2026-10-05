DROP TABLE IF EXISTS dbo.rfm_segment_summary;
GO

SELECT
    Segment,

    COUNT(*) AS CustomerCount,

    CAST(
        100.0 * COUNT(*)
        / SUM(COUNT(*)) OVER ()
        AS DECIMAL(10,2)
    ) AS CustomerPercentage,

    CAST(
        AVG(RecencyDays)
        AS DECIMAL(10,2)
    ) AS AvgRecencyDays,

    CAST(
        AVG(Frequency * 1.0)
        AS DECIMAL(10,2)
    ) AS AvgFrequency,

    CAST(
        AVG(MonetaryValue)
        AS DECIMAL(18,2)
    ) AS AvgMonetaryValue,

    CAST(
        SUM(MonetaryValue)
        AS DECIMAL(18,2)
    ) AS SegmentRevenue,

    CAST(
        100.0 * SUM(MonetaryValue)
        / SUM(SUM(MonetaryValue)) OVER ()
        AS DECIMAL(10,2)
    ) AS RevenuePercentage,

    CAST(
        AVG(RFM_TotalScore)
        AS DECIMAL(10,2)
    ) AS AvgRFMScore

INTO dbo.rfm_segment_summary

FROM dbo.customer_rfm

GROUP BY
    Segment;
GO


SELECT
    Segment,
    CustomerCount,
    CustomerPercentage,
    AvgRecencyDays,
    AvgFrequency,
    AvgMonetaryValue,
    SegmentRevenue,
    RevenuePercentage,
    AvgRFMScore

FROM dbo.rfm_segment_summary

ORDER BY
    SegmentRevenue DESC;