/* Aggiunta di index */

ALTER TABLE Archi
  ADD INDEX(Nome);

ALTER TABLE Corse
  ADD INDEX(Origine_x, Origine_y),
  ADD INDEX(Destinazione_x, Destinazione_y);

ALTER TABLE Indicazioni
  ADD INDEX(Partenza),
  ADD INDEX(Destinazione); -- già esistente?????????

ALTER TABLE Nodi
  ADD INDEX(Latitudine, Longitudine);

ALTER TABLE Richieste
  ADD INDEX(Origine_x, Origine_y),
  ADD INDEX(Destinazione_x, Destinazione_y);

ALTER TABLE Stazioni_di_ricarica
  ADD INDEX(Posizione_x, Posizione_y);

ALTER TABLE Tratte
  ADD INDEX(Inizio_x, Inizio_y),
  ADD INDEX(Fine_x, Fine_y);

ALTER TABLE Veicoli
  ADD INDEX(Posizione_x, Posizione_y);