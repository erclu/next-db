-- Query Progetto Basi di Dati 2018/19 Ercole Luca e Ferrati Marco


insert into Richieste values (null, current_timestamp, current_timestamp, 1, 37, 1, 20, null, null, 1)

-- trova tutti i veicoli vicini alle richieste
SELECT
    r.Id as Id_richiesta, r.Origine_x, r.Origine_y, v.Targa, v.Posizione_x, v.Posizione_y
FROM
    Richieste r,
    Veicoli v
WHERE
    v.Tipo = "Trasporto persone" AND
    r.Accettata IS NULL AND
    r.Origine_x BETWEEN v.Posizione_x - 25 and v.Posizione_x + 25
    AND
    r.Origine_y BETWEEN v.Posizione_y - 25 and v.Posizione_y + 25
GROUP BY
    r.Id, v.Targa
;