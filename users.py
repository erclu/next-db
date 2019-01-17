from hashlib import sha256

HOW_MANY = 10

PASSWORD = sha256("password").hexdigest()
NAME = "nome"
SURNAME = "cognome"
DOB = "2000-01-01"


def create_users():
    users = []
    emails = []

    for i in range(1, HOW_MANY + 1):
        email = "{}.{}.{}@email.it, ".format(NAME, SURNAME, i)
        user = "{}, {}, {}, {}, {}".format(email, PASSWORD, NAME, SURNAME, DOB)

        users.append(user)

    # for i in range(HOW_MANY):
    # email = random.choice(
    #   ''.join(
    #     random.choice(string.digits)
    #     for _ in range(2)))

    with open("data/Utenti.csv", "w") as file:
        file.write("Email, Password, Nome, Cognome, Data_di_nascita\n")
        file.write("\n".join(users))


if __name__ == "__main__":
    create_users()
