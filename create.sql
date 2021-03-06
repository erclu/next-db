/* Progetto Base di Dati 18/19 Ercole Luca e Ferrati Marco*/

/* drop di tutte le tabelle */

SET FOREIGN_KEY_CHECKS=0;

DROP TABLE IF EXISTS Archi, Associazioni, Autisti, Corse, Eventi, EventiTratte, Cammini, Metodi_di_pagamento, Nodi, Richieste, Stazioni_di_ricarica, Storico_corse, Storico_tratte, Tratte, Utenti, Veicoli;

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

CREATE TABLE Richieste(
  Id INTEGER PRIMARY KEY AUTO_INCREMENT,
  Orario_richiesta TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Orario_partenza TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Origine_x DECIMAL(3, 1) NOT NULL,
  Origine_y DECIMAL(3, 1) NOT NULL,
  Destinazione_x DECIMAL(3, 1) NOT NULL,
  Destinazione_y DECIMAL(3, 1) NOT NULL,
  Utente INTEGER NOT NULL,
  Accettata BOOLEAN,

  CHECK(TRUNCATE(Origine_x, 0)=Origine_x OR TRUNCATE(Origine_y, 0)=Origine_y),
  CHECK(TRUNCATE(Destinazione_x, 0)=Destinazione_x OR TRUNCATE(Destinazione_y, 0)=Destinazione_y),

  FOREIGN KEY(Utente) REFERENCES Utenti(Id)
) Engine=InnoDB;

CREATE TABLE Corse(
  Richiesta INTEGER PRIMARY KEY,
  Orario_partenza TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Orario_conclusione TIMESTAMP NULL DEFAULT NULL,
  Prezzo DECIMAL(10, 2) CHECK(Prezzo>0),

  FOREIGN KEY(Richiesta) REFERENCES Richieste(Id)
) Engine=InnoDB;

CREATE TABLE Storico_corse( -- FIXME serve davvero?
  Id INTEGER PRIMARY KEY AUTO_INCREMENT,
  Corsa INTEGER NOT NULL,
  Utente INTEGER NOT NULL,

  FOREIGN KEY(Corsa) REFERENCES Corse(Richiesta),
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
  UNIQUE(Tratta, Posto_occupato),
  FOREIGN KEY(Corsa) REFERENCES Corse(Richiesta),
  FOREIGN KEY(Tratta) REFERENCES Tratte(Id)
) Engine=InnoDB;

CREATE TABLE Eventi(
  Id INTEGER PRIMARY KEY AUTO_INCREMENT,
  Orario TIMESTAMP NOT NULL,
  Tipo VARCHAR(255) NOT NULL

  -- TODO check sul tipo?
) Engine=InnoDB;

CREATE TABLE EventiTratte(
  Evento INTEGER NOT NULL,
  Tratta INTEGER NOT NULL,

  PRIMARY KEY(Evento, Tratta),
  FOREIGN KEY(Evento) REFERENCES Eventi(Id),
  FOREIGN Key(Tratta) REFERENCES Tratte(Id)
) Engine=InnoDB;

CREATE TABLE Stazioni_di_ricarica(
  Id INTEGER PRIMARY KEY AUTO_INCREMENT,
  Posizione_x DECIMAL(3, 1) NOT NULL,
  Posizione_y DECIMAL(3, 1) NOT NULL,
  Posti_totali INTEGER NOT NULL,

  CHECK(TRUNCATE(Posizione_x, 0)=Posizione_x OR TRUNCATE(Posizione_y, 0)=Posizione_y)
) Engine=InnoDB;

CREATE TABLE Veicoli(
  Targa CHAR(8) PRIMARY KEY,
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

CREATE TABLE Autisti(
  Codice_dipendente INTEGER PRIMARY KEY AUTO_INCREMENT,
  Nome VARCHAR(255) NOT NULL,
  Cognome VARCHAR(255) NOT NULL,
  Data_di_nascita DATE NOT NULL,
  Veicolo CHAR(8),
  Alla_guida BOOLEAN,

  CHECK((Veicolo IS NULL AND Alla_guida IS NULL) OR (Veicolo IS NOT NULL AND Alla_guida IS NOT NULL)),

  FOREIGN KEY(Veicolo) REFERENCES Veicoli(Targa)
) Engine=InnoDB;

CREATE TABLE Storico_tratte(
  Id INTEGER PRIMARY KEY AUTO_INCREMENT,
  Tratta INTEGER NOT NULL,
  Veicolo CHAR(8) NOT NULL,
  Autista INTEGER NOT NULL,

  FOREIGN KEY(Tratta) REFERENCES Tratte(Id),
  FOREIGN KEY(Veicolo) REFERENCES Veicoli(Targa),
  FOREIGN KEY(Autista) REFERENCES Autisti(Codice_dipendente)
) Engine=InnoDB;

CREATE TABLE Nodi(
  Id INTEGER PRIMARY KEY AUTO_INCREMENT,
  Latitudine INTEGER NOT NULL,
  Longitudine INTEGER NOT NULL,

  UNIQUE(Latitudine, Longitudine)
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

CREATE TABLE Cammini(
  Nodo INTEGER NOT NULL,
  Tratta INTEGER NOT NULL,
  Indice_sequenza INTEGER NOT NULL,

  PRIMARY KEY(Nodo, Tratta),
  FOREIGN KEY(Nodo) REFERENCES Nodi(Id),
  FOREIGN KEY(Tratta) REFERENCES Tratte(Id)
) Engine=InnoDB;
