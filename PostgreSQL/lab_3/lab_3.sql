SELECT 'Юлия Яковлева';


-- Оконные функции

SELECT userid, movieid, rating,
(rating - MIN(rating) OVER (PARTITION BY userid))/(MAX(rating) OVER (PARTITION BY userid)) as normed_rating,
rating - AVG(rating) OVER (PARTITION BY userid) as avg_rating
FROM ratings
LIMIT 30;


-- Создание таблицы

CREATE TABLE IF NOT EXISTS keywords1 (
id BIGINT,
tags TEXT 
)


-- Заливка данных в таблицу

\copy keywords1 FROM '/usr/local/share/netology/raw_data/keywords.csv' DELIMITER ',' CSV HEADER;


-- Запрос 3

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
top_rated_tags
FROM top_rated
JOIN public.keywords1
ON top_rated.movieid=keywords1.id;


-- Загрузка таблицы в файл

\copy (SELECT * FROM top_rated_tags LIMIT 150) TO '~/databases/PostgreSQL/lab_3/top_rated_tags_file.csv' WITH CSV HEADER DELIMITER as E'\t';

























