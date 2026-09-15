# CV de Cristhian Sanchez

*[Read in English](README.md)*

Repositorio del currículum vitae de **Cristhian Sanchez**, Full Stack Developer en AI y Machine Learning Engineer.

## Estructura

- [`latex/`](latex/README.es.md): fuentes LaTeX, recursos y PDF generado.
- [`infra/`](infra/README.es.md): Docker Compose y script de compilación.

## Versiones

El CV está organizado por versión, una carpeta por revisión objetivo:

- [`latex/v1/`](latex/v1): el CV de propósito general (inglés + español).
- [`latex/v2/`](latex/v2): adaptado a una postulación específica, dejando más
  explícitos los años de experiencia por área y la propiedad de arquitectura
  y producción.

Ambas comparten la misma clase, fuentes y foto desde `latex/`, así que siempre
se ven idénticas — solo cambia el contenido.

## Flujo rápido

1. Levantar la infraestructura:

	```powershell
	cd infra
	docker compose up -d
	```

2. Compilar desde la raíz del proyecto (`-Version v1` es el valor por defecto):

	```powershell
	.\infra\compile.ps1 -Clean -Version v1 -Lang both
	```

3. Abrir el resultado en [`latex/v1/output/`](latex/v1/output/):

	```text
	latex/v1/output/sanchez_saune_cristhian_CV.pdf
	latex/v1/output/sanchez_saune_cristhian_CV_es.pdf
	```

La infraestructura utiliza `sharelatex/sharelatex:6.1.1`, `mongo:8.0` y `redis:7.4`. La clase LaTeX se distribuye bajo la [LPPL 1.3c](https://www.latex-project.org/lppl.txt) y el contenido del CV bajo [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/legalcode).

## Uso

Este proyecto es de uso libre: cualquier persona puede forkearlo, reutilizar la plantilla LaTeX y adaptarla a sus propias necesidades.
