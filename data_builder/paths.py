from .utils import write_to_file


def create_files():
    paths = [
      ("Nodo", "Tratta", "Indice_sequenza"),
    ]

    for node_id, i in zip(range(1521, 1511, -1), range(10)):
        paths.append((node_id, 1, i))

    for node_id, i in zip(range(1511, 1501, -1), range(10)):
        paths.append((node_id, 2, i))

    # da 47,5 a 47,15
    for node_id, i in zip(range(2356, 2366, +1), range(10)):
        paths.append((node_id, 3, i))

    write_to_file("Cammini.csv", paths) #TODO


if __name__ == "__main__":
    create_files()