DROP TABLE IF EXISTS films, persons, persons2content;

CREATE TABLE films (
	id SERIAL PRIMARY KEY,
	title VARCHAR (128) NOT NULL,
	country VARCHAR (128) NOT NULL,
	box_office MONEY DEFAULT 0,
	release_year TIMESTAMP
);

CREATE TABLE persons (
	id SERIAL PRIMARY KEY,
	first_name VARCHAR (128) NOT NULL,
	second_name VARCHAR (128) NOT NULL
);

CREATE TABLE persons2content (
	id SERIAL PRIMARY KEY,
	person_id SERIAL REFERENCES persons (id),
	film_id SERIAL REFERENCES films (id),
	person_type VARCHAR (128) NOT NULL
);


INSERT INTO films (title, country, box_office, release_year) VALUES 
('Зеленая миля', 'США', 286801374, '1999-12-06'), 
('Побег из Шоушенка', 'США', 59841469, '1994-09-10'),
('Форрест Гамп', 'США', 677386686, '1994-06-23'),
('Авиатор', 'Германия,США', 213741459, '2004-12-14'),
('Остров проклятых', 'США', 294804195, '2010-02-13');

INSERT INTO persons (first_name, second_name) VALUES 
('Том', 'Хэнкс'), 
('Тим', 'Роббинс'),
('Том', 'Хэнкс'),
('Леонардо', 'ДиКаприо'),
('Леонардо', 'ДиКаприо');

INSERT INTO persons2content (person_id, film_id, person_type) VALUES 
(1, 1, 'Актер'), 
(2, 2, 'Актер'), 
(3, 3, 'Актер'), 
(4, 4, 'Актер'), 
(5, 5, 'Актер');


SELECT * FROM films;
SELECT * FROM persons;
SELECT * FROM persons2content;
