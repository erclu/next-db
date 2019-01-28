from .utils import write_to_file, NULL


def create_files():
    req_time = "2018-12-31 23:00:00"
    start_time = "2019-01-10 00:00:00"
    end_time = "2019-01-10 00:45:00"

    requests = [
      (
        "Id",
        "Orario_richiesta",
        "Orario_partenza",
        "Origine_x",
        "Origine_y",
        "Destinazione_x",
        "Destinazione_y",
        "Utente",
        "Accettata",
      ),
      # accettate e concluse:
      (NULL, req_time, start_time, 45, 20, 45, 1, 1, 1), # R_alice
      (NULL, req_time, start_time, 45, 20, 35, 10, 2, 1), # R_bob
      (NULL, req_time, start_time, 30, 15, 45, 1, 3, 1), # R_charlie
      # accettate e in corso, due utenti che hanno fatto la stessa richiesta:
      (NULL, NULL, NULL, 47, 5, 47, 15, 4, 1),
      (NULL, NULL, NULL, 47, 5, 47, 15, 5, 1),
      # non ancora accettate:
      (NULL, NULL, NULL, 1, 45, 20, 45, 6, NULL),
      (NULL, NULL, NULL, 14, 14, 20, 20, 7, NULL),
      (NULL, NULL, NULL, 1, 37, 1, 1, 8, NULL),
    ]

    rides = [
      (
        "Id",
        "Orario_partenza",
<<<<<<< HEAD
        "Ora_conclusione",
=======
        "Origine_x",
        "Origine_y",
        "Destinazione_x",
        "Destinazione_y",
        "Orario_conclusione",
>>>>>>> b0713ff935d8970302c73501f6090dbb9ac19df8
        "Prezzo",
      ),
      # TODO calcolo prezzi su corse completate..
      (1, start_time, end_time, 3.50), # C_Alice
      (2, start_time, end_time, 3.0), # C_Bob
      (3, start_time, end_time, 3.75), # C_Charlie
      # Corsa in corso
      (4, NULL, NULL, NULL),
    ]

    completed_rides = [
      ("Id", "Corsa", "Utente"),
      (NULL, 1, 1), # Storico Alice
      (NULL, 2, 2), # Storico Bob
      (NULL, 3, 3), # Storico Charlie
    ]

    relationships = [
      ("Corsa", "Tratta", "Posto_occupato"),
      (1, 1, 0),
      (1, 3, 0),
      (1, 4, 0),
      (2, 1, 1),
      (2, 3, 1),
      (2, 5, 0),
      (3, 2, 0),
      (3, 3, 2),
      (3, 4, 1),
      (4, 6, 0),
      (4, 6, 1), #FIXME due utenti una corsa occupano due posti? vedi query...
    ]

    routes = [
      ("Id", "Orario_partenza", "Inizio_x", "Inizio_y", "Fine_x", "Fine_y"),
      (1, start_time, 45, 20, 45, 15),
      (2, start_time, 30, 15, 45, 15),
      (3, "2019-01-10 00:15:00", 45, 15, 45, 10), # UNIONE
      (4, "2019-01-10 00:30:00", 45, 10, 45, 1),
      (5, "2019-01-10 00:30:00", 45, 10, 35, 10),
      # in corso
      (6, NULL, 47, 5, 47, 15),
    ]

    completed_routes = [
      ("Id", "Tratta", "Veicolo", "Autista"),
      (NULL, 1, "NXT00001", 1),
      (NULL, 2, "NXT00002", 2),
      (NULL, 3, "NXT00001", 1),
      (NULL, 4, "NXT00001", 1),
      (NULL, 5, "NXT00003", 3),
    ]

    events = [
      ("Id", "Orario", "Tipo"),
      (1, start_time, "Salita"), # alice e bob salgono
      (2, start_time, "Salita"), # charlie sale
      (3, "2019-01-10 00:15:00",
       "Transfer"), # charlie va sul veicolo di alice e bob
      (4, "2019-01-10 00:30:00", "Transfer"), # bob cambia veicolo
      (5, end_time, "Discesa"), # alice e charlie scendono
      (6, end_time, "Discesa"), # bob scendono
      # In corso
      (7, NULL, "Salita")
    ]

    events_routes = [
      ("Evento", "Tratta"),
      (1, 1), # salita A,B
      (2, 2), # salita C
      (3, 1), # transfer IN
      (3, 2), # transfer IN
      (3, 3), # transfer OUT
      (4, 3), # transfer IN
      (4, 4), # transfer OUT
      (4, 5), # transfer OUT
      (5, 4), # discesa A,C
      (6, 5), # discesa B
      (7, 6), # In corso
    ]

    write_to_file("Richieste.csv", requests)

    write_to_file("Corse.csv", rides)
    write_to_file("Storico_corse.csv", completed_rides)

    write_to_file("Tratte.csv", routes)
    write_to_file("Storico_tratte.csv", completed_routes)

    write_to_file("Associazioni.csv", relationships)
    write_to_file("Eventi.csv", events)
    write_to_file("EventiTratte.csv", events_routes)


if __name__ == "__main__":
    create_files()
