#@(#) script.ddl

DROP TABLE IF EXISTS UzsakymoPreke;
DROP TABLE IF EXISTS pristatoSiunta;
DROP TABLE IF EXISTS Siunta;
DROP TABLE IF EXISTS Preke;
DROP TABLE IF EXISTS Uzsakymas;
DROP TABLE IF EXISTS SportoSakosIrankioKategorija;
DROP TABLE IF EXISTS SiuntuPervezimoTarnyba;
DROP TABLE IF EXISTS Saskaita;
DROP TABLE IF EXISTS TransportoPriemones;
DROP TABLE IF EXISTS Spalva;
DROP TABLE IF EXISTS Sezonas;
DROP TABLE IF EXISTS PristatymoBudas;
DROP TABLE IF EXISTS PakuotesDydis;
DROP TABLE IF EXISTS MokejimoBudas;
DROP TABLE IF EXISTS Busena;
DROP TABLE IF EXISTS SportoSaka;
DROP TABLE IF EXISTS Pirkejas;
DROP TABLE IF EXISTS AptarnaujantisAsistentas;

CREATE TABLE AptarnaujantisAsistentas
(
	tabelioNr varchar (255),
	vardas varchar (255),
	pavarde varchar (255),
	telefonas varchar (255),
	el_pastas varchar (255),
	PRIMARY KEY(tabelioNr)
);

CREATE TABLE Pirkejas
(
	kodas varchar (255),
	prisijungimoVardas varchar (255),
	slaptazodis varchar (255),
	vardas varchar (255),
	pavarde varchar (255),
	telefonas varchar (255),
	el_pastas varchar (255),
	adresas varchar (255),
	PRIMARY KEY(kodas)
);

CREATE TABLE SportoSaka
(
	pavadinimas varchar (255),
	kilmesSalis varchar (255),
	id_SportoSaka integer,
	PRIMARY KEY(id_SportoSaka)
);

CREATE TABLE Busena
(
	id_Busena integer,
	name char (8) NOT NULL,
	PRIMARY KEY(id_Busena)
);
INSERT INTO Busena(id_Busena, name) VALUES(1, 'nauja');
INSERT INTO Busena(id_Busena, name) VALUES(2, 'naudota');
INSERT INTO Busena(id_Busena, name) VALUES(3, 'brokuota');

CREATE TABLE MokejimoBudas
(
	id_MokejimoBudas integer,
	name char (14) NOT NULL,
	PRIMARY KEY(id_MokejimoBudas)
);
INSERT INTO MokejimoBudas(id_MokejimoBudas, name) VALUES(1, 'grynaisiais');
INSERT INTO MokejimoBudas(id_MokejimoBudas, name) VALUES(2, 'bankoPavedimu');
INSERT INTO MokejimoBudas(id_MokejimoBudas, name) VALUES(3, 'kreditoKortele');
INSERT INTO MokejimoBudas(id_MokejimoBudas, name) VALUES(4, 'pastomatu');

CREATE TABLE PakuotesDydis
(
	id_PakuotesDydis integer,
	name char (9) NOT NULL,
	PRIMARY KEY(id_PakuotesDydis)
);
INSERT INTO PakuotesDydis(id_PakuotesDydis, name) VALUES(1, 'mazas');
INSERT INTO PakuotesDydis(id_PakuotesDydis, name) VALUES(2, 'vidutinis');
INSERT INTO PakuotesDydis(id_PakuotesDydis, name) VALUES(3, 'didelis');

CREATE TABLE PristatymoBudas
(
	id_PristatymoBudas integer,
	name char (19) NOT NULL,
	PRIMARY KEY(id_PristatymoBudas)
);
INSERT INTO PristatymoBudas(id_PristatymoBudas, name) VALUES(1, 'pastomatas');
INSERT INTO PristatymoBudas(id_PristatymoBudas, name) VALUES(2, 'kurjeris');
INSERT INTO PristatymoBudas(id_PristatymoBudas, name) VALUES(3, 'pastas');
INSERT INTO PristatymoBudas(id_PristatymoBudas, name) VALUES(4, 'atsiemimasSandelyje');

CREATE TABLE Sezonas
(
	id_Sezonas integer,
	name char (11) NOT NULL,
	PRIMARY KEY(id_Sezonas)
);
INSERT INTO Sezonas(id_Sezonas, name) VALUES(1, 'ziemos');
INSERT INTO Sezonas(id_Sezonas, name) VALUES(2, 'vasaros');
INSERT INTO Sezonas(id_Sezonas, name) VALUES(3, 'universalus');

CREATE TABLE Spalva
(
	id_Spalva integer,
	name char (9) NOT NULL,
	PRIMARY KEY(id_Spalva)
);
INSERT INTO Spalva(id_Spalva, name) VALUES(1, 'balta');
INSERT INTO Spalva(id_Spalva, name) VALUES(2, 'juoda');
INSERT INTO Spalva(id_Spalva, name) VALUES(3, 'ruda');
INSERT INTO Spalva(id_Spalva, name) VALUES(4, 'purpurine');
INSERT INTO Spalva(id_Spalva, name) VALUES(5, 'rozine');
INSERT INTO Spalva(id_Spalva, name) VALUES(6, 'raudona');
INSERT INTO Spalva(id_Spalva, name) VALUES(7, 'oranzine');
INSERT INTO Spalva(id_Spalva, name) VALUES(8, 'geltona');
INSERT INTO Spalva(id_Spalva, name) VALUES(9, 'salotine');
INSERT INTO Spalva(id_Spalva, name) VALUES(10, 'zalia');
INSERT INTO Spalva(id_Spalva, name) VALUES(11, 'elektrine');
INSERT INTO Spalva(id_Spalva, name) VALUES(12, 'zydra');
INSERT INTO Spalva(id_Spalva, name) VALUES(13, 'melyna');
INSERT INTO Spalva(id_Spalva, name) VALUES(14, 'indigas');
INSERT INTO Spalva(id_Spalva, name) VALUES(15, 'violetine');
INSERT INTO Spalva(id_Spalva, name) VALUES(16, 'spalvota');

CREATE TABLE TransportoPriemones
(
	id_TransportoPriemones integer,
	name char (14) NOT NULL,
	PRIMARY KEY(id_TransportoPriemones)
);
INSERT INTO TransportoPriemones(id_TransportoPriemones, name) VALUES(1, 'autobusas');
INSERT INTO TransportoPriemones(id_TransportoPriemones, name) VALUES(2, 'mikroautobusas');
INSERT INTO TransportoPriemones(id_TransportoPriemones, name) VALUES(3, 'laivas');
INSERT INTO TransportoPriemones(id_TransportoPriemones, name) VALUES(4, 'automobilis');
INSERT INTO TransportoPriemones(id_TransportoPriemones, name) VALUES(5, 'lektuvas');
INSERT INTO TransportoPriemones(id_TransportoPriemones, name) VALUES(6, 'dviratis');

CREATE TABLE Saskaita
(
	nr varchar (255),
	data date,
	suma double,
	mokejimoData date,
	mokejimoBudas integer,
	fk_Pirkejaskodas varchar (255) NOT NULL,
	fk_AptarnaujantisAsistentastabelioNr varchar (255) NOT NULL,
	PRIMARY KEY(nr),
	FOREIGN KEY(mokejimoBudas) REFERENCES MokejimoBudas (id_MokejimoBudas),
	CONSTRAINT apmoka FOREIGN KEY(fk_Pirkejaskodas) REFERENCES Pirkejas (kodas),
	CONSTRAINT israso FOREIGN KEY(fk_AptarnaujantisAsistentastabelioNr) REFERENCES AptarnaujantisAsistentas (tabelioNr)
);

CREATE TABLE SiuntuPervezimoTarnyba
(
	pavadinimas varchar (255),
	transportoPriemonesTalpa double,
	pristatymoGreitisValandomis int,
	transportoPriemoniuKiekis int,
	laukimoTarifasUzValanda double,
	transportoPriemone integer,
	id_SiuntuPervezimoTarnyba integer,
	PRIMARY KEY(id_SiuntuPervezimoTarnyba),
	FOREIGN KEY(transportoPriemone) REFERENCES TransportoPriemones (id_TransportoPriemones)
);

CREATE TABLE SportoSakosIrankioKategorija
(
	pavadinimas varchar (255),
	id_SportoSakosIrankioKategorija integer,
	fk_SportoSakaid_SportoSaka integer NOT NULL,
	PRIMARY KEY(id_SportoSakosIrankioKategorija),
	CONSTRAINT apima FOREIGN KEY(fk_SportoSakaid_SportoSaka) REFERENCES SportoSaka (id_SportoSaka)
);

CREATE TABLE Uzsakymas
(
	uzsakymoNumeris varchar (255),
	uzsakymoData date,
	nuolaida double,
	nuolaidosKodas varchar (255),
	transportavimoKaina double,
	prekiuKiekis int,
	pristatymoBudas integer,
	fk_AptarnaujantisAsistentastabelioNr varchar (255) NOT NULL,
	fk_Pirkejaskodas varchar (255) NOT NULL,
	PRIMARY KEY(uzsakymoNumeris),
	FOREIGN KEY(pristatymoBudas) REFERENCES PristatymoBudas (id_PristatymoBudas),
	CONSTRAINT patvirtina FOREIGN KEY(fk_AptarnaujantisAsistentastabelioNr) REFERENCES AptarnaujantisAsistentas (tabelioNr),
	CONSTRAINT pateikia FOREIGN KEY(fk_Pirkejaskodas) REFERENCES Pirkejas (kodas)
);

CREATE TABLE Preke
(
	kodas varchar (255),
	pavadinimas varchar (255),
	kaina double,
	aprasymas varchar (255),
	pagaminimoData date,
	garantija double,
	kilmesSalis varchar (255),
	busena integer,
	sezonas integer,
	spalva integer,
	fk_SportoSakosIrankioKategorijaid_SportoSakosIrankioKategorija integer NOT NULL,
	PRIMARY KEY(kodas),
	FOREIGN KEY(busena) REFERENCES Busena (id_Busena),
	FOREIGN KEY(sezonas) REFERENCES Sezonas (id_Sezonas),
	FOREIGN KEY(spalva) REFERENCES Spalva (id_Spalva),
	CONSTRAINT turi FOREIGN KEY(fk_SportoSakosIrankioKategorijaid_SportoSakosIrankioKategorija) REFERENCES SportoSakosIrankioKategorija (id_SportoSakosIrankioKategorija)
);

CREATE TABLE Siunta
(
	kodas varchar (255),
	svoris double,
	pristatymoData date,
	gavejoAdresas varchar (255),
	draudimoKaina double,
	pakuotesDydis integer,
	fk_AptarnaujantisAsistentastabelioNr varchar (255) NOT NULL,
	fk_SiuntuPervezimoTarnybaid_SiuntuPervezimoTarnyba integer NOT NULL,
	fk_UzsakymasuzsakymoNumeris varchar (255) NOT NULL,
	fk_Pirkejaskodas varchar (255) NOT NULL,
	PRIMARY KEY(kodas),
	UNIQUE(fk_UzsakymasuzsakymoNumeris),
	FOREIGN KEY(pakuotesDydis) REFERENCES PakuotesDydis (id_PakuotesDydis),
	CONSTRAINT paruosia FOREIGN KEY(fk_AptarnaujantisAsistentastabelioNr) REFERENCES AptarnaujantisAsistentas (tabelioNr),
	CONSTRAINT paima FOREIGN KEY(fk_SiuntuPervezimoTarnybaid_SiuntuPervezimoTarnyba) REFERENCES SiuntuPervezimoTarnyba (id_SiuntuPervezimoTarnyba),
	CONSTRAINT itraukiamasI FOREIGN KEY(fk_UzsakymasuzsakymoNumeris) REFERENCES Uzsakymas (uzsakymoNumeris),
	CONSTRAINT pasiima FOREIGN KEY(fk_Pirkejaskodas) REFERENCES Pirkejas (kodas)
);

CREATE TABLE pristatoSiunta
(
	fk_Pirkejaskodas varchar (255),
	fk_SiuntuPervezimoTarnybaid_SiuntuPervezimoTarnyba integer,
	PRIMARY KEY(fk_Pirkejaskodas, fk_SiuntuPervezimoTarnybaid_SiuntuPervezimoTarnyba),
	CONSTRAINT pristatoSiunta FOREIGN KEY(fk_Pirkejaskodas) REFERENCES Pirkejas (kodas)
);

CREATE TABLE UzsakymoPreke
(
	kiekis int,
	fk_UzsakymasuzsakymoNumeris varchar (255) NOT NULL,
	fk_Prekekodas varchar (255) NOT NULL,
	CONSTRAINT sudarytasIs FOREIGN KEY(fk_UzsakymasuzsakymoNumeris) REFERENCES Uzsakymas (uzsakymoNumeris),
	CONSTRAINT itrauktaI FOREIGN KEY(fk_Prekekodas) REFERENCES Preke (kodas)
);
