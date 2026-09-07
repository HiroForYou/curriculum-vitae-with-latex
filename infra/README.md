# Docker Infrastructure

This folder contains the local infrastructure used to compile Cristhian Sanchez's CV. Feel free to reuse and adapt it to your own needs.

## Why local?

Overleaf's cloud plans felt like overkill for compiling a single résumé every
now and then, so this runs the same engine locally instead — for free.
Ironically, what's running here (`sharelatex/sharelatex`) *is* Overleaf: this
Docker image is Overleaf Community Edition, the official self-hosted version
of the very same cloud editor.

## Services

- `sharelatex/sharelatex:6.1.1`: ShareLaTeX and LuaLaTeX environment.
- `mongo:8.0`: ShareLaTeX's database.
- `redis:7.4`: cache and queue service.

## Starting the infrastructure

From this folder:

```powershell
docker compose up -d
```

Check the status:

```powershell
docker compose ps
```

ShareLaTeX becomes available at <http://localhost:1998>.

To stop the services without deleting data:

```powershell
docker compose down
```

To stop them and also delete the volumes:

```powershell
docker compose down -v
```

## Compiling

From the project root:

```powershell
.\infra\compile.ps1 -Clean
```

The script reuses the `sharelatex` container and picks up the sources from `latex/`.

## Note on Mongo (replica set)

Overleaf/ShareLaTeX 6.x uses Mongo transactions internally, so Mongo must run
as a replica set (even a single-node one). The `mongo` service already starts
with `--replSet overleaf`, and its healthcheck self-initializes the replica
set the first time it runs (fresh volume). If Mongo were ever to run without
`--replSet` or without being initialized, `sharelatex` fails its connection
check about 60s into each boot and ends up stuck in a restart loop. To
diagnose it manually:

```powershell
docker exec mongo mongosh --quiet --eval "rs.status()"
```

If it reports "no replset config has been received", initialize it by hand:

```powershell
docker exec mongo mongosh --quiet --eval "rs.initiate({_id:'overleaf', members:[{_id:0, host:'mongo:27017'}]})"
```
