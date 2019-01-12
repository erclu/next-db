/*Progetto Base di Dati 18/19 Ercole Luca e Ferrati Marco*/

DROP TABLE IF EXIST Metodi_di_pagamento;
CREATE TABLE Metodi_di_pagamento(
	Utente INTEGER NOT NULL,
	Tipo VARCHAR(255),
)


DROP TABLE IF EXIST Utenti;
CREATE TABLE Utenti(
	Id INTEGER NOT NULL AUTO_INCREMENT,
	Email VARCHAR(255) NOT NULL,
	Password CHAR(64) NOT NULL,
	Nome VARCHAR(255) NOT NULL,
	Cognome VARCHAR(255) NOT NULL,
	Data_di_nascita: DATE NOT NULL
)


DROP TABLE IF EXIST Richieste;
CREATE TABLE Richieste(
	Id INTEGER NOT NULL AUTO_INCREMENT,
	Orario_richiesta TIMESTAMP NOT NULL,
	Orario_partenza TIMESTAMP NOT NULL,
	Partenza_x FLOAT NOT NULL,
	Partenza_y FLOAT NOT NULL,
	Destinazione_x FLOAT NOT NULL,
	Destinazione_y FLOAT NOT NULL,
	Accettata BOOLEAN,
#	Tariffa,
	Corsa INTEGER, #
	Utente INTEGER NOT NULL,
)


DROP TABLE IF EXIST Tariffe;
CREATE TABLE Tariffe()


DROP TABLE IF EXIST Corse;
CREATE TABLE Corse(
	Id INTEGER AUTO_INCREMENT NOT NULL,
	Orario_partenza TIMESTAMP,
	Partenza_x INTEGER NOT NULL,
	Partenza_y INTEGER NOT NULL,
	Destinazione_y INTEGER NOT NULL,
	Destinazione_x INTEGER NOT NULL,
	Ora_conclusione TIMESTAMP,
)


DROP TABLE IF EXIST Storici;
CREATE TABLE Storici(
	Id INTEGER NOT NULL AUTO_INCREMENT,
	Corsa INTEGER NOT NULL,
	Utente INTEGER NOT NULL,
)


DROP TABLE IF EXIST Associazioni;
CREATE TABLE Associazioni(
	Corsa INTEGER NOT NULL,
	Tratta INTEGER NOT NULL,
	Posto_occupato INTEGER NOT NULL,
)


DROP TABLE IF EXIST Tratte;
CREATE TABLE Tratte(
	Id INTEGER NOT NULL AUTO_INCREMENT,
	Orario_partenza TIMESTAMP NOT NULL,
	Inizio_x INTEGER NOT NULL,
	Inizio_y INTEGER NOT NULL,
	Fine_x INTEGER NOT NULL,
	Fine_y INTEGER NOT NULL,
)


DROP TABLE IF EXIST Fermate;
CREATE TABLE Fermate(
	Id INTEGER NOT NULL AUTO_INCREMENT,
	Precedente INTEGER,
	Successiva INTEGER,
	Orario_evento TIMESTAMP,
	Tipo_evento VARCHAR(255),
)


DROP TABLE IF EXIST Indicazioni;
CREATE TABLE Indicazioni(
	#Aggiungere un id?
	Partenza INTEGER NOT NULL,
	Destinazione INTEGER NOT NULL,
	Tratta INTEGER NOT NULL,
	Successiva INTEGER,
	Precedente INTEGER,
)


DROP TABLE IF EXIST Veicoli;
CREATE TABLE Veicoli(
	Targa INTEGER NOT NULL,
	Stato_batteria INTEGER, /*Compreso tra 0 e 100*/
	Posizione_x INTEGER NOT NULL,
	Posizione_y INTEGER NOT NULL,
	Tipo VARCHAR(255) NOT NULL,
	Guidatore INTEGER,
	In_ricarica /*IDENTIFICATORE DI HUB DI RICARCIA*/,
	Tratta INTEGER,
	Testa BOOLEAN,
)


DROP TABLE IF EXIST Autisti;
CREATE TABLE Autisti(
	Codice_dipendente INTEGER NOT NULL AUTO_INCREMENT,
	Nome VARCHAR(255) NOT NULL,
	Cognome VARCHAR(255) NOT NULL,
	Data_di_nascita DATE,
	Passeggero INTEGER,
)


DROP TABLE IF EXIST Hub_di_ricarica;
CREATE TABLE Hub_di_ricarica(
	/*Qaulè l'identificatore primario??*/
)


DROP TABLE IF EXIST Nodi;
CREATE TABLE Nodi(
	Id INTEGER NOT NULL AUTO_INCREMENT,
	Latitudine INTEGER NOT NULL,
	Longitudine INTEGER NOT NULL,
)


DROP TABLE IF EXIST Archi;
CREATE TABLE Archi(
	Entrante INTEGER NOT NULL,
	Uscente INTEGER NOT NULL,
	Peso INTEGER NOT NULL,
)
