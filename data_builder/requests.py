from .utils import write_to_file


def create_files():
    requests = [
      (
        "Id",
        "Orario_richiesta",
        "Orario_partenza",
        "Origine_x",
        "Origine_y",
        "Destinazione_x",
        "Destinazione_y",
        "Accettata",
        "Corsa",
        "Utente",
      ),
      ("NULL", "NULL", "NULL", 1, 45, 20, 45, "NULL", "NULL", 1),
      ("NULL", "NULL", "NULL", 14, 14, 20, 20, "NULL", "NULL", 2),
      ("NULL", "NULL", "NULL", 1, 37, 1, 1, "NULL", "NULL", 3),
      # accettata e in corso:
      ("NULL", "NULL", "NULL", 47, 5, 47, 15, 1, 2, 5),
      # accettate e completate:
      (
        "NULL", "2019-01-09 20:00:00", "2019-01-10 00:00:00", 45, 20, 45, 1, 1,
        1, 1), #R_alice
      (
        "NULL", "2019-01-09 20:00:00", "2019-01-10 00:00:00", 45, 20, 35, 10,
        1, 2, 2), #R_bob
      (
        "NULL", "2019-01-09 20:00:00", "2019-01-10 00:00:00", 30, 15, 45, 1, 1,
        3, 3), #R_charlie
    ]

    rides = [
      (
        "Id",
        "Orario_partenza",
        "Origine_x",
        "Origine_y",
        "Destinazione_x",
        "Destinazione_y",
        "Ora_conclusione",
        "Prezzo",
      ),
      # TODO: calcolo prezzi....
      (1, "2019-01-10 00:00:00", 45, 20, 45, 1, "2019-01-10 00:45:00",
       3.50), #C_Alice
      (2, "2019-01-10 00:00:00", 45, 20, 35, 10, "2019-01-10 00:45:00",
       3.0), #C_Bob
      (3, "2019-01-10 00:00:00", 30, 15, 45, 1, "2019-01-10 00:45:00",
       3.75), #C_Charlie
      #Corsa in corso
      (4, "NULL", 47, 5, 47, 15, "NULL", "NULL"),
    ]

    completed_rides = [
      ("Id", "Corsa", "Utente"),
      ("NULL", 1, 4),
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
    ]

    routes = [
      ("Id", "Orario_partenza", "Inizio_x", "Inizio_y", "Fine_x", "Fine_y"),
      (1, "2019-01-10 00:00:00", 45, 20, 45, 15),
      (2, "2019-01-10 00:00:00", 30, 15, 45, 15),
      (3, "2019-01-10 00:15:00", 45, 15, 45, 10), #UNIONE
      (4, "2019-01-10 00:30:00", 45, 10, 45, 1),
      (5, "2019-01-10 00:30:00", 45, 10, 35, 10),
      #in corso
      (6, "NULL", 47, 5, 47, 15),
    ]

    completed_routes = [
      ("Id", "Tratta", "Veicolo", "Autista"),
      ("NULL", 1, "NXT00001", 1),
      ("NULL", 2, "NXT00002", 2),
      ("NULL", 3, "NXT00001", 1),
      ("NULL", 4, "NXT00001", 1),
      ("NULL", 5, "NXT00003", 3),
    ]

    events = [
      ("Id", "Orario", "Tipo"), # tratta Precedente/Successiva all'evento
      (1, "2019-01-10 00:00:00", "Salita"),
      (2, "2019-01-10 00:00:00", "Salita"),
      (3, "2019-01-10 00:15:00", "Transfer"),
      (4, "2019-01-10 00:30:00", "Transfer"),
      (5, "2019-01-10 00:45:00", "Discesa"),
      (6, "2019-01-10 00:45:00", "Discesa"),
      #In corso
      #   ("NULL", "NULL", "Salita")
    ] #TODO finish??

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
