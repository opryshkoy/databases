SELECT 'Юлия Яковлева';

--1.1
SELECT * FROM public.ratings
LIMIT 10;

-- 1.2
SELECT *
FROM public.links
WHERE
imdbid like '%42'
AND movieid BETWEEN 100 AND 1000
LIMIT 10;

--2.1
SELECT 
imdbid
FROM public.links
JOIN public.ratings
ON links.movieid=ratings.movieid
WHERE ratings.rating = 5
LIMIT 10;

--3.1
SELECT
COUNT(links.movieid)
FROM public.links
LEFT JOIN public.ratings
ON links.movieid=ratings.movieid
WHERE ratings.movieid IS NULL;

--3.2
SELECT
userid,
COUNT(rating) as activity,
AVG(rating) as avg_rating
FROM public.ratings
GROUP BY userid
HAVING AVG(rating) > 3.5
ORDER BY activity DESC
LIMIT 10;

--4.1
SELECT 
imdbid
FROM public.links
WHERE links.movieid IN (
SELECT
ratings.movieid
FROM public.ratings
GROUP BY ratings.movieid
HAVING AVG(rating) > 3.5	
	)
LIMIT 10;

--4.2
WITH avg_rating
AS (
SELECT 
rating,
COUNT(rating)
FROM public.ratings
GROUP BY rating
HAVING COUNT(rating) > 10
)
SELECT
AVG(rating) as avg_rating
from avg_rating;

