/*Progetto Base di Dati 18/19 Ercole Luca e Ferrati Marco*/

SET FOREIGN_KEY_CHECKS=0;

/*Creazione tabelle e inserimento valori*/
DROP TABLE IF EXISTS Utenti;
CREATE TABLE Utenti(
	Id INTEGER PRIMARY KEY AUTO_INCREMENT,
	Email VARCHAR(255) NOT NULL UNIQUE,
	Password CHAR(64) NOT NULL,
	Nome VARCHAR(255) NOT NULL,
	Cognome VARCHAR(255) NOT NULL,
	Data_di_nascita DATE NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*Nota, all'inserimento mettere il campo password cifrato (con la funzione encode?)*/


DROP TABLE IF EXISTS Fonti_di_pagamento;
CREATE TABLE Fonti_di_pagamento(
	Id INTEGER PRIMARY KEY AUTO_INCREMENT,
	Utente INTEGER,
	Tipo VARCHAR(255),

	FOREIGN KEY(Utente) REFERENCES Utenti(Id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS Corse;
CREATE TABLE Corse(
	Id INTEGER AUTO_INCREMENT PRIMARY KEY,
	Orario_partenza TIMESTAMP NOT NULL,
	Origine_x INTEGER NOT NULL,
	Origine_y INTEGER NOT NULL,
	Destinazione_x INTEGER NOT NULL,
	Destinazione_y INTEGER NOT NULL,
	Ora_conclusione TIMESTAMP,
	Prezzo DECIMAL
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS Richieste;
CREATE TABLE Richieste(
	Id INTEGER PRIMARY KEY AUTO_INCREMENT,
	Orario_richiesta TIMESTAMP NOT NULL,
	Orario_partenza TIMESTAMP NOT NULL,
	Origine_x DECIMAL NOT NULL,
	Origine_y DECIMAL NOT NULL,
	Destinazione_x DECIMAL NOT NULL,
	Destinazione_y DECIMAL NOT NULL,
	Accettata BOOLEAN,
	Corsa INTEGER,
	Utente INTEGER NOT NULL,

	FOREIGN KEY(Utente) REFERENCES Utenti(Id),
	FOREIGN KEY(Corsa) REFERENCES Corse(Id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS Storico_corse;
CREATE TABLE Storico_corse(
	Id INTEGER PRIMARY KEY AUTO_INCREMENT,
	Corsa INTEGER NOT NULL,
	Utente INTEGER NOT NULL,

	FOREIGN KEY(Corsa) REFERENCES Corse(Id),
	FOREIGN KEY(Utente) REFERENCES Utenti(Id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS Tratte;
CREATE TABLE Tratte(
	Id INTEGER PRIMARY KEY AUTO_INCREMENT,
	Orario_partenza TIMESTAMP NOT NULL,
	Inizio_x INTEGER NOT NULL,
	Inizio_y INTEGER NOT NULL,
	Fine_x INTEGER NOT NULL,
	Fine_y INTEGER NOT NULL
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS Associazioni;
CREATE TABLE Associazioni(
	Corsa INTEGER NOT NULL,
	Tratta INTEGER NOT NULL,
	Posto_occupato INTEGER NOT NULL,

	PRIMARY KEY(Corsa, Tratta, Posto_occupato),
	FOREIGN KEY(Corsa) REFERENCES Corse(Id),
	FOREIGN KEY(Tratta) REFERENCES Tratte(Id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS Eventi;
CREATE TABLE Eventi(
	Id INTEGER PRIMARY KEY AUTO_INCREMENT,
	Precedente INTEGER,
	Successiva INTEGER,
	Orario TIMESTAMP,
	Tipo VARCHAR(255),

	FOREIGN KEY(Precedente) REFERENCES Tratte(Id),
	FOREIGN KEY(Successiva) REFERENCES Tratte(Id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS Nodi;
CREATE TABLE Nodi(
	Id INTEGER PRIMARY KEY AUTO_INCREMENT,
	Latitudine INTEGER NOT NULL,
	Longitudine INTEGER NOT NULL
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS Indicazioni;
CREATE TABLE Indicazioni(
	Partenza INTEGER NOT NULL,
	Destinazione INTEGER NOT NULL,
	Tratta INTEGER NOT NULL,

	PRIMARY KEY(Partenza, Destinazione, Tratta),
	FOREIGN KEY(Partenza) REFERENCES Nodi(Id), -- vincolo partenza e destinazione diversi?
	FOREIGN KEY(Destinazione) REFERENCES Nodi(Id) -- vincolo partenza e destinazione diversi?
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS Veicoli;
CREATE TABLE Veicoli(
	Targa INTEGER PRIMARY KEY,
	Stato_batteria INTEGER, -- Check, bisonga controllare con un trigger? per poi spostare assegnarli un hub di ricarica?
	Posizione_x INTEGER NOT NULL,
	Posizione_y INTEGER NOT NULL,
	Tipo VARCHAR(255) NOT NULL,
	Guidatore INTEGER,
	In_ricarica INTEGER,
	Tratta INTEGER,
	Testa BOOLEAN,

	FOREIGN KEY(Guidatore) REFERENCES Autisti(Codice_dipendente),
	FOREIGN KEY(Tratta) REFERENCES Tratte(Id),
	FOREIGN KEY(In_ricarica) REFERENCES Stazioni_di_ricarica(id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS Autisti;
CREATE TABLE Autisti(
	Codice_dipendente INTEGER PRIMARY KEY AUTO_INCREMENT,
	Nome VARCHAR(255) NOT NULL,
	Cognome VARCHAR(255) NOT NULL,
	Data_di_nascita DATE,
	Passeggero INTEGER,

	FOREIGN KEY(Passeggero) REFERENCES Veicoli(Targa)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS Storico_tratte;
CREATE TABLE Storico_tratte(
	Id INTEGER PRIMARY KEY AUTO_INCREMENT,
	Tratta INTEGER,
	Veicolo INTEGER,
	Autista INTEGER,

	FOREIGN KEY(Tratta) REFERENCES Tratte(Id),
	FOREIGN KEY(Veicolo) REFERENCES Veicoli(Targa),
	FOREIGN KEY(Autista) REFERENCES Autisti(Codice_dipendente)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS Stazioni_di_ricarica;
CREATE TABLE Stazioni_di_ricarica(
	Id INTEGER PRIMARY KEY AUTO_INCREMENT,
	Posizione_x DECIMAL,
	Posizione_y DECIMAL,
	Posti_totali INTEGER
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS Archi;
CREATE TABLE Archi(
	Entrante INTEGER NOT NULL, /*Esprimere che entrante != uscente*/
	Uscente INTEGER NOT NULL,
	Nome VARCHAR(255),
	Peso INTEGER NOT NULL,

	FOREIGN KEY(Entrante) REFERENCES Nodi(Id),
	FOREIGN KEY(Uscente) REFERENCES Nodi(Id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SET FOREIGN_KEY_CHECKS=1;

-- Inserimento dei dati
INSERT INTO Fonti_di_pagamento(Id, Utente, Tipo) VALUES
(NULL, 1, "Carta di credito"),
(NULL, 1, "PayPal"),
(NULL, 2, "Carta di credito"),
(NULL, 2, "ApplePay"),
(NULL, 3, "Carta di credito"),
(NULL, 3, "PayPal"),
(NULL, 4, "Carta di credito"),
(NULL, 4, "GooglePay"),
(NULL, 5, "Carta di credito"),
(NULL, 5, "ApplePay"),
(NULL, 6, "Carta di credito"),
(NULL, 6, "GooglePay"),
(NULL, 7, "Carta di credito"),
(NULL, 7, "PayPal"),
(NULL, 8, "Carta di credito"),
(NULL, 8, "ApplePay"),
(NULL, 9, "Carta di credito"),
(NULL, 9, "PayPal"),
(NULL, 10, "Carta di credito"),
(NULL, 10, "GooglePay");

-- Query

--
