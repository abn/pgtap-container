# pgTap Container For Testing

A [pgTap](https://pgtap.org/) enabled [PostgreSQL](https://www.postgresql.org/) [Alpine](https://alpinelinux.org/) containers, 
across multiple versions of postgres. These images are built on top of the [Docker Hub Postgres Images](https://hub.docker.com/_/postgres). 

For convenience, this image also includes the [wait-for](https://github.com/eficode/wait-for) script.

## Usage
```bash
# Run the postgres server with tests mounted in
docker run -d --name pgtap -v `pwd`/examples/tests:/opt/pgtap/tests:z pgtap:latest

# Run your tests suite
docker exec -it pgtap pg_prove -U postgres -h postgres --ext .sql -r /opt/pgtap/tests
```

### Example: Docker Compose
```yml
# docker-compose up --renew-anon-volumes --abort-on-container-exit
version: '3.7'
services:
  postgres:
    image: ${DOCKER_REGISTRY:-docker.pkg.github.com/twyla-ai/pgtap-container}/pgtap:latest
    environment:
      POSTGRES_PASSWORD: pgtap
    ports:
      - 5432:5432

  tests:
    image: ${DOCKER_REGISTRY:-docker.pkg.github.com/twyla-ai/pgtap-container}/pgtap:latest
    environment:
      PGPASSWORD: pgtap
    command: wait-for postgres:5432 -t 60 -- pg_prove -U postgres -h postgres --ext .sql -r /opt/pgtap/tests
    depends_on:
      - postgres
    volumes:
      - "./tests/:/opt/pgtap/tests/:z"
```
