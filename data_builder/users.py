from hashlib import sha256
from .utils import write_to_file, get_seeded_random

HOW_MANY_USERS = 100

PASSWORD = sha256("password".encode("utf-8")).hexdigest()
NAME = "nome"
SURNAME = "cognome"
DOB = "2000-01-01"


def create_files():
    random = get_seeded_random()
    users = [("Id", "Email", "Password", "Nome", "Cognome", "Data_di_nascita")]

    payment_methods = [("Id", "Utente", "Tipo")]
    payment_methods_types = (
      "Carta di credito", "PayPal", "ApplePay", "GooglePay")

    for i in range(1, HOW_MANY_USERS + 1):
        email = "{}.{}.{}@email.it".format(NAME, SURNAME, i)

        user = (i, email, PASSWORD, NAME + str(i), SURNAME + str(i), DOB)

        users.append(user)

        for pm_type in random.choices(payment_methods_types,
                                      k=random.randrange(1, 3)):
            payment_method = ("NULL", i, pm_type)
            payment_methods.append(payment_method)

    write_to_file("Utenti.csv", users)
    write_to_file("Metodi_di_pagamento.csv", payment_methods)


if __name__ == "__main__":
    create_files()
