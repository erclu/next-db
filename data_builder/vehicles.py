from .road_network import GRID_SIZE
from .utils import (
  custom_csv_writer, custom_open, get_data_dir, get_seeded_random)

HOW_MANY_VEHICLES = 10


def create_files():
    data_dir = get_data_dir()
    random = get_seeded_random()
    # targhe: NXT001ecc

    vehicles = []
    types = [
      "Trasporto persone", "Trasporto persone", "Trasporto persone",
      "Trasporto merci", "Servizi", "Battery pack"
    ]

    for i in range(1, HOW_MANY_VEHICLES + 1):
        vehicle_type = types[i - 1] if i - 1 < len(types) else random.choice(
          types)

        vehicle = (
          i,
          random.choice(range(20, 101)),
          random.choice(range(GRID_SIZE)),
          random.choice(range(GRID_SIZE)),
          vehicle_type,
        )

        vehicles.append(vehicle)

    with custom_open(data_dir/"Veicoli.csv") as file:
        file.write("Targa, Stato_batteria, Posizione_x, Posizione_y, Tipo\n")

        writer = custom_csv_writer(file)
        writer.writerows(vehicles)


if __name__ == "__main__":
    create_files()