#!/bin/bash

## Script para ejecutar todas las pruebas

# Verifica si los scripts de prueba existen
if [ ! -f "pruebas_añadir.sh" ] || [ ! -f "pruebas_modificar.sh" ]; then
    echo "Uno o ambos archivos de prueba no existen en la carpeta 'pruebas'."
    exit 1
fi

# Ejecuta el script de añadir registros
echo "Ejecutando pruebas de añadir registros..."
bash pruebas_añadir.sh

# Ejecuta el script de modificar registros
echo "Ejecutando pruebas de modificar registros..."
bash pruebas_modificar.sh

echo "Todas las pruebas ejecutadas correctamente."
