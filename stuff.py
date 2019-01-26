import networkx as nx


def main():
    g = nx.read_adjlist("outdata/outfile.csv", nodetype=int, delimiter=',')

    nx.write_graphml(g, "zzz.graphml")


if __name__ == "__main__":
    main()