import psycopg2
import os
import comment_functions

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
            SELECT id, city, street, title, price
            FROM view_advertisements;
            """
            cursor.execute(query)
            advertisements = cursor.fetchall()

            if not advertisements:
                print("No advertisements found.")
                return

            print(f"{'Id':<10} {'City':<20} {'Street':<30} {'Title':<50} {'Price':<10}")
            print("=" * 110)
            for ad in advertisements:
                id, city, street, title, price = ad
                print(f"{id:<10} {city:<20} {street:<30} {title:<50} {price:<10.2f}")

            ids = [ad[0] for ad in advertisements]

    except psycopg2.Error as e:
        print(f"Error during loading advertisements: {e}")

    choice = input("Please choose an advertisement, or enter 0 to close: ")
    try:
        choice = int(choice)
    except ValueError:
        print("Invalid input. Please enter a number.")
        return

    if choice == 0:
        print("Closing...")
        return
    elif choice not in ids:
        print("Your choice is incorrect, please try again.")
    else:
        get_advertisement_details(connection, user, choice)

def hide_advertisement(conn):

    advertisement_id = input("Please enter advertisement ID to hide")
    try:
        cursor = conn.cursor()

        cursor.execute("SELECT sp_hide_advertisement(%s)", (advertisement_id,))

        conn.commit()

        print(f"Function executed successfully: Advertisement ID {advertisement_id} hidden!")

    except psycopg2.Error as e:
        print(f"Database error: {e}")



def edit_advertisement(connection, user):
    os.system('cls' if os.name == 'nt' else 'clear')

    display_advertisements(connection, user)

    advertisement_id = input("Please enter advertisement ID to edit: ")

    try:
        with connection.cursor() as cursor:
            cursor.execute("""
                       SELECT userid
                       FROM advertisement
                       WHERE advertisement.id = %s;
                       """, (advertisement_id,))
            userId = cursor.fetchall()
            print(f"Function executed successfully: {userId}")

            if not userId:
                print("No advertisements found.")
                return

            if userId[0][0] != user['id']:
                print("You can change only advertisements owned by you.")
                return

    except psycopg2.Error as e:
        print(f"Error during loading advertisements: {e}")




def get_advertisement_details(conn, user, advertisement_id):
    try:
        cursor = conn.cursor()

        query = """
        SELECT 
            ad.id AS advertisement_id,
            ad.postTime,
            ad.endDate,
            ad.status,
            ad.title,
            ad.lastModificationDate,
            addr.country,
            addr.region,
            addr.postalCode,
            addr.city,
            addr.street,
            addr.buildingNum,
            addr.flatNum,
            obj.squareFootage,
            obj.description,
            obj.rooms,
            obj.bathrooms,
            obj.basementSquareFootage,
            obj.balconySquareFootage,
            obj.allowAnimals,
            obj.additionalInfo,
            obj.floor,
            pr.price,
            pr.rent,
            pr.media,
            pr.deposit,
            pr.typeOFPayment,
            pr.typeOfOwner,
            h.stories,
            h.atticSquareFootage,
            h.terraceSquareFootage,
            h.plotArea
        FROM advertisement ad
        LEFT JOIN address addr ON ad.addressId = addr.id
        LEFT JOIN object obj ON ad.objectId = obj.id
        LEFT JOIN price pr ON ad.priceId = pr.id
        LEFT JOIN house h ON obj.typeId = h.id
        WHERE ad.id = %s;
        """

        cursor.execute(query, (advertisement_id,))
        result = cursor.fetchone()

        if not result:
            print(f"No advertisement found with ID {advertisement_id}.")
            return

        print("Advertisement Details:")
        columns = [desc[0] for desc in cursor.description]
        for col, val in zip(columns, result):
            print(f"{col}: {val}")

    except psycopg2.Error as e:
        print(f"Database error: {e}")

    comment_functions.get_active_comments_for_advertisement(conn, advertisement_id)