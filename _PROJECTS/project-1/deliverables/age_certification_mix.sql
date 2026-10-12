-- Age-certification mix by movie and show

WITH certification_counts AS(
	SELECT
		type,

		COALESCE(
			NULLIF(TRIM(age_certification), ''),
			'Missing / no label'
		) AS certification,

		COUNT(*) AS title_count

		FROM titles

		GROUP BY type,
		COALESCE(NULLIF(TRIM(age_certification), ''), 'Missing / no label')
)

SELECT 
	type,
	certification,
	title_count,

	CAST(	
		100.0 * title_count
		/ SUM(title_count) OVER(PARTITION BY type) AS DECIMAL(10,2)
	) AS pct_within_type

FROM certification_counts
ORDER BY type, title_count DESC;