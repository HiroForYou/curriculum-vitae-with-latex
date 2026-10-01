# Infraestructura Docker

Esta carpeta contiene la infraestructura local para compilar el CV de Cristhian Sanchez. Siéntete libre de reutilizarla y adaptarla a tus propias necesidades.

## ¿Por qué local?

Los planes cloud de Overleaf parecían excesivos para compilar un solo CV de
vez en cuando, así que esto corre el mismo motor en local en su lugar — gratis.
Irónicamente, lo que corre acá (`sharelatex/sharelatex`) *es* Overleaf: esta
imagen Docker es Overleaf Community Edition, la versión self-hosted oficial
del mismo editor cloud.

## Servicios

- `sharelatex-full:6.1.1`: se construye desde el `Dockerfile` sobre `sharelatex/sharelatex:6.1.1`, agregando las colecciones de TeX Live que necesita el CV (latexrecommended, latexextra, fontsrecommended, fontsextra, luatex, langspanish, pictures; sin documentación ni fuentes) para que `fontspec` y el resto de paquetes ya vengan instalados. Entorno ShareLaTeX y LuaLaTeX.
- `mongo:8.0`: base de datos de ShareLaTeX.
- `redis:7.4`: servicio de cache y colas.

## Levantar la infraestructura

Desde esta carpeta:

```powershell
docker compose up -d
```

La primera vez construye la imagen (tarda unos minutos); las siguientes la reutilizan. Para reconstruirla: `docker compose build`.

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
