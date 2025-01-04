import psycopg2


def display_active_complaints(connection):
    print("\n=== Active Complaints ===")

    try:
        with connection.cursor() as cursor:
            query = """
            SELECT content, postdate, name, surname, email
            FROM ActiveComplaintsView;
            """
            cursor.execute(query)
            complaints = cursor.fetchall()

            if not complaints:
                print("No active complaints.")
                return

            print(f"{'Date':<20} {'Name and surname':<30} {'Email':<30} {'Content':<50}")
            print("=" * 120)
            for content, postdate, name, surname, email in complaints:
                print(f"{postdate:<20} {name} {surname:<30} {email:<30} {content:<50}")

    except psycopg2.Error as e:
        print(f"Error during fetching complaints: {e}")


def add_complaint(connection, user):
    print("\n=== Add complaint ===")

    try:
        content = input("Provide content of your complaint: ").strip()

        if not content:
            print("Content cannot be empty.")
            return

        with connection.cursor() as cursor:
            cursor.execute("""
            SELECT sp_insert_into_complaint(%s, %s);
            """, (user['id'], content))

            connection.commit()

            print(f"Complaint is successfully added for ID {user['id']}.")

    except ValueError:
        print("Error: Id must be an integer.")
    except psycopg2.Error as e:
        print(f"Error during adding complaint: {e}")
