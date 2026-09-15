# CV LaTeX de Cristhian Sanchez

Esta carpeta contiene todas las fuentes, recursos y resultados del currículum vitae. La plantilla es de uso libre y puede adaptarse a tus propias necesidades.

## Archivos principales

- `v1/`, `v2/`, ...: una carpeta por *versión* del CV (ver el
  [README de la raíz](../README.es.md) para qué es cada versión). Dentro de
  cada versión, `en/` y `es/` son una carpeta por idioma, cada una con su
  propio `cv.tex` (documento principal y datos personales) y sus
  `section_*.tex` (secciones del CV). Todas las versiones e idiomas comparten
  todo lo demás, así que su contenido es independiente pero su estilo se
  mantiene idéntico.
- `yaac-another-awesome-cv.cls`: clase y estilos LaTeX compartidos.
- `darwiin.png` y `fonts/`: foto y tipografías compartidas.
- `v1/output/`, `v2/output/`, ...: los PDF y archivos auxiliares generados
  por la compilación de esa versión (un par por idioma, ej.
  `sanchez_saune_cristhian_CV.pdf` y `sanchez_saune_cristhian_CV_es.pdf`).

## Edición

Modifica `<version>/en/cv.tex` o `<version>/es/cv.tex` para actualizar el encabezado, enlaces y datos personales de ese idioma. Edita el `section_*.tex` correspondiente dentro de esa misma carpeta para cambiar una sección concreta. Mantén ambos idiomas de una versión sincronizados a mano — no hay traducción automática entre ellos, ni sincronización automática entre versiones (cada una se edita y adapta por separado, a propósito).

La compilación se ejecuta desde `infra/compile.ps1` (`-Version v1|v2`, `-Lang en|es|both`) y requiere que el contenedor `sharelatex` esté levantado junto con `mongo` y `redis`. Compila con el directorio de trabajo en `latex/` mismo, pasando `<version>/en/cv.tex` o `<version>/es/cv.tex` como archivo objetivo — por eso cada `\input` dentro de esos archivos lleva el prefijo `<version>/en/` o `<version>/es/`, y la clase/foto/fuentes compartidas se referencian por su nombre simple (relativo a `latex/`, no a la subcarpeta de versión/idioma). Cambiar ese directorio de trabajo (por ejemplo, compilando desde dentro de `v1/en/`) rompe la compilación: con `-output-directory` apuntando entonces fuera del árbol del propio directorio del compilador, `hyperref`/`rerunfilecheck` fallan justo al final con un críptico `cannot find file ''`, aunque todo el documento se haya compilado bien hasta ese punto.

En `v1/en/section_experience_short.tex`, la experiencia de Seidor se declara con el mismo `\experience` que las demás: la
descripción y los clientes van juntos en el octavo argumento, y cada cliente se
compone con `\clientblock{<cliente>}{<sector>}{<logros>}`. Así toda la misión de
consultoría ocupa una única fila de la tabla, igual que el resto de entradas — `\experience` envuelve ese argumento en un `minipage`, que `longtable` solo puede colocar entero en una página, nunca dividirlo.

`v1/es/section_experience_short.tex` escribe esa misma entrada distinto: como filas sueltas de `longtable` en vez de una sola llamada a `\experience`, con cada `\clientblock` en su propia fila con prefijo `&`. `v2/es/section_experience_short.tex` usa la misma técnica para la entrada de Arkrisk (dividida en varios bloques de `itemize` con prefijo `&` en vez de una sola llamada a `\experience`). Ver "Ajuste fino del espaciado" más abajo para el porqué.

## Ajuste fino del espaciado

La clase expone longitudes con nombre para el ritmo vertical, en lugar de valores
dispersos por las macros:

- `\cvrowheadsep`: encabezado de una experiencia → cuerpo.
- `\cvtagrowheight`: altura de la fila de tecnologías. El cuerpo es un
  `minipage[t]`, cuya profundidad siempre supera un `\\[...]`; por eso el aire
  sobre las etiquetas se regula con la altura de su fila y no con el separador.
- `\cvrowtagsep`: tecnologías → siguiente experiencia.
- `\cvclientpresep` y `\cvclientpostsep`: aire antes y después del encabezado de
  cliente.
- `\cvprojecttagsep`: aire antes de las etiquetas de un proyecto.

El guionado automático está desactivado (`\hyphenpenalty=10000`) y se usa
`\frenchspacing`: las líneas se justifican comprimiendo los blancos, lo que
produce algunas `Overfull \hbox` esperadas. La columna derecha de las
experiencias (`E`) va justificada, no en bandera.

El resultado esperado para una versión dada es, por ejemplo para `v1`:

```text
v1/output/sanchez_saune_cristhian_CV.pdf      (inglés)
v1/output/sanchez_saune_cristhian_CV_es.pdf   (español)
```

El español ocupa notablemente más espacio que el inglés. Cualquier entrada con varios `\clientblock` o un `itemize` inusualmente largo (Seidor en `v1`, Arkrisk en `v2` una vez que sus bullets se volvieron más detallados) puede terminar siendo más alta que el espacio restante de la página actual una vez traducida. `longtable` nunca divide una sola fila entre páginas — normalmente, si una fila no cabe, la fila *entera* (envuelta en un `minipage` por `\experience`) salta a la siguiente página, dejando un hueco en blanco grande detrás. Un `\newpage` antes del título de sección evita el hueco, pero entonces el título de sección y el encabezado de esa entrada no aparecen en la página anterior, a diferencia de la versión en inglés.

Los archivos `es/section_experience_short.tex` lo arreglan de raíz en cambio: la entrada demasiado alta se escribe como filas sueltas de `longtable` (ej. `\textbf{Junio 2025} & ...`) en vez de una sola llamada a `\experience`, con cada bloque autocontenido (un `\clientblock`, o un grupo de `\item`) en su propia fila (`& ... \\`). Como ya nada los envuelve en un `minipage`, `longtable` puede cortar entre dos bloques cualesquiera, igual que ya hace entre experiencias distintas — así la página se llena por completo y solo el último bloque o los últimos dos fluyen a la siguiente página, sin salto forzado y sin hueco en blanco.
