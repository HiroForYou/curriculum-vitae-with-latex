param(
    [switch]$Clean,
    # 'en' compila latex/en/cv.tex (por defecto); 'es' compila
    # latex/es/cv.tex; 'both' compila las dos versiones en una sola pasada.
    [ValidateSet('en', 'es', 'both')]
    [string]$Lang = 'en'
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

$jobs = switch ($Lang) {
    'en'   { , @{ Dir = 'en'; JobName = 'sanchez_saune_cristhian_CV' } }
    'es'   { , @{ Dir = 'es'; JobName = 'sanchez_saune_cristhian_CV_es' } }
    'both' { @(
                @{ Dir = 'en'; JobName = 'sanchez_saune_cristhian_CV' },
                @{ Dir = 'es'; JobName = 'sanchez_saune_cristhian_CV_es' }
             ) }
}

docker exec $container bash -lc "rm -rf $remote"
docker cp $latexRoot "${container}:$remote"
if ($LASTEXITCODE -ne 0) {
    throw "No se pudo copiar el proyecto al contenedor '$container'."
}

foreach ($job in $jobs) {
    $dir = $job.Dir
    $jobName = $job.JobName
    # Se compila con cwd=$remote (la raiz de latex/), pasando '<dir>/cv.tex'
    # como argumento: la clase, fonts/ y darwiin.png se resuelven con rutas
    # bare relativas a esa raiz, y kpathsea encuentra los \input{section_*}
    # de cada subcarpeta por busqueda recursiva. Cambiar el cwd a en/ o es/
    # (con -output-directory apuntando fuera de ese arbol) hace que
    # hyperref/rerunfilecheck fallen al cerrar el PDF con un misterioso
    # "cannot find file ''" tras compilar todo el contenido igual.
    $compileCommand = "set -e; cd $remote; mkdir -p output; lualatex -interaction=nonstopmode -halt-on-error -file-line-error -output-directory=output -jobname=$jobName $dir/cv.tex; lualatex -interaction=nonstopmode -halt-on-error -file-line-error -output-directory=output -jobname=$jobName $dir/cv.tex"

    docker exec $container bash -lc $compileCommand
    if ($LASTEXITCODE -ne 0) {
        throw "La compilacion de '$dir/cv.tex' dentro de '$container' fallo con el codigo $LASTEXITCODE."
    }
}

docker cp "${container}:$remote/output/." $output
if ($LASTEXITCODE -ne 0) {
    throw "No se pudo copiar el resultado desde el contenedor '$container'."
}

foreach ($job in $jobs) {
    $pdf = Join-Path $output "$($job.JobName).pdf"
    if (-not (Test-Path $pdf)) {
        throw "LuaLaTeX termino sin generar el PDF esperado: $pdf"
    }
    Write-Host "PDF generado en: $pdf"
}