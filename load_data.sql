
-- SET FOREIGN_KEY_CHECKS=0;

LOAD DATA LOCAL INFILE 'data/Utenti.csv' INTO TABLE Utenti
  (Email, Password, Nome, Cognome, Data_di_nascita)
  FIELDS TERMINATED BY ','
  OPTIONALLY ENCLOSED BY '"'
  ESCAPED BY '\\'
  LINES TERMINATED BY '\n'
  IGNORE 1 LINES;

INSERT INTO Metodi_di_pagamento(Id, Utente, Tipo) VALUES
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

LOAD DATA LOCAL INFILE 'data/Nodi.csv' INTO TABLE Nodi
  FIELDS TERMINATED BY ','
  OPTIONALLY ENCLOSED BY '"'
  ESCAPED BY '\\'
  LINES TERMINATED BY '\n'
  IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'data/Archi.csv' INTO TABLE Archi
  FIELDS TERMINATED BY ','
  OPTIONALLY ENCLOSED BY '"'
  ESCAPED BY '\\'
  LINES TERMINATED BY '\n'
  IGNORE 1 LINES;

-- SET FOREIGN_KEY_CHECKS=1;