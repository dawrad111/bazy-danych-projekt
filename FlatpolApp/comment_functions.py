import psycopg2
import os

def add_comment(conn, user, advertisement_id ):
    try:

        content = input("Please enter content of your comment: ")
        status = 'active'
        cursor = conn.cursor()

        query = "SELECT sp_insert_into_comment(%s, %s, %s, %s);"
        cursor.execute(query, (user['id'], advertisement_id, content, status))

        conn.commit()

        print(f"Comment successfully added for User ID {user['id']} and Advertisement ID {advertisement_id}.")

    except psycopg2.Error as e:
        print(f"Database error: {e}")
        conn.rollback()


def get_active_comments_for_advertisement(conn, advertisement_id):

    try:
        cursor = conn.cursor()

        query = """
        SELECT comment_id, user_name, user_surname, post_date, last_modification_date, comment_content
        FROM view_active_comments
        WHERE advertisement_id = %s;
        """

        cursor.execute(query, (advertisement_id,))

        results = cursor.fetchall()

        if not results:
            print(f"No active comments found for advertisement ID {advertisement_id}.")
            return

        print(f"Active comments for advertisement ID {advertisement_id}:")
        for row in results:
            print(f"""
            Comment ID: {row[0]}
            User: {row[1]} {row[2]}
            Post Date: {row[3]}
            Last Modified: {row[4]}
            Content: {row[5]}
            """)

    except psycopg2.Error as e:
        print(f"Database error: {e}")


def suspend_comment(conn, comment_id):

    try:
        cursor = conn.cursor()

        query = """
        UPDATE comment
        SET status = 'suspended',
            lastModificationDate = CURRENT_TIMESTAMP
        WHERE id = %s AND status = 'active';
        """

        cursor.execute(query, (comment_id,))

        if cursor.rowcount == 0:
            print(f"No active comment found with ID {comment_id}.")
        else:
            print(f"Comment ID {comment_id} successfully suspended.")

        conn.commit()

    except psycopg2.Error as e:
        print(f"Database error: {e}")
        conn.rollback()



def add_bump(conn, user, comment_id):
    try:

        cursor = conn.cursor()

        query = "SELECT sp_insert_into_bumpCount(%s, %s);"
        cursor.execute(query, (user['id'], comment_id))

        conn.commit()

        print(f"Bump successfully added for User ID {user['id']} and Comment ID {comment_id}.")

    except psycopg2.Error as e:
        print(f"Database error: {e}")
        conn.rollback()