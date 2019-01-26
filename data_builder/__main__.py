from . import road_network, users, vehicles, requests


def main():
    road_network.create_files()
    users.create_files()
    vehicles.create_files()
    requests.create_files()


if __name__ == "__main__":
    main()