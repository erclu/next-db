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
