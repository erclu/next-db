from .road_network import GRID_SIZE
from .users import NAME, SURNAME, DOB
from .utils import write_to_file, get_seeded_random

HOW_MANY_VEHICLES = 10
HOW_MANY_DRIVERS = 2*HOW_MANY_VEHICLES
HOW_MANY_HUBS = 5 # XXX not implemented


def create_files():
    # TODO targhe: NXT001ecc??
    random = get_seeded_random()

    drivers = [(
      "Codice_dipendente", "Nome", "Cognome", "Data_di_nascita", "Passeggero")]

    hubs = (
      ("Id", "Posizione_x", "Posizione_y", "Posti_totali"),
      (1, 34, 27, 3),
      (2, 29, 14, 4),
      (3, 45, 7, 10),
      (4, 36, 8, 7),
      (5, 15, 34, 10),
    )

    vehicles = [(
      "Targa", "Stato_batteria", "Posizione_x", "Posizione_y", "Tipo",
      "Guidatore", "In_ricarica", "Tratta", "Testa")]

    vehicle_types = [
      "Trasporto persone", "Trasporto persone", "Trasporto persone",
      "Trasporto merci", "Servizi", "Battery pack"
    ]

    for i in range(1, HOW_MANY_VEHICLES + 1):
        vehicle_type = vehicle_types[i - 1] if i - 1 < len(
          vehicle_types) else random.choice(vehicle_types)

        vehicle = (
          i,
          random.choice(range(20, 101)),
          random.choice(range(GRID_SIZE)),
          random.choice(range(GRID_SIZE)),
          vehicle_type,
          "NULL",
          "NULL",
          "NULL",
          "NULL",
        )

        vehicles.append(vehicle)

    for i in range(1, HOW_MANY_DRIVERS + 1):
        driver = (i, NAME + str(i), SURNAME + str(i), DOB, "NULL")

        drivers.append(driver)

    write_to_file("Autisti.csv", drivers)
    write_to_file("Stazioni_di_ricarica.csv", hubs)
    write_to_file("Veicoli.csv", vehicles)


if __name__ == "__main__":
    create_files()