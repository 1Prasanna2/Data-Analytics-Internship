-- Top directors by number of titles
WITH director_titles AS (
    SELECT DISTINCT
        c.person_id,
        c.name,
        t.id AS title_id,
        t.type,
        t.imdb_score

    FROM credits AS c

    INNER JOIN titles AS t
        ON c.id = t.id

    WHERE c.role = 'DIRECTOR'
)

SELECT TOP 10
    person_id,
    name,

    COUNT(DISTINCT title_id) AS titles_directed,

    COUNT(
        DISTINCT CASE
            WHEN type = 'MOVIE' THEN title_id
        END
    ) AS movies_directed,

    COUNT(
        DISTINCT CASE
            WHEN type = 'SHOW' THEN title_id
        END
    ) AS shows_directed,

    CAST(AVG(imdb_score) AS DECIMAL(10,2)) AS avg_imdb_score

FROM director_titles

GROUP BY person_id, name

HAVING COUNT(DISTINCT title_id) >= 3

ORDER BY titles_directed DESC;
