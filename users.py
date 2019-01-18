from hashlib import sha256

HOW_MANY = 10

PASSWORD = sha256("password".encode("utf-8")).hexdigest()
NAME = "nome"
SURNAME = "cognome"
DOB = "2000-01-01"


def create_users():
    users = []
    payment_methods = [
      'NULL,1,"Carta di credito"\n',
      'NULL,1,"PayPal"\n',
      'NULL,2,"Carta di credito"\n',
      'NULL,2,"ApplePay"\n',
      'NULL,3,"Carta di credito"\n',
      'NULL,3,"PayPal"\n',
      'NULL,4,"Carta di credito"\n',
      'NULL,4,"GooglePay"\n',
      'NULL,5,"Carta di credito"\n',
      'NULL,5,"ApplePay"\n',
      'NULL,6,"Carta di credito"\n',
      'NULL,6,"GooglePay"\n',
      'NULL,7,"Carta di credito"\n',
      'NULL,7,"PayPal"\n',
      'NULL,8,"Carta di credito"\n',
      'NULL,8,"ApplePay"\n',
      'NULL,9,"Carta di credito"\n',
      'NULL,9,"PayPal"\n',
      'NULL,10,"Carta di credito"\n',
      'NULL,10,"GooglePay"\n',
    ]

    for i in range(1, HOW_MANY + 1):
        email = "{}.{}.{}@email.it".format(NAME, SURNAME, i)

        user = "{},{},{},{},{},{}\n".format(
          i, email, PASSWORD, NAME, SURNAME, DOB)

        users.append(user)

    with open("data/Utenti.csv", "w", newline='\n') as file:
        file.write("Id, Email, Password, Nome, Cognome, Data_di_nascita\n")
        file.writelines(users)

    with open("data/Metodi_di_pagamento.csv", "w", newline='\n') as file:
        file.write("Id, Utente, Tipo\n")
        file.writelines(payment_methods)


if __name__ == "__main__":
    create_users()
