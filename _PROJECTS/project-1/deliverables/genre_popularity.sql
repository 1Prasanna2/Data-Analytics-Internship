-- Genre popularity and format mix

SELECT TOP 15 
	jt.value AS genre,

	COUNT(DISTINCT id) AS total_titles,

	COUNT(
		DISTINCT CASE 
				WHEN t.type = 'MOVIE' THEN t.id
		END
	) AS movie_titles,

	COUNT(
		DISTINCT CASE 
				WHEN t.type = 'SHOW' THEN t.id
		END
	) AS show_titles,

	CAST(
        100.0 * COUNT(DISTINCT t.id)
        / (SELECT COUNT(*) FROM titles) AS
        DECIMAL(10,2)
    ) AS pct_of_catalogue

FROM titles AS t

CROSS APPLY OPENJSON(REPLACE(t.genres, '''', '"')) AS jt

GROUP BY jt.value
ORDER BY total_titles DESC;