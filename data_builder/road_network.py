from .utils import write_to_file

GRID_SIZE = 50
WEIGHT = 1


def create_graph():
    adj_list = {}
    node_ids = {}
    counter = 1

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

    return adj_list, node_ids


# def calculate_paths(od_instances):
#     """( ((x,y), (x,y)), .... )"""
#     graph, node_ids = create_graph()

#     paths = {}

#     for istance in od_instances:

#         start, end = istance

#         print(start, end)

#         path = find_shortest_path(graph, start, end)

#         print(path)

#         path_ids = [node_ids[node] for node in path]
#         paths[istance] = path_ids

#     return paths


def create_files():
    edges = [("Entrante", "Uscente", "Nome", "Peso")]
    nodes = [("Id", "Latitudine", "Longitudine")]

    adj_list, node_ids = create_graph()

    for node_from, value in adj_list.items():
        for node_to in value:
            edge = (
              node_ids[node_from], node_ids[node_to], "{} -> {}".format(
                node_from, node_to), WEIGHT)

            edges.append(edge)

    for node_coord, node_id in node_ids.items():
        node = (node_id, node_coord[0], node_coord[1])
        nodes.append(node)

    write_to_file("Archi.csv", edges)

    write_to_file("Nodi.csv", nodes)


if __name__ == "__main__":
    create_files()
