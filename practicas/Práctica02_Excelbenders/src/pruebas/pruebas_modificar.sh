#!/bin/bash

## Script para ejecutar el programa y automatizar las entradas
## Prueba de edición, eliminación y consulta de registros

# Verifica si el comando `expect` está instalado
if ! command -v expect &> /dev/null
then
    echo "'expect' no está instalado. Instálalo usando 'sudo apt-get install expect'."
    exit
fi

# Ejecuta el programa y automatiza las entradas con expect
expect << EOF
    # Ejecutar el programa Python
    spawn python3 ../menu.py

    # Modificar un atleta
    expect "Seleccione una opción:"
    send "5\r"
    expect "Seleccione una entidad:"
    send "1\r"  
    expect "Ingrese el ID a editar:"
    send "1\r"
    expect "Ingrese el nuevo nombre del atleta:"
    send "Carlos Modificado\r"
    expect "Ingrese el nuevo apellido paterno del atleta:"
    send "Pérez Modificado\r"
    expect "Ingrese el nuevo apellido materno del atleta:"
    send "Gómez Modificado\r"
    expect "Seleccione el sexo:"
    send "2\r"  
    expect "Ingrese la nueva edad del atleta:"
    send "26\r"
    expect "Ingrese las nuevas disciplinas del atleta (separadas por coma):"
    send "Natación, Atletismo\r"

    # Modificar un entrenador
    expect "Seleccione una opción:"
    send "5\r"
    expect "Seleccione una entidad:"
    send "2\r"  
    expect "Ingrese el ID a editar:"
    send "1\r"
    expect "Ingrese el nuevo nombre del entrenador:"
    send "María Modificada\r"
    expect "Ingrese el nuevo apellido paterno del entrenador:"
    send "Vázquez Modificado\r"
    expect "Ingrese el nuevo apellido materno del entrenador:"
    send "Mora Modificada\r"
    expect "Seleccione el sexo:"
    send "1\r"  
    expect "Ingrese la nueva edad del entrenador:"
    send "46\r"
    expect "Ingrese la nueva disciplina del entrenador:"
    send "Boxeo\r"

    # Modificar una disciplina
    expect "Seleccione una opción:"
    send "5\r"
    expect "Seleccione una entidad:"
    send "3\r"  
    expect "Ingrese el ID a editar:"
    send "1\r"
    expect "Ingrese el nuevo nombre de la disciplina:"
    send "Natación Modificada\r"
    expect "Ingrese la nueva fecha de inclusión (YYYY-MM-DD):"
    send "2024-09-06\r"

    # Eliminar un atleta
    expect "Seleccione una opción:"
    send "6\r"
    expect "Seleccione una entidad:"
    send "1\r"  
    expect "Ingrese el ID a eliminar:"
    send "2\r"

    # Eliminar un entrenador
    expect "Seleccione una opción:"
    send "6\r"
    expect "Seleccione una entidad:"
    send "2\r"  
    expect "Ingrese el ID a eliminar:"
    send "2\r"

    # Eliminar una disciplina
    expect "Seleccione una opción:"
    send "6\r"
    expect "Seleccione una entidad:"
    send "3\r"  
    expect "Ingrese el ID a eliminar:"
    send "2\r"

    # Consultar un atleta
    expect "Seleccione una opción:"
    send "4\r"
    expect "Seleccione una entidad:"
    send "1\r"  
    expect "Ingrese el ID del atleta a consultar:"
    send "1\r"

    # Consultar un entrenador
    expect "Seleccione una opción:"
    send "4\r"
    expect "Seleccione una entidad:"
    send "2\r"  
    expect "Ingrese el ID del entrenador a consultar:"
    send "1\r"

    # Consultar una disciplina
    expect "Seleccione una opción:"
    send "4\r"
    expect "Seleccione una entidad:"
    send "3\r"  
    expect "Ingrese el ID de la disciplina a consultar:"
    send "1\r"

    # Finaliza el programa
    expect "Seleccione una opción:"
    send "8\r"
    expect eof
EOF

echo "Script ejecutado correctamente."
