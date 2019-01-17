
-- SET FOREIGN_KEY_CHECKS=0;

LOAD DATA LOCAL INFILE 'data/Utenti.txt' INTO TABLE Utenti
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n';

LOAD DATA LOCAL INFILE 'data/Nodi.txt' INTO TABLE Nodi
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n';

LOAD DATA LOCAL INFILE 'data/Archi.txt' INTO TABLE Archi
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  LINES TERMINATED BY '\n';


-- SET FOREIGN_KEY_CHECKS=1;