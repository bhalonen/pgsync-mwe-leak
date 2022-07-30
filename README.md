# PGSync memory leak MWE

Minimal repo to reproduce memory leak.

In order to test the memory leak in pgsync please follow the following procedure.

```
docker compose up -d postgres
```

```
  ./psql.sh -f /init/migrations/build_db.sql
   ./psql.sh -f /init/migrations/spammer.sql
   docker compose up -d 
```

Run repeatedly:
```
./spam.sh
```
Over time the memory drifts higher, even with no write load.

Monitor top inside of pgsync docker
```
docker ps
docker exec -ti <IMAGE> /bin/sh
```