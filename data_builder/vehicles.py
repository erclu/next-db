from .road_network import GRID_SIZE
from .users import NAME, SURNAME, DOB
from .utils import write_to_file, get_seeded_random, NULL

HOW_MANY_VEHICLES = 10
HOW_MANY_DRIVERS = 3*HOW_MANY_VEHICLES
HOW_MANY_HUBS = 5 # XXX not implemented


def create_files():
    random = get_seeded_random()

    drivers = [(
      "Codice_dipendente", "Nome", "Cognome", "Data_di_nascita", "Veicolo",
      "Alla_guida")]

    hubs = (
      ("Id", "Posizione_x", "Posizione_y", "Posti_totali"),
      (1, 34, 27, 3),
      (2, 29, 14, 4),
      (3, 45, 7, 10),
      (4, 36, 8, 7),
      (5, 15, 34, 10),
    )

    vehicles = [
      (
        "Targa",
        "Stato_batteria",
        "Posizione_x",
        "Posizione_y",
        "Tipo",
        "In_ricarica",
        "Tratta",
        "Testa",
      ),
      ("NXT00001", 34, 47, 6, "Trasporto persone", NULL, 1, NULL),
      ("NXT00002", 55, 45, 15, "Trasporto persone", NULL, NULL, NULL),
      ("NXT00003", 37, 35, 10, "Trasporto persone", NULL, NULL, NULL),
    ]

    vehicle_types = [
      "Trasporto persone", "Trasporto merci", "Servizi", "Battery pack"
    ]
    vehicle_types_copy = list(vehicle_types)

    for i in range(len(vehicles), min(HOW_MANY_VEHICLES + 1, 99999)):

        vehicle_type = vehicle_types_copy.pop(
          0) if vehicle_types_copy else random.choice(vehicle_types)

        vehicle = (
          "NXT{:05d}".format(i),
          random.choice(range(20, 101)),
          random.choice(range(GRID_SIZE)),
          random.choice(range(GRID_SIZE)),
          vehicle_type,
          NULL,
          NULL,
          NULL,
        )

        vehicles.append(vehicle)

    for i in range(1, HOW_MANY_DRIVERS + 1):
        driver = (i, NAME + str(i), SURNAME + str(i), DOB, NULL, NULL)

        drivers.append(driver)

    write_to_file("Autisti.csv", drivers)
    write_to_file("Stazioni_di_ricarica.csv", hubs)
    write_to_file("Veicoli.csv", vehicles)


if __name__ == "__main__":
    create_files()