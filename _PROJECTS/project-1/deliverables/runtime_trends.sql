-- Runtime trends by decade and format
SELECT
    -- Integer division in SQL Server automatically performs the floor operation
    (release_year / 10) * 10 AS release_decade,
    type,

    COUNT(runtime) AS titles_with_runtime,


    CAST(AVG(runtime) AS DECIMAL(10,1)) AS avg_runtime,
    MIN(runtime) AS min_runtime,
    MAX(runtime) AS max_runtime

FROM titles

WHERE release_year IS NOT NULL

GROUP BY
    (release_year / 10) * 10,
    type

ORDER BY release_decade, type;
