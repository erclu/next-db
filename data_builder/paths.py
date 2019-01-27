from .utils import write_to_file


def create_files():
    paths = [
      ("Partenza", "Destinazione", "Tratta"),
    ]

    write_to_file("Indicazioni.csv", paths) #TODO


if __name__ == "__main__":
    create_files()