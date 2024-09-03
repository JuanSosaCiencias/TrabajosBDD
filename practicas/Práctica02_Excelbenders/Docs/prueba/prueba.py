import csv # Para leer y escribir archivos CSV
import os # Para verificar si un archivo existe
import unicodedata # Para normalizar texto

class OlympicDatabase:
    """Clase para interactuar con la base de datos de atletas, entrenadores y disciplinas.
    
    Attributes:
        entities (dict): Diccionario con las entidades disponibles y sus archivos CSV asociados.
        
        Methods:
            id_exists(entity, id): Verifica si un ID ya está en uso en la base de datos.
            add_record(entity, record): Añade un registro a la base de datos.
            get_record(entity, id): Obtiene un registro de la base de datos.
            update_record(entity, id, new_data): Actualiza un registro en la base de datos.
            delete_record(entity, id): Elimina un registro de la base de datos.
            get_all_disciplines(): Obtiene todas las disciplinas registradas en la base de datos.
            
            Ejemplo de uso:
                db = OlympicDatabase()
                db.add_record('atletas', ['1', 'Juan', 'Pérez', 'Gómez', 'Masculino', '25', 'Natación'])
                db.get_record('atletas', '1')
                db.update_record('atletas', '1', ['Juan', 'Pérez', 'Gómez', 'Masculino', '26', 'Natación'])
                db.delete_record('atletas', '1')
                db.get_all_disciplines()
                
    """
    def __init__(self):
        """Inicializa la base de datos y las entidades disponibles.
        
        Args:
            None
            
        Returns:
            None
        """
        self.entities = {
            'atletas': 'atletas.csv',
            'entrenadores': 'entrenadores.csv',
            'disciplinas': 'disciplinas.csv'
        }

    def id_exists(self, entity, id):
        """Verifica si un ID ya está en uso en la base de datos.
        
        Args:
            entity (str): Nombre de la entidad a la que pertenece el ID.
            id (str): ID a verificar.
            
        Returns:
            bool: True si el ID ya está en uso, False en caso contrario.
        """
        if not os.path.exists(self.entities[entity]):
            return False
        with open(self.entities[entity], 'r') as f:
            reader = csv.reader(f)
            return any(row[0] == id for row in reader)

    def add_record(self, entity, record):
        """Añade un registro a la base de datos.
        
        Args:
            entity (str): Nombre de la entidad a la que pertenece el registro.
            record (list): Lista con los datos del registro a añadir.
            
        Returns:
            None
        """
        with open(self.entities[entity], 'a', newline='') as f:
            writer = csv.writer(f)
            writer.writerow(record)
        print(f"Registro añadido a {entity} exitosamente.")

    def get_record(self, entity, id):
        """Obtiene un registro de la base de datos.
        
        Args:
            entity (str): Nombre de la entidad a la que pertenece el registro.
            id (str): ID del registro a obtener.
            
        Returns:
            list: Lista con los datos del registro, o None si no se encontró el registro.
        """
        if not os.path.exists(self.entities[entity]):
            print(f"No hay registros en {entity}.")
            return None
        with open(self.entities[entity], 'r') as f:
            reader = csv.reader(f)
            for row in reader:
                if row[0] == id:
                    return row
        print(f"No se encontró el registro con ID {id} en {entity}.")
        return None

    def update_record(self, entity, id, new_data):
        """Actualiza un registro en la base de datos.
        
        Args:
            entity (str): Nombre de la entidad a la que pertenece el registro.
            id (str): ID del registro a actualizar.
            new_data (list): Lista con los nuevos datos del registro.
            
        Returns:
            None
        """
        if not os.path.exists(self.entities[entity]):
            print(f"No hay registros en {entity} para actualizar.")
            return
        rows = []
        updated = False
        with open(self.entities[entity], 'r') as f:
            reader = csv.reader(f)
            for row in reader:
                if row[0] == id:
                    row = [id] + new_data
                    updated = True
                rows.append(row)
        
        if updated:
            with open(self.entities[entity], 'w', newline='') as f:
                writer = csv.writer(f)
                writer.writerows(rows)
            print(f"Registro actualizado en {entity} exitosamente.")
        else:
            print(f"No se encontró el registro con ID {id} en {entity}.")

    def delete_record(self, entity, id):
        """Elimina un registro de la base de datos.
        
        Args:
            entity (str): Nombre de la entidad a la que pertenece el registro.
            id (str): ID del registro a eliminar.
            
        Returns:
            None"""
        if not os.path.exists(self.entities[entity]):
            print(f"No hay registros en {entity} para eliminar.")
            return
        rows = []
        deleted = False
        with open(self.entities[entity], 'r') as f:
            reader = csv.reader(f)
            for row in reader:
                if row[0] != id:
                    rows.append(row)
                else:
                    deleted = True
        
        if deleted:
            with open(self.entities[entity], 'w', newline='') as f:
                writer = csv.writer(f)
                writer.writerows(rows)
            print(f"Registro eliminado de {entity} exitosamente.")
        else:
            print(f"No se encontró el registro con ID {id} en {entity}.")

    def get_all_disciplines(self):
        """Obtiene todas las disciplinas registradas en la base de datos.

        Args:
            None
        
        Returns:
            list: Lista de disciplinas, donde cada disciplina es una lista con los campos ID, Nombre y Fecha de inclusión."""
        disciplines = []
        if os.path.exists(self.entities['disciplinas']):
            with open(self.entities['disciplinas'], 'r') as f:
                reader = csv.reader(f)
                disciplines = [row for row in reader]
        return disciplines

def validate_number(prompt):
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

def validate_id(db, entity, prompt):
    """Valida que el ID ingresado por el usuario no esté en uso en la base de datos.
    
    Args:
        db (OlympicDatabase): Instancia de la base de datos.
        entity (str): Nombre de la entidad a la que pertenece el ID.
        prompt (str): Mensaje a mostrar al usuario para solicitar el ID.
        
    Returns:
        str: ID validado.
    """
    while True:
        id = input(prompt)
        if id.isdigit():
            if not db.id_exists(entity, id):
                return id
            else:
                print(f"El ID {id} ya está en uso. Por favor, elija otro.")
        else:
            print("Por favor, ingrese un ID válido (número entero).")

def select_sex():
    """Permite al usuario seleccionar el sexo de un atleta o entrenador.

    Args:
        None
    
    Returns:
        str: Sexo seleccionado."""
    while True:
        print("\nSeleccione el sexo:")
        print("1. Femenino")
        print("2. Masculino")
        print("3. No definido")
        choice = validate_number("Ingrese el número correspondiente: ")
        if choice == 1:
            return "Femenino"
        elif choice == 2:
            return "Masculino"
        elif choice == 3:
            return "No definido"
        else:
            print("Opción no válida. Por favor, intente de nuevo.")

def select_entity():
    """Permite al usuario seleccionar la entidad a la que desea acceder.

    Available entities: Atletas, Entrenadores, Disciplinas

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
        choice = validate_number("Ingrese el número correspondiente: ")
        if choice in [1, 2, 3]:
            return ['atletas', 'entrenadores', 'disciplinas'][choice - 1]
        else:
            print("Opción no válida. Por favor, intente de nuevo.")

def show_disciplines(db):
    """Muestra todas las disciplinas disponibles en la base de datos.
    
    Args:
        db (OlympicDatabase): Instancia de la base de datos.
        
    Returns:
        None
    """
    disciplines = db.get_all_disciplines()
    if disciplines:
        print("\nDisciplinas disponibles:")
        for discipline in disciplines:
            print(f"ID: {discipline[0]}, Nombre: {discipline[1]}, Fecha de inclusión: {discipline[2]}")
    else:
        print("No hay disciplinas registradas.")

def consult_record_menu(db):
    """Menú para consultar un registro en la base de datos.
    
    Permite al usuario seleccionar la entidad y el ID del registro a consultar.

    Args:
        db (OlympicDatabase): Instancia de la base de datos.

    Returns:
        None
    """
    entity = select_entity()
    id = input(f"Ingrese el ID del {entity[:-1]} a consultar: ")
    record = db.get_record(entity, id)
    if record:
        print(f"\nRegistro encontrado:")
        headers = ['ID', 'Nombre', 'Sexo', 'Edad', 'Disciplinas/Disciplina'] if entity != 'disciplinas' else ['ID', 'Nombre', 'Fecha de inclusión']
        for header, value in zip(headers, record):
            print(f"{header}: {value}")

def get_next_id(db, entity):
    """Obtiene el siguiente ID disponible para una entidad en la base de datos.
    
    Args:
        db (OlympicDatabase): Instancia de la base de datos.
        entity (str): Nombre de la entidad para la que se desea obtener el siguiente ID.
        
    Returns:
        int: Siguiente ID disponible.
    """
    try:
        if not os.path.exists(db.entities[entity]):
            return 1
        with open(db.entities[entity], 'r') as f:
            reader = csv.reader(f)
            ids = [int(row[0]) for row in reader if len(row) > 0 and row[0].isdigit()]
            return max(ids) + 1 if ids else 1
    except Exception as e:
        print(f"Error al obtener el siguiente ID: {e}")
        return 1

    
def discipline_exists(db, discipline_name):
    """Verifica si una disciplina existe en la base de datos.
    
    Args:
        db (OlympicDatabase): Instancia de la base de datos.
        discipline_name (str): Nombre de la disciplina a buscar.

    Returns:
        bool: True si la disciplina existe, False en caso contrario.
    """
    normalized_name = normalize_string(discipline_name)
    if not os.path.exists(db.entities['disciplinas']):
        return False
    with open(db.entities['disciplinas'], 'r') as f:
        reader = csv.reader(f)
        for row in reader:
            if normalize_string(row[1]) == normalized_name:
                return True
    return False


    
def input_disciplines(db):
    """Solicita al usuario ingresar las disciplinas de un atleta o entrenador.

    Args:
        db (OlympicDatabase): Instancia de la base de datos.

    Returns:
        str: Disciplinas ingresadas por el usuario.
    """
    valid_disciplines = []
    show_disciplines(db)  # Mostrar las disciplinas disponibles
    while True:
        disciplinas = input("Ingrese las disciplinas (separadas por coma): ").split(',')
        all_valid = True
        for disciplina in disciplinas:
            disciplina = disciplina.strip()
            if not discipline_exists(db, disciplina):
                print(f"La disciplina '{disciplina}' no existe.")
                option = input(f"¿Desea agregar '{disciplina}' como una nueva disciplina? (s/n): ").lower()
                if option == 's':
                    fecha_inclusion = input("Ingrese la fecha de inclusión (YYYY-MM-DD): ")
                    id = get_next_id(db, 'disciplinas')
                    db.add_record('disciplinas', [id, disciplina, fecha_inclusion])
                    print(f"Disciplina '{disciplina}' añadida exitosamente.")
                else:
                    all_valid = False
                    print(f"Por favor, ingrese disciplinas válidas o agregue las que falten.")
        if all_valid:
            valid_disciplines = [disciplina.strip() for disciplina in disciplinas]
            break
    return ",".join(valid_disciplines)


def normalize_string(s):
    """Normaliza una cadena de texto para comparaciones de texto sin distinción de mayúsculas y minúsculas.
    
    Args:
        s (str): Cadena de texto a normalizar.
        
    Returns:
        str: Cadena de texto normalizada.
    """
    return ''.join(
        c for c in unicodedata.normalize('NFD', s.lower())
        if unicodedata.category(c) != 'Mn'
    )

def main_menu():
    """Menú principal del sistema.
    
    Muestra las opciones disponibles y permite al usuario seleccionar una de ellas.
    """
    db = OlympicDatabase()
    while True:
        print("\n--- Menú Principal ---")
        print("1. Agregar atleta")
        print("2. Agregar entrenador")
        print("3. Agregar disciplina")
        print("4. Consultar registro")
        print("5. Editar registro")
        print("6. Eliminar registro")
        print("7. Mostrar todas las disciplinas")
        print("8. Salir")
        
        choice = validate_number("Seleccione una opción: ")
        
        if choice == 1:
            id = get_next_id(db, 'atletas')  
            nombre = input("Ingrese el nombre del atleta: ")
            apellido_paterno = input("Ingrese el apellido paterno del atleta: ")
            apellido_materno = input("Ingrese el apellido materno del atleta: ")
            sexo = select_sex()
            edad = validate_number("Ingrese la edad del atleta: ")
            show_disciplines(db)
            disciplinas = input_disciplines(db)
            db.add_record('atletas', [id, nombre, apellido_paterno, apellido_materno, sexo, edad, disciplinas])

        elif choice == 2:
            id = get_next_id(db, 'entrenadores') 
            nombre = input("Ingrese el nombre del entrenador: ")
            apellido_paterno = input("Ingrese el apellido paterno del entrenador: ")
            apellido_materno = input("Ingrese el apellido materno del entrenador: ")
            sexo = select_sex()
            edad = validate_number("Ingrese la edad del entrenador: ")
            show_disciplines(db)
            disciplinas = input_disciplines(db)
            db.add_record('entrenadores', [id, nombre, apellido_paterno, apellido_materno, sexo, edad, disciplinas])


        elif choice == 3:
            id = get_next_id(db, 'disciplinas')
            print(f"ID asignado a la disciplina: {id}")
            while True:
                nombre = input("Ingrese el nombre de la disciplina: ")
                if not discipline_exists(db, nombre):
                    break
                print(f"La disciplina '{nombre}' ya existe. Por favor, ingrese otra.")
            fecha_inclusion = input("Ingrese la fecha de inclusión (YYYY-MM-DD): ")
            db.add_record('disciplinas', [id, nombre, fecha_inclusion])

        elif choice == 4:
            consult_record_menu(db)

        elif choice == 5:
            entity = select_entity()
            id = input("Ingrese el ID a editar: ")
            if entity == 'atletas':
                nombre = input("Ingrese el nuevo nombre del atleta: ")
                apellido_paterno = input("Ingrese el nuevo apellido paterno del atleta: ")
                apellido_materno = input("Ingrese el nuevo apellido materno del atleta: ")
                sexo = select_sex()
                edad = validate_number("Ingrese la nueva edad del atleta: ")
                show_disciplines(db)
                disciplinas = input("Ingrese las nuevas disciplinas del atleta (separadas por coma): ")
                db.update_record(entity, id, [nombre, apellido_paterno, apellido_materno, sexo, edad, disciplinas])

            elif entity == 'entrenadores':
                nombre = input("Ingrese el nuevo nombre del entrenador: ")
                apellido_paterno = input("Ingrese el nuevo apellido paterno del entrenador: ")
                apellido_materno = input("Ingrese el nuevo apellido materno del entrenador: ")
                sexo = select_sex()
                edad = validate_number("Ingrese la nueva edad del entrenador: ")
                show_disciplines(db)
                disciplinas = input("Ingrese las nuevas disciplinas del entrenador (separadas por coma): ")
                db.update_record(entity, id, [nombre, apellido_paterno, apellido_materno, sexo, edad, disciplinas])

            elif entity == 'disciplinas':
                nombre = input("Ingrese el nuevo nombre de la disciplina: ")
                fecha_inclusion = input("Ingrese la nueva fecha de inclusión (YYYY-MM-DD): ")
                db.update_record(entity, id, [nombre, fecha_inclusion])

        elif choice == 6:
            entity = select_entity()
            id = input("Ingrese el ID a eliminar: ")
            db.delete_record(entity, id)

        elif choice == 7:
            show_disciplines(db)

        elif choice == 8:
            print("Gracias por usar el sistema. ¡Hasta luego!")
            break

        else:
            print("Opción no válida. Por favor, intente de nuevo.")

if __name__ == "__main__":
    main_menu()
