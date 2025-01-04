import psycopg2
import os
from user_functions import authenticate_user
from user_functions import register_user
from advertisement_functions import display_advertisements
import complaint_functions

def connect_to_db():
    try:
        connection = psycopg2.connect(
            host="localhost",
            port=5432,
            database="Flatpol",
            user="postgres",
            password="example"
        )
        return connection
    except psycopg2.Error as e:
        print(f"Error during connection with database: {e}")
        return None

def main_operator_menu(connection, user):
    while True:

        if user:
            print(f"Successfully login as {user['name']} {user['surname']} ({user['usertype']}).")
        else:
            print(f"Login as a guest")

        print("\n=== Menu ===")
        print("1. Show active complaints")
        print("2. Block user")
        print("3. Block advertisement")
        print("4. Hide comments")
        print("0. Close")

        choice = input("Choose: ").strip()

        if choice == "1":
            complaint_functions.display_active_complaints(connection)
        elif choice == "2":
            pass
        elif choice == "3":
            if user:
                complaint_functions.add_complaint(connection, user)
            else:
                print("This function is not allowed for guest")
        elif choice == "0":
            print("Closing...")
            exit(0)
        else:
            print("Your choice is invalid, please try again.")

def main_user_menu(connection, user):
    while True:

        if user:
            print(f"Successfully login as {user['name']} {user['surname']} ({user['usertype']}).")
        else:
            print(f"Login as a guest")

        print("\n=== Menu ===")
        print("1. Show advertisements")
        print("2. Create advertisement")
        print("3. Create complaint")
        print("0. Close")

        choice = input("Choose: ").strip()

        if choice == "1":
            display_advertisements(connection, user)
        elif choice == "2":
            pass
        elif choice == "3":
            if user:
                complaint_functions.add_complaint(connection, user)
            else:
                print("This function is not allowed for guest")
        elif choice == "0":
            print("Closing...")
            exit(0)
        else:
            print("Your choice is invalid, please try again.")

def login_menu(connection):
    while True:
        print("\n=== Menu ===")
        print("1. Sign in")
        print("2. Sign up")
        print("3. Continue as a guest")
        print("0. Close")

        choice = input("Choose: ").strip()

        if choice == "1":
            user = authenticate_user(connection)
            if user:
                if user['usertype'] == 'user':
                    main_user_menu(connection, user)
                elif user['usertype'] == 'operator' or user['usertype'] == 'administrator':
                    main_operator_menu(connection, user)
        elif choice == "2":
            register_user(connection)
        elif choice == "3":
            user = None
            main_user_menu(connection, user)
        elif choice == "0":
            print("Closing...")
            exit(0)
        else:
            print("Your choice is incorrect, please try again.")


def main():
    connection = connect_to_db()
    if connection:
        login_menu(connection)

        connection.close()