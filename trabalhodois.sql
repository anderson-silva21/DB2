-- Database: empresa

-- DROP DATABASE IF EXISTS empresa;

CREATE DATABASE empresa
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'Portuguese_Brazil.1252'
    LC_CTYPE = 'Portuguese_Brazil.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;
	
	-- CRIAR BANCO DE DADOS COM USUARIO POSTGREE
-- create database atividade2;
--------------------------------------------

-- CRIAR TABELAS COM USUARIO POSTGREE
CREATE TABLE empregado (
	SSN  int
	,pnome varchar(20)
	,minicial varchar(50)
	,unome int
	,datanasc date
	,endereco varchar(200)
	,sexo varchar(1)
	,salario real
	,superssn int
	,dno int
);

CREATE TABLE departamento (
	dnumero  int
	,dnome varchar(20)
	,gerssn int
	,gerdatainicio date
);
	
CREATE TABLE depto_localizacoes (
	dlocalizacao  int
	,dnumero  int
);

CREATE TABLE projeto (
	pnumero  int
	,pjnome varchar(20)
	,dnum int
	,plocalizacao varchar(200)
);

CREATE TABLE trabalha_em (
	pno  int
	,essn int
	,horas time
);

CREATE TABLE dependente (
	essn  int
	,nome_dependente varchar(20)
	,datanasc date
	,parentesco varchar(50)
	,sexo varchar(1)
);
--------------------------------------------
-- CRIAR USUÁRIOS COM USUARIO POSTGREE
create user userA encrypted password '123'; -- pode recuperar ou modificar quaisquer relaçoes exceto dependentes e pode conceder privilégios para outros usuários. 
create user userB encrypted password '123'; -- pode recuperar todos os atributos de empregado e departamento, exceto salario, o numero de seguro social do gerente e a data de inicio do gerente. 
create user userC encrypted password '123'; -- pode recuperar ou modificar TRABALHA_EM, porem, pode apenas recuperar os atributos PNOME, INICIALM,UNOME e NUMEROD0SEGUROSOCIAl de EMPREGADO e os atributos NOMEP e NUMEROP de PROJETO 
create user userD encrypted password '123'; -- pode recuperar qualquer atributo de EMPREGADO ou dependente e pode modificar DEPENDENTE. 
create user userE encrypted password '123'; -- Pode recuperar qualquer atributo de EMPREGADO, porém, somente para as tuplas de EMPREGADO que possuam DNO = 3. 

SELECT * FROM pg_catalog.pg_user;
alter user postgres;
--a
GRANT SELECT, INSERT, UPDATE, DELETE ON empregado, departamento, depto_localizacoes, projeto, trabalha_em TO userA WITH GRANT OPTION;
--teste
set role userA;

INSERT INTO empregado (
	SSN  
	,pnome 
	,minicial 
	,unome 
	,datanasc 
	,endereco 
	,sexo 
	,salario 
	,superssn 
	,dno 
)VALUES(
	1,
	'mari',
	'teste',
	1,
	'2001-09-28',
	'apucarana',
	'f',
	10000,
	1,
	3
);


INSERT INTO empregado (
	SSN  
	,pnome 
	,minicial 
	,unome 
	,datanasc 
	,endereco 
	,sexo 
	,salario 
	,superssn 
	,dno 
)VALUES(
	1,
	'caio',
	'teste',
	1,
	'2001-09-29',
	'apucarana',
	'm',
	100,
	1,
	1
);

--b
GRANT SELECT (ssn, pnome, minicial, unome, datanasc, endereco, sexo, superssn, dno) ON empregado TO userB;
GRANT SELECT (dnumero, dnome) ON departamento TO userB;
--teste
set role userB;

select ssn from empregado;
select salario from empregado;
--c
GRANT SELECT, INSERT, UPDATE, DELETE ON trabalha_em TO userC WITH GRANT OPTION;
GRANT SELECT (PNOME, MINICIAL, UNOME, SSN) ON empregado  TO userC WITH GRANT OPTION;
GRANT SELECT (PJNOME, PNUMERO) ON projeto TO userC WITH GRANT OPTION;
--teste
set role userC;
select PNOME, MINICIAL, UNOME, SSN from empregado;
select * from trabalha_em;
select PJNOME, PNUMERO from projeto;
--d
GRANT SELECT ON empregado TO userD;
GRANT SELECT, INSERT, UPDATE, DELETE ON dependente TO userD;
--teste
set role userD;
select * from empregado;
select * from dependente;
insert into dependente (essn, nome_dependente, datanasc, parentesco, sexo) 
values (5, 'jorge', '1998-05-06', 'filho', 'm');
--e
CREATE VIEW empregado_dno_3 AS SELECT * FROM empregado WHERE DNO = 3;
GRANT SELECT ON empregado_dno_3 TO userE;
--teste
set role userE;
select * from empregado_dno_3;

