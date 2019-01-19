from .utils import custom_csv_writer, custom_open, get_data_dir

GRID_SIZE = 50
WEIGHT = 1


def create_files():
    data_dir = get_data_dir()

    adj_list = {}

    node_ids = {}
    counter = 1

    edges = []
    nodes = []

    for i in range(GRID_SIZE):
        for j in range(GRID_SIZE):
            neighbours = []

            # counterclockwise, from the top:
            #         | i-1, j |
            #  i, j-1 | i, j   | i, j+1
            #         | i+1, j |
            if i > 0:
                neighbours.append((i - 1, j))
            if j < GRID_SIZE - 1:
                neighbours.append((i, j + 1))
            if i < GRID_SIZE - 1:
                neighbours.append((i + 1, j))
            if j > 0:
                neighbours.append((i, j - 1))

            adj_list[(i, j)] = neighbours
            node_ids[(i, j)] = counter
            counter += 1

    for node_from, value in adj_list.items():
        for node_to in value:
            edge = (
              node_ids[node_from], node_ids[node_to], "{} -> {}".format(
                node_from, node_to), WEIGHT)

            edges.append(edge)

    for node_coord, node_id in node_ids.items():
        node = (node_id, node_coord[0], node_coord[1])
        nodes.append(node)

    with custom_open(data_dir/"Archi.csv") as file:
        file.write("Entrante, Uscente, Nome, Peso\n")

        writer = custom_csv_writer(file)
        writer.writerows(edges)

    with custom_open(data_dir/"Nodi.csv") as file:
        file.write("Id, Latitudine, Longitudine\n")

        writer = custom_csv_writer(file)
        writer.writerows(nodes)


if __name__ == "__main__":
    create_files()
