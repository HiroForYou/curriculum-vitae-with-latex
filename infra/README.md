# Infraestructura Docker

Esta carpeta contiene la infraestructura local para compilar el CV de Cristhian Sanchez.

## Servicios

- `sharelatex/sharelatex:6.1.1`: entorno ShareLaTeX y LuaLaTeX.
- `mongo:8.0`: base de datos de ShareLaTeX.
- `redis:7.4`: servicio de cache y colas.

## Levantar la infraestructura

Desde esta carpeta:

```powershell
docker compose up -d
```

Comprobar el estado:

```powershell
docker compose ps
```

ShareLaTeX queda disponible en <http://localhost:1998>.

Para detener los servicios sin borrar datos:

```powershell
docker compose down
```

Para detenerlos y borrar también los volúmenes:

```powershell
docker compose down -v
```

## Compilar

Desde la raíz del proyecto:

```powershell
.\infra\compile.ps1 -Clean
```

El script reutiliza el contenedor `sharelatex` y toma las fuentes desde `latex/`.

## Nota sobre Mongo (replica set)

Overleaf/ShareLaTeX 6.x usa transacciones de Mongo internamente, así que Mongo
debe correr como replica set (aunque sea de un solo nodo). El servicio `mongo`
ya arranca con `--replSet overleaf` y su healthcheck se auto-inicializa la
primera vez (volumen nuevo). Si Mongo llegara a correr sin `--replSet` o sin
inicializar, `sharelatex` falla su chequeo de conexión a los ~60s de cada
arranque y queda reiniciándose en bucle. Para diagnosticarlo manualmente:

```powershell
docker exec mongo mongosh --quiet --eval "rs.status()"
```

Si da error "no replset config has been received", inicialízalo a mano:

```powershell
docker exec mongo mongosh --quiet --eval "rs.initiate({_id:'overleaf', members:[{_id:0, host:'mongo:27017'}]})"
```
