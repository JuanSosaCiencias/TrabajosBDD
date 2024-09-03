# validators.py
LILA = '\033[95m'
MORADO = '\033[35m'
AZUL_CLARO = '\033[94m'
AMARILLO_CLARO = '\033[93m'
ROSA = '\033[95m' 
VERDE_LIMON = '\033[92m'
ROJO = '\033[91m'
RESET = '\033[0m'  # Para resetear el color
NEGRITA = '\033[1m'
CYAN = '\033[36m'
VERDE = '\033[32m'
AZUL = '\033[34m'
NARANJA = '\033[38;5;208m'
MAGENTA_BRILLANTE = '\033[95m'
CYAN_BRILLANTE = '\033[96m'
MARRON = '\033[38;5;94m'
CORAL = '\033[38;5;209m'
SALMON = '\033[38;5;173m'
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
            print(f"{ROJO}Por favor, ingrese un número válido.{RESET}")

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
                print(f"{ROJO}El ID {id} ya está en uso. Por favor, elija otro.{RESET}")
        else:
            print(f"{ROJO}Por favor, ingrese un ID válido (número entero).{RESET}")

def seleccionar_sexo():
    """Permite al usuario seleccionar el sexo de un atleta o entrenador.
    Returns:
        str: Sexo seleccionado.
    """
    while True:
        print(f"{AZUL_CLARO}{NEGRITA}\nSeleccione el sexo:{RESET}")
        print(f"{LILA}1.{RESET} Femenino")
        print(f"{AMARILLO_CLARO}2.{RESET} Masculino")
        print(f"{MARRON}3.{RESET} No definido")
        eleccion = validar_numero("Ingrese el número correspondiente: ")
        if eleccion == 1:
            return "Femenino"
        elif eleccion == 2:
            return "Masculino"
        elif eleccion == 3:
            return "No definido"
        else:
            print(f"{ROJO}Opción no válida. Por favor, intente de nuevo.{RESET}")

def seleccionar_entidad():
    """Permite al usuario seleccionar la entidad a la que desea acceder.

    Entidades Disponibles: Atletas, Entrenadores, Disciplinas

    Returns:
        str: Nombre de la entidad seleccionada.
    """
    while True:
        print(f"\n{NEGRITA}{AZUL_CLARO}Seleccione la entidad:{RESET}")
        print(f"{VERDE}1.{RESET} Atletas")
        print(f"{ROSA}2.{RESET} Entrenadores")
        print(f"{NARANJA}3.{RESET} Disciplinas")
        eleccion = validar_numero("Ingrese el número correspondiente: ")
        if eleccion in [1, 2, 3]:
            return ['atletas', 'entrenadores', 'disciplinas'][eleccion - 1]
        else:
            print(f"{ROJO}Opción no válida. Por favor, intente de nuevo.{RESET}")

def mostrar_disciplinas(db):
    """Muestra todas las disciplinas disponibles en la base de datos.
    
    Args:
        db (OlympicDatabase): Instancia de la base de datos.

    """
    disciplinas = db.obtener_todas_las_disciplinas()
    if disciplinas:
        print("\nDisciplinas disponibles:")
        for disciplina in disciplinas:
            print(f"ID: {disciplina[0]}, Nombre: {disciplina[1]}, Fecha de inclusión: {disciplina[2]}")
    else:
        print(f"{ROJO}No hay disciplinas registradas.{RESET}")

def menu_consultar_registro(db):
    """Menú para consultar un registro en la base de datos.
    
    Permite al usuario seleccionar la entidad y el ID del registro a consultar.

    Args:
        db (OlympicDatabase): Instancia de la base de datos.

    """
    entidad = seleccionar_entidad()
    id = input(f"Ingrese el ID del {entidad[:-1]} a consultar: ")
    registro = db.obtener_registro(entidad, id)
    if registro:
        print(f"{VERDE}\nRegistro encontrado:{RESET}")
        cabeceras = ['ID', 'Nombre', 'Sexo', 'Edad', 'Disciplina(s)'] if entidad != 'disciplinas' else ['ID', 'Nombre', 'Fecha de inclusión']
        for cabecera, valor in zip(cabeceras, registro):
            print(f"{cabecera}: {valor}")
