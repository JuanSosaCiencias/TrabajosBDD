#!/bin/bash

# Verifica si el comando `expect` está instalado
if ! command -v expect &> /dev/null
then
    echo "'expect' no está instalado. Instalalo usando 'sudo apt-get install expect'."
    exit
fi

# Ejecuta el programa y automatiza las entradas con expect
expect << EOF
    # Ejecutar el programa Python
    spawn python3 prueba.py

    # 1. Agregar disciplinas
    expect "Seleccione una opción:"
    send "3\r"
    expect "Ingrese el nombre de la disciplina:"
    send "Natación\r"
    expect "Ingrese la fecha de inclusión"
    send "2024-09-01\r"

    expect "Seleccione una opción:"
    send "3\r"
    expect "Ingrese el nombre de la disciplina:"
    send "Atletismo\r"
    expect "Ingrese la fecha de inclusión"
    send "2024-09-02\r"

    expect "Seleccione una opción:"
    send "3\r"
    expect "Ingrese el nombre de la disciplina:"
    send "Fútbol\r"
    expect "Ingrese la fecha de inclusión"
    send "2024-09-03\r"

    expect "Seleccione una opción:"
    send "3\r"
    expect "Ingrese el nombre de la disciplina:"
    send "Boxeo\r"
    expect "Ingrese la fecha de inclusión"
    send "2024-09-04\r"

    expect "Seleccione una opción:"
    send "3\r"
    expect "Ingrese el nombre de la disciplina:"
    send "Baloncesto\r"
    expect "Ingrese la fecha de inclusión"
    send "2024-09-05\r"

    # 2. Agregar atletas
    expect "Seleccione una opción:"
    send "1\r"
    expect "Ingrese el nombre del atleta:"
    send "Carlos\r"
    expect "Seleccione el sexo:"
    send "2\r"
    expect "Ingrese la edad del atleta:"
    send "25\r"
    expect "Ingrese las disciplinas (separadas por coma):"
    send "Natación,Fútbol\r"

    expect "Seleccione una opción:"
    send "1\r"
    expect "Ingrese el nombre del atleta:"
    send "Ana\r"
    expect "Seleccione el sexo:"
    send "1\r"
    expect "Ingrese la edad del atleta:"
    send "23\r"
    expect "Ingrese las disciplinas (separadas por coma):"
    send "Atletismo,Boxeo\r"

    expect "Seleccione una opción:"
    send "1\r"
    expect "Ingrese el nombre del atleta:"
    send "Luis\r"
    expect "Seleccione el sexo:"
    send "2\r"
    expect "Ingrese la edad del atleta:"
    send "28\r"
    expect "Ingrese las disciplinas (separadas por coma):"
    send "Fútbol,Baloncesto\r"

    expect "Seleccione una opción:"
    send "1\r"
    expect "Ingrese el nombre del atleta:"
    send "Sofía\r"
    expect "Seleccione el sexo:"
    send "1\r"
    expect "Ingrese la edad del atleta:"
    send "21\r"
    expect "Ingrese las disciplinas (separadas por coma):"
    send "Natación,Atletismo\r"

    expect "Seleccione una opción:"
    send "1\r"
    expect "Ingrese el nombre del atleta:"
    send "Pedro\r"
    expect "Seleccione el sexo:"
    send "2\r"
    expect "Ingrese la edad del atleta:"
    send "26\r"
    expect "Ingrese las disciplinas (separadas por coma):"
    send "Boxeo,Fútbol\r"

    # 3. Agregar entrenadores
    expect "Seleccione una opción:"
    send "2\r"
    expect "Ingrese el nombre del entrenador:"
    send "María\r"
    expect "Seleccione el sexo:"
    send "1\r"
    expect "Ingrese la edad del entrenador:"
    send "45\r"
    expect "Ingrese la nueva disciplina del entrenador:"
    send "Natación\r"

    expect "Seleccione una opción:"
    send "2\r"
    expect "Ingrese el nombre del entrenador:"
    send "José\r"
    expect "Seleccione el sexo:"
    send "2\r"
    expect "Ingrese la edad del entrenador:"
    send "50\r"
    expect "Ingrese la nueva disciplina del entrenador:"
    send "Atletismo\r"

    expect "Seleccione una opción:"
    send "2\r"
    expect "Ingrese el nombre del entrenador:"
    send "Laura\r"
    expect "Seleccione el sexo:"
    send "1\r"
    expect "Ingrese la edad del entrenador:"
    send "39\r"
    expect "Ingrese la nueva disciplina del entrenador:"
    send "Fútbol\r"

    expect "Seleccione una opción:"
    send "2\r"
    expect "Ingrese el nombre del entrenador:"
    send "Carlos\r"
    expect "Seleccione el sexo:"
    send "2\r"
    expect "Ingrese la edad del entrenador:"
    send "42\r"
    expect "Ingrese la nueva disciplina del entrenador:"
    send "Boxeo\r"

    expect "Seleccione una opción:"
    send "2\r"
    expect "Ingrese el nombre del entrenador:"
    send "Clara\r"
    expect "Seleccione el sexo:"
    send "1\r"
    expect "Ingrese la edad del entrenador:"
    send "35\r"
    expect "Ingrese la nueva disciplina del entrenador:"
    send "Baloncesto\r"

    # 4. Modificar registros (ejemplo de modificación de un registro)
    expect "Seleccione una opción:"
    send "5\r"
    send "1\r"  # Editar un atleta
    expect "Ingrese el ID a editar:"
    send "1\r"
    expect "Ingrese el nuevo nombre del atleta:"
    send "Carlos Modificado\r"
    expect "Seleccione el sexo:"
    send "2\r"
    expect "Ingrese la nueva edad del atleta:"
    send "26\r"
    expect "Ingrese las nuevas disciplinas del atleta (separadas por coma):"
    send "Fútbol,Atletismo\r"

    # Finaliza el programa
    expect "Seleccione una opción:"
    send "8\r"
    expect eof
EOF

echo "Script ejecutado correctamente."
