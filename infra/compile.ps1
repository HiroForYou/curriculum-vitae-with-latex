param(
    [switch]$Clean,
    # 'en' compila <Version>/en/cv.tex (por defecto); 'es' compila
    # <Version>/es/cv.tex; 'both' compila las dos versiones en una sola pasada.
    [ValidateSet('en', 'es', 'both')]
    [string]$Lang = 'en',
    # Version del CV a compilar: latex/v1/ (por defecto) o latex/v2/. Cada
    # version tiene su propio en/ y es/, pero comparte la clase, fonts/ y
    # darwiin.png en la raiz de latex/.
    [ValidateSet('v1', 'v2')]
    [string]$Version = 'v1'
)

$ErrorActionPreference = 'Stop'
$container = 'sharelatex'
$projectRoot = Split-Path $PSScriptRoot -Parent
$latexRoot = Join-Path $projectRoot 'latex'
$output = Join-Path $latexRoot "$Version\output"
$remote = '/tmp/cv-build'

$running = docker inspect -f '{{.State.Running}}' $container 2>$null
if ($LASTEXITCODE -ne 0 -or $running -ne 'true') {
    throw "El contenedor '$container' no esta ejecutandose. Inicia ShareLaTeX antes de compilar."
}

New-Item -ItemType Directory -Force -Path $output | Out-Null

if ($Clean) { Get-ChildItem -Path $output -File | Remove-Item -Force }

$jobs = switch ($Lang) {
    'en'   { , @{ Dir = "$Version/en"; JobName = 'sanchez_saune_cristhian_CV' } }
    'es'   { , @{ Dir = "$Version/es"; JobName = 'sanchez_saune_cristhian_CV_es' } }
    'both' { @(
                @{ Dir = "$Version/en"; JobName = 'sanchez_saune_cristhian_CV' },
                @{ Dir = "$Version/es"; JobName = 'sanchez_saune_cristhian_CV_es' }
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
    # Se compila con cwd=$remote (la raiz de latex/), pasando '<version>/<lang>/cv.tex'
    # como argumento: la clase, fonts/ y darwiin.png se resuelven con rutas
    # bare relativas a esa raiz (compartidas entre v1 y v2), y kpathsea
    # encuentra los \input{section_*} de cada subcarpeta por busqueda
    # recursiva. Cambiar el cwd a <version>/en o <version>/es (con
    # -output-directory apuntando fuera de ese arbol) hace que
    # hyperref/rerunfilecheck fallen al cerrar el PDF con un misterioso
    # "cannot find file ''" tras compilar todo el contenido igual.
    $outDirRemote = "$remote/$Version/output"
    $compileCommand = "set -e; cd $remote; mkdir -p $Version/output; lualatex -interaction=nonstopmode -halt-on-error -file-line-error -output-directory=$Version/output -jobname=$jobName $dir/cv.tex; lualatex -interaction=nonstopmode -halt-on-error -file-line-error -output-directory=$Version/output -jobname=$jobName $dir/cv.tex"

    docker exec $container bash -lc $compileCommand
    if ($LASTEXITCODE -ne 0) {
        throw "La compilacion de '$dir/cv.tex' dentro de '$container' fallo con el codigo $LASTEXITCODE."
    }
}

docker cp "${container}:$remote/$Version/output/." $output
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
