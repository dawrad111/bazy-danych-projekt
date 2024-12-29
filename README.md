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