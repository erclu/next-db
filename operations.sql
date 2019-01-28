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
CREATE FUNCTION Controllo_batteria(Targa_to_check CHAR(8)) RETURNS VARCHAR
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

  SELECT v.Stato_batteria, v.Posizione_x, v.Posizione_y INTO (stato_batteria, posX, posY)
  FROM Veicoli v
  WHERE v.targa = Targa_to_check;

  IF stato_batteria < 20
  THEN
    SELECT sdr.Id, sdr.Posizione_x, sdr.Posizione_y, ABS(sdr.Posizione_x - posX) + ABS(sdr.Posizione_y - posY) as Distanza
    INTO (stazione_di_ricarica_piu_vicina, posX_stazione, posY_stazione, distanza_stdr)
    FROM Stazioni_di_ricarica sdr
    ORDER BY Distanza
    LIMIT 1;

    SELECT v.Targa, v.Posizione_x, v.Posizione_y, ABS(v.Posizione_x - posX) + ABS(v.Posizione_y - posY) as Distanza
    INTO (veicolo_di_ricarica_piu_vicina, posX_bp, posY_bp, distanza_bp)
    FROM Veicoli v
    WHERE v.Targa <> Targa_to_check AND v.Tipo = "Battery pack"
    LIMIT 1;

    if distanza_stdr < distanza_bp
    THEN
      UPDATE Veicoli SET In_ricarica = stazione_di_ricarica_piu_vicina WHERE Veicoli.Targa = Targa_to_check;
      INSERT INTO Tratte VALUES(NULL, CURRENT_TIMESTAMP, posX, posY, posX_stazione, posY_stazione)
      UPDATE Veicoli SET Tratta = SELECT LAST_INSERT_ID() WHERE Veicoli.Targa = Targa_to_check;
      RETURN CONCAT("Stazione di ricarica: (",posX_stazione, ", ", posY_stazione, ")")
    ELSE
      INSERT INTO Tratte VALUES(NULL, CURRENT_TIMESTAMP, posX, posY, posX_bp, posY_bp)
      UPDATE Veicoli SET Tratta = SELECT LAST_INSERT_ID() WHERE Veicoli.Targa = Targa_to_check;
      RETURN CONCAT("Veicolo: (",posX_bp, ", ", posY_bp, ")")
    END IF;
  END IF;
END |
DELIMITER ;
