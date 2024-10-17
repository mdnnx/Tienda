#!/bin/bash
#script by Armin Van Mont
Archivo_escaneos=DiaLaboral.txt
if [[ ! -f "$Archivo_escaneos" ]]; then
	echo "El archivo $Archivo_escaneos no existe"
	exit 1
fi
echo "Conteo de productos escaneados."
sort "$Archivo_escaneos" | uniq -c | while read -r count product; do
	echo "Producto: $product - Veces Escaneado: $count"
done
