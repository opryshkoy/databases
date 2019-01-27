CREATE TABLE films (
	title VARCHAR (128) NOT NULL,
	id SERIAL PRIMARY KEY,
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



