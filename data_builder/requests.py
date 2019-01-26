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
      ("NULL", "NULL", "NULL", 1, 37, 1, 1, "NULL", "NULL", 1),
      ("NULL", "NULL", "NULL", 14, 14, 20, 20, "NULL", "NULL", 2),
      ("NULL", "NULL", "NULL", 1, 45, 20, 45, "NULL", "NULL", 3),
      #   ("NULL", "NULL", "NULL", 46, 7, 40, 12, "NULL", "NULL", 4),
    ]

    write_to_file("Richieste.csv", requests)