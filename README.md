## Database Schemas Recreation Instructions


- Create a container group with docker-compose
- Create a database "Flatpol"
```
docker cp <path_to_backup_file> <container_name>:/tmp/backup.sql
```
```
docker exec -it <container_name> bash
```
```
psql -U postgres -d Flatpol -f /tmp/backup.sql
```

## Python database connection and sample usage
```
import psycopg2

try:
    conn = psycopg2.connect(
        dbname="Flatpol",
        user="postgres",
        password="example",
        host="localhost,5432"
    )
    cur = conn.cursor()
    cur.execute("SELECT * FROM address_view LIMIT 50;")
    rows = cur.fetchall()
    for row in rows:
        print(row)
    cur.close()
    conn.close()
except Exception as e:
    print(f"An error occurred: {e}")
```