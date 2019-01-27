import csv
from contextlib import contextmanager
from pathlib import Path
from random import Random

DATA_DIR: Path = Path(__file__).parent.parent/"data"

if not DATA_DIR.exists():
    print("-- creating data folder")
    DATA_DIR.mkdir()


def get_seeded_random():
    return Random(42)


def custom_csv_writer(fileobj):
    return csv.writer(
      fileobj,
      delimiter=',',
      quotechar='"',
      quoting=csv.QUOTE_MINIMAL,
      lineterminator='\n')


@contextmanager
def custom_open(filename):
    file = open(DATA_DIR/filename, "w", encoding="utf-8", newline='\n')
    try:
        yield file
    finally:
        file.close()


def write_to_file(filename, rows):
    # print("creating {}".format(filename))
    with custom_open(filename) as file:
        custom_csv_writer(file).writerows(rows)