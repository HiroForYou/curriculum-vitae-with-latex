# CV de Cristhian Sanchez

*[Read in English](README.md)*

Repositorio del currículum vitae de **Cristhian Sanchez**, Full Stack Developer en AI y Machine Learning Engineer.

## Estructura

- [`latex/`](latex/README.es.md): fuentes LaTeX, recursos y PDF generado.
- [`infra/`](infra/README.es.md): Docker Compose y script de compilación.

## Flujo rápido

1. Levantar la infraestructura:

	```powershell
	cd infra
	docker compose up -d
	```

2. Compilar desde la raíz del proyecto:

	```powershell
	.\infra\compile.ps1 -Clean
	```

3. Abrir el resultado en [`latex/output/`](latex/output/):

	```text
	latex/output/sanchez_saune_cristhian_CV.pdf
	```

La infraestructura utiliza `sharelatex/sharelatex:6.1.1`, `mongo:8.0` y `redis:7.4`. La clase LaTeX se distribuye bajo la [LPPL 1.3c](https://www.latex-project.org/lppl.txt) y el contenido del CV bajo [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/legalcode).

## Uso

Este proyecto es de uso libre: cualquier persona puede forkearlo, reutilizar la plantilla LaTeX y adaptarla a sus propias necesidades.
