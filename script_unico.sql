/* Progetto Base di Dati 18/19 Ercole Luca e Ferrati Marco*/
/* CREAZIONE TABELLE*/
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

/* CREAZIONE QUERIES come viste*/
-- Query Progetto Basi di Dati 2018/19 Ercole Luca e Ferrati Marco

-- #1
DROP VIEW IF EXISTS Lunghezza_cammino_per_tratta;
CREATE VIEW Lunghezza_cammino_per_tratta AS
SELECT
    t.Id AS tratta_id,
    SUM(a.Peso) AS lunghezza_cammino
FROM
    Tratte t,
    Cammini c1,
    Cammini c2,
    Archi a
WHERE
    t.Id = c1.Tratta AND c1.Indice_sequenza + 1 = c2.Indice_sequenza AND c1.Tratta = c2.Tratta AND c1.Nodo = a.Entrante AND c2.Nodo = a.Uscente
GROUP BY
    t.Id
ORDER BY
    t.Id,
    c1.Indice_sequenza
;

-- #2
DROP VIEW IF EXISTS durata_tratte;
CREATE VIEW durata_tratte AS
SELECT
    t.Id idTratta,
    TIMEDIFF(e.Orario, t.Orario_partenza) durata_tratta
FROM
    Eventi e,
    EventiTratte et,
    Tratte t
WHERE
    e.Id = et.Evento AND et.Tratta = t.Id AND e.Orario <> t.Orario_partenza
ORDER BY
    t.Id
;

DROP VIEW IF EXISTS Ore_di_guida_per_autista;
CREATE VIEW Ore_di_guida_per_autista AS
SELECT
    a.Nome,
    a.Cognome,
    SEC_TO_TIME(
        SUM(
            TIME_TO_SEC(dt.durata_tratta)
        )
    ) Ore_di_guida
FROM
durata_tratte dt,
Storico_tratte st,
Autisti a
WHERE
    dt.idTratta = st.Tratta AND st.Autista = a.Codice_dipendente
GROUP BY
    st.Autista
;

-- #3
DROP VIEW IF EXISTS Storico_utenti_per_veicolo;
CREATE VIEW Storico_utenti_per_veicolo AS
SELECT
    u.Nome,
    u.Cognome,
    st.Veicolo,
    SUM(lcpt.lunghezza_cammino) AS strada_percorsa
FROM
    Utenti u,
    Storico_corse sc,
    Associazioni a,
    Tratte t,
    Lunghezza_cammino_per_tratta lcpt,
    Storico_tratte st
WHERE
    u.Id = sc.Utente AND sc.Corsa = a.Corsa AND a.Tratta = t.Id AND t.Id = lcpt.tratta_id AND st.Tratta = lcpt.tratta_id
GROUP BY
    u.Id, st.Veicolo
;

-- #4
DROP VIEW IF EXISTS Sequenza_eventi_per_utente;
CREATE VIEW Sequenza_eventi_per_utente AS
SELECT
    u.Id AS id_utente,
    u.Nome,
    u.Cognome,
    e.Orario AS orario_evento,
    e.Tipo AS tipo_evento,
    a.Posto_occupato,
    t.Id AS id_tratta,
    t.Orario_partenza AS orario_partenza_tratta,
    t.Inizio_x,
    t.Inizio_y
FROM
    Eventi e, EventiTratte et, Tratte t, Associazioni a, Corse c, Richieste r, Utenti u
WHERE
    e.Id = et.Evento AND
    et.Tratta = t.Id AND
    t.Id = a.Tratta AND
    a.Corsa = c.Richiesta AND
    c.Richiesta = r.Id AND
    r.Utente = u.Id
GROUP BY
    e.Tipo, t.Id, a.Posto_occupato, u.Id
ORDER BY
    u.Id, e.Orario
;

-- #5
DROP VIEW IF EXISTS Vicinanza_veicoli_a_richieste;
CREATE VIEW Vicinanza_veicoli_a_richieste AS
SELECT
    r.Id AS Id_richiesta,
    v.Targa,
    ABS(r.Origine_x - v.Posizione_x) + ABS(r.Origine_y - v.Posizione_y) AS Distanza,
    r.Origine_x AS R_x,
    r.Origine_y AS R_y,
    v.Posizione_x AS V_x,
    v.Posizione_y AS V_y
FROM
    Richieste r,
    Veicoli v
WHERE
    v.Tipo = "Trasporto persone" AND r.Accettata IS NULL AND ABS(r.Origine_x - v.Posizione_x) < 25 AND ABS(r.Origine_y - v.Posizione_y) < 25
GROUP BY
    r.Id,
    v.Targa
ORDER BY
    r.Id,
    Distanza
;

-- #6
DROP VIEW IF EXISTS Utenti_che_hanno_fatto_almeno_una_richiesta;
CREATE VIEW Utenti_che_hanno_fatto_almeno_una_richiesta AS
SELECT
    u.Nome,
    u.Cognome
FROM
    Utenti u
WHERE EXISTS
    (
    SELECT
        r.Id
    FROM
        Richieste r
    WHERE
        u.Id = r.Utente
);

/*CREAZIONE TRIGGER E FUNZIONI*/
-- Trigger e funzioni Progetto Basi di Dati 2018/19 Ercole Luca e Ferrati Marco

-- Trigger 1 calcolo della nuova targa
DROP TRIGGER IF EXISTS Calcolo_targa;
DELIMITER |
CREATE TRIGGER Calcolo_targa
BEFORE INSERT ON Veicoli
FOR EACH ROW
BEGIN
DECLARE ultima_targa INTEGER;
DECLARE nuova_targa CHAR(8);
DECLARE padding_zeros CHAR(5);

SELECT CAST(RIGHT(MAX(Targa), 5) AS UNSIGNED) + 1
INTO ultima_targa
FROM Veicoli;

SET nuova_targa := CAST(ultima_targa AS CHAR);
SET padding_zeros := RIGHT("00000", 5 - CHAR_LENGTH(nuova_targa));

SET NEW.Targa = CONCAT("NXT", padding_zeros, nuova_targa);

END |
DELIMITER ;

-- Trigger 2 calcolo del prezzo quando una corsa è conclusa
DROP VIEW IF EXISTS Utenti_in_tratta;
CREATE VIEW Utenti_in_tratta AS
SELECT t.Id as tratta_id, COUNT(a.Posto_occupato) as num_posti_occupati_in_tratta
FROM Tratte t, Associazioni a
WHERE a.Tratta = t.Id
GROUP BY t.Id;

DROP TRIGGER IF EXISTS Calcolo_prezzo;
DELIMITER |
CREATE TRIGGER Calcolo_prezzo
BEFORE UPDATE ON Corse
FOR EACH ROW
BEGIN

DECLARE price DECIMAL(10,2);
SET price = 0;

SELECT SUM(lcpt.lunghezza_cammino/uit.num_posti_occupati_in_tratta) INTO price
FROM Utenti_in_tratta uit, Associazioni a, Lunghezza_cammino_per_tratta lcpt
WHERE NEW.Richiesta = a.Corsa AND a.Tratta = uit.tratta_id AND lcpt.tratta_id = uit.tratta_id;

SET NEW.prezzo = price;
END |
DELIMITER ;

-- Funzione 1
DROP FUNCTION IF EXISTS Accettazione_richiesta;
DELIMITER |
CREATE FUNCTION Accettazione_richiesta(Richiesta_id INTEGER) RETURNS BOOLEAN
BEGIN

  DECLARE targa CHAR(8);
  DECLARE orario_partenza TIMESTAMP;

  SELECT Targa INTO targa
  FROM Vicinanza_veicoli_a_richieste as vvar
  WHERE vvar.Id_richiesta = Richiesta_id
  LIMIT 1;

  SELECT r.Orario_partenza INTO orario_partenza
  FROM Richieste r
  WHERE r.Id = Richiesta_id;

  IF targa IS NOT NULL
  THEN
    UPDATE Richieste SET Accettata = 1 WHERE Richieste.Id = Richiesta_id;
    INSERT INTO Corse VALUES(Richiesta_id, orario_partenza, NULL, NULL);
    RETURN 1;
  ELSE
    UPDATE Richieste SET Accettata = 0 WHERE Richieste.Id = Richiesta_id;
    RETURN 0;
  END IF;
END |
DELIMITER ;
-- Funzione 2
DROP FUNCTION IF EXISTS Controllo_batteria;
DELIMITER |
CREATE FUNCTION Controllo_batteria(Targa_to_check CHAR(8)) RETURNS VARCHAR(255)
BEGIN
  DECLARE stato_batteria INTEGER;
  DECLARE posX DECIMAL(3,1);
  DECLARE posY DECIMAL(3,1);
  DECLARE stazione_di_ricarica_piu_vicina INTEGER;
  DECLARE posX_stazione INTEGER;
  DECLARE posY_stazione INTEGER;
  DECLARE veicolo_di_ricarica_piu_vicina CHAR(8);
  DECLARE posX_bp INTEGER;
  DECLARE posY_bp INTEGER;
  DECLARE distanza_stdr INTEGER;
  DECLARE distanza_bp INTEGER;

  SELECT v.Stato_batteria, v.Posizione_x, v.Posizione_y INTO stato_batteria, posX, posY
  FROM Veicoli v
  WHERE v.Targa = Targa_to_check;

  IF stato_batteria < 20
  THEN
    SELECT sdr.Id, sdr.Posizione_x, sdr.Posizione_y, ABS(sdr.Posizione_x - posX) + ABS(sdr.Posizione_y - posY) as Distanza
    INTO stazione_di_ricarica_piu_vicina, posX_stazione, posY_stazione, distanza_stdr
    FROM Stazioni_di_ricarica sdr
    ORDER BY Distanza
    LIMIT 1;

    SELECT v.Targa, v.Posizione_x, v.Posizione_y, ABS(v.Posizione_x - posX) + ABS(v.Posizione_y - posY) as Distanza
    INTO veicolo_di_ricarica_piu_vicina, posX_bp, posY_bp, distanza_bp
    FROM Veicoli v
    WHERE v.Targa <> Targa_to_check AND v.Tipo = "Battery pack"
    LIMIT 1;

    IF distanza_stdr < distanza_bp
    THEN
      UPDATE Veicoli SET In_ricarica = stazione_di_ricarica_piu_vicina WHERE Veicoli.Targa = Targa_to_check;
      INSERT INTO Tratte VALUES(NULL, CURRENT_TIMESTAMP, posX, posY, posX_stazione, posY_stazione);
      UPDATE Veicoli SET Tratta = (SELECT LAST_INSERT_ID()) WHERE Veicoli.Targa = Targa_to_check;

      RETURN CONCAT("Stazione di ricarica: (",posX_stazione, ", ", posY_stazione, ")");
    ELSE
      INSERT INTO Tratte VALUES(NULL, CURRENT_TIMESTAMP, posX, posY, posX_bp, posY_bp);

      UPDATE Veicoli SET Tratta = (SELECT LAST_INSERT_ID()) WHERE Veicoli.Targa = Targa_to_check;
      RETURN CONCAT("Veicolo: (",posX_bp, ", ", posY_bp, ")");
    END IF;
  END IF;
END |
DELIMITER ;


/* INSERIMENTO DEI VALORI CHE SI TROVANO NELLA CARTELLA data */

SET FOREIGN_KEY_CHECKS=0;

TRUNCATE TABLE `Archi`;
TRUNCATE TABLE `Associazioni`;
TRUNCATE TABLE `Autisti`;
TRUNCATE TABLE `Cammini`;
TRUNCATE TABLE `Corse`;
TRUNCATE TABLE `Eventi`;
TRUNCATE TABLE `EventiTratte`;
TRUNCATE TABLE `Metodi_di_pagamento`;
TRUNCATE TABLE `Nodi`;
TRUNCATE TABLE `Richieste`;
TRUNCATE TABLE `Stazioni_di_ricarica`;
TRUNCATE TABLE `Storico_corse`;
TRUNCATE TABLE `Storico_tratte`;
TRUNCATE TABLE `Tratte`;
TRUNCATE TABLE `Utenti`;
TRUNCATE TABLE `Veicoli`;

SET FOREIGN_KEY_CHECKS=1;

LOAD DATA LOCAL INFILE 'data/Utenti.csv' INTO TABLE Utenti
  FIELDS TERMINATED BY ','
  OPTIONALLY ENCLOSED BY '"'
  ESCAPED BY '"'
  LINES TERMINATED BY '\n'
  IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'data/Metodi_di_pagamento.csv' INTO TABLE Metodi_di_pagamento
  FIELDS TERMINATED BY ','
  OPTIONALLY ENCLOSED BY '"'
  ESCAPED BY '"'
  LINES TERMINATED BY '\n'
  IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'data/Richieste.csv' INTO TABLE Richieste
  FIELDS TERMINATED BY ','
  OPTIONALLY ENCLOSED BY '"'
  ESCAPED BY '"'
  LINES TERMINATED BY '\n'
  IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'data/Corse.csv' INTO TABLE Corse
  FIELDS TERMINATED BY ','
  OPTIONALLY ENCLOSED BY '"'
  ESCAPED BY '"'
  LINES TERMINATED BY '\n'
  IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'data/Storico_corse.csv' INTO TABLE Storico_corse
  FIELDS TERMINATED BY ','
  OPTIONALLY ENCLOSED BY '"'
  ESCAPED BY '"'
  LINES TERMINATED BY '\n'
  IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'data/Tratte.csv' INTO TABLE Tratte
  FIELDS TERMINATED BY ','
  OPTIONALLY ENCLOSED BY '"'
  ESCAPED BY '"'
  LINES TERMINATED BY '\n'
  IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'data/Associazioni.csv' INTO TABLE Associazioni
  FIELDS TERMINATED BY ','
  OPTIONALLY ENCLOSED BY '"'
  ESCAPED BY '"'
  LINES TERMINATED BY '\n'
  IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'data/Eventi.csv' INTO TABLE Eventi
  FIELDS TERMINATED BY ','
  OPTIONALLY ENCLOSED BY '"'
  ESCAPED BY '"'
  LINES TERMINATED BY '\n'
  IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'data/EventiTratte.csv' INTO TABLE EventiTratte
  FIELDS TERMINATED BY ','
  OPTIONALLY ENCLOSED BY '"'
  ESCAPED BY '"'
  LINES TERMINATED BY '\n'
  IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'data/Nodi.csv' INTO TABLE Nodi
  FIELDS TERMINATED BY ','
  OPTIONALLY ENCLOSED BY '"'
  ESCAPED BY '"'
  LINES TERMINATED BY '\n'
  IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'data/Cammini.csv' INTO TABLE Cammini
  FIELDS TERMINATED BY ','
  OPTIONALLY ENCLOSED BY '"'
  ESCAPED BY '"'
  LINES TERMINATED BY '\n'
  IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'data/Veicoli.csv' INTO TABLE Veicoli
  FIELDS TERMINATED BY ','
  OPTIONALLY ENCLOSED BY '"'
  ESCAPED BY '"'
  LINES TERMINATED BY '\n'
  IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'data/Autisti.csv' INTO TABLE Autisti
  FIELDS TERMINATED BY ','
  OPTIONALLY ENCLOSED BY '"'
  ESCAPED BY '"'
  LINES TERMINATED BY '\n'
  IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'data/Storico_tratte.csv' INTO TABLE Storico_tratte
  FIELDS TERMINATED BY ','
  OPTIONALLY ENCLOSED BY '"'
  ESCAPED BY '"'
  LINES TERMINATED BY '\n'
  IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'data/Stazioni_di_ricarica.csv' INTO TABLE Stazioni_di_ricarica
  FIELDS TERMINATED BY ','
  OPTIONALLY ENCLOSED BY '"'
  ESCAPED BY '"'
  LINES TERMINATED BY '\n'
  IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'data/Archi.csv' INTO TABLE Archi
  FIELDS TERMINATED BY ','
  OPTIONALLY ENCLOSED BY '"'
  ESCAPED BY '"'
  LINES TERMINATED BY '\n'
  IGNORE 1 LINES;
