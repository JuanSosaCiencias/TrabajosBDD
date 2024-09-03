# validators.py

def validar_numero(prompt):
    while True:
        try:
            return int(input(prompt))
        except ValueError:
            print("Por favor, ingrese un número válido.")

def validar_id(db, entidad, prompt):
    """Valida que el ID no exista ya en la base de datos para la entidad especificada."""
    while True:
        id = input(prompt)
        if not db.id_existe(entidad, id):
            return id
        else:
            print(f"El ID {id} ya existe en {entidad}. Por favor, ingrese otro.")

def seleccionar_sexo():
    while True:
        print("\nSeleccione el sexo:")
        print("1. Femenino")
        print("2. Masculino")
        print("3. No definido")
        eleccion = validar_numero("Ingrese el número correspondiente: ")
        if eleccion == 1:
            return "Femenino"
        elif eleccion == 2:
            return "Masculino"
        elif eleccion == 3:
            return "No definido"
        else:
            print("Opción no válida. Por favor, intente de nuevo.")

def seleccionar_entidad():
    while True:
        print("\nSeleccione la entidad:")
        print("1. Atletas")
        print("2. Entrenadores")
        print("3. Disciplinas")
        eleccion = validar_numero("Ingrese el número correspondiente: ")
        if eleccion in [1, 2, 3]:
            return ['atletas', 'entrenadores', 'disciplinas'][eleccion - 1]
        else:
            print("Opción no válida. Por favor, intente de nuevo.")

def mostrar_disciplinas(db):
    disciplinas = db.obtener_todas_las_disciplinas()
    if disciplinas:
        print("\nDisciplinas disponibles:")
        for disciplina in disciplinas:
            print(f"ID: {disciplina[0]}, Nombre: {disciplina[1]}, Fecha de inclusión: {disciplina[2]}")
    else:
        print("No hay disciplinas registradas.")

def menu_consultar_registro(db):
    entidad = seleccionar_entidad()
    id = input(f"Ingrese el ID del {entidad[:-1]} a consultar: ")
    registro = db.obtener_registro(entidad, id)
    if registro:
        print(f"\nRegistro encontrado:")
        cabeceras = ['ID', 'Nombre', 'Sexo', 'Edad', 'Disciplinas/Disciplina'] if entidad != 'disciplinas' else ['ID', 'Nombre', 'Fecha de inclusión']
        for cabecera, valor in zip(cabeceras, registro):
            print(f"{cabecera}: {valor}")
