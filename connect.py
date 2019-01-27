import mysql.connector


def main():
    mydb = mysql.connector.connect(
      host="localhost", user="root", passwd="",
      database="ercolel-PR") # TODO local infile?

    mycursor = mydb.cursor()

    mycursor.execute("SELECT * FROM Utenti")

    myresult = mycursor.fetchall()

    for x in myresult:
        print(x)


if __name__ == "__main__":
    main()

# from subprocess import Popen, PIPE
# process = Popen(['mysql', db, '-u', user, '-p', passwd],
#                 stdout=PIPE, stdin=PIPE)
# output = process.communicate('source ' + filename)[0]