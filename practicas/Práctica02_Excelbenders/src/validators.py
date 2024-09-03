# validators.py

def validar_numero(prompt):
    """Valida que el número ingresado por el usuario sea un entero.
    
    Args:
        prompt (str): Mensaje a mostrar al usuario para solicitar el número.
        
    Returns:
        int: Número validado.
    """
    while True:
        try:
            return int(input(prompt))
        except ValueError:
            print("Por favor, ingrese un número válido.")

def validar_id(db, entidad, prompt):

    """Valida que el ID ingresado por el usuario no esté en uso en la base de datos.
    
    Args:
        db (OlympicDatabase): Instancia de la base de datos.
        entidady (str): Nombre de la entidad a la que pertenece el ID.
        prompt (str): Mensaje a mostrar al usuario para solicitar el ID.
        
    Returns:
        str: ID validado.
    """
    while True:
        id = input(prompt)
        if id.isdigit():
            if not db.id_existe(entidad, id):
                return id
            else:
                print(f"El ID {id} ya está en uso. Por favor, elija otro.")
        else:
            print("Por favor, ingrese un ID válido (número entero).")

def seleccionar_sexo():
    """Permite al usuario seleccionar el sexo de un atleta o entrenador.

    Args:
        None
    
    Returns:
        str: Sexo seleccionado.
    """
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
    """Permite al usuario seleccionar la entidad a la que desea acceder.

    Entidades Disponibles: Atletas, Entrenadores, Disciplinas

    Args:
        None
    
    Returns:
        str: Nombre de la entidad seleccionada.
    """
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
    """Muestra todas las disciplinas disponibles en la base de datos.
    
    Args:
        db (OlympicDatabase): Instancia de la base de datos.
        
    Returns:
        None
    """
    disciplinas = db.obtener_todas_las_disciplinas()
    if disciplinas:
        print("\nDisciplinas disponibles:")
        for disciplina in disciplinas:
            print(f"ID: {disciplina[0]}, Nombre: {disciplina[1]}, Fecha de inclusión: {disciplina[2]}")
    else:
        print("No hay disciplinas registradas.")

def menu_consultar_registro(db):
    """Menú para consultar un registro en la base de datos.
    
    Permite al usuario seleccionar la entidad y el ID del registro a consultar.

    Args:
        db (OlympicDatabase): Instancia de la base de datos.

    Returns:
        None
    """
    entidad = seleccionar_entidad()
    id = input(f"Ingrese el ID del {entidad[:-1]} a consultar: ")
    registro = db.obtener_registro(entidad, id)
    if registro:
        print(f"\nRegistro encontrado:")
        cabeceras = ['ID', 'Nombre', 'Sexo', 'Edad', 'Disciplinas/Disciplina'] if entidad != 'disciplinas' else ['ID', 'Nombre', 'Fecha de inclusión']
        for cabecera, valor in zip(cabeceras, registro):
            print(f"{cabecera}: {valor}")
