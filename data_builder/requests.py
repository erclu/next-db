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
      # completata:
      ("NULL", "NULL", "NULL", 1, 45, 20, 45, 1, 1, 4),
      # da completare:
      ("NULL", "NULL", "NULL", 47, 5, 47, 15, 1, 2, 5),
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
      (1, "2019-01-10 00:00:00", 30, 20, 30, 1, "2019-01-10 00:30:00", 3.50),
      (2, "NULL", 47, 5, 47, 15, "NULL", "NULL"),
    ]

    completed_rides = [("Id", "Corsa", "Utente"), ("NULL", 1, 4)]

    relationships = [
      ("Corsa", "Tratta", "Posto_occupato"),
      (1, 1, 0),
      (1, 2, 1),
      (2, 3, 0),
    ]

    routes = [
      ("Id", "Orario_partenza", "Inizio_x", "Inizio_y", "Fine_x", "Fine_y"),
      (1, "2019-01-10 00:00:00", 30, 20, 30, 10),
      (2, "2019-01-10 00:15:00", 30, 10, 30, 1), # è salito qualcuno?????? XXX
      (3, "NULL", 47, 5, 47, 15),
    ]

    completed_routes = [
      ("Id", "Tratta", "Veicolo", "Autista"),
      ("NULL", 1, 8, 1),
      ("NULL", 2, 8, 1),
    ]

    events = [
      ("Id", "Precedente", "Successiva", "Orario", "Tipo"),
      ("NULL", 1, 2, "2019-01-10 00:15:00", "TODO"),
    ] #TODO finish??

    write_to_file("Richieste.csv", requests)

    write_to_file("Corse.csv", rides)
    write_to_file("Storico_corse.csv", completed_rides)

    write_to_file("Tratte.csv", routes)
    write_to_file("Storico_tratte.csv", completed_routes)

    write_to_file("Associazioni.csv", relationships)
    write_to_file("Eventi.csv", events)


if __name__ == "__main__":
    create_files()