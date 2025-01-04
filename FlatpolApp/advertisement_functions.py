import psycopg2
import os

def display_advertisements(connection, user):
    os.system('cls' if os.name == 'nt' else 'clear')

    if user:
        print(f"Successfully login as {user['name']} {user['surname']} ({user['usertype']}).")
    else:
        print(f"Login as a guest")
    print("=== Advertisement List ===")

    try:
        with connection.cursor() as cursor:
            query = """
            SELECT city, street, title, price
            FROM view_advertisements;
            """
            cursor.execute(query)
            advertisements = cursor.fetchall()

            if not advertisements:
                print("No advertisements found.")
                return

            print(f"{'City':<20} {'Street':<30} {'Title':<50} {'Price':<10}")
            print("=" * 110)
            for ad in advertisements:
                city, street, title, price = ad
                print(f"{city:<20} {street:<30} {title:<50} {price:<10.2f}")

    except psycopg2.Error as e:
        print(f"Error during loading advertisements: {e}")
