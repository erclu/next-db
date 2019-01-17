GRID_SIZE = 50
WEIGHT = 1


def main():

    adj_list = {}

    node_ids = {}
    counter = 1

    edges = []
    nodes = []

    for i in range(GRID_SIZE):
        for j in range(GRID_SIZE):
            neighbours = []

            # counterclockwise, from the top:
            #         - i-1, j -
            #  i, j-1 - i, j   - i, j+1
            #         - i+1, j -
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
            edge = "{}, {}, \"{} -> {}\", {} ".format(
              node_ids[node_from], node_ids[node_to], node_from, node_to,
              WEIGHT)

            edges.append(edge)

    for node_coord, node_id in node_ids.items():
        node = "{}, {}, {}".format(node_id, node_coord[0], node_coord[1])
        nodes.append(node)

    with open("data/Archi.txt", "w") as file:
        file.write("from, to, name, weight")
        file.write("\n".join(edges))

    with open("data/Nodi.txt", "w") as file:
        file.write("id, lat, lon")
        file.write("\n".join(nodes))


if __name__ == "__main__":
    main()