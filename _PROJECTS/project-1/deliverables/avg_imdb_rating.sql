USE project_1;

-- Average IMDb rating by decade and format
SELECT
		(release_year / 10) * 10 AS release_decade,
		type,
		
		COUNT(*) AS qualifying_titles,

		CAST(AVG(imdb_score) AS DECIMAL(10,2)) AS mean_imdb_score,
		CAST(AVG(tmdb_score) AS DECIMAL(10,2)) AS mean_tmdb_score,

		SUM(CASE WHEN tmdb_score IS NOT NULL THEN 1 ELSE 0 END) AS titles_with_tmdb_score
		
FROM titles
WHERE release_year IS NOT NULL
	AND imdb_votes >= 100
	AND imdb_score IS NOT NULL

GROUP BY (release_year / 10) * 10, type
ORDER BY release_decade, type;