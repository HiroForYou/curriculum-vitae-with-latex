# Cristhian Sanchez's CV

Repository for **Cristhian Sanchez**'s résumé, Full Stack Developer in AI and Machine Learning Engineer.

## Structure

- [`latex/`](latex/README.md): LaTeX sources, assets, and the generated PDF.
- [`infra/`](infra/README.md): Docker Compose setup and the compile script.

## Quick start

1. Start the infrastructure:

	```powershell
	cd infra
	docker compose up -d
	```

2. Compile from the project root:

	```powershell
	.\infra\compile.ps1 -Clean
	```

3. Open the result in [`latex/output/`](latex/output/):

	```text
	latex/output/sanchez_saune_cristhian_CV.pdf
	```

The infrastructure uses `sharelatex/sharelatex:6.1.1`, `mongo:8.0`, and `redis:7.4`. The LaTeX class is distributed under [LPPL 1.3c](https://www.latex-project.org/lppl.txt) and the CV content under [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/legalcode).

## Usage

This project is free to use: anyone is welcome to fork it, reuse the LaTeX template, and adapt it to their own needs.
