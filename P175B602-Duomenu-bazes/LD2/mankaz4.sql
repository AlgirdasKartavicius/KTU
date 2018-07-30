-- phpMyAdmin SQL Dump
-- version 3.4.11.1deb2+deb7u2
-- http://www.phpmyadmin.net
--
-- Darbinė stotis: localhost
-- Atlikimo laikas: 2016 m. Geg 12 d. 08:40
-- Serverio versija: 1.0.23
-- PHP versija: 5.4.45-0+deb7u2

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Duomenų bazė: `mankaz4`
--

-- --------------------------------------------------------

--
-- Sukurta duomenų struktūra lentelei `aiksteles`
--

CREATE TABLE IF NOT EXISTS `aiksteles` (
  `id` int(11) NOT NULL,
  `pavadinimas` varchar(40) NOT NULL,
  `adresas` text NOT NULL,
  `fk_miestas` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fkc_vieta` (`fk_miestas`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Sukurta duomenų kopija lentelei `aiksteles`
--

INSERT INTO `aiksteles` (`id`, `pavadinimas`, `adresas`, `fk_miestas`) VALUES
(1, 'Vilniaus oro uostas', 'Ten ir taip', 1),
(2, 'Kauno oro uostas', '', 2),
(3, 'Vilniaus geležinkelio stotis', '', 1),
(4, 'Kauno geležinkelio stotis', '', 2),
(5, 'Palangos oro uostas', '', 3);

-- --------------------------------------------------------

--
-- Sukurta duomenų struktūra lentelei `AptarnaujantisAsistentas`
--

CREATE TABLE IF NOT EXISTS `AptarnaujantisAsistentas` (
  `tabelioNr` varchar(255) NOT NULL DEFAULT '',
  `vardas` varchar(255) DEFAULT NULL,
  `pavarde` varchar(255) DEFAULT NULL,
  `telefonas` varchar(255) DEFAULT NULL,
  `el_pastas` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`tabelioNr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Sukurta duomenų kopija lentelei `AptarnaujantisAsistentas`
--

INSERT INTO `AptarnaujantisAsistentas` (`tabelioNr`, `vardas`, `pavarde`, `telefonas`, `el_pastas`) VALUES
('A01', 'Mintvydas', 'Gardutis', '+37062598736', 'mintvydas.gardutis@eshop.lt'),
('A02', 'Kazys', 'Saja', '+37068945712', 'kazys.saja@eshop.lt'),
('A03', 'Rusnė', 'Barakauskienė', '+37065689710', 'rusne.barakauskiene@eshop.lt'),
('A04', 'Liepa', 'Mendelytė', '+37065897462', 'liepa.mendelyte@eshop.lt'),
('A05', 'Alvydas', 'Poškus', '+37064587965', 'alvydas.poskus@eshop.lt'),
('A06', 'Gardevutis', 'Ibizas', '+37062598423', 'gardevutis.ibizas@eshop.lt'),
('A07', 'Irena', 'Vainytė', '+37064597820', 'irena.vainyte@eshop.lt'),
('A08', 'Antanas', 'Nedzys', '+37067410324', 'antanas.nedzys@eshop.lt'),
('A09', 'Petras', 'Raibys', '+37069823589', 'petras.raibys@eshop.lt'),
('A10', 'Gintarė', 'Burbytė', '+37066589745', 'gintare.burbyte@eshop.lt');

-- --------------------------------------------------------

--
-- Sukurta duomenų struktūra lentelei `automobiliai`
--

CREATE TABLE IF NOT EXISTS `automobiliai` (
  `id` int(11) NOT NULL,
  `valstybinis_nr` char(6) NOT NULL,
  `pagaminimo_data` date NOT NULL,
  `rida` int(11) NOT NULL,
  `radijas` tinyint(1) NOT NULL,
  `grotuvas` tinyint(1) NOT NULL,
  `kondicionierius` tinyint(1) NOT NULL,
  `vietu_skaicius` smallint(6) NOT NULL,
  `registravimo_data` date NOT NULL,
  `verte` decimal(8,2) NOT NULL,
  `pavaru_deze` int(11) NOT NULL,
  `degalu_tipas` int(11) NOT NULL,
  `kebulas` int(11) NOT NULL,
  `bagazo_dydis` int(11) NOT NULL,
  `busena` int(11) DEFAULT NULL,
  `fk_modelis` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `pavaru_deze` (`pavaru_deze`),
  KEY `degalu_tipas` (`degalu_tipas`),
  KEY `kebulas` (`kebulas`),
  KEY `bagazo_dydis` (`bagazo_dydis`),
  KEY `busena` (`busena`),
  KEY `fkc_modelis` (`fk_modelis`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Sukurta duomenų kopija lentelei `automobiliai`
--

INSERT INTO `automobiliai` (`id`, `valstybinis_nr`, `pagaminimo_data`, `rida`, `radijas`, `grotuvas`, `kondicionierius`, `vietu_skaicius`, `registravimo_data`, `verte`, `pavaru_deze`, `degalu_tipas`, `kebulas`, `bagazo_dydis`, `busena`, `fk_modelis`) VALUES
(1, 'GBA545', '2016-01-29', 120000, 1, 1, 1, 5, '2016-02-21', 15000.00, 2, 1, 8, 7, 2, 11),
(2, 'GBA545', '2015-12-21', 15693, 1, 1, 1, 5, '2016-01-01', 15000.00, 1, 1, 2, 4, 2, 17),
(4, 'ABK165', '2009-01-01', 12000, 1, 0, 0, 5, '2010-01-01', 12000.00, 2, 3, 8, 7, 1, 3),
(5, 'ABS365', '2015-06-07', 1000, 1, 1, 0, 5, '2016-01-01', 10000.00, 1, 3, 2, 2, 1, 2),
(6, 'DFG989', '2013-01-01', 23654, 1, 1, 1, 5, '2013-06-01', 18000.00, 1, 3, 3, 7, 1, 1),
(7, 'GDF698', '2014-02-04', 35000, 1, 1, 1, 5, '2014-06-15', 13000.00, 2, 1, 8, 6, 1, 10),
(8, 'GCB699', '2013-12-10', 25000, 1, 1, 1, 4, '2014-01-05', 14500.00, 2, 1, 2, 5, 1, 12),
(9, 'FDR654', '2013-06-05', 18659, 1, 1, 1, 4, '2013-09-08', 16500.00, 1, 3, 2, 5, 1, 21),
(10, 'DRF546', '2011-05-06', 85600, 1, 1, 1, 5, '2011-07-15', 4500.00, 2, 1, 3, 7, 1, 11),
(11, 'FDS656', '2011-12-10', 98655, 1, 0, 1, 4, '2012-01-16', 4000.00, 1, 1, 2, 5, 2, 12),
(12, 'DHN356', '2011-01-01', 298606, 1, 0, 0, 5, '2011-03-05', 4500.00, 2, 3, 8, 7, 1, 3);

-- --------------------------------------------------------

--
-- Sukurta duomenų struktūra lentelei `auto_busenos`
--

CREATE TABLE IF NOT EXISTS `auto_busenos` (
  `id` int(11) NOT NULL,
  `name` char(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Sukurta duomenų kopija lentelei `auto_busenos`
--

INSERT INTO `auto_busenos` (`id`, `name`) VALUES
(1, 'laisvas'),
(2, 'išnuomotas'),
(3, 'remonte'),
(4, 'tikrinamas');

-- --------------------------------------------------------

--
-- Sukurta duomenų struktūra lentelei `Busena`
--

CREATE TABLE IF NOT EXISTS `Busena` (
  `id` int(11) NOT NULL DEFAULT '0',
  `name` char(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Sukurta duomenų kopija lentelei `Busena`
--

INSERT INTO `Busena` (`id`, `name`) VALUES
(1, 'Nauja'),
(2, 'Naudota'),
(3, 'Brokuota');

-- --------------------------------------------------------

--
-- Sukurta duomenų struktūra lentelei `darbuotojai`
--

CREATE TABLE IF NOT EXISTS `darbuotojai` (
  `tabelio_nr` char(6) NOT NULL,
  `vardas` varchar(20) NOT NULL,
  `pavarde` varchar(20) NOT NULL,
  PRIMARY KEY (`tabelio_nr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Sukurta duomenų kopija lentelei `darbuotojai`
--

INSERT INTO `darbuotojai` (`tabelio_nr`, `vardas`, `pavarde`) VALUES
('A56568', 'Mantas', 'Titas'),
('A6564d', 'Tomas', 'Kasauskas'),
('A65656', 'Marta', 'Gasiulytė'),
('A6575D', 'Nerijus', 'Linkus'),
('A65DFG', 'Marius', 'Kasparas'),
('A665F', 'Aurimas', 'Nikas'),
('A698GF', 'Tadas', 'Linikas'),
('A6998d', 'Greta', 'Lingytė');

-- --------------------------------------------------------

--
-- Sukurta duomenų struktūra lentelei `degalu_tipai`
--

CREATE TABLE IF NOT EXISTS `degalu_tipai` (
  `id` int(11) NOT NULL,
  `name` char(16) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Sukurta duomenų kopija lentelei `degalu_tipai`
--

INSERT INTO `degalu_tipai` (`id`, `name`) VALUES
(1, 'benzinas'),
(2, 'benzinas/elektra'),
(3, 'dyzelis'),
(4, 'dujos'),
(5, 'elektra');

-- --------------------------------------------------------

--
-- Sukurta duomenų struktūra lentelei `kebulu_tipai`
--

CREATE TABLE IF NOT EXISTS `kebulu_tipai` (
  `id` int(11) NOT NULL,
  `name` char(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Sukurta duomenų kopija lentelei `kebulu_tipai`
--

INSERT INTO `kebulu_tipai` (`id`, `name`) VALUES
(1, 'sedanas'),
(2, 'hečbekas'),
(3, 'universalas'),
(4, 'visureigis'),
(5, 'pikapas'),
(6, 'coupe'),
(7, 'kabrioletas'),
(8, 'vienatūris');

-- --------------------------------------------------------

--
-- Sukurta duomenų struktūra lentelei `klientai`
--

CREATE TABLE IF NOT EXISTS `klientai` (
  `asmens_kodas` char(11) NOT NULL,
  `vardas` varchar(20) NOT NULL,
  `pavarde` varchar(20) NOT NULL,
  `gimimo_data` date NOT NULL,
  `telefonas` varchar(20) NOT NULL,
  `epastas` varchar(40) NOT NULL,
  PRIMARY KEY (`asmens_kodas`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Sukurta duomenų kopija lentelei `klientai`
--

INSERT INTO `klientai` (`asmens_kodas`, `vardas`, `pavarde`, `gimimo_data`, `telefonas`, `epastas`) VALUES
('3729898989', 'Giedrius', 'Mikelionis', '1972-05-05', '877777777', ''),
('3729898990', 'Matote', 'Patys', '2016-01-19', '869897854', ''),
('3746656464', 'Jonas', 'Narkevičius', '1974-09-09', '8999999999', ''),
('3756565656', 'Jonas', 'Gervė', '1974-05-05', '855555555', ''),
('3804556464', 'Romas', 'Aušra', '1980-01-05', '811111111', ''),
('3806565656', 'Justinas', 'Tarasevičius', '1980-05-05', '855555555', ''),
('3815656449', 'Tadas', 'Mikalajūnas', '1982-02-02', '8655655555', ''),
('3816565656', 'Antanas', 'Narbutas', '1981-01-01', '8111111111', ''),
('391898899', 'Artūras', 'Mikaila', '1991-01-01', '866666666', ''),
('39456465466', 'Jonas', 'Grigas', '2015-01-01', '865665674', '333@333.lt'),
('3953656325', 'Marius', 'Lankauskas', '1995-01-01', '1456456455', ''),
('3956565656', 'Tadas', 'Linkus', '1995-02-05', '865665555', ''),
('39865641111', 'Marius', 'Linksmuolis', '1998-01-01', '8961111111', ''),
('4656656556', 'Aušra', 'Titienė', '1965-04-04', '8444444444', ''),
('47059898998', 'Asta', 'Laurinkienė', '1970-06-06', '866666664', ''),
('4723565599', 'Violeta', 'Masaitienė', '1972-07-07', '874444444', ''),
('4760205060', 'Janina', 'Laucienė', '1976-05-06', '822222222', ''),
('4789898989', 'Adelė', 'Kasauskienė', '1978-02-02', '833333333', ''),
('480156446', 'Renata', 'Narvydienė', '1980-02-02', '811111111', ''),
('48565656566', 'Sigita', 'Zinevičienė', '1985-02-02', '822222222', '');

-- --------------------------------------------------------

--
-- Sukurta duomenų struktūra lentelei `lagaminai`
--

CREATE TABLE IF NOT EXISTS `lagaminai` (
  `id` int(11) NOT NULL,
  `name` char(29) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Sukurta duomenų kopija lentelei `lagaminai`
--

INSERT INTO `lagaminai` (`id`, `name`) VALUES
(1, '1_mažas_lagaminas'),
(2, '2_maži_lagaminai'),
(3, '1_didelis_lagaminas'),
(4, '2_dideli_lagaminai'),
(5, '1_mažas_ir_1didelis_lagaminas'),
(6, '3_dideli_lagaminai'),
(7, '4_dideli_lagaminai');

-- --------------------------------------------------------

--
-- Sukurta duomenų struktūra lentelei `markes`
--

CREATE TABLE IF NOT EXISTS `markes` (
  `pavadinimas` varchar(20) NOT NULL,
  `id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Sukurta duomenų kopija lentelei `markes`
--

INSERT INTO `markes` (`pavadinimas`, `id`) VALUES
('Renault', 1),
('Opel', 2),
('Škoda', 3);

-- --------------------------------------------------------

--
-- Sukurta duomenų struktūra lentelei `miestai`
--

CREATE TABLE IF NOT EXISTS `miestai` (
  `id` int(11) NOT NULL,
  `pavadinimas` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Sukurta duomenų kopija lentelei `miestai`
--

INSERT INTO `miestai` (`id`, `pavadinimas`) VALUES
(1, 'Vilnius'),
(2, 'Kaunas'),
(3, 'Palanga');

-- --------------------------------------------------------

--
-- Sukurta duomenų struktūra lentelei `modeliai`
--

CREATE TABLE IF NOT EXISTS `modeliai` (
  `pavadinimas` varchar(20) NOT NULL,
  `id` int(11) NOT NULL,
  `fk_marke` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fkc_marke` (`fk_marke`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Sukurta duomenų kopija lentelei `modeliai`
--

INSERT INTO `modeliai` (`pavadinimas`, `id`, `fk_marke`) VALUES
('Megane', 1, 1),
('Clio', 2, 1),
('Kangoo', 3, 1),
('Laguna Coupe', 4, 1),
('Master', 5, 1),
('Twingo', 6, 1),
('Twizy', 7, 1),
('Symbol', 8, 1),
('Koleos', 9, 1),
('Meriva', 10, 2),
('Astra', 11, 2),
('Corsa', 12, 2),
('Zafira', 13, 2),
('Omega', 14, 2),
('Calibra', 15, 2),
('Vectra', 16, 2),
('Yeti', 17, 3),
('Roomster', 18, 3),
('Superb', 19, 3),
('Rapid', 20, 3),
('Fabia', 21, 3),
('Joyster', 23, 3);

-- --------------------------------------------------------

--
-- Sukurta duomenų struktūra lentelei `MokejimoBudas`
--

CREATE TABLE IF NOT EXISTS `MokejimoBudas` (
  `id` int(11) NOT NULL DEFAULT '0',
  `name` char(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Sukurta duomenų kopija lentelei `MokejimoBudas`
--

INSERT INTO `MokejimoBudas` (`id`, `name`) VALUES
(1, 'grynaisiais'),
(2, 'bankoPavedimu'),
(3, 'kreditoKortele'),
(4, 'pastomatu');

-- --------------------------------------------------------

--
-- Sukurta duomenų struktūra lentelei `PakuotesDydis`
--

CREATE TABLE IF NOT EXISTS `PakuotesDydis` (
  `id` int(11) NOT NULL DEFAULT '0',
  `name` char(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Sukurta duomenų kopija lentelei `PakuotesDydis`
--

INSERT INTO `PakuotesDydis` (`id`, `name`) VALUES
(1, 'mazas'),
(2, 'vidutinis'),
(3, 'didelis');

-- --------------------------------------------------------

--
-- Sukurta duomenų struktūra lentelei `paslaugos`
--

CREATE TABLE IF NOT EXISTS `paslaugos` (
  `id` int(11) NOT NULL,
  `pavadinimas` varchar(40) NOT NULL,
  `aprasymas` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Sukurta duomenų kopija lentelei `paslaugos`
--

INSERT INTO `paslaugos` (`id`, `pavadinimas`, `aprasymas`) VALUES
(1, 'Draudimas vagystės atveju', ''),
(2, 'Draudimas autoįvykio atveju', ''),
(3, 'Navigacijos sistema', NULL),
(4, 'Vaikiška kėdutė', NULL),
(5, 'Tvirtinimas slidėms', NULL),
(6, 'Papildoma bagažinė', NULL),
(7, 'Skubi pagalba kelyje', ''),
(8, 'Keleivių draudimas', 'Keleivių draudimas nuo nelaimingų atsitikimų.'),
(9, 'Papildomas vairuotojas', ''),
(10, 'Neribota rida', ''),
(11, 'Tvirtinimas dviračiams', '');

-- --------------------------------------------------------

--
-- Sukurta duomenų struktūra lentelei `paslaugu_kainos`
--

CREATE TABLE IF NOT EXISTS `paslaugu_kainos` (
  `fk_paslauga` int(11) NOT NULL,
  `galioja_nuo` date NOT NULL,
  `galioja_iki` date DEFAULT NULL,
  `kaina` decimal(5,2) NOT NULL,
  PRIMARY KEY (`galioja_nuo`,`fk_paslauga`),
  KEY `fkc_paslauga` (`fk_paslauga`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Sukurta duomenų kopija lentelei `paslaugu_kainos`
--

INSERT INTO `paslaugu_kainos` (`fk_paslauga`, `galioja_nuo`, `galioja_iki`, `kaina`) VALUES
(11, '2015-08-01', NULL, 15.00),
(7, '2015-10-01', NULL, 25.00),
(8, '2015-10-01', NULL, 30.00),
(9, '2015-10-15', NULL, 10.00),
(10, '2015-11-11', NULL, 15.00),
(1, '2016-01-01', NULL, 45.00),
(8, '2016-01-01', NULL, 25.00),
(1, '2016-02-01', NULL, 15.00),
(2, '2016-02-01', NULL, 24.00),
(3, '2016-02-01', NULL, 45.00),
(4, '2016-02-01', NULL, 32.00),
(5, '2016-02-01', NULL, 27.00),
(6, '2016-02-01', NULL, 26.00),
(1, '2016-03-01', NULL, 18.00),
(2, '2016-03-01', NULL, 25.00),
(1, '2016-04-01', NULL, 17.00);

-- --------------------------------------------------------

--
-- Sukurta duomenų struktūra lentelei `pavaru_dezes`
--

CREATE TABLE IF NOT EXISTS `pavaru_dezes` (
  `id` int(11) NOT NULL,
  `name` char(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Sukurta duomenų kopija lentelei `pavaru_dezes`
--

INSERT INTO `pavaru_dezes` (`id`, `name`) VALUES
(1, 'automatinė'),
(2, 'mechaninė');

-- --------------------------------------------------------

--
-- Sukurta duomenų struktūra lentelei `Pirkejas`
--

CREATE TABLE IF NOT EXISTS `Pirkejas` (
  `kodas` varchar(255) NOT NULL DEFAULT '',
  `prisijungimoVardas` varchar(255) DEFAULT NULL,
  `slaptazodis` varchar(255) DEFAULT NULL,
  `vardas` varchar(255) DEFAULT NULL,
  `pavarde` varchar(255) DEFAULT NULL,
  `telefonas` varchar(255) DEFAULT NULL,
  `el_pastas` varchar(255) DEFAULT NULL,
  `adresas` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`kodas`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Sukurta duomenų kopija lentelei `Pirkejas`
--

INSERT INTO `Pirkejas` (`kodas`, `prisijungimoVardas`, `slaptazodis`, `vardas`, `pavarde`, `telefonas`, `el_pastas`, `adresas`) VALUES
('PIRK01', 'kiskutis64', 'zuikis8', 'Antanas', 'Varkys', '+37064587963', 'antanas.varkys@gmail.com', 'Nėra adreso g. 40'),
('PIRK02', 'destroyer666', 'velnesraganeja', 'Jonas', 'Urbšys', '+37063258745', 'jonas.urbsys@gmail.com', 'Ukmergės g. 88, Panevėžys'),
('PIRK03', 'urtbimbim', 'diva6699', 'Urtė', 'Bimbaitė', '+37064732106', 'urte.bimbaite@inbox.lt', 'Vilniaus g. 123a, Kaunas'),
('PIRK04', 'verksnys55', 'hitlerdidit', 'Viktoras', 'Užkuras', '+37062589647', 'viktoriuxxx@gmail.com', 'Savanorių pr. 158, Kaunas'),
('PIRK05', 'tiknusipirksiu', 'nusiperkuirdingstu', 'Gerda', 'Kaušiūtė', '+37065410023', 'gerda.kausiute@yahoo.com', 'V. Krėvės g. 86, Klaipėda'),
('PIRK06', 'neziniuke877', 'password64', 'Nijolė', 'Durbytė', '+37065588473', 'nijole.durbyte@gmail.com', 'P. Višinskio g. 13, Kavarskas'),
('PIRK07', 'tyngiupirkti', 'nenoriunieko', 'Kazys', 'Kazutis', '+37062345789', 'kazys.kazutis@gmail.com', 'Gedimino pr. 256, Vilnius'),
('PIRK08', 'laisvapiliete', 'jauciulaisve', 'Laisvė', 'Šakytė', '+37062345000', 'laisve8789@yahoo.com', 'Vasario 16g. 56, Šiauliai'),
('PIRK09', 'puponautas44', 'geltonasniekas', 'Mindaugas', 'Šatkauskas', '+37062364789', 'mindaugelismanovardas@one.lt', 'Kampinė g. 87, Jonava'),
('PIRK10', 'perkudykai', 'gaukdykai', 'Ernestas', 'Bembotas', '+37064787741', 'ernestutisx6@gmail.com', 'Nepriklausomybės g. 88, Rokiškis'),
('PIRK11', 'naujaspirkejas6', 'pirkinys888', 'Petras', 'Kazlauskas', '+37062354781', 'petriukasss@gmail.com', 'Vertybių g. 66, Vilkaviškis'),
('PIRK12', 'modestukas7', 'alachakbar', 'Modestas', 'Šuštauskas', '+37062222484', 'modestasSus@gmail.com', 'Naujienų g. 79, Vilnius'),
('PIRK13', 'vartojuatsakingai', 'betalkoholikas', 'Vaidas', 'Baumys', '+37062356987', 'vaiduxxxx@one.lt', 'J. Basanavičiaus g. 68-56, Kaunas'),
('PIRK14', 'sportuojuvisada', 'naujaprekeperku', 'Nerijus', 'Gabutis', '+37062365478', 'nerijukas888@yahoo.com', 'Pamestinukų g. 66, Nida'),
('PIRK15', 'pirksiunaujapreke', 'pamirstuvisada', 'Leonardas', 'Pabieda', '+37063567412', 'leo.pabieda@gmail.com', 'Naujininkų g. 69b, Molėtai'),
('PIRK16', 'ausrineee', 'zvaigzdute', 'Aušrinė ', 'Kadzytė', '+37063566984', 'ausrine.kadzyte@inbox.lt', 'Vienybės g. 78, Vilnius'),
('PIRK17', 'vejavaikis', 'pasileidau9999', 'Džiulis', 'Vernas', '+37062335668', 'dziulvern@yahoo.com', 'Merkinės g. 77, Ukmergė'),
('PIRK18', 'kietaveidis', 'kalukalukalu', 'Milvydas', 'Argaras', '+37064545456', 'milvydukass55@one.lt', 'Naujoji g. 89, Marijampolė'),
('PIRK19', 'lolplayerpro', 'profesionalas444', 'Vaidotas', 'Bermudis', '+37063265332', 'vaidotasloleris@gmail.com', 'Namų g. 55, Vilnius'),
('PIRK20', 'naujute888', '12345aaA', 'Nijolė', 'Aušrytė', '+37062356774', 'nijole.ausryte@gmail.com', 'Naujienų g. 78, Palanga'),
('PIRK21', 'sportininkas666', 'stumiustanga', 'Mangirdas', 'Aštuntainis', '+37062356879', 'mangirdacio@inbox.lt', 'Savanorių pr. 78a, Kaunas'),
('PIRK22', 'nedzyte66', '123-456', 'Viktorija', 'Nedzytė', '+37062356447', 'nedzyteee668@gmail.com', 'Konstitucijos g. 56, Šiauliai'),
('PIRK23', 'tiknusipirkti', 'vienkartinisa', 'Eglė', 'Malytė', '+37063569887', 'egle.malyte@yahoo.com', 'Nežinomybės g. 33, Utena'),
('PIRK24', 'donkichotas', 'sancapanca', 'Mindaugas', 'Barbutis', '+37062354559', 'mindaugutis@one.lt', 'Donelaičio g. 80b, Vilnius'),
('PIRK25', 'narbutas69', 'nezinomybe87', 'Vaidas', 'Narbutas', '+37062661158', 'vaidas.narbutas@gmail.com', 'Kęstučio g. 77, Kaunas'),
('PIRK26', 'veiksmynas', 'karburatorius', 'Kazys', 'Saja', '+37063526578', 'kaziukas888@inbox.lt', 'Maironio g. 56, Kelmė'),
('PIRK27', 'keksiukunaikintojas', 'valgauirstoreju', 'Martynas', 'Makarovas', '+37063326001', 'makarov665@gmail.com', 'Marių g. 66, Palanga'),
('PIRK28', 'burbtukas', 'burbuburbu63', 'Nijolė', 'Burbaitė', '+37063255578', 'nijolburb@gmail.com', 'Naujienų g. 61, Klaipėda'),
('PIRK29', 'prisijung8', 'nejungia', 'Marius', 'Iškovas', '+37065466589', 'mariukasssxxx@one.lt', 'Verkių g. 78, Vilnius'),
('PIRK30', 'meturukyt', 'naujasvartotojas', 'Algis', 'Arkūnas', '+37062378989', 'algisark@yahoo.com', 'Darželio g. 2-12, Kaunas'),
('PIRK31', 'tenirtaip', 'vakaipva', 'Inga', 'Dzindaitė', '+37062365485', 'inga.dzindzaite@gmail.com', 'Vilniaus g. 56, Kaunas'),
('PIRK32', 'prisijungimasxxx', 'nenoriuvesti', 'Algis', 'Stasiulis', '+37062356799', 'algis.stasiulis@inbox.lt', 'Miško g. 22, Kelmė'),
('PIRK33', 'milvidacio', 'akacio', 'Milvydas', 'Knyzelis', '+37062354698', 'milvydas.knyzelis@gmail.com', 'Ventos g. 89, Šakiai'),
('PIRK34', 'naujasvardas', 'prisijungsiu', 'Naujė', 'Nainė', '+37062356998', 'nauje.naine@yahoo.com', 'Naujininkų g. 86, Vilnius'),
('PIRK35', 'naujokascia', 'nezinaukavesti', 'Petras', 'Gražutis', '+37060022336', 'petriukas@one.lt', 'Nemuno g. 68-9, Kaunas'),
('PIRK36', 'reikiakazkaivesti', 'prasmingas', 'Nerijus', 'Gedminas', '+37061144559', 'nerijus.gedm@gmail.com', 'Varnių g. 56, Kaunas'),
('PIRK37', 'barbe999', 'rozine6', 'Aistė', 'Rimgailaitė', '+37063568987', 'aistuliukass@inbox.lt', 'Centrinė g. 56, Šiauliai'),
('PIRK38', 'naujienumai', 'password', 'Mantas', 'Kalnietis', '+37062366997', 'mantas.kalnietis@inbox.lt', 'Aido g. 9, Šiauliai'),
('PIRK39', 'loginname', 'passwordname', 'Izidorius', 'Gardutis', '+37062366547', 'izidoriuxas@gmail.com', 'P. Višinskio g. 47, Tauragė'),
('PIRK40', 'vienkartinispirkinys', 'neprisiminsiu', 'Andrėjus', 'Gargaras', '+37062369887', 'privietandrej@gmail.com', 'Rusijos g. 45, Kaunas'),
('PIRK41', 'pirkejas22', 'perkuparduodu', 'Simonas', 'Zaronskis', '+37062356976', 'simonas.zaronskis@gmail.com', 'Margės g. 8, Ukmergė'),
('PIRK42', 'prekeivis89', 'password123', 'Mantvydas', 'Kazimieras', '+37061235669', 'mantvydask@gmail.com', 'Miškinio g. 56-8, Vilnius'),
('PIRK43', 'nenoriuPrisijungti', 'betReikia', 'Irena', 'Degutienė', '+37062366577', 'irenuteee77@inbox.lt', 'Šeškinės g. 78, Vilnius'),
('PIRK44', 'daliukas', 'prezidente', 'Dalia', 'Grybauskaitė', '+37065588994', 'dalia.grybauskaite@seimas.lt', 'Žirmūnų g. 78, Vilnius'),
('PIRK45', 'valdingasis', 'karalius665', 'Valdas', 'Adamkus', '+37065688912', 'valdas.adamkus@seimas.lt', 'Daugpilio g. 78, Vilnius'),
('PIRK46', 'prekininkas', 'tavotevas', 'Alvydas', 'Kisielius', '+37062356996', 'alvydukas@gmail.com', 'Bereikšmė g. 12-2, Kavarskas'),
('PIRK47', 'elvispreslis', 'prisijungsiugi', 'Elvis', 'Preslis', '+37062356987', 'elvisssssss@gmail.com', 'Majamio g. 56, Alytus'),
('PIRK48', 'noriuirperku', 'nusipirksiuviska', 'Martyna', 'Virkytė', '+37062354783', 'martynuuute@inbox.lt', 'Vietinė g. 78-10, Klaipėda'),
('PIRK49', 'jureivis', 'isplaukiu', 'Jurgis', 'Kapitonas', '+37062365478', 'jurgis.kapitonas@one.lt', 'Pajūrio g. 66, Klaipėda'),
('PIRK50', 'uostopriziuretojas', 'priziuriulaivus', 'Stasys', 'Pajūris', '+37062354789', 'stasysplaukiu@inbox.lt', 'Uosto g. 77a, Nida');

-- --------------------------------------------------------

--
-- Sukurta duomenų struktūra lentelei `Preke`
--

CREATE TABLE IF NOT EXISTS `Preke` (
  `kodas` varchar(255) NOT NULL DEFAULT '',
  `pavadinimas` varchar(255) DEFAULT NULL,
  `kaina` double DEFAULT NULL,
  `aprasymas` varchar(255) DEFAULT NULL,
  `pagaminimoData` date DEFAULT NULL,
  `garantija` double DEFAULT NULL,
  `kilmesSalis` varchar(255) DEFAULT NULL,
  `busena` int(11) DEFAULT NULL,
  `sezonas` int(11) DEFAULT NULL,
  `spalva` int(11) DEFAULT NULL,
  `fk_SportoSakosIrankioKategorijaid` int(11) NOT NULL,
  PRIMARY KEY (`kodas`),
  KEY `busena` (`busena`),
  KEY `sezonas` (`sezonas`),
  KEY `spalva` (`spalva`),
  KEY `turi` (`fk_SportoSakosIrankioKategorijaid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Sukurta duomenų kopija lentelei `Preke`
--

INSERT INTO `Preke` (`kodas`, `pavadinimas`, `kaina`, `aprasymas`, `pagaminimoData`, `garantija`, `kilmesSalis`, `busena`, `sezonas`, `spalva`, `fk_SportoSakosIrankioKategorijaid`) VALUES
('PR01', 'Nauja Apranga', 22, '', '0000-00-00', 0, '', 1, 2, 13, 33),
('PR02', 'Adidas Skate', 55, '', '2238-02-01', 0, '', 2, 1, 13, 12),
('PR03', 'Nike Air Ball', 49, '', '0000-00-00', 0, '', 1, 3, 16, 2),
('PR04', 'Adidas Saving Tool', 19.99, '', '0000-00-00', 0, '', 1, 3, 10, 16),
('PR05', 'Nike NBA', 45.99, 'Salės krepšinio kamuolys', '2016-02-01', 0.5, 'JAV', 1, 3, 7, 2),
('PR06', 'Adidas Outdoor', 15.99, 'Lauko krepšinio kamuolys', '2015-11-18', 0, 'JAV', 2, 2, 16, 2),
('PR07', 'Molten XD', 30, 'Lauko futbolo kamuolys', '2016-05-11', 0, 'Anglija', 1, 3, 1, 3),
('PR08', 'Adidas Indoor', 20, 'Salės futbolo kamuolys', '2015-08-05', 0.5, 'Kinijas', 1, 3, 16, 3),
('PR09', 'Adidas NFL', 10.99, 'Oficialus NFL lygos kamuolys', '2015-09-15', 1, 'JAV', 3, 2, 7, 4),
('PR10', 'NFL Color', 25.99, 'NFL spalvotosios serijos kamuolys', '2016-02-03', 1, 'JAV', 1, 3, 12, 4),
('PR11', 'MLB official', 9.99, 'Oficialus MLB lygos kamuoliukas', '2015-10-06', 1, 'JAV', 2, 2, 1, 5),
('PR12', 'Epic Ball', 5.99, 'Beisbolo tvirtas kamuoliukas', '2016-03-01', 0, 'Kinija', 1, 2, 1, 5),
('PR13', 'Molten RX5', 29.99, 'Oficialaus dydžio tinklinio kamuolys', '2015-11-09', 1, 'JAV', 1, 3, 16, 6),
('PR14', 'Molten RX6 Outdoor', 29.99, 'Paplūdimio tinklinio kamuolys', '2015-11-02', 1, 'JAV', 1, 2, 16, 6),
('PR15', 'Šilainių naikintoja3000', 19.99, 'Gynybinė-beisbolo lazda', '2015-11-09', 0, 'Lietuva', 2, 3, 3, 7),
('PR16', 'MLB Official Bat', 29.99, 'Oficiali MLB lygos beisbolo lazda', '2014-03-04', 0, 'JAV', 2, 3, 3, 7),
('PR17', 'Wilson Energy P', 20.99, 'Oficialaus dydžio badmintono raketė', '2016-03-01', 1, 'Anglija', 1, 3, 16, 8),
('PR18', 'Nike Badminton Series', 25.99, 'Sutvirtinta badmintono raketė', '2016-01-04', 1, 'JAV', 1, 3, 14, 8),
('PR19', 'Jordan Air3', 59.99, 'Aukštesnio pado krepšinio bateliai', '2016-01-06', 1, 'Prancūzija', 1, 3, 9, 9),
('PR20', 'Nike Air Basketball X2', 20.99, 'Sutvirtinti krepšinio bateliai', '2015-12-15', 0, 'Indonezija', 2, 3, 2, 9),
('PR21', 'Adidas Predator ARX', 49.99, 'Minkšto pado salės futbolo bateliai', '2015-11-11', 1, 'Indonezija', 1, 3, 16, 10),
('PR22', 'Nike Turbo R6', 59.99, 'Lauko futbolo bateliai, pritaikyti dirbtinei dangai', '2015-10-04', 1, 'Indonezija', 1, 3, 2, 10),
('PR23', 'Reebok Badminton Edition X3', 29.99, 'Badmintono bateliai', '2015-11-05', 0.5, 'Anglija', 1, 3, 4, 11),
('PR24', 'Reebok Badminton Edition X4', 10.99, 'Lankstaus pado badmintono bateliai', '2015-03-05', 0, 'Kinija', 3, 3, 15, 11),
('PR25', 'Adidas NHL Official B2', 59.99, 'Tvirtos, oficialios NHL lygos pačiūžos', '2016-03-01', 1, 'JAV', 1, 1, 1, 12),
('PR26', 'Nike Hockey Edition R4', 20.99, 'Itin lengvos pačiūžos', '2015-10-04', 0, 'JAV', 2, 1, 11, 12),
('PR27', 'Nike Air Max', 59.99, 'Bėgimo bateliai kietai dangai', '2014-10-25', 1, 'Indonezija', 1, 3, 12, 13),
('PR28', 'Adidas Runner Pro', 49.99, 'Bėgimo bateliai minkštai dangai', '2014-12-04', 1, 'Kinija', 1, 3, 16, 13),
('PR29', 'Climber Max', 69.99, 'Uolų laipiojimo bateliai pakietintu padu', '2015-10-05', 0.5, 'JAV', 1, 2, 8, 14),
('PR30', 'High Hill Climber Max5', 19.99, 'Uolų laipiojimo bateliai pakietintu padu', '2016-03-01', 0, 'JAV', 2, 2, 2, 14),
('PR31', 'Adidas Max Jump', 44.99, 'Profesionalūs tinklinio bateliai', '2015-09-06', 1, 'Indonezija', 1, 3, 5, 15),
('PR32', 'Adidas Max Jump', 22.99, 'Profesionalūs tinklinio bateliai', '2015-09-06', 0, 'Indonezija', 2, 3, 5, 15),
('PR33', 'Adidas Football Series', 29.99, 'Itin minkštos futbolo pirštinės', '2015-09-07', 1, 'Prancūzija', 1, 3, 12, 16),
('PR34', 'Reebok Football XL', 24.99, 'Futbolo pirštinės plačiam delnui', '2015-04-13', 1, 'Vokietija', 1, 3, 6, 16),
('PR35', 'MLB Official', 35.99, 'MLB lygos oficiali pirštinė', '2016-02-03', 1, 'JAV', 1, 2, 3, 17),
('PR36', 'MLB Official', 15.99, 'MLB lygos oficiali pirštinė', '2015-11-01', 0, 'JAV', 3, 2, 3, 17),
('PR37', 'Chess Master Wooden', 29.99, 'Medinė šachmatų lenta', '2014-11-14', 2, 'Rusija', 1, 3, 3, 18),
('PR38', 'Chess Beginner', 9.99, 'Mėgėjiška šachmatų lenta', '2015-10-10', 0, 'Rusija', 1, 3, 1, 18),
('PR39', 'Adidas Football Edition', 19.99, 'Kojų apsaugos', '2015-11-18', 0.5, 'Indonezija', 1, 3, 12, 19),
('PR40', 'Adidas Football Edition', 19.99, 'Kojų apsaugos', '2015-11-18', 0.5, 'Indonezija', 1, 3, 13, 19),
('PR41', 'NHL Official', 45.99, 'Krūtinės apsauga', '2015-07-23', 1, 'JAV', 1, 2, 1, 20),
('PR42', 'NHL Official', 22.99, 'Pečių apsaugos', '2015-10-01', 0, 'JAV', 3, 2, 1, 20),
('PR43', 'Nike MLB', 9.99, 'Puodelis', '2016-03-01', 0, 'JAV', 1, 2, 1, 21),
('PR44', 'Nike MLB', 10.99, 'Kojų apsaugos', '2015-08-03', 0.5, 'JAV', 1, 2, 1, 21),
('PR45', 'NHL Official', 49.99, 'Šalmas', '2013-03-08', 1, 'JAV', 1, 1, 13, 22),
('PR46', 'NHL Official', 29.99, 'Pečių apsaugos', '2015-06-10', 1, 'JAV', 1, 1, 1, 22),
('PR47', 'Nike Volleyball Air', 25.55, 'Kelių apsaugos', '2015-09-18', 0, 'Vokietija', 1, 3, 10, 23),
('PR48', 'Adidas Volley X3', 9.99, 'Kelių apsaugos', '2016-06-25', 0, 'Vokietija', 3, 3, 13, 23),
('PR49', 'Wall Climber', 10.99, 'Riešų apsaugos', '2016-08-18', 0, 'JAV', 1, 3, 6, 24),
('PR50', 'Wall Climbing Skills', 15.59, 'Kojų apsaugos', '2015-11-18', 0, 'JAV', 1, 3, 1, 24),
('PR51', 'Chess Master Class', 15.99, 'Oficialus šachmatų mačo laikmatis', '2015-09-19', 1, 'Rusija', 1, 3, 2, 25),
('PR52', 'Chess Master Class', 9.99, 'Oficialus šachmatų mačo laikmatis', '2015-09-19', 0, 'Rusija', 2, 3, 2, 25),
('PR53', 'Chess Master Class', 9.99, 'Oficialios žaidimo figūros (baltos)', '2015-06-14', 0, 'Rusija', 1, 3, 1, 26),
('PR54', 'Chess Master Class', 9.99, 'Oficialios žaidimo figūros (juodos)', '2015-06-14', 0, 'Rusija', 1, 3, 2, 26),
('PR55', 'Adidas NHL', 9.99, 'Ledo ritulys', '2015-06-17', 0, 'JAV', 1, 1, 2, 27),
('PR56', 'Adidas NHL', 29.99, 'Ledo rituliai (4 vnt.)', '2015-11-13', 0, 'JAV', 1, 1, 2, 27),
('PR57', 'Reebok Badminton', 5.99, 'Plunksninukės (4 vnt.)', '2015-02-12', 0, 'Vokietija', 1, 3, 1, 28),
('PR58', 'Reebok Badminton', 10.99, 'Plunksinunkės (8 vnt.)', '2015-09-11', 0, 'Vokietija', 1, 3, 1, 28),
('PR61', 'Nike Basketball Band', 15.99, 'Galvos raištis', '2015-09-09', 0.5, 'JAV', 1, 3, 13, 30),
('PR62', 'Nike Basketball Band', 19.99, 'Ilgas rankos raištis', '2015-10-08', 0.5, 'Indonezija', 1, 3, 10, 30),
('PR63', 'Adidas Football Band', 10.99, 'Galvos raištis', '2015-10-16', 0.5, 'Kinija', 1, 3, 16, 31),
('PR64', 'Adidas Football Band', 10.99, 'Rankų riešų raiščiai (2 vnt.)', '2015-10-15', 0.5, 'Kinija', 1, 3, 4, 31),
('PR65', 'Rugby Bands NFL', 9.99, 'Galvos raištis', '2015-10-04', 0, 'Kinija', 3, 3, 11, 32),
('PR66', 'Rugby Bands NFL', 15.99, 'Kelio raištis', '2015-12-11', 0, 'JAV', 1, 3, 1, 32),
('PR669', 'dtfyghjk', 33, 'fvghbjkml', '2011-05-08', 3, 'Kinija', 2, 1, 11, 10),
('PR67', 'Jordan Shirt Line', 29.99, 'Marškinėliai "Jordan 23"', '2015-11-12', 0.5, 'JAV', 1, 3, 6, 33),
('PR68', 'Jordan Shirt Line', 29.99, 'Marškinėliai "Jordan 23"', '2015-11-11', 0.5, 'JAV', 1, 3, 1, 33),
('PR69', 'Nike Shirt', 25.99, 'Marškinėliai "Lionel Messi 10"', '2015-10-16', 0, 'Indonezija', 1, 3, 13, 34),
('PR70', 'Adidas Outfit', 19.99, 'Marškinėliai "Clevelend Cavaliers"', '2015-12-10', 0, 'JAV', 1, 3, 2, 34),
('PR71', 'Nike Outfit', 29.99, 'Dainiaus Zubraus NHL marškinėliai', '2015-10-04', 0, 'JAV', 1, 1, 12, 35),
('PR72', 'Adidas Outfit', 19.99, 'Dainiaus Zubraus NHL marškinėliai', '2015-10-08', 0, 'JAV', 3, 1, 15, 35),
('PR73', 'Adidas Outdoors', 25.99, 'Bėgiojimo apranga', '2016-03-19', 0, 'Kinija', 1, 3, 14, 36),
('PR74', 'Reebok Outdoors', 19.99, 'Bėgiojimo marškinėliai', '2016-03-01', 0, 'Indonezija', 1, 3, 8, 36),
('PR75', 'Reebok Extreme', 25.99, 'Uolų laipiojimo apranga', '2015-11-15', 0.5, 'Prancūzija', 1, 3, 3, 37),
('PR76', 'Reebok Extreme', 25.99, 'Uolų laipiojimo apranga', '2015-05-15', 0.5, 'Prancūzija', 1, 3, 16, 37),
('PR77', 'Adidas Volleyball Outfit', 19.99, 'Tinklinio marškinėliai su numeriu 7', '2015-08-02', 0, 'JAV', 1, 3, 14, 38),
('PR78', 'Nike Volleybal Series', 9.99, 'Paplūdimio tinklinio marškinėliai', '2014-12-27', 0, 'Kinija', 3, 3, 12, 38);

-- --------------------------------------------------------

--
-- Sukurta duomenų struktūra lentelei `PristatoSiunta`
--

CREATE TABLE IF NOT EXISTS `PristatoSiunta` (
  `fk_Pirkejaskodas` varchar(255) NOT NULL DEFAULT '',
  `fk_SiuntuPervezimoTarnybaid` int(11) NOT NULL DEFAULT '0',
  `id` int(11) NOT NULL,
  PRIMARY KEY (`fk_Pirkejaskodas`,`fk_SiuntuPervezimoTarnybaid`),
  KEY `fk_SiuntuPervezimoTarnybaid_SiuntuPervezimoTarnyba` (`fk_SiuntuPervezimoTarnybaid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Sukurta duomenų kopija lentelei `PristatoSiunta`
--

INSERT INTO `PristatoSiunta` (`fk_Pirkejaskodas`, `fk_SiuntuPervezimoTarnybaid`, `id`) VALUES
('PIRK01', 10, 26),
('PIRK02', 2, 23),
('PIRK03', 3, 24),
('PIRK04', 3, 22),
('PIRK04', 6, 2),
('PIRK10', 3, 3),
('PIRK11', 3, 4),
('PIRK11', 5, 20),
('PIRK14', 4, 5),
('PIRK20', 7, 6),
('PIRK21', 8, 7),
('PIRK22', 3, 8),
('PIRK23', 9, 9),
('PIRK25', 2, 10),
('PIRK26', 8, 11),
('PIRK27', 5, 12),
('PIRK28', 5, 13),
('PIRK29', 3, 14),
('PIRK29', 4, 21),
('PIRK29', 5, 15);

-- --------------------------------------------------------

--
-- Sukurta duomenų struktūra lentelei `PristatymoBudas`
--

CREATE TABLE IF NOT EXISTS `PristatymoBudas` (
  `id` int(11) NOT NULL DEFAULT '0',
  `name` char(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Sukurta duomenų kopija lentelei `PristatymoBudas`
--

INSERT INTO `PristatymoBudas` (`id`, `name`) VALUES
(1, 'pastomatas'),
(2, 'kurjeris'),
(3, 'pastas'),
(4, 'atsiimti sandelyje');

-- --------------------------------------------------------

--
-- Sukurta duomenų struktūra lentelei `Saskaita`
--

CREATE TABLE IF NOT EXISTS `Saskaita` (
  `nr` varchar(255) NOT NULL DEFAULT '',
  `data` date DEFAULT NULL,
  `suma` double DEFAULT NULL,
  `mokejimoData` date DEFAULT NULL,
  `mokejimoBudas` int(11) DEFAULT NULL,
  `fk_Pirkejaskodas` varchar(255) NOT NULL,
  `fk_AptarnaujantisAsistentastabelioNr` varchar(255) NOT NULL,
  PRIMARY KEY (`nr`),
  KEY `mokejimoBudas` (`mokejimoBudas`),
  KEY `apmoka` (`fk_Pirkejaskodas`),
  KEY `israso` (`fk_AptarnaujantisAsistentastabelioNr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Sukurta duomenų kopija lentelei `Saskaita`
--

INSERT INTO `Saskaita` (`nr`, `data`, `suma`, `mokejimoData`, `mokejimoBudas`, `fk_Pirkejaskodas`, `fk_AptarnaujantisAsistentastabelioNr`) VALUES
('S01', '2016-09-07', 100, '2016-03-08', 3, 'PIRK11', 'A01'),
('S02', '2016-03-09', 69, '2016-03-09', 1, 'PIRK01', 'A02'),
('S03', '2016-03-09', 150, '2016-03-09', 4, 'PIRK10', 'A10'),
('S04', '2016-03-09', 90, '2016-03-09', 1, 'PIRK42', 'A07'),
('S05', '2016-03-09', 70, '2016-03-09', 3, 'PIRK29', 'A05'),
('S06', '2016-03-08', 60, '2016-03-09', 2, 'PIRK04', 'A08'),
('S07', '2016-03-09', 50, '2016-03-09', 1, 'PIRK02', 'A01'),
('S08', '2016-03-08', 60, '2016-03-09', 4, 'PIRK47', 'A03'),
('S09', '2016-03-08', 50, '2016-03-09', 3, 'PIRK38', 'A09'),
('S10', '2016-03-09', 90, '2016-03-09', 1, 'PIRK18', 'A04'),
('S11', '2016-04-05', 15.5, '2016-04-08', 2, 'PIRK11', 'A04'),
('S12', '2016-03-07', 60, '2016-03-07', 4, 'PIRK21', 'A02'),
('S13', '2016-03-07', 99, '2016-03-08', 3, 'PIRK22', 'A03'),
('S14', '2016-03-06', 80, '2016-03-07', 3, 'PIRK23', 'A04'),
('S15', '2016-03-07', 70, '2016-03-08', 1, 'PIRK24', 'A05'),
('S16', '2016-03-06', 40, '2016-03-07', 1, 'PIRK25', 'A06'),
('S17', '2016-03-07', 60, '2016-03-08', 3, 'PIRK26', 'A07'),
('S18', '2016-03-06', 100, '2016-03-07', 4, 'PIRK27', 'A08'),
('S19', '2016-03-07', 80, '2016-03-08', 3, 'PIRK28', 'A09'),
('S20', '2016-03-07', 60, '2016-03-08', 1, 'PIRK29', 'A10');

-- --------------------------------------------------------

--
-- Sukurta duomenų struktūra lentelei `Sezonas`
--

CREATE TABLE IF NOT EXISTS `Sezonas` (
  `id` int(11) NOT NULL DEFAULT '0',
  `name` char(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Sukurta duomenų kopija lentelei `Sezonas`
--

INSERT INTO `Sezonas` (`id`, `name`) VALUES
(1, 'ziemos'),
(2, 'vasaros'),
(3, 'universalus');

-- --------------------------------------------------------

--
-- Sukurta duomenų struktūra lentelei `Siunta`
--

CREATE TABLE IF NOT EXISTS `Siunta` (
  `kodas` varchar(255) NOT NULL DEFAULT '',
  `svoris` double DEFAULT NULL,
  `pristatymoData` date DEFAULT NULL,
  `gavejoAdresas` varchar(255) DEFAULT NULL,
  `draudimoKaina` double DEFAULT NULL,
  `pakuotesDydis` int(11) DEFAULT NULL,
  `fk_AptarnaujantisAsistentastabelioNr` varchar(255) NOT NULL,
  `fk_SiuntuPervezimoTarnybaid` int(11) NOT NULL,
  `fk_UzsakymasuzsakymoNumeris` varchar(255) NOT NULL,
  `fk_Pirkejaskodas` varchar(255) NOT NULL,
  PRIMARY KEY (`kodas`),
  UNIQUE KEY `fk_UzsakymasuzsakymoNumeris` (`fk_UzsakymasuzsakymoNumeris`),
  KEY `pakuotesDydis` (`pakuotesDydis`),
  KEY `paruosia` (`fk_AptarnaujantisAsistentastabelioNr`),
  KEY `paima` (`fk_SiuntuPervezimoTarnybaid`),
  KEY `pasiima` (`fk_Pirkejaskodas`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Sukurta duomenų kopija lentelei `Siunta`
--

INSERT INTO `Siunta` (`kodas`, `svoris`, `pristatymoData`, `gavejoAdresas`, `draudimoKaina`, `pakuotesDydis`, `fk_AptarnaujantisAsistentastabelioNr`, `fk_SiuntuPervezimoTarnybaid`, `fk_UzsakymasuzsakymoNumeris`, `fk_Pirkejaskodas`) VALUES
('SIUNT01', 0, '2016-01-07', 'Netinkamas adresas 88', 0, 2, 'A07', 4, 'UZS01', 'PIRK14'),
('SIUNT02', 0, '2016-04-01', 'No adress 55', 0, 1, 'A09', 4, 'UZS02', 'PIRK06'),
('SIUNT03', 4, '2016-03-09', 'Nepriklausomybės g. 88, Rokiškis', 0, 2, 'A03', 8, 'UZS03', 'PIRK14'),
('SIUNT04', 2, '2016-03-10', 'Miškinio g. 56-8, Vilnius', 3, 1, 'A07', 2, 'UZS04', 'PIRK42'),
('SIUNT05', 2, '2016-03-09', 'Verkių g. 78, Vilnius', 3, 1, 'A05', 4, 'UZS05', 'PIRK29'),
('SIUNT06', 15, '2016-03-10', 'Savanorių pr. 158, Kaunas', NULL, 3, 'A08', 3, 'UZS06', 'PIRK04'),
('SIUNT07', 4.5, '2016-03-11', 'Majamio g. 56, Alytus', 3, 2, 'A03', 8, 'UZS08', 'PIRK47'),
('SIUNT08', 5, '2016-03-09', 'Ukmergės g. 88, Panevėžys', NULL, 2, 'A01', 5, 'UZS07', 'PIRK02'),
('SIUNT09', 3.5, '2016-03-11', 'Aido g. 9, Šiauliai', 5, 2, 'A09', 8, 'UZS09', 'PIRK38'),
('SIUNT10', 4, '2016-03-10', 'Naujoji g. 89, Marijampolė', NULL, 2, 'A04', 7, 'UZS10', 'PIRK18'),
('SIUNT11', 5, '2016-03-10', 'Naujienų g. 78, Palanga', 0, 2, 'A01', 7, 'UZS11', 'PIRK11'),
('SIUNT12', 4, '2016-03-11', 'Savanorių pr. 78a, Kaunas', 3, 2, 'A02', 8, 'UZS12', 'PIRK21'),
('SIUNT13', 12, '2016-03-09', 'Konstitucijos g. 56, Šiauliai', 3, 3, 'A03', 3, 'UZS13', 'PIRK22'),
('SIUNT14', 2, '2016-03-10', 'Nežinomybės g. 33, Utena', 0, 1, 'A04', 9, 'UZS14', 'PIRK23'),
('SIUNT15', 0, '2015-12-29', 'Medienos g. 55', 0, 2, 'A02', 2, 'UZS15', 'PIRK15'),
('SIUNT16', 5, '2016-03-11', 'Kęstučio g. 77, Kaunas', 3, 2, 'A06', 2, 'UZS16', 'PIRK25'),
('SIUNT17', 10, '2016-03-10', 'Maironio g. 56, Kelmė', 0, 3, 'A07', 8, 'UZS17', 'PIRK26'),
('SIUNT18', 2, '2016-03-10', 'Marių g. 66, Palanga', 0, 1, 'A08', 5, 'UZS18', 'PIRK27'),
('SIUNT19', 3, '2016-03-11', 'Naujienų g. 61, Klaipėda', 3, 2, 'A09', 5, 'UZS19', 'PIRK28'),
('SIUNT20', 5, '2016-10-11', 'Verkių g. 78, Vilnius', 3, 2, 'A08', 1, 'UZS20', 'PIRK20');

-- --------------------------------------------------------

--
-- Sukurta duomenų struktūra lentelei `SiuntuPervezimoTarnyba`
--

CREATE TABLE IF NOT EXISTS `SiuntuPervezimoTarnyba` (
  `pavadinimas` varchar(255) DEFAULT NULL,
  `transportoPriemonesTalpa` double DEFAULT NULL,
  `pristatymoGreitisValandomis` int(11) DEFAULT NULL,
  `transportoPriemoniuKiekis` int(11) DEFAULT NULL,
  `laukimoTarifasUzValanda` double DEFAULT NULL,
  `transportoPriemone` int(11) DEFAULT NULL,
  `id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `transportoPriemone` (`transportoPriemone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Sukurta duomenų kopija lentelei `SiuntuPervezimoTarnyba`
--

INSERT INTO `SiuntuPervezimoTarnyba` (`pavadinimas`, `transportoPriemonesTalpa`, `pristatymoGreitisValandomis`, `transportoPriemoniuKiekis`, `laukimoTarifasUzValanda`, `transportoPriemone`, `id`) VALUES
('DPD', 52, 24, 50, 2.4, 2, 1),
('FedEx', 35, 10, 50, 2, 2, 2),
('Lietuvos pašto kurjeriai', 50, 24, 27, 0, 2, 3),
('Dviračiukas ir KO', 2, 12, 120, 1, 6, 4),
('Jūrų uostas', 300, 48, 3, 8, 3, 5),
('Pristatukas', 20, 10, 78, 1, 4, 6),
('Omniva', 30, 12, 44, 2, 2, 7),
('Oro paštas', 150, 48, 4, 10, 5, 8),
('Greitasis pristatymas', 15, 5, 66, 3, 4, 9),
('Kautra', 80, 48, 37, 0.3, 1, 10);

-- --------------------------------------------------------

--
-- Sukurta duomenų struktūra lentelei `Spalva`
--

CREATE TABLE IF NOT EXISTS `Spalva` (
  `id` int(11) NOT NULL DEFAULT '0',
  `name` char(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Sukurta duomenų kopija lentelei `Spalva`
--

INSERT INTO `Spalva` (`id`, `name`) VALUES
(1, 'balta'),
(2, 'juoda'),
(3, 'ruda'),
(4, 'purpurine'),
(5, 'rozine'),
(6, 'raudona'),
(7, 'oranzine'),
(8, 'geltona'),
(9, 'salotine'),
(10, 'zalia'),
(11, 'elektrine'),
(12, 'zydra'),
(13, 'melyna'),
(14, 'indigas'),
(15, 'violetine'),
(16, 'spalvota');

-- --------------------------------------------------------

--
-- Sukurta duomenų struktūra lentelei `SportoSaka`
--

CREATE TABLE IF NOT EXISTS `SportoSaka` (
  `pavadinimas` varchar(255) DEFAULT NULL,
  `kilmesSalis` varchar(255) DEFAULT NULL,
  `id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Sukurta duomenų kopija lentelei `SportoSaka`
--

INSERT INTO `SportoSaka` (`pavadinimas`, `kilmesSalis`, `id`) VALUES
('Krepšinis', 'JAV', 1),
('Futbolas', 'Anglija', 2),
('Badmintonas', 'Anglija', 3),
('Regbis', 'Graikija', 4),
('Ledo ritulys', 'Kanada', 5),
('Beisbolas', 'Anglija', 6),
('Bėgimas', 'Nenustatyta', 7),
('Uolų laipiojimas', 'Prancūzija', 8),
('Tinklinis', 'JAV', 9),
('Šachmatai', 'Indija', 10),
('Tenisas', 'Anglija', 11);

-- --------------------------------------------------------

--
-- Sukurta duomenų struktūra lentelei `SportoSakosIrankioKategorija`
--

CREATE TABLE IF NOT EXISTS `SportoSakosIrankioKategorija` (
  `pavadinimas` varchar(255) DEFAULT NULL,
  `id` int(11) NOT NULL DEFAULT '0',
  `fk_SportoSakaid` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `apima` (`fk_SportoSakaid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Sukurta duomenų kopija lentelei `SportoSakosIrankioKategorija`
--

INSERT INTO `SportoSakosIrankioKategorija` (`pavadinimas`, `id`, `fk_SportoSakaid`) VALUES
('Kamuolys', 2, 1),
('Kamuolys', 3, 2),
('Kamuolys', 4, 4),
('Kamuolys', 5, 6),
('Kamuolys', 6, 9),
('Lazda', 7, 6),
('Raketė', 8, 3),
('Bateliai', 9, 1),
('Bateliai', 10, 2),
('Bateliai', 11, 3),
('Pačiūžos', 12, 5),
('Bateliai', 13, 7),
('Bateliai', 14, 8),
('Bateliai', 15, 9),
('Pirštinės', 16, 2),
('Pirštinė', 17, 6),
('Lenta', 18, 10),
('Apsaugos', 19, 2),
('Apsaugos', 20, 4),
('Apsaugos', 21, 6),
('Apsaugos', 22, 5),
('Apsaugos', 23, 9),
('Apsaugos', 24, 8),
('Laikmatis', 25, 10),
('Žaidimo figūros', 26, 10),
('Ritulys', 27, 5),
('Kamuoliukas', 28, 3),
('Raištis', 30, 1),
('Raištis', 31, 2),
('Raištis', 32, 4),
('Apranga', 33, 1),
('Apranga', 34, 2),
('Apranga', 35, 5),
('Apranga', 36, 7),
('Apranga', 37, 8),
('Apranga', 38, 9),
('Raištis', 39, 11),
('Raketė', 40, 11);

-- --------------------------------------------------------

--
-- Sukurta duomenų struktūra lentelei `sutarties_busenos`
--

CREATE TABLE IF NOT EXISTS `sutarties_busenos` (
  `id` int(11) NOT NULL,
  `name` char(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Sukurta duomenų kopija lentelei `sutarties_busenos`
--

INSERT INTO `sutarties_busenos` (`id`, `name`) VALUES
(1, 'užsakyta'),
(2, 'patvirtinta'),
(3, 'nutraukta'),
(4, 'užbaigta');

-- --------------------------------------------------------

--
-- Sukurta duomenų struktūra lentelei `sutartys`
--

CREATE TABLE IF NOT EXISTS `sutartys` (
  `nr` int(11) NOT NULL,
  `sutarties_data` date NOT NULL,
  `nuomos_data_laikas` datetime NOT NULL,
  `planuojama_grazinimo_data_laikas` datetime NOT NULL,
  `faktine_grazinimo_data_laikas` datetime DEFAULT NULL,
  `pradine_rida` int(11) NOT NULL,
  `galine_rida` int(11) DEFAULT NULL,
  `kaina` decimal(8,2) NOT NULL,
  `degalu_kiekis_paimant` smallint(6) NOT NULL,
  `dagalu_kiekis_grazinus` smallint(6) DEFAULT NULL,
  `busena` int(11) NOT NULL,
  `fk_klientas` char(11) NOT NULL,
  `fk_darbuotojas` char(11) NOT NULL,
  `fk_automobilis` int(11) NOT NULL,
  `fk_grazinimo_vieta` int(11) NOT NULL,
  `fk_paemimo_vieta` int(11) NOT NULL,
  PRIMARY KEY (`nr`),
  KEY `busena` (`busena`),
  KEY `fkc_nuomininkas` (`fk_klientas`),
  KEY `fkc_tvirtinantis_darbuotojas` (`fk_darbuotojas`),
  KEY `fkc_automobilis` (`fk_automobilis`),
  KEY `fkc_grazinimo_vieta` (`fk_grazinimo_vieta`),
  KEY `fkc_paemimo_vieta` (`fk_paemimo_vieta`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Sukurta duomenų kopija lentelei `sutartys`
--

INSERT INTO `sutartys` (`nr`, `sutarties_data`, `nuomos_data_laikas`, `planuojama_grazinimo_data_laikas`, `faktine_grazinimo_data_laikas`, `pradine_rida`, `galine_rida`, `kaina`, `degalu_kiekis_paimant`, `dagalu_kiekis_grazinus`, `busena`, `fk_klientas`, `fk_darbuotojas`, `fk_automobilis`, `fk_grazinimo_vieta`, `fk_paemimo_vieta`) VALUES
(1, '2016-01-05', '2016-01-20 10:00:00', '2016-01-27 10:00:00', '2016-01-27 09:00:00', 15889, 16542, 170.00, 75, 57, 4, '47059898998', 'A65656', 4, 2, 1),
(2, '2016-01-01', '2016-01-02 01:00:00', '2016-01-03 02:00:00', '2016-01-08 03:00:00', 14699, 16500, 55.00, 45, 40, 4, '39456465466', 'A6564d', 1, 1, 1),
(3, '2016-01-01', '2016-01-20 02:00:00', '2016-01-20 04:00:00', '0000-00-00 00:00:00', 125000, 0, 55.00, 50, 0, 1, '3956565656', 'A56568', 4, 1, 1),
(4, '2016-01-01', '2016-01-01 00:00:00', '2016-01-08 00:00:00', '0000-00-00 00:00:00', 15000, 0, 100.00, 50, 0, 1, '3953656325', 'A665F', 4, 2, 1),
(5, '2016-01-01', '2016-01-01 00:00:00', '2016-01-03 00:00:00', '0000-00-00 00:00:00', 10000, 0, 120.00, 50, 0, 1, '48565656566', 'A6998d', 4, 2, 1),
(6, '2016-02-01', '2016-02-02 00:00:00', '2016-02-05 00:00:00', '2016-02-05 00:00:00', 154656, 155656, 155.00, 40, 40, 2, '391898899', 'A665F', 10, 2, 1),
(7, '2016-01-02', '2016-01-15 00:00:00', '2016-01-22 00:00:00', '2016-01-22 00:00:00', 35698, 37608, 135.00, 45, 45, 2, '48565656566', 'A56568', 7, 2, 2),
(8, '2016-01-07', '2016-01-20 00:00:00', '2016-01-30 00:00:00', '2016-01-30 00:00:00', 45656, 47016, 145.00, 50, 50, 1, '4656656556', 'A65DFG', 11, 1, 1),
(9, '2016-01-19', '2016-01-15 00:00:00', '2016-01-28 00:00:00', '2016-01-28 00:00:00', 56466, 57656, 165.00, 35, 35, 1, '4760205060', 'A6575D', 9, 2, 1),
(10, '2016-01-20', '2016-01-20 00:00:00', '2016-01-31 00:00:00', '2016-01-31 00:00:00', 35689, 37656, 129.00, 48, 48, 3, '3956565656', 'A65656', 10, 4, 4),
(11, '2016-01-17', '2016-01-28 00:00:00', '2016-02-06 00:00:00', '2016-01-06 00:00:00', 78998, 81545, 189.00, 50, 50, 4, '3815656449', 'A6998d', 4, 4, 2),
(12, '2016-01-18', '2016-01-27 00:00:00', '2016-01-31 00:00:00', '2016-01-31 00:00:00', 45697, 47799, 79.00, 35, 35, 4, '3746656464', 'A6564d', 7, 2, 2),
(13, '2016-01-04', '2016-01-11 00:00:00', '2016-01-18 00:00:00', '2016-01-18 00:00:00', 68987, 70155, 136.00, 50, 50, 4, '3729898989', 'A6998d', 2, 4, 3),
(14, '2016-01-11', '2016-01-19 00:00:00', '2016-01-26 00:00:00', '2016-01-26 00:00:00', 46364, 48615, 164.00, 35, 35, 4, '3746656464', 'A698GF', 5, 3, 4),
(15, '2016-01-20', '2016-01-27 00:00:00', '2016-02-03 00:00:00', '2016-02-10 00:00:00', 64898, 66598, 135.00, 46, 46, 4, '3729898989', 'A6575D', 1, 3, 3),
(16, '2016-01-18', '2016-01-30 00:00:00', '2016-02-18 00:00:00', '0000-00-00 00:00:00', 45677, 0, 167.00, 38, 0, 1, '4723565599', 'A65DFG', 9, 2, 2),
(17, '2016-01-12', '2016-01-20 00:00:00', '2016-01-28 00:00:00', '2016-01-28 00:00:00', 64646, 65494, 178.00, 38, 38, 1, '3756565656', 'A65DFG', 8, 5, 5),
(18, '2016-01-20', '2016-01-14 00:00:00', '2016-01-21 00:00:00', '2016-01-21 00:00:00', 34645, 36454, 164.00, 48, 48, 2, '3804556464', 'A698GF', 6, 4, 4),
(19, '2016-01-26', '2016-01-28 00:00:00', '2016-02-28 00:00:00', '0000-00-00 00:00:00', 69878, 0, 256.00, 46, 0, 1, '3756565656', 'A6575D', 7, 4, 3),
(20, '2016-01-12', '2016-01-12 00:00:00', '2016-01-28 00:00:00', '2016-01-28 00:00:00', 64978, 65699, 134.00, 38, 38, 2, '3756565656', 'A65656', 4, 3, 4),
(21, '2016-01-27', '2016-01-30 00:00:00', '2016-02-06 00:00:00', '2016-02-06 00:00:00', 34989, 36987, 132.00, 39, 42, 1, '3953656325', 'A6575D', 1, 2, 3),
(22, '2016-01-19', '2016-01-20 00:00:00', '2016-01-27 00:00:00', '2016-01-27 00:00:00', 34565, 36545, 134.00, 51, 51, 3, '3806565656', 'A65DFG', 6, 3, 3);

-- --------------------------------------------------------

--
-- Sukurta duomenų struktūra lentelei `TransportoPriemones`
--

CREATE TABLE IF NOT EXISTS `TransportoPriemones` (
  `id` int(11) NOT NULL DEFAULT '0',
  `name` char(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Sukurta duomenų kopija lentelei `TransportoPriemones`
--

INSERT INTO `TransportoPriemones` (`id`, `name`) VALUES
(1, 'autobusas'),
(2, 'mikroautobusas'),
(3, 'laivas'),
(4, 'automobilis'),
(5, 'lektuvas'),
(6, 'dviratis');

-- --------------------------------------------------------

--
-- Sukurta duomenų struktūra lentelei `Uzsakymas`
--

CREATE TABLE IF NOT EXISTS `Uzsakymas` (
  `uzsakymoNumeris` varchar(255) NOT NULL DEFAULT '',
  `uzsakymoData` date DEFAULT NULL,
  `nuolaida` double DEFAULT NULL,
  `nuolaidosKodas` varchar(255) DEFAULT NULL,
  `transportavimoKaina` double DEFAULT NULL,
  `prekiuKiekis` int(11) DEFAULT NULL,
  `pristatymoBudas` int(11) DEFAULT NULL,
  `fk_AptarnaujantisAsistentastabelioNr` varchar(255) NOT NULL,
  `fk_Pirkejaskodas` varchar(255) NOT NULL,
  PRIMARY KEY (`uzsakymoNumeris`),
  KEY `pristatymoBudas` (`pristatymoBudas`),
  KEY `patvirtina` (`fk_AptarnaujantisAsistentastabelioNr`),
  KEY `pateikia` (`fk_Pirkejaskodas`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Sukurta duomenų kopija lentelei `Uzsakymas`
--

INSERT INTO `Uzsakymas` (`uzsakymoNumeris`, `uzsakymoData`, `nuolaida`, `nuolaidosKodas`, `transportavimoKaina`, `prekiuKiekis`, `pristatymoBudas`, `fk_AptarnaujantisAsistentastabelioNr`, `fk_Pirkejaskodas`) VALUES
('UZS01', '2016-04-03', 0, '', 3, 1, 1, 'A01', 'PIRK01'),
('UZS02', '2016-03-05', 10, 'PerkuPigiau', 10, 2, 2, 'A02', 'PIRK01'),
('UZS03', '2016-03-05', 0, '', 0, 1, 4, 'A10', 'PIRK10'),
('UZS04', '2016-03-08', 20, 'KaipPigu', 2.99, 1, 3, 'A07', 'PIRK42'),
('UZS05', '2016-03-09', 0, '', 0, 1, 4, 'A05', 'PIRK29'),
('UZS06', '2016-03-06', 10, 'PerkuPigiau', 3, 2, 3, 'A08', 'PIRK04'),
('UZS07', '2016-03-06', 0, NULL, 0, 1, 4, 'A01', 'PIRK02'),
('UZS08', '2016-03-07', 20, 'UltraPigu', 5, 1, 3, 'A03', 'PIRK47'),
('UZS09', '2016-03-08', 10, 'PerkuPigiau', 2.99, 1, 1, 'A09', 'PIRK38'),
('UZS10', '2016-03-05', 0, NULL, 0, 1, 4, 'A04', 'PIRK18'),
('UZS11', '2016-03-01', 0, NULL, 0, 1, 4, 'A01', 'PIRK20'),
('UZS12', '2016-03-02', 10, 'PerkuPigiau', 3, 1, 2, 'A02', 'PIRK21'),
('UZS13', '2016-03-02', 0, NULL, 0, 1, 4, 'A03', 'PIRK22'),
('UZS14', '2016-03-04', 0, NULL, 0, 1, 4, 'A04', 'PIRK23'),
('UZS15', '2016-03-02', 10, 'PerkuPigiau', 3, 1, 1, 'A05', 'PIRK24'),
('UZS16', '2016-03-01', 0, NULL, 3, 1, 2, 'A06', 'PIRK25'),
('UZS17', '2016-03-05', 0, NULL, 3, 1, 3, 'A07', 'PIRK26'),
('UZS18', '2016-03-03', 10, 'PerkuPigiau', 3, 1, 2, 'A08', 'PIRK27'),
('UZS19', '2016-03-03', 10, 'PerkuPigiau', 3, 1, 1, 'A09', 'PIRK28'),
('UZS20', '2016-03-02', 0, '', 3, 1, 3, 'A10', 'PIRK29'),
('UZS21', '2016-04-12', 12, 'Perku pigiau', 2, 1, 2, 'A09', 'PIRK09');

-- --------------------------------------------------------

--
-- Sukurta duomenų struktūra lentelei `UzsakymoPreke`
--

CREATE TABLE IF NOT EXISTS `UzsakymoPreke` (
  `kiekis` int(11) DEFAULT NULL,
  `fk_UzsakymasuzsakymoNumeris` varchar(255) NOT NULL,
  `fk_Prekekodas` varchar(255) NOT NULL,
  `id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `sudarytasIs` (`fk_UzsakymasuzsakymoNumeris`),
  KEY `itrauktaI` (`fk_Prekekodas`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Sukurta duomenų kopija lentelei `UzsakymoPreke`
--

INSERT INTO `UzsakymoPreke` (`kiekis`, `fk_UzsakymasuzsakymoNumeris`, `fk_Prekekodas`, `id`) VALUES
(1, 'UZS04', 'PR19', 5),
(2, 'UZS06', 'PR69', 6),
(1, 'UZS07', 'PR06', 7),
(1, 'UZS08', 'PR14', 8),
(1, 'UZS09', 'PR58', 9),
(1, 'UZS10', 'PR72', 10),
(1, 'UZS11', 'PR74', 11),
(1, 'UZS12', 'PR23', 12),
(1, 'UZS13', 'PR62', 13),
(1, 'UZS14', 'PR32', 14),
(1, 'UZS15', 'PR52', 15),
(1, 'UZS16', 'PR54', 16),
(1, 'UZS17', 'PR29', 17),
(1, 'UZS18', 'PR13', 18),
(1, 'UZS19', 'PR22', 19),
(1, 'UZS02', 'PR19', 23),
(2, 'UZS03', 'PR19', 24),
(1, 'UZS05', 'PR16', 25),
(1, 'UZS20', 'PR66', 32),
(1, 'UZS21', 'PR17', 33),
(1, 'UZS01', 'PR01', 34);

-- --------------------------------------------------------

--
-- Sukurta duomenų struktūra lentelei `uzsakytos_paslaugos`
--

CREATE TABLE IF NOT EXISTS `uzsakytos_paslaugos` (
  `fk_sutartis` int(11) NOT NULL,
  `fk_kaina_galioja_nuo` date NOT NULL,
  `fk_paslauga` int(11) NOT NULL,
  `kiekis` smallint(6) NOT NULL,
  `kaina` decimal(7,2) NOT NULL,
  PRIMARY KEY (`fk_sutartis`,`fk_paslauga`,`fk_kaina_galioja_nuo`),
  KEY `fkc_paslaugos_kaina` (`fk_kaina_galioja_nuo`,`fk_paslauga`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Sukurta duomenų kopija lentelei `uzsakytos_paslaugos`
--

INSERT INTO `uzsakytos_paslaugos` (`fk_sutartis`, `fk_kaina_galioja_nuo`, `fk_paslauga`, `kiekis`, `kaina`) VALUES
(1, '2016-01-01', 1, 1, 45.00),
(1, '2016-03-01', 2, 1, 25.00),
(2, '2016-01-01', 1, 1, 45.00),
(2, '2016-02-01', 4, 2, 32.00),
(3, '2016-02-01', 1, 1, 15.00),
(4, '2016-02-01', 1, 1, 15.00),
(4, '2016-02-01', 2, 1, 24.00),
(4, '2016-02-01', 5, 1, 27.00),
(5, '2016-02-01', 1, 5, 15.00),
(5, '2016-02-01', 4, 2, 32.00),
(6, '2016-01-01', 1, 1, 45.00),
(7, '2015-10-01', 7, 1, 25.00),
(8, '2016-03-01', 2, 1, 25.00),
(9, '2016-02-01', 5, 1, 27.00),
(11, '2016-02-01', 1, 1, 15.00),
(11, '2016-02-01', 2, 1, 24.00),
(11, '2016-02-01', 3, 1, 45.00),
(11, '2016-02-01', 4, 2, 32.00),
(12, '2016-02-01', 5, 2, 27.00),
(12, '2015-10-01', 7, 1, 25.00),
(13, '2016-02-01', 4, 1, 32.00),
(15, '2016-02-01', 3, 1, 45.00),
(15, '2016-02-01', 5, 1, 27.00),
(19, '2016-03-01', 1, 1, 18.00);

--
-- Apribojimai eksportuotom lentelėm
--

--
-- Apribojimai lentelei `aiksteles`
--
ALTER TABLE `aiksteles`
  ADD CONSTRAINT `fkc_vieta` FOREIGN KEY (`fk_miestas`) REFERENCES `miestai` (`id`);

--
-- Apribojimai lentelei `automobiliai`
--
ALTER TABLE `automobiliai`
  ADD CONSTRAINT `automobiliai_ibfk_1` FOREIGN KEY (`pavaru_deze`) REFERENCES `pavaru_dezes` (`id`),
  ADD CONSTRAINT `automobiliai_ibfk_2` FOREIGN KEY (`degalu_tipas`) REFERENCES `degalu_tipai` (`id`),
  ADD CONSTRAINT `automobiliai_ibfk_3` FOREIGN KEY (`kebulas`) REFERENCES `kebulu_tipai` (`id`),
  ADD CONSTRAINT `automobiliai_ibfk_4` FOREIGN KEY (`bagazo_dydis`) REFERENCES `lagaminai` (`id`),
  ADD CONSTRAINT `automobiliai_ibfk_5` FOREIGN KEY (`busena`) REFERENCES `auto_busenos` (`id`),
  ADD CONSTRAINT `fkc_modelis` FOREIGN KEY (`fk_modelis`) REFERENCES `modeliai` (`id`);

--
-- Apribojimai lentelei `modeliai`
--
ALTER TABLE `modeliai`
  ADD CONSTRAINT `fkc_marke` FOREIGN KEY (`fk_marke`) REFERENCES `markes` (`id`);

--
-- Apribojimai lentelei `paslaugu_kainos`
--
ALTER TABLE `paslaugu_kainos`
  ADD CONSTRAINT `fkc_paslauga` FOREIGN KEY (`fk_paslauga`) REFERENCES `paslaugos` (`id`);

--
-- Apribojimai lentelei `Preke`
--
ALTER TABLE `Preke`
  ADD CONSTRAINT `Preke_ibfk_1` FOREIGN KEY (`busena`) REFERENCES `Busena` (`id`),
  ADD CONSTRAINT `Preke_ibfk_2` FOREIGN KEY (`sezonas`) REFERENCES `Sezonas` (`id`),
  ADD CONSTRAINT `Preke_ibfk_3` FOREIGN KEY (`spalva`) REFERENCES `Spalva` (`id`),
  ADD CONSTRAINT `turi` FOREIGN KEY (`fk_SportoSakosIrankioKategorijaid`) REFERENCES `SportoSakosIrankioKategorija` (`id`);

--
-- Apribojimai lentelei `PristatoSiunta`
--
ALTER TABLE `PristatoSiunta`
  ADD CONSTRAINT `PristatoSiunta_ibfk_1` FOREIGN KEY (`fk_SiuntuPervezimoTarnybaid`) REFERENCES `SiuntuPervezimoTarnyba` (`id`),
  ADD CONSTRAINT `pristatoSiunta` FOREIGN KEY (`fk_Pirkejaskodas`) REFERENCES `Pirkejas` (`kodas`);

--
-- Apribojimai lentelei `Saskaita`
--
ALTER TABLE `Saskaita`
  ADD CONSTRAINT `Saskaita_ibfk_1` FOREIGN KEY (`mokejimoBudas`) REFERENCES `MokejimoBudas` (`id`),
  ADD CONSTRAINT `apmoka` FOREIGN KEY (`fk_Pirkejaskodas`) REFERENCES `Pirkejas` (`kodas`),
  ADD CONSTRAINT `israso` FOREIGN KEY (`fk_AptarnaujantisAsistentastabelioNr`) REFERENCES `AptarnaujantisAsistentas` (`tabelioNr`);

--
-- Apribojimai lentelei `Siunta`
--
ALTER TABLE `Siunta`
  ADD CONSTRAINT `Siunta_ibfk_1` FOREIGN KEY (`pakuotesDydis`) REFERENCES `PakuotesDydis` (`id`),
  ADD CONSTRAINT `itraukiamasI` FOREIGN KEY (`fk_UzsakymasuzsakymoNumeris`) REFERENCES `Uzsakymas` (`uzsakymoNumeris`),
  ADD CONSTRAINT `paima` FOREIGN KEY (`fk_SiuntuPervezimoTarnybaid`) REFERENCES `SiuntuPervezimoTarnyba` (`id`),
  ADD CONSTRAINT `paruosia` FOREIGN KEY (`fk_AptarnaujantisAsistentastabelioNr`) REFERENCES `AptarnaujantisAsistentas` (`tabelioNr`),
  ADD CONSTRAINT `pasiima` FOREIGN KEY (`fk_Pirkejaskodas`) REFERENCES `Pirkejas` (`kodas`);

--
-- Apribojimai lentelei `SiuntuPervezimoTarnyba`
--
ALTER TABLE `SiuntuPervezimoTarnyba`
  ADD CONSTRAINT `SiuntuPervezimoTarnyba_ibfk_1` FOREIGN KEY (`transportoPriemone`) REFERENCES `TransportoPriemones` (`id`);

--
-- Apribojimai lentelei `SportoSakosIrankioKategorija`
--
ALTER TABLE `SportoSakosIrankioKategorija`
  ADD CONSTRAINT `apima` FOREIGN KEY (`fk_SportoSakaid`) REFERENCES `SportoSaka` (`id`);

--
-- Apribojimai lentelei `sutartys`
--
ALTER TABLE `sutartys`
  ADD CONSTRAINT `fkc_automobilis` FOREIGN KEY (`fk_automobilis`) REFERENCES `automobiliai` (`id`),
  ADD CONSTRAINT `fkc_grazinimo_vieta` FOREIGN KEY (`fk_grazinimo_vieta`) REFERENCES `aiksteles` (`id`),
  ADD CONSTRAINT `fkc_nuomininkas` FOREIGN KEY (`fk_klientas`) REFERENCES `klientai` (`asmens_kodas`),
  ADD CONSTRAINT `fkc_paemimo_vieta` FOREIGN KEY (`fk_paemimo_vieta`) REFERENCES `aiksteles` (`id`),
  ADD CONSTRAINT `fkc_tvirtinantis_darbuotojas` FOREIGN KEY (`fk_darbuotojas`) REFERENCES `darbuotojai` (`tabelio_nr`),
  ADD CONSTRAINT `sutartys_ibfk_1` FOREIGN KEY (`busena`) REFERENCES `sutarties_busenos` (`id`);

--
-- Apribojimai lentelei `Uzsakymas`
--
ALTER TABLE `Uzsakymas`
  ADD CONSTRAINT `Uzsakymas_ibfk_1` FOREIGN KEY (`pristatymoBudas`) REFERENCES `PristatymoBudas` (`id`),
  ADD CONSTRAINT `pateikia` FOREIGN KEY (`fk_Pirkejaskodas`) REFERENCES `Pirkejas` (`kodas`),
  ADD CONSTRAINT `patvirtina` FOREIGN KEY (`fk_AptarnaujantisAsistentastabelioNr`) REFERENCES `AptarnaujantisAsistentas` (`tabelioNr`);

--
-- Apribojimai lentelei `UzsakymoPreke`
--
ALTER TABLE `UzsakymoPreke`
  ADD CONSTRAINT `itrauktaI` FOREIGN KEY (`fk_Prekekodas`) REFERENCES `Preke` (`kodas`),
  ADD CONSTRAINT `sudarytasIs` FOREIGN KEY (`fk_UzsakymasuzsakymoNumeris`) REFERENCES `Uzsakymas` (`uzsakymoNumeris`);

--
-- Apribojimai lentelei `uzsakytos_paslaugos`
--
ALTER TABLE `uzsakytos_paslaugos`
  ADD CONSTRAINT `fkc_paslaugos_kaina` FOREIGN KEY (`fk_kaina_galioja_nuo`, `fk_paslauga`) REFERENCES `paslaugu_kainos` (`galioja_nuo`, `fk_paslauga`),
  ADD CONSTRAINT `fkc_paslaugu_sutartis` FOREIGN KEY (`fk_sutartis`) REFERENCES `sutartys` (`nr`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
