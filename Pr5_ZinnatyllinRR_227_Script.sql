CREATE TABLE film (
	id_film int4 NOT NULL,
	name_film varchar(255) NOT NULL,
	description varchar(2000) NOT NULL,
	CONSTRAINT film_pkey PRIMARY KEY (id_film)
);

-- Permissions

ALTER TABLE film OWNER TO postgres;
GRANT ALL ON TABLE film TO postgres;


-- public.hall определение

-- Drop table

-- DROP TABLE hall;

CREATE TABLE hall (
	id int4 NOT NULL,
	name_ varchar(100) NOT NULL,
	CONSTRAINT hall_pkey PRIMARY KEY (id)
);

-- Permissions

ALTER TABLE hall OWNER TO postgres;
GRANT ALL ON TABLE hall TO postgres;


-- public.hall_row определение

-- Drop table

-- DROP TABLE hall_row;

CREATE TABLE hall_row (
	id_hall int4 NOT NULL,
	number_ int2 NOT NULL,
	capacity int2 NOT NULL,
	CONSTRAINT hall_row_id_hall_fkey FOREIGN KEY (id_hall) REFERENCES hall(id)
);

-- Permissions

ALTER TABLE hall_row OWNER TO postgres;
GRANT ALL ON TABLE hall_row TO postgres;


-- public.screening определение

-- Drop table

-- DROP TABLE screening;

CREATE TABLE screening (
	id int4 NOT NULL,
	hall_id int4 NOT NULL,
	film_id int4 NOT NULL,
	time_ timestamp NOT NULL,
	CONSTRAINT screening_pkey PRIMARY KEY (id),
	CONSTRAINT screening_film_id_fkey FOREIGN KEY (film_id) REFERENCES film(id_film),
	CONSTRAINT screening_hall_id_fkey FOREIGN KEY (hall_id) REFERENCES hall(id)
);

-- Permissions

ALTER TABLE screening OWNER TO postgres;
GRANT ALL ON TABLE screening TO postgres;


-- public.tickets определение

-- Drop table

-- DROP TABLE tickets;

CREATE TABLE tickets (
	id_screening int4 NOT NULL,
	"row" int2 NOT NULL,
	seat int2 NOT NULL,
	"cost" int4 NOT NULL,
	CONSTRAINT tickets_pkey PRIMARY KEY ("row", seat),
	CONSTRAINT tickets_id_screening_fkey FOREIGN KEY (id_screening) REFERENCES screening(id)
);

-- Permissions

ALTER TABLE tickets OWNER TO postgres;
GRANT ALL ON TABLE tickets TO postgres;


-- public.filmname_time_ исходный текст

CREATE OR REPLACE VIEW filmname_time_
AS SELECT film.name_film,
    hall.name_,
    screening.time_
   FROM screening
     JOIN hall ON screening.hall_id = hall.id
     JOIN film ON screening.film_id = film.id_film
  WHERE film.name_film::text = 'Крёстный отец'::text;

-- Permissions

ALTER TABLE filmname_time_ OWNER TO postgres;
GRANT ALL ON TABLE filmname_time_ TO postgres;


-- public.films_showing_after_11am исходный текст

CREATE OR REPLACE VIEW films_showing_after_11am
AS SELECT film.name_film,
    screening.time_
   FROM screening
     JOIN film ON screening.film_id = film.id_film
  WHERE screening.time_ > '2021-01-01 11:00:00'::timestamp without time zone;

-- Permissions

ALTER TABLE films_showing_after_11am OWNER TO postgres;
GRANT ALL ON TABLE films_showing_after_11am TO postgres;


-- public.hall_film_time исходный текст

CREATE OR REPLACE VIEW hall_film_time
AS SELECT hall.name_,
    film.name_film,
    screening.time_
   FROM screening
     JOIN hall ON screening.hall_id = hall.id
     JOIN film ON screening.film_id = film.id_film;

-- Permissions

ALTER TABLE hall_film_time OWNER TO postgres;
GRANT ALL ON TABLE hall_film_time TO postgres;


-- public.hall_number_capacity исходный текст

CREATE OR REPLACE VIEW hall_number_capacity
AS SELECT hall.name_,
    hall_row.number_,
    hall_row.capacity
   FROM tickets
     JOIN hall ON tickets.id_screening = hall.id
     JOIN hall_row ON tickets.id_screening = hall_row.id_hall
  WHERE hall.name_::text = 'Третий большой зал'::text AND hall_row.number_ = '3'::smallint;

-- Permissions

ALTER TABLE hall_number_capacity OWNER TO postgres;
GRANT ALL ON TABLE hall_number_capacity TO postgres;




-- Permissions

GRANT ALL ON SCHEMA public TO pg_database_owner;
GRANT USAGE ON SCHEMA public TO public;

INSERT INTO public.film (id_film,name_film,description) VALUES
	 (1,'Крёстный отец','Криминальная сага, повествующая о мафиозной семье Корлеоне.'),
	 (2,'Титаник','Американская эпическая романтическая драма и фильм-катастрофа 1997 года'),
	 (3,'Форрест Гамп','Фильм 1994 года, экранизация одноимённого романа Уинстона Грума.'),
	 (4,'Собачье сердце','Научно-фантастический советский двухсерийный художественный телевизионный фильм');
INSERT INTO public.hall (id,name_) VALUES
	 (1,'Первый средний зал'),
	 (2,'Второй маленький зал'),
	 (3,'Третий большой зал'),
	 (4,'Четвертый средний зал');
INSERT INTO public.hall_row (id_hall,number_,capacity) VALUES
	 (1,1,25),
	 (2,2,10),
	 (3,3,40),
	 (4,4,25);
INSERT INTO public.screening (id,hall_id,film_id,time_) VALUES
	 (1,2,4,'2020-10-01 14:00:00'),
	 (2,1,3,'2019-10-01 16:30:00'),
	 (3,3,1,'2024-10-01 18:00:00'),
	 (4,4,2,'2023-10-01 20:15:00');
INSERT INTO public.tickets (id_screening,"row",seat,"cost") VALUES
	 (1,1,1,500),
	 (1,1,2,500),
	 (1,1,3,500),
	 (2,2,1,700),
	 (2,2,2,700),
	 (3,3,2,400),
	 (4,2,5,600);
