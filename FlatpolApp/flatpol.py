import psycopg2
import os
from user_functions import authenticate_user
from user_functions import register_user
import advertisement_functions
import complaint_functions
import comment_functions
from geocoding_module import AddressGeocoder, GeocodingError

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
            advertisement_functions.hide_advertisement(connection)
        elif choice == "4":
            comment_functions.suspend_comment(connection, 9)
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
        print("3. Edit advertisement")
        print("4. Create complaint")
        print("5. Geolocation")
        print("6. Show comments")
        print("7. Add comments")
        print("8. Like comment")
        print("0. Close")

        choice = input("Choose: ").strip()

        if choice == "1":
            advertisement_functions.display_advertisements(connection, user)
        elif choice == "2":
            pass
        elif choice == "3":
            if user:
                advertisement_functions.edit_advertisement(connection, user)
            else:
                print("This function is not allowed for guest")
        elif choice == "4":
            if user:
                complaint_functions.add_complaint(connection, user)
            else:
                print("This function is not allowed for guest")
        elif choice == "5":
            geocoder = AddressGeocoder(user_agent="your_application_name")

            try:
                # Get coordinates
                location = geocoder.get_coordinates(
                    country="France",
                    city="Paris",
                    street="Rue de Rivoli",
                    number="1"
                )

                if location:
                    print(f"Latitude: {location.latitude}")
                    print(f"Longitude: {location.longitude}")
                    print(f"Full address: {location.display_name}")
                else:
                    print("Location not found")

            except GeocodingError as e:
                print(f"Error: {e}")
        elif choice == "6":
            if user:
                comment_functions.get_active_comments_for_advertisement(connection, 31)
            else:
                print("This function is not allowed for guest")
        elif choice == "7":
            if user:
                advertisementId = input("Provide advertisement ID to comment it:")
                comment_functions.add_comment(connection, user, advertisementId)
            else:
                print("This function is not allowed for guest")
        elif choice == "8":
            if user:
                commentId = input("Provide comment ID to comment it:")
                comment_functions.add_bump(connection, user, commentId)
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