#!/bin/bash

	function Crear_base {        
		echo -e "Como llamaras a tu nueva base de datos: "       
		read Nueva_base
        	sqlite3 $Nueva_base.db<< EOF
	CREATE TABLE Inventario(
	ID iNTEGER PRIMARY KEY,
	Producto TEXT NOT NULL,       
	Precio_U INTEGER,      
	Precio_P INTEGER,       
	Beneficio INTEGER AS (Precio_P - Precio_U),     
	Stock INTEGER,
	Inversion INTEGER AS (Precio_U * Stock));

EOF
		echo -e "La nueva base de datos $Nueva_base.db se ha creado con exito\nAhora selecciona < 1 > para agregar datos a la base de datos o < 2 > para salir"
       		 read -p "Has una eleccion: " opt    
		 case $opt in    
		 "1") Modificar ;; 
		 "2") exit ;;
		 
	        esac   
}
	function Mostrar_base {
	
		sqlite3 minisupersanpedro.db ".mode column" "SELECT * FROM Inventario;"

	}

	function Agregar {

		echo "Producto:"     
		read Producto      
		echo "Precio unitario:"     
		read Precio_unitario
       		echo "Precio al publico:"
       		read Precio_publico
       		echo "Stock:"
       		read Stock
		echo "barcode:"
		read barcode
		sqlite3 minisupersanpedro.db << EOF
        INSERT INTO Inventario (Producto, Precio_U, Precio_P, Stock, barcode) VALUES ('$Producto', $Precio_unitario, $Precio_publico, $Stock, $barcode );
EOF
		function Seguir_agregando () {
			read -p "Desea seguir ingresando mas datos? s/n: " opc
			if [ "$opc" != "s" ]; then
				exit 
			else
				Agregar
			fi

		}
		Seguir_agregando
}

	function Inversion {
		sqlite3 minisupersanpedro.db "SELECT SUM(Inversion) AS Total_inversion FROM Inventario;"
		

	}
	function Modificar {
		read -p "Cual es el nombre de la columna que deseas modificar: " optio
		read -p "Cual es el numero ID del producto que desea actualizar: " option
		read -p "Cual es el nuevo valor con el que deseas actualizar la celda : " options
		sqlite3 minisupersanpedro.db "UPDATE Inventario SET $optio='$options' WHERE ID=$option"
		echo "La base de datos se ha actualizado con exito"

	}
	function Dia_laboral {
		read -p "Para comenzar anota la fecha del dia laboral a comenzar con el siguiente formato 'doce_enero_2024' " o
		sqlite3 minisupersanpedro.db "CREATE TABLE $o AS SELECT ID, Producto, Beneficio FROM Inventario WHERE ID >= 1; "
		sqlite3 minisupersanpedro.db "ALTER TABLE $o ADD COLUMN Cantidad_vendida;"
		sqlite3 minisupersanpedro.db "ALTER TABLE $o ADD COLUMN Ganancia_del_dia;"

		function continuar () {

		read -p "Numero ID del producto: " opt
		read -p "Cantidad vendida durante el dia: " opti

		sqlite3 minisupersanpedro.db "UPDATE $o SET Cantidad_vendida=$opti WHERE ID=$opt"
		sqlite3 minisupersanpedro.db "UPDATE $o SET Ganancia_del_dia=($opti * Beneficio) WHERE ID=$opt"
		sqlite3 minisupersanpedro.db "SELECT SUM(Ganancia_del_dia) AS Total_Ganancia FROM $o;"
	}
		while true
		do
			continuar
			sleep .5
		done

}
	function Consultar {
	read -p "Que articulo buscas: " articulo
	sqlite3 minisupersanpedro.db ".mode column" "SELECT * FROM Inventario WHERE producto LIKE '%$articulo%';"
		function Seguir_buscando () {
			read -p "Deseas hacer otra consulta? s/n: " opc
			if [ "$opc" != "s" ]; then
				exit
			else
				Consultar
			fi

		}
		Seguir_buscando

}

echo -e "Bienvenido al script para crear bases de datos, que deseas hacer hoy: \n1.- Crear una nueva base de datos.\n2.- Agregar datos a  una base de datos existente.\n3.- Modificar una base de datos existente.\n4.- Mostrar base de datos.\n5.- Consultar base de datos.\n6.- Total de Inversion.\n7.- Iniciar un nuevo dia laboral.\n8.- Salir"
read -p "Has una eleccion: " opt      
case $opt in       
	"1") Crear_base ;;     
	"2") Agregar ;;
	"3") Modificar ;;   
	"4") Mostrar_base ;;
	"5") Consultar ;;
	"6") Inversion ;;
	"7") Dia_laboral ;;
	"8") exit ;;
esac


