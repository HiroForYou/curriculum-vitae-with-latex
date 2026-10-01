# Overleaf CE trae solo un TeX Live minimo (sin fontspec, etc.). Se instalan
# solo las colecciones necesarias, sin documentacion ni fuentes, para que la
# construccion sea rapida (scheme-full baja ~4800 paquetes y tarda horas).
#
# Se fija el repositorio historico de TL2025: el mirror por defecto puede tener
# checksums desincronizados y tlmgr falla sin abortar el build. La ultima linea
# hace fallar la construccion si alguno de los paquetes clave no quedo instalado.
FROM sharelatex/sharelatex:6.1.1
RUN tlmgr option repository https://ftp.tu-chemnitz.de/pub/tug/historic/systems/texlive/2025/tlnet-final \
 && tlmgr option docfiles 0 && tlmgr option srcfiles 0 \
 && tlmgr install collection-latexrecommended collection-latexextra \
    collection-fontsrecommended collection-fontsextra \
    collection-luatex collection-langspanish collection-pictures \
 && kpsewhich fontspec.sty titlesec.sty tcolorbox.sty fontawesome.sty enumitem.sty xcolor.sty tikz.sty
