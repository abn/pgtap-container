[![Container Registry on Quay](https://quay.io/repository/abn/pgtap/status "Container Registry on Quay")](https://quay.io/repository/abn/pgtap)

# pgTap Container For Testing

A [pgTap](https://pgtap.org/) enabled [PostgreSQL](https://www.postgresql.org/) [Alpine](https://alpinelinux.org/) containers, 
across multiple versions of postgres. These images are built on top of the [Docker Hub Postgres Images](https://hub.docker.com/_/postgres). 

For convenience, this image also includes the [wait-for](https://github.com/eficode/wait-for) script.

## Usage
The image releases are available on [quay.io](https://quay.io/repository/abn/pgtap?tab=tags) as well as 
[GitHub Packages](https://github.com/abn/pgtap-container/pkgs/container/pgtap-container%2Fpgtap).

```bash
# Run the postgres server with tests mounted in
docker run -d --name pgtap -v `pwd`/examples/tests:/opt/pgtap/tests:z quay.io/abn/pgtap:latest

# Run your tests suite
docker exec -it pgtap pg_prove -U postgres -h postgres --ext .sql -r /opt/pgtap/tests
```

### Example: Docker Compose
```yml
# docker-compose up --renew-anon-volumes --abort-on-container-exit
version: '3.7'
services:
  postgres:
    image: quay.io/abn/pgtap:latest
    environment:
      POSTGRES_PASSWORD: pgtap
    ports:
      - 5432:5432

  tests:
    image: quay.io/abn/pgtap:latest
    environment:
      PGPASSWORD: pgtap
    command: wait-for postgres:5432 -t 60 -- pg_prove -U postgres -h postgres --ext .sql -r /opt/pgtap/tests
    depends_on:
      - postgres
    volumes:
      - "./tests/:/opt/pgtap/tests/:z"
```
