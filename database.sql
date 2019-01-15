/*Progetto Base di Dati 18/19 Ercole Luca e Ferrati Marco*/

/*Creazione tabelle e inserimento valori*/
DROP TABLE IF EXIST Utenti;
CREATE TABLE Utenti(
	Id INTEGER PRIMARY KEY AUTO_INCREMENT,
	Email VARCHAR(255) NOT NULL,
	Password CHAR(64) NOT NULL,
	Nome VARCHAR(255) NOT NULL,
	Cognome VARCHAR(255) NOT NULL,
	Data_di_nascita DATE NOT NULL
) ENGINE=InnoDB;
/*Nota, all'inserimento mettere il campo password cifrato (con la funzione encode?)*/


DROP TABLE IF EXIST Fonte_di_pagamento;
CREATE TABLE Fonte_di_pagamento(
	Utente INTEGER,
	Tipo VARCHAR(255),

	PRIMARY KEY (Utente, Tipo), --Solo un tipo per utente?
	FOREIGN KEY(Utente) REFERENCES Utenti(Id),
)ENGINE=InnoDB;


DROP TABLE IF EXIST Corse;
CREATE TABLE Corse(
	Id INTEGER AUTO_INCREMENT PRIMARY KEY,
	Orario_partenza TIMESTAMP NOT NULL,
	Origine_x INTEGER NOT NULL,
	Origine_y INTEGER NOT NULL,
	Destinazione_x INTEGER NOT NULL,
	Destinazione_y INTEGER NOT NULL,
	Ora_conclusione TIMESTAMP,
	Prezzo DECIMAL,
)ENGINE=InnoDB;


DROP TABLE IF EXIST Richieste;
CREATE TABLE Richieste(
	Id INTEGER PRIMARY KEY AUTO_INCREMENT,
	Orario_richiesta TIMESTAMP NOT NULL,
	Orario_partenza TIMESTAMP NOT NULL,
	Origine_x DECIMAL NOT NULL,
	Origine_y DECIMAL NOT NULL,
	Destinazione_x DECIMAL NOT NULL,
	Destinazione_y DECIMAL NOT NULL,
	Accettata BOOLEAN,
	Corsa INTEGER, /**/
	Utente INTEGER NOT NULL,

	FOREIGN KEY(Utente) REFERENCES Utenti(Id),
	FOREIGN KEY(Corsa) REFERENCES Corse(Id),
)ENGINE=InnoDB;


DROP TABLE IF EXIST Storici;
CREATE TABLE Storici(
	Id INTEGER PRIMARY KEY AUTO_INCREMENT,
	Corsa INTEGER NOT NULL,
	Utente INTEGER NOT NULL,

	FOREIGN KEY(Corsa) REFERENCES Corse(Id),
	FOREIGN KEY(Utente) REFERENCES Utenti(Id),
)ENGINE=InnoDB;


DROP TABLE IF EXIST Tratte;
CREATE TABLE Tratte(
	Id INTEGER PRIMARY KEY AUTO_INCREMENT,
	Orario_partenza TIMESTAMP NOT NULL,
	Inizio_x INTEGER NOT NULL,
	Inizio_y INTEGER NOT NULL,
	Fine_x INTEGER NOT NULL,
	Fine_y INTEGER NOT NULL,
)ENGINE=InnoDB;


DROP TABLE IF EXIST Associazioni;
CREATE TABLE Associazioni(
	Corsa INTEGER NOT NULL,
	Tratta INTEGER NOT NULL,
	Posto_occupato INTEGER NOT NULL,

	PRIMARY KEY(Corsa, Tratta, Posto_occupato),
	FOREIGN KEY(Corsa) REFERENCES Corse(Id),
	FOREIGN KEY(Tratta) REFERENCES Tratte(Id),
)ENGINE=InnoDB;


DROP TABLE IF EXIST Evento;
CREATE TABLE Evento(
	Id INTEGER PRIMARY KEY AUTO_INCREMENT,
	Precedente INTEGER,
	Successiva INTEGER,
	Orario TIMESTAMP,
	Tipo VARCHAR(255),

	FOREIGN KEY(Precedente) REFERENCES Tratte(Id),
	FOREIGN KEY(Successiva) REFERENCES Tratte(Id),
)ENGINE=InnoDB;

DROP TABLE IF EXIST Nodi;
CREATE TABLE Nodi(
	Id INTEGER PRIMARY KEY AUTO_INCREMENT,
	Latitudine INTEGER NOT NULL,
	Longitudine INTEGER NOT NULL,
)ENGINE=InnoDB;

DROP TABLE IF EXIST Indicazioni;
CREATE TABLE Indicazioni(
	Partenza INTEGER NOT NULL,
	Destinazione INTEGER NOT NULL,
	Tratta INTEGER NOT NULL,

	PRIMARY KEY(Partenza, Destinazione, Tratta),
	FOREIGN KEY(Partenza) REFERENCES Nodi(Id), --vincolo partenza e destinazione diversi?
	FOREIGN KEY(Destinazione) REFERENCES Nodi(Id), --vincolo partenza e destinazione diversi?
)ENGINE=InnoDB;


DROP TABLE IF EXIST Veicoli;
CREATE TABLE Veicoli(
	Targa INTEGER PRIMARY KEY,
	Stato_batteria INTEGER,
	Posizione_x INTEGER NOT NULL,
	Posizione_y INTEGER NOT NULL,
	Tipo VARCHAR(255) NOT NULL,
	Guidatore INTEGER,
	In_ricarica /*IDENTIFICATORE DI HUB DI RICARCIA*/,
	Tratta INTEGER,
	Testa BOOLEAN,

	FOREIGN KEY(Guidatore) REFERENCES Autisti(Codice_dipendente),
	FOREIGN KEY(Tratta) REFERENCES Tratte(Id),
	FOREIGN KEY(In_ricarica) REFERENCES Stazione_di_ricarica(id),

	CHECK (Stato_batteria>=0 AND Stato_batteria<=100),
)ENGINE=InnoDB;


DROP TABLE IF EXIST Autisti;
CREATE TABLE Autisti(
	Codice_dipendente INTEGER PRIMARY KEY AUTO_INCREMENT,
	Nome VARCHAR(255) NOT NULL,
	Cognome VARCHAR(255) NOT NULL,
	Data_di_nascita DATE,
	Passeggero INTEGER,

	FOREIGN KEY(Passeggero) REFERENCES Veicoli(Targa),
)ENGINE=InnoDB;


DROP TABLE IF EXIST Stazione_di_ricarica;
CREATE TABLE Stazione_di_ricarica(
	Id INTEGER PRIMARY KEY AUTO_INCREMENT,
	Posizione_x DECIMAL,
	Posizione_y DECIMAL,
	Posti_totali INTEGER,
)ENGINE=InnoDB;


DROP TABLE IF EXIST Archi;
CREATE TABLE Archi(
	Entrante INTEGER NOT NULL, /*Esprimere che entrante != uscente*/
	Uscente INTEGER NOT NULL,
	Nome VARCHAR(255),
	Peso INTEGER NOT NULL,

	FOREIGN KEY(Entrante) REFERENCES Nodi(Id),
	FOREIGN KEY(Uscente) REFERENCES Nodi(Id),
)ENGINE=InnoDB;
