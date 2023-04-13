CREATE TABLE civicTurbo(
	id serial primary key not null,
	turbina VARCHAR(50) NOT NULL,
	HP Numeric(6, 2) NOT NULL
);
	
CREATE TABLE mazdaRXSete(
	id serial primary key not null,
	bodykit VARCHAR(50) NOT NULL,
	HP Numeric(6, 2) NOT NULL,
	quilometragem Numeric(6, 2) NOT NULL,
	rotores integer not null
);

INSERT INTO mazdaRXSete(bodykit, HP, quilometragem, rotores) VALUES	('Pandem', 1200, 6000, 8);
INSERT INTO mazdaRXSete(bodykit, HP, quilometragem, rotores) VALUES	('Libert Walk', 900, 1000, 5);

INSERT INTO civicTurbo(turbina, HP) VALUES ('G25-550', 580);
INSERT INTO civicTurbo(turbina, HP) VALUES ('HX35', 700);

CREATE INDEX JDM on mazdaRXSete(
	rotores
);

CREATE INDEX Vtec on civicTurbo(
	turbina
);

CREATE TABLE log_carro(
	id int primary key,
	mensagem VARCHAR(100),
	data_registro TIMESTAMP DEFAULT NOW()
);

CREATE OR REPLACE FUNCTION log_civicTurbo_func()
	RETURNS TRIGGER AS $$
		BEGIN
			INSERT INTO log_carro (mensagem) VALUES ('Nova linha inserida em civicTURBAO');
			RETURN NEW;	
		END;
	$$ LANGUAGE 'plpgsql';

CREATE TRIGGER tr_log_civicTurbo 
AFTER INSERT ON civicTurbo 
FOR EACH ROW 
EXECUTE PROCEDURE log_civicTurbo_func();

CREATE USER KeiichiTsuchiya encrypted password '123';
CREATE USER KeiMiura encrypted password '123';
CREATE USER WataruKatu encrypted password '123';

SELECT * FROM pg_catalog.pg_tables where schemaname = 'public';
SELECT * FROM pg_catalog.pg_indexes where schemaname = 'public';
SELECT * FROM pg_catalog.pg_user;
SELECT * FROM pg_catalog.pg_trigger;


