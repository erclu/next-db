from hashlib import sha256
from .utils import write_to_file

HOW_MANY_USERS = 10

PASSWORD = sha256("password".encode("utf-8")).hexdigest()
NAME = "nome"
SURNAME = "cognome"
DOB = "2000-01-01"


def create_files():
    users = [("Id", "Email", "Password", "Nome", "Cognome", "Data_di_nascita")]

    payment_methods = (
      ("Id", "Utente", "Tipo"),
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

    write_to_file("Utenti.csv", users)
    write_to_file("Metodi_di_pagamento.csv", payment_methods)


if __name__ == "__main__":
    create_files()
