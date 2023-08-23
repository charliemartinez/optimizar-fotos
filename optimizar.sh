#!/bin/bash
#
# Optimizar-fotos
# Comando para terminal GNU Linux.
# Autor: Charlie Martinez <cmartinez@quirinux.org>
#
# Script para optimizar una gran cantidad de fotografías .jpg
#
# IMPORATNTE: Guardar un backup de la carpeta con las fotos originales,
# una vez optimizadas los cambios no pueden deshacerse. 

DIRECTORIO="$PWD"
ANCHO_HORIZONTAL=1920
ALTO_3_2=1280  # 3:2 aspect ratio
ALTO_2_3=2560  # 2:3 aspect ratio

find "$DIRECTORIO" -maxdepth 1 -type f -print0 | while IFS= read -r -d '' IMAGEN; do
    WIDTH=$(identify -format "%w" "$IMAGEN")
    HEIGHT=$(identify -format "%h" "$IMAGEN")
    RATIO=$(echo "scale=2; $WIDTH / $HEIGHT" | bc)

    if (( $(echo "$RATIO >= 1.5" | bc -l) )); then
        NEW_HEIGHT=$ALTO_3_2
    else
        NEW_HEIGHT=$ALTO_2_3
    fi

    convert "$IMAGEN" -resize "$ANCHO_HORIZONTAL"x"$NEW_HEIGHT^" -gravity center -extent "$ANCHO_HORIZONTAL"x"$NEW_HEIGHT" "$IMAGEN"
    convert "$IMAGEN" -quality 80 "$DIRECTORIO/$(basename "$IMAGEN")"
done
