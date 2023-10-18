![Build Status](https://github.com/abn/pgtap-container/actions/workflows/main.yml/badge.svg?branch=main)

# pgTap Container For Testing

A [pgTap](https://pgtap.org/) enabled [PostgreSQL](https://www.postgresql.org/) [Alpine](https://alpinelinux.org/) containers, 
across multiple versions of postgres. These images are built on top of the [Docker Hub Postgres Images](https://hub.docker.com/_/postgres). 

For convenience, this image also includes the [wait-for](https://github.com/eficode/wait-for) script.

## Usage
The image releases are available on [quay.io](https://quay.io/repository/abn/pgtap?tab=tags) as well as 
[GitHub Packages](https://github.com/abn/pgtap-container/pkgs/container/pgtap-container%2Fpgtap).

```bash
# Run the postgres server with tests mounted in
podman run -d --name pgtap -v `pwd`/examples/tests:/opt/pgtap/tests:z quay.io/abn/pgtap:1.3.1-pg16

# Run your tests suite
podman exec -it pgtap pg_prove -U postgres -h postgres --ext .sql -r /opt/pgtap/tests
```

### Example: Docker Compose
```yml
# podman-compose up --renew-anon-volumes --abort-on-container-exit --exit-code-from tests tests
version: '3.7'
services:
  postgres:
    image: quay.io/abn/pgtap:1.3.1-pg16
    environment:
      POSTGRES_PASSWORD: pgtap
    ports:
      - 5432:5432

  tests:
    image: quay.io/abn/pgtap:1.3.1-pg16
    environment:
      PGPASSWORD: pgtap
    command: wait-for postgres:5432 -t 60 -- pg_prove -U postgres -h postgres --ext .sql -r /opt/pgtap/tests
    depends_on:
      - postgres
    volumes:
      - "./tests/:/opt/pgtap/tests/:z"
```
