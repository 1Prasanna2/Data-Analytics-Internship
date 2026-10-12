-- Overall catalogue KPIs
SELECT 
	COUNT(*) AS total_titles,
	COUNT(DISTINCT id) AS unique_title_ids,

	SUM(CASE WHEN type = 'MOVIE' THEN 1 ELSE 0 END) AS total_movies,
	SUM(CASE WHEN type = 'SHOW' THEN 1 ELSE 0 END) AS total_shows,

	MIN(release_year) AS earliest_release_year,
	MAX(release_year) AS latest_release_year,
	COUNT(DISTINCT release_year) AS distinct_release_years,

	ROUND(AVG(imdb_score), 2) AS avg_imdb_score,
	ROUND(AVG(tmdb_score), 2) AS avg_tmdb_score,

	SUM(CASE WHEN imdb_score IS NULL THEN 1 ELSE 0 END) AS missing_imdb_scores,

	SUM(
		CASE WHEN age_certification IS NULL OR TRIM(age_certification) = '' THEN 1 ELSE 0 END
	) AS missing_certification_labels,

	CAST(
        100.0 * SUM(CASE WHEN imdb_score IS NULL THEN 1 ELSE 0 END) / COUNT(*) 
        AS DECIMAL(10,2)
    ) AS missing_imdb_score_pct,

    CAST(
        100.0 * SUM(CASE WHEN age_certification IS NULL OR TRIM(age_certification) = '' THEN 1 ELSE 0 END) / COUNT(*) 
        AS DECIMAL(10,2)
    ) AS missing_certification_pct

FROM titles;


