## Database Schemas Recreation Instructions


```
docker exec -it <containter_name> bash
service postgresql stop
rm -rf /var/lib/postgresql/data/*
cp -r /data_backup/* /var/lib/postgresql/data/
chown -R postgres:postgres /var/lib/postgresql/data
service postgresql start
```