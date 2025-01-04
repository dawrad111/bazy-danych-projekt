import psycopg2
from psycopg2.extras import DictCursor
import bcrypt
from getpass import getpass

def authenticate_user(connection):
    print("=== Login ===")
    while True:
        user_email = input("Provide your email:")
        if not user_email:
            print("Data could not be empty")
            continue
        password = getpass(prompt='Input your password: ').strip()
        if not password:
            print("Data could not be empty")
            continue
        break
    try:
        with connection.cursor(cursor_factory=DictCursor) as cursor:
            query = """
               SELECT users.id, users.name, users.surname, users.passwordHash, users.userType, users.status, users.isVerified
                FROM users
                INNER JOIN email
                ON email.id = users.emailId
                WHERE email.email = %s;
               """
            cursor.execute(query, (user_email,))
            user = cursor.fetchone()

            if not user:
                print("Incorrect email or password")
                return None

            if  password.encode() != user['passwordhash'].encode():
                print("Incorrect email or password")
                return None

            if user['status'] != 'active':
                print(f"The account is: {user['status']}. Please contact administrator.")
                return None

            return user

    except psycopg2.Error as e:
        print(f"Error during login: {e}")
        return None

def register_user(connection):
    print("\n=== Sign up ===")
    while True:

        user_name = input("Provide your name:")
        if not user_name:
            print("Data could not be empty")
            continue
        user_surname = input("Provide your surname:")
        if not user_surname:
            print("Data could not be empty")
            continue
        user_email = input("Provide your email:")
        if not user_email:
            print("Data could not be empty")
            continue
        user_phone_number = input("Provide your phone number:")
        if not user_email:
            print("Data could not be empty")
            continue
        password = getpass(prompt='Input your password: ').strip()
        if not password:
            print("Data could not be empty")
            continue
        password_check = getpass(prompt='Input your password again: ').strip()
        if not password_check:
            print("Data could not be empty")
            continue
        if password != password_check:
            print("Passwords do not match")
            continue

        break
    #hashed_password = bcrypt.hashpw(password.encode(), bcrypt.gensalt())

    try:
        with connection.cursor() as cursor:
            # Wywołanie procedury składowanej
            query = """
                SELECT sp_insert_into_users(%s, %s, %s, %s, %s, %s);
                """
            cursor.execute(query, (user_name, user_surname, password, user_email, user_phone_number, 'user'))
            connection.commit()
            print("User created successfully, now you can login.")
    except psycopg2.errors.UniqueViolation:
        print("This email has already been registered.")
    except psycopg2.Error as e:
        print(f"Error during adding user: {e}")
