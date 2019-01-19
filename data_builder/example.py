from .utils import write_to_file


def create_files():

    lista_di_righe_da_inserire = (
      ("NULL", 1, "testo"), # una riga
      (1, "un campo, di cui verrà fatto l'escaping", 23)
      # ...
    )

    write_to_file("esempio.csv", lista_di_righe_da_inserire)


if __name__ == "__main__":
    create_files()

# per eseguire il file che hai appena creato, da terminale:
# "python3 -m data_builder.example"

# oppure aggiungi il file che hai appena creato a __main__.py sulla riga dell'import,
# chiami la funzione create_files(), e da terminale:
# "python3 -m data_builder"