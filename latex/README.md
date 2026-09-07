# CV LaTeX de Cristhian Sanchez

Esta carpeta contiene todas las fuentes, recursos y resultados del currículum vitae.

## Archivos principales

- `cv.tex`: documento principal y datos personales.
- `section_*.tex`: secciones del CV.
- `yaac-another-awesome-cv.cls`: clase y estilos LaTeX.
- `darwiin.png` y `fonts/`: foto y tipografías usadas por el documento.
- `output/`: PDF y archivos auxiliares generados por la compilación.

## Edición

Modifica `cv.tex` para actualizar el encabezado, enlaces y datos de Cristhian Sanchez. Edita el archivo `section_*.tex` correspondiente para cambiar una sección concreta.

La compilación se ejecuta desde `infra/compile.ps1` y requiere que el contenedor `sharelatex` esté levantado junto con `mongo` y `redis`.

La experiencia de Seidor se declara con el mismo `\experience` que las demás: la
descripción y los clientes van juntos en el octavo argumento, y cada cliente se
compone con `\clientblock{<cliente>}{<sector>}{<logros>}`. Así toda la misión de
consultoría ocupa una única fila de la tabla, igual que el resto de entradas.

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

El resultado esperado es:

```text
output/sanchez_saune_cristhian_CV.pdf
```
