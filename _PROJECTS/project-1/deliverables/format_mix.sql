USE project_1;

-- Country-level volume, ratings and format mix
WITH base AS (
	SELECT
			id, 
			type,
			imdb_score,
			imdb_votes,

			COALESCE(
				JSON_VALUE(
						REPLACE(COALESCE(production_countries, '[]'), '''', '"'),
						'$[0]'
				),
				'Unknown'
			) AS lead_country
	FROM titles
),
volume AS (
	SELECT
		lead_country,
		COUNT(*) AS title_count,

		CAST( 100.0 * AVG(CASE WHEN type='SHOW' THEN 1.0 ELSE 0.0 END) 
		AS DECIMAL(10,2)) AS show_share_pct
	FROM base
	GROUP BY lead_country
),
rated_ranked AS (
	SELECT
		lead_country,
		imdb_score,
		imdb_votes,

		ROW_NUMBER() OVER(PARTITION BY lead_country ORDER BY imdb_score) AS score_rn,
		
		ROW_NUMBER() OVER(PARTITION BY lead_country ORDER BY imdb_votes) AS votes_rn,

		COUNT(*) OVER(PARTITION BY lead_country) AS rated_n
	FROM base
	WHERE imdb_votes >= 100 AND imdb_score IS NOT NULL
),
quality AS(
	SELECT 
		lead_country,
		MAX(rated_n) AS rated_n,
		
		AVG(CASE WHEN score_rn IN(
					  FLOOR((rated_n + 1) / 2.0),
					  FLOOR((rated_n + 2) / 2.0)
			) THEN imdb_score
			END
		) AS median_imdb_score,

		AVG(CASE WHEN votes_rn IN(
					  FLOOR((rated_n + 1) / 2.0),
					  FLOOR((rated_n + 2) / 2.0)
			) THEN imdb_votes
			END
		) AS median_imdb_votes
	FROM rated_ranked
	GROUP BY lead_country
)

SELECT
	v.lead_country,
	v.title_count,
	q.rated_n,

	CAST(q.median_imdb_score AS DECIMAL(10,2)) AS median_imdb_score,

	CAST(q.median_imdb_votes AS DECIMAL(10,0)) AS median_imdb_votes,
	
	v.show_share_pct 
FROM volume AS v

LEFT JOIN quality AS q
	ON v.lead_country = q.lead_country

WHERE v.title_count >= 10
	AND q.rated_n >= 3

ORDER BY v.title_count DESC;

