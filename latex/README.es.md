# CV LaTeX de Cristhian Sanchez

Esta carpeta contiene todas las fuentes, recursos y resultados del currículum vitae. La plantilla es de uso libre y puede adaptarse a tus propias necesidades.

## Archivos principales

- `en/` y `es/`: una carpeta por idioma, cada una con su propio `cv.tex`
  (documento principal y datos personales) y sus `section_*.tex` (secciones
  del CV). Ambas versiones comparten todo lo demás, así que su contenido es
  independiente pero su estilo se mantiene idéntico.
- `yaac-another-awesome-cv.cls`: clase y estilos LaTeX compartidos.
- `darwiin.png` y `fonts/`: foto y tipografías compartidas.
- `output/`: los PDF y archivos auxiliares generados por la compilación (un
  par por idioma, ej. `sanchez_saune_cristhian_CV.pdf` y
  `sanchez_saune_cristhian_CV_es.pdf`).

## Edición

Modifica `en/cv.tex` o `es/cv.tex` para actualizar el encabezado, enlaces y datos personales de ese idioma. Edita el `section_*.tex` correspondiente dentro de esa misma carpeta para cambiar una sección concreta. Mantén ambos idiomas sincronizados a mano — no hay traducción automática entre ellos.

La compilación se ejecuta desde `infra/compile.ps1` (`-Lang en|es|both`) y requiere que el contenedor `sharelatex` esté levantado junto con `mongo` y `redis`. Compila con el directorio de trabajo en `latex/` mismo, pasando `en/cv.tex` o `es/cv.tex` como archivo objetivo — por eso cada `\input` dentro de esos archivos lleva el prefijo `en/` o `es/`, y la clase/foto/fuentes compartidas se referencian por su nombre simple (relativo a `latex/`, no a la subcarpeta de idioma). Cambiar ese directorio de trabajo (por ejemplo, compilando desde dentro de `en/`) rompe la compilación: con `-output-directory` apuntando entonces fuera del árbol del propio directorio del compilador, `hyperref`/`rerunfilecheck` fallan justo al final con un críptico `cannot find file ''`, aunque todo el documento se haya compilado bien hasta ese punto.

En `en/section_experience_short.tex`, la experiencia de Seidor se declara con el mismo `\experience` que las demás: la
descripción y los clientes van juntos en el octavo argumento, y cada cliente se
compone con `\clientblock{<cliente>}{<sector>}{<logros>}`. Así toda la misión de
consultoría ocupa una única fila de la tabla, igual que el resto de entradas — `\experience` envuelve ese argumento en un `minipage`, que `longtable` solo puede colocar entero en una página, nunca dividirlo.

`es/section_experience_short.tex` escribe esa misma entrada distinto: como filas sueltas de `longtable` en vez de una sola llamada a `\experience`, con cada `\clientblock` en su propia fila con prefijo `&`. Ver "Ajuste fino del espaciado" más abajo para el porqué.

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
output/sanchez_saune_cristhian_CV.pdf      (inglés)
output/sanchez_saune_cristhian_CV_es.pdf   (español)
```

El español ocupa notablemente más espacio que el inglés. La entrada de Seidor (5 `\clientblock`) es el elemento individual más alto de todo el CV, y una vez traducida ya no cabe en el espacio restante de la página 1 tras Habilidades. `longtable` nunca divide una sola fila entre páginas — normalmente, si una fila no cabe, la fila *entera* (todo el cuerpo de Seidor, envuelto en un `minipage` por `\experience`) salta a la siguiente página, dejando un hueco en blanco grande en la página 1. Un `\newpage` antes del título de sección evita el hueco, pero entonces "Experiencia Profesional" y el encabezado de Seidor no aparecen en la página 1, a diferencia de la versión en inglés.

`es/section_experience_short.tex` lo arregla de raíz en cambio: la entrada de Seidor se escribe como filas sueltas de `longtable` (ver `\textbf{Junio 2025} & ...`) en vez de una sola llamada a `\experience`, con cada `\clientblock` en su propia fila (`& \clientblock{...} \\`). Como ya nada los envuelve en un `minipage`, `longtable` puede cortar entre dos clientes cualesquiera, igual que ya hace entre experiencias distintas — así los primeros cuatro clientes llenan la página 1 y solo el quinto (Innova Sports) fluye a la página 2, sin salto forzado y sin hueco en blanco.
