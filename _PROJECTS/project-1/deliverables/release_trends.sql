-- Release trends by decade and content type

WITH decade_counts AS(
	 SELECT 
			(release_year / 10) * 10 AS release_decade,
			type,
			COUNT(DISTINCT id) AS title_count
	 FROM titles
	 WHERE release_year IS NOT NULL
	 GROUP BY 
			(release_year / 10) * 10,
			type
)

SELECT
	release_decade,
	CONCAT(release_decade, 's') AS decade_label,
	type,
	title_count,
	CAST(
		100.0 * title_count / 
		SUM(title_count) OVER(PARTITION BY release_decade) AS DECIMAL(10,2)
	) AS pct_of_decade

FROM decade_counts
ORDER BY release_decade, type;








