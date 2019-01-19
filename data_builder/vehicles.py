from .road_network import GRID_SIZE
from .utils import write_to_file, get_seeded_random

HOW_MANY_VEHICLES = 10

# HOW_MANY_HUBS = 5


def create_files():
    random = get_seeded_random()
    # targhe: NXT001ecc

    vehicles = [(
      "Targa", "Stato_batteria", "Posizione_x", "Posizione_y", "Tipo",
      "Guidatore", "In_ricarica", "Tratta", "Testa")]

    types = [
      "Trasporto persone", "Trasporto persone", "Trasporto persone",
      "Trasporto merci", "Servizi", "Battery pack"
    ]

    hubs = (
      ("Id", "Posizione_x", "Posizione_y", "Posti_totali"),
      (1, 34, 27, 3),
      (2, 29, 14, 4),
      (3, 45, 7, 10),
      (4, 36, 8, 7),
      (5, 15, 34, 10),
    )

    for i in range(1, HOW_MANY_VEHICLES + 1):
        vehicle_type = types[i - 1] if i - 1 < len(types) else random.choice(
          types)

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

    write_to_file("Veicoli.csv", vehicles)
    write_to_file("Stazioni_di_ricarica.csv", hubs)


if __name__ == "__main__":
    create_files()