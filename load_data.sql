
SET FOREIGN_KEY_CHECKS=0;

TRUNCATE TABLE `Archi`;
TRUNCATE TABLE `Associazioni`;
TRUNCATE TABLE `Autisti`;
TRUNCATE TABLE `Corse`;
TRUNCATE TABLE `Eventi`;
TRUNCATE TABLE `Indicazioni`;
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

LOAD DATA LOCAL INFILE 'data/Nodi.csv' INTO TABLE Nodi
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
