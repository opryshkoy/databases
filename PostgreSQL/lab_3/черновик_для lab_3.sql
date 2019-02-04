SELECT 'Юлия Яковлева';

-- Оконные функции

SELECT userid, movieid, rating,
(rating - MIN(rating) OVER (PARTITION BY userid))/(MAX(rating) OVER (PARTITION BY userid)) as normed_rating,
rating - AVG(rating) OVER (PARTITION BY userid) as avg_rating
FROM ratings
LIMIT 30;


-- ETL.Extract

ls $NETOLOGY_DATA/raw_data | grep keywords

psql -U postgres -c '
CREATE TABLE IF NOT EXISTS keywords1 (
id BIGINT,
tags TEXT 
)'


psql -U postgres -c "copy keywords1 FROM '/usr/local/share/netology/raw_data/keywords.csv' DELIMITER ',' CSV HEADER;"

psql -U postgres -c "SELECT  COUNT(*) FROM keywords1;"

psql -U postgres -c "\d keywords1;"


-- ETL.Transform

-- 1

SELECT
movieid,
AVG(rating)::numeric(10,2) as avg_rating
FROM public.ratings
GROUP BY movieid
HAVING COUNT(userid) > 50
ORDER BY
avg_rating DESC, 
movieid ASC
LIMIT 150;

-- 2

WITH top_rated as (
SELECT
movieid,
AVG(rating)::numeric(10,2) as avg_rating
FROM public.ratings
GROUP BY movieid
HAVING COUNT(userid) > 50
ORDER BY
avg_rating DESC, 
movieid ASC
LIMIT 150
)
SELECT *
FROM top_rated
JOIN public.keywords1
ON top_rated.movieid=keywords1.id;


-- ETL.Load

WITH top_rated as (
SELECT
movieid,
AVG(rating)::numeric(10,2) as avg_rating
FROM public.ratings
GROUP BY movieid
HAVING COUNT(userid) > 50
ORDER BY
avg_rating DESC, 
movieid ASC
LIMIT 150
)
SELECT *
INTO
new_table
FROM top_rated
JOIN public.keywords1
ON top_rated.movieid=keywords1.id;





\copy (SELECT * FROM new_table LIMIT 150) TO '/home/juliya/new_table_file.csv' WITH CSV HEADER DELIMITER as E'\t';

























