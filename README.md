# Cristhian Sanchez's CV

*[Leer en español](README.es.md)*

Repository for **Cristhian Sanchez**'s résumé, Full Stack Developer in AI and Machine Learning Engineer.

## Structure

- [`latex/`](latex/README.md): LaTeX sources, assets, and the generated PDF.
- [`infra/`](infra/README.md): Docker Compose setup and the compile script.

## Versions

The résumé is organized by version, one folder per targeted revision:

- [`latex/v1/`](latex/v1): the general-purpose CV (English + Spanish).
- [`latex/v2/`](latex/v2): tailored for a specific application, making years of
  experience per domain and production/architecture ownership more explicit.

Both share the same class, fonts, and photo from `latex/`, so they always look
identical — only the content differs.

## Quick start

1. Start the infrastructure:

	```powershell
	cd infra
	docker compose up -d
	```

2. Compile from the project root (`-Version v1` is the default):

	```powershell
	.\infra\compile.ps1 -Clean -Version v1 -Lang both
	```

3. Open the result in [`latex/v1/output/`](latex/v1/output/):

	```text
	latex/v1/output/sanchez_saune_cristhian_CV.pdf
	latex/v1/output/sanchez_saune_cristhian_CV_es.pdf
	```

The infrastructure uses `sharelatex/sharelatex:6.1.1`, `mongo:8.0`, and `redis:7.4`. The LaTeX class is distributed under [LPPL 1.3c](https://www.latex-project.org/lppl.txt) and the CV content under [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/legalcode).

## Usage

This project is free to use: anyone is welcome to fork it, reuse the LaTeX template, and adapt it to their own needs.
