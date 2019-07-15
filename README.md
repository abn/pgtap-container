# pgTap Container

A [pgTap](https://pgtap.org/) enabled PostGreSQL 9.6 Alpine container. For convenience, 
this image also includes the [wait-for](https://github.com/eficode/wait-for) script.

## Usage
```bash
# Run the postgres server with tests mounted in
docker run -d --name pgtap -v `pwd`/examples/tests:/opt/pgtap/tests:z pgtap:latest

# Run your tests suite
docker exec -it pgtap pg_prove -U postgres -h postgres --ext .sql -r /opt/pgtap/tests
```

For a `docker-compose` example refer to the [examples/docker-compose.yaml](examples/docker-compose.yaml).
```bash
docker-compose up --renew-anon-volumes --abort-on-container-exit
```
