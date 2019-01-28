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
DROP VIEW IF EXISTS Utenti_che_non_hanno_fatto_almeno_una_richiesta;
CREATE VIEW Utenti_che_non_hanno_fatto_almeno_una_richiesta AS
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
)
