import csv
from contextlib import contextmanager
from pathlib import Path
from random import Random

DATA_DIR: Path = Path(__file__).parent.parent/"data"


def get_data_dir() -> Path:
    if not DATA_DIR.exists():
        print("creating data folder")
        DATA_DIR.mkdir()

    return DATA_DIR


def get_seeded_random():
    return Random(42)


def custom_csv_writer(fileobj):
    return csv.writer(
      fileobj, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)


@contextmanager
def custom_open(filename):
    file = open(filename, "w", encoding="utf-8", newline='\n')
    try:
        yield file
    finally:
        file.close()
