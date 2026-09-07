param(
    [switch]$Clean
)

$ErrorActionPreference = 'Stop'
$container = 'sharelatex'
$projectRoot = Split-Path $PSScriptRoot -Parent
$latexRoot = Join-Path $projectRoot 'latex'
$output = Join-Path $latexRoot 'output'
$remote = '/tmp/cv-build'

$running = docker inspect -f '{{.State.Running}}' $container 2>$null
if ($LASTEXITCODE -ne 0 -or $running -ne 'true') {
    throw "El contenedor '$container' no esta ejecutandose. Inicia ShareLaTeX antes de compilar."
}

New-Item -ItemType Directory -Force -Path $output | Out-Null

if ($Clean) { Get-ChildItem -Path $output -File | Remove-Item -Force }

$compileCommand = "set -e; cd $remote; mkdir -p output; lualatex -interaction=nonstopmode -halt-on-error -file-line-error -output-directory=output -jobname=sanchez_saune_cristhian_CV cv.tex; lualatex -interaction=nonstopmode -halt-on-error -file-line-error -output-directory=output -jobname=sanchez_saune_cristhian_CV cv.tex"

docker exec $container bash -lc "rm -rf $remote"
docker cp $latexRoot "${container}:$remote"
if ($LASTEXITCODE -ne 0) {
    throw "No se pudo copiar el proyecto al contenedor '$container'."
}

docker exec $container bash -lc $compileCommand
if ($LASTEXITCODE -ne 0) {
    throw "La compilacion dentro de '$container' fallo con el codigo $LASTEXITCODE."
}

docker cp "${container}:$remote/output/." $output
if ($LASTEXITCODE -ne 0) {
    throw "No se pudo copiar el resultado desde el contenedor '$container'."
}

$pdf = Join-Path $output 'sanchez_saune_cristhian_CV.pdf'
if (-not (Test-Path $pdf)) {
    throw "LuaLaTeX termino sin generar el PDF esperado: $pdf"
}

Write-Host "PDF generado en: $pdf"