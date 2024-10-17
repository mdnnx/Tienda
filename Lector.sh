#!/bin/bash
barcode=$(termux-clipboard-get)
sqlite3 minisupersanpedro.db ".mode column" "SELECT Producto, Precio_P FROM Inventario WHERE barcode = "$barcode";"
