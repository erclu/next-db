-- Query Progetto Basi di Dati 2018/19 Ercole Luca e Ferrati Marco

-- #6
DROP VIEW IF EXISTS Veicoli_per_Richiesta;
CREATE VIEW Veicoli_per_Richiesta AS
SELECT
    r.Id AS Id_richiesta,
    r.Origine_x AS R_x,
    r.Origine_y AS R_y,
    v.Targa,
    ABS(r.Origine_x - v.Posizione_x) AS Distanza_x,
    ABS(r.Origine_y - v.Posizione_y) AS Distanza_y,
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
    Distanza_x,
    Distanza_y;