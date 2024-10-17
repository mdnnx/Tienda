#!/bin/bash
barcode=$(termux-clipboard-get)
sqlite3 minisupersanpedro.db ".mode list" " SELECT ID FROM Inventario WHERE barcode = "$barcode";" >> DiaLaboral.txt

