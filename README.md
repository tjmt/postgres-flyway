Uses the same Postgres from https://hub.docker.com/_/postgres/

The same variables are valid:
- POSTGRES_DB
- POSTGRES_USER
- POSTGRES_PASSWORD

It has Flyway (https://flywaydb.org/) installed and it is migrated at RUN.
So, copy the migration files (ex: `./sql/V1__Initial.sql` - https://flywaydb.org/documentation/migrations#naming) to the `/flyway/sql` directory to auto-migrate at run.

## Usage
### Dockerfile

```docker
FROM tjmt/postgres-flyway:9.4
COPY ./sql /flyway/sql
```


### docker-compose.yml

```yml
version: '3'
services:
  sistema-database:
    build:
      context: .
    ports:
      - 5432:5432
    environment:
      POSTGRES_USER: sa
      POSTGRES_PASSWORD: P@ssw0rd
      POSTGRES_DB: Banco
    volumes:
      - sistema-database:/var/lib/postgresql/data
    labels:
      kompose.volume.size: 1Gi
      kompose.service.type: nodeport
    deploy:
      replicas: 1
      placement:
        constraints:
        - node.labels.server == database
volumes:
  sistema-database:
```

#### Obs: 
Use `docker-compose down -v` to remove the volume and re-test the script from start/empty.