from hashlib import sha256

from .utils import custom_csv_writer, custom_open, get_data_dir

HOW_MANY_USERS = 10

PASSWORD = sha256("password".encode("utf-8")).hexdigest()
NAME = "nome"
SURNAME = "cognome"
DOB = "2000-01-01"


def create_files():
    data_dir = get_data_dir()

    users = []
    payment_methods = (
      ("NULL", 1, "Carta di credito"),
      ("NULL", 1, "PayPal"),
      ("NULL", 2, "Carta di credito"),
      ("NULL", 2, "ApplePay"),
      ("NULL", 3, "Carta di credito"),
      ("NULL", 3, "PayPal"),
      ("NULL", 4, "Carta di credito"),
      ("NULL", 4, "GooglePay"),
      ("NULL", 5, "Carta di credito"),
      ("NULL", 5, "ApplePay"),
      ("NULL", 6, "Carta di credito"),
      ("NULL", 6, "GooglePay"),
      ("NULL", 7, "Carta di credito"),
      ("NULL", 7, "PayPal"),
      ("NULL", 8, "Carta di credito"),
      ("NULL", 8, "ApplePay"),
      ("NULL", 9, "Carta di credito"),
      ("NULL", 9, "PayPal"),
      ("NULL", 10, "Carta di credito"),
      ("NULL", 10, "GooglePay"),
    )

    for i in range(1, HOW_MANY_USERS + 1):
        email = "{}.{}.{}@email.it".format(NAME, SURNAME, i)

        user = (i, email, PASSWORD, NAME, SURNAME, DOB)

        users.append(user)

    with custom_open(data_dir/"Utenti.csv") as file:
        file.write("Id, Email, Password, Nome, Cognome, Data_di_nascita\n")

        writer = custom_csv_writer(file)
        writer.writerows(users)

    with custom_open(data_dir/"Metodi_di_pagamento.csv") as file:
        file.write("Id, Utente, Tipo\n")

        writer = custom_csv_writer(file)
        writer.writerows(payment_methods)


if __name__ == "__main__":
    create_files()
