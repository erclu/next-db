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
    t.Id = c1.Tratta AND c1.Indice_sequenza +1 = c2.Indice_sequenza AND c1.Tratta = c2.Tratta AND c1.Nodo = a.Entrante AND c2.Nodo = a.Uscente
GROUP BY
    t.Id
ORDER BY
    t.Id,
    c1.Indice_sequenza
;

-- #2
DROP VIEW IF EXISTS durata_tratte;
CREATE VIEW durata_tratte AS
(
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
) AS
;
DROP VIEW IF EXISTS Ore_di_guida_per_autista;
CREATE VIEW Ore_di_guida_per_autista AS
SELECT
    a.Nome,
    a.Cognome,
    SEC_TO_TIME(
        SUM(
            TIME_TO_SEC(durata_tratte.durata_tratta)
        )
    ) Ore_di_guida
FROM
durata_tratte,
Storico_tratte st,
Autisti a
WHERE
    durata_tratte.idTratta = st.Tratta AND st.Autista = a.Codice_dipendente
GROUP BY
    st.Autista
;

-- #3


-- #4


-- #5
DROP VIEW IF EXISTS Sequenza_eventi_per_utente;
CREATE VIEW Sequenza_eventi_per_utente AS
SELECT
    u.Id,
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
	e.Tipo, a.Posto_occupato, u.Id
ORDER BY
    u.Id, e.Orario
;

-- #6
DROP VIEW IF EXISTS Veicoli_per_Richiesta;
CREATE VIEW Veicoli_per_Richiesta AS
SELECT
    r.Id AS Id_richiesta,
    r.Origine_x AS R_x,
    r.Origine_y AS R_y,
    v.Targa,
    ABS(r.Origine_x - v.Posizione_x) + ABS(r.Origine_y - v.Posizione_y) AS Distanza,
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
