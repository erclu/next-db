/* Progetto Base di Dati 18/19 Ercole Luca e Ferrati Marco*/

/* drop di tutte le tabelle */

SET FOREIGN_KEY_CHECKS=0;

DROP TABLE IF EXISTS Archi, Associazioni, Autisti, Corse, Eventi, Indicazioni, Metodi_di_pagamento, Nodi, Richieste, Stazioni_di_ricarica, Storico_corse, Storico_tratte, Tratte, Utenti, Veicoli;

SET FOREIGN_KEY_CHECKS=1;

/* Creazione tabelle e inserimento valori */

CREATE TABLE Utenti(
  Id INTEGER PRIMARY KEY AUTO_INCREMENT,
  Email VARCHAR(190) NOT NULL UNIQUE, /* 191 è la dimensione massima per un indice su varchar con encoding utf8mb4 */
  Password CHAR(64) NOT NULL,
  Nome VARCHAR(255) NOT NULL,
  Cognome VARCHAR(255) NOT NULL,
  Data_di_nascita DATE NOT NULL
) Engine=InnoDB;
/* Nota, all'inserimento cifrare il campo password */

CREATE TABLE Metodi_di_pagamento(
  Id INTEGER PRIMARY KEY AUTO_INCREMENT,
  Utente INTEGER,
  Tipo VARCHAR(255),

  FOREIGN KEY(Utente) REFERENCES Utenti(Id)
) Engine=InnoDB;

CREATE TABLE Corse(
  Id INTEGER AUTO_INCREMENT PRIMARY KEY,
  Orario_partenza TIMESTAMP NOT NULL,
  Origine_x INTEGER NOT NULL,
  Origine_y INTEGER NOT NULL,
  Destinazione_x INTEGER NOT NULL,
  Destinazione_y INTEGER NOT NULL,
  Ora_conclusione TIMESTAMP,
  Prezzo DECIMAL(10, 2) NOT NULL,

  CHECK(Prezzo>0)
) Engine=InnoDB;

CREATE TABLE Richieste(
  Id INTEGER PRIMARY KEY AUTO_INCREMENT,
  Orario_richiesta TIMESTAMP NOT NULL,
  Orario_partenza TIMESTAMP NOT NULL,
  Origine_x DECIMAL(3, 1) NOT NULL,
  Origine_y DECIMAL(3, 1) NOT NULL,
  Destinazione_x DECIMAL(3, 1) NOT NULL,
  Destinazione_y DECIMAL(3, 1) NOT NULL,
  Accettata BOOLEAN,
  Corsa INTEGER,
  Utente INTEGER NOT NULL,

  CHECK(TRUNCATE(Origine_x, 0)=Origine_x OR TRUNCATE(Origine_y, 0)=Origine_y),
  CHECK(TRUNCATE(Destinazione_x, 0)=Destinazione_x OR TRUNCATE(Destinazione_y, 0)=Destinazione_y),

  FOREIGN KEY(Utente) REFERENCES Utenti(Id),
  FOREIGN KEY(Corsa) REFERENCES Corse(Id)
) Engine=InnoDB;

CREATE TABLE Storico_corse(
  Id INTEGER PRIMARY KEY AUTO_INCREMENT,
  Corsa INTEGER NOT NULL,
  Utente INTEGER NOT NULL,

  FOREIGN KEY(Corsa) REFERENCES Corse(Id),
  FOREIGN KEY(Utente) REFERENCES Utenti(Id)
) Engine=InnoDB;

CREATE TABLE Tratte(
  Id INTEGER PRIMARY KEY AUTO_INCREMENT,
  Orario_partenza TIMESTAMP NOT NULL,
  Inizio_x DECIMAL(3, 1) NOT NULL,
  Inizio_y DECIMAL(3, 1) NOT NULL,
  Fine_x DECIMAL(3, 1) NOT NULL,
  Fine_y DECIMAL(3, 1) NOT NULL,

  CHECK(TRUNCATE(Inizio_x, 0)=Inizio_x OR TRUNCATE(Inizio_y, 0)=Inizio_y),
  CHECK(TRUNCATE(Fine_x, 0)=Fine_x OR TRUNCATE(Fine_y, 0)=Fine_y)
) Engine=InnoDB;

CREATE TABLE Associazioni(
  Corsa INTEGER NOT NULL,
  Tratta INTEGER NOT NULL,
  Posto_occupato INTEGER NOT NULL,

  PRIMARY KEY(Corsa, Tratta, Posto_occupato),
  FOREIGN KEY(Corsa) REFERENCES Corse(Id),
  FOREIGN KEY(Tratta) REFERENCES Tratte(Id)
) Engine=InnoDB;

CREATE TABLE Eventi(
  Id INTEGER PRIMARY KEY AUTO_INCREMENT,
  Precedente INTEGER,
  Successiva INTEGER,
  Orario TIMESTAMP,
  Tipo VARCHAR(255),

  FOREIGN KEY(Precedente) REFERENCES Tratte(Id),
  FOREIGN KEY(Successiva) REFERENCES Tratte(Id)
) Engine=InnoDB;

CREATE TABLE Stazioni_di_ricarica(
  Id INTEGER PRIMARY KEY AUTO_INCREMENT,
  Posizione_x DECIMAL(3, 1) NOT NULL,
  Posizione_y DECIMAL(3, 1) NOT NULL,
  Posti_totali INTEGER NOT NULL,

  CHECK(TRUNCATE(Posizione_x, 0)=Posizione_x OR TRUNCATE(Posizione_y, 0)=Posizione_y)
) Engine=InnoDB;

CREATE TABLE Autisti(
  Codice_dipendente INTEGER PRIMARY KEY AUTO_INCREMENT,
  Nome VARCHAR(255) NOT NULL,
  Cognome VARCHAR(255) NOT NULL,
  Data_di_nascita DATE NOT NULL,
  Veicolo INTEGER,
  Alla_guida BOOLEAN,

  CHECK((Veicolo IS NULL AND Alla_guida IS NULL) OR (Veicolo IS NOT NULL AND Alla_guida IS NOT NULL)),

  FOREIGN KEY(Veicolo) REFERENCES Veicoli(Targa)
) Engine=InnoDB;

CREATE TABLE Veicoli(
  Targa INTEGER PRIMARY KEY AUTO_INCREMENT,
  Stato_batteria INTEGER NOT NULL,
  Posizione_x DECIMAL(3, 1) NOT NULL,
  Posizione_y DECIMAL(3, 1) NOT NULL,
  Tipo VARCHAR(255) NOT NULL DEFAULT "Trasporto persone",
  In_ricarica INTEGER,
  Tratta INTEGER,
  Testa BOOLEAN,

  CHECK(Stato_batteria>=0 AND Stato_batteria<=100),
  CHECK(TRUNCATE(Posizione_x, 0)=Posizione_x OR TRUNCATE(Posizione_y, 0)=Posizione_y),
  CHECK(Tipo="Trasporto persone" OR Tipo="Trasporto merci" OR Tipo="Servizi" OR Tipo="Battery pack"),
  CHECK((Tratta IS NULL AND Testa IS NULL) OR (Tratta IS NOT NULL AND Testa IS NOT NULL)),

  FOREIGN KEY(Tratta) REFERENCES Tratte(Id),
  FOREIGN KEY(In_ricarica) REFERENCES Stazioni_di_ricarica(Id)
) Engine=InnoDB;

CREATE TABLE Storico_tratte(
  Id INTEGER PRIMARY KEY AUTO_INCREMENT,
  Tratta INTEGER NOT NULL,
  Veicolo INTEGER NOT NULL,
  Autista INTEGER NOT NULL,

  FOREIGN KEY(Tratta) REFERENCES Tratte(Id),
  FOREIGN KEY(Veicolo) REFERENCES Veicoli(Targa),
  FOREIGN KEY(Autista) REFERENCES Autisti(Codice_dipendente)
) Engine=InnoDB;

CREATE TABLE Nodi(
  Id INTEGER PRIMARY KEY AUTO_INCREMENT,
  Latitudine INTEGER NOT NULL,
  Longitudine INTEGER NOT NULL
) Engine=InnoDB;

CREATE TABLE Archi(
  Entrante INTEGER NOT NULL,
  Uscente INTEGER NOT NULL,
  Nome VARCHAR(255) NOT NULL,
  Peso INTEGER NOT NULL,

  CHECK(Entrante<>Uscente),

  PRIMARY KEY(Entrante, Uscente),
  FOREIGN KEY(Entrante) REFERENCES Nodi(Id),
  FOREIGN KEY(Uscente) REFERENCES Nodi(Id)
) Engine=InnoDB;

CREATE TABLE Indicazioni(
  Partenza INTEGER NOT NULL,
  Destinazione INTEGER NOT NULL,
  Tratta INTEGER NOT NULL,

  CHECK(Partenza<>Destinazione),

  PRIMARY KEY(Partenza, Destinazione, Tratta),
  FOREIGN KEY(Partenza) REFERENCES Nodi(Id),
  FOREIGN KEY(Destinazione) REFERENCES Nodi(Id),
  FOREIGN KEY(Tratta) REFERENCES Tratte(Id)
) Engine=InnoDB;
