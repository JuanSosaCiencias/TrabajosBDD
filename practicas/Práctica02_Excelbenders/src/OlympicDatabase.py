# OlympicDatabase.py

import csv
import os
import unicodedata # Para normalizar texto
from validators import mostrar_disciplinas

class BaseDeDatosOlimpica:
    """Clase para manejar la base de datos de atletas, entrenadores y disciplinas olímpicas.
    
    Attributes:
        entidades (dict): Rutas de los archivos CSV de las entidades.
        ruta_datos (str): Ruta de la carpeta de datos.
        
    Methods:
        id_existe(entidad, id): Verifica si un ID ya está en uso en la base de datos.
        agregar_registro(entidad, registro): Añade un registro a la base de datos.
        obtener_registro(entidad, id): Obtiene un registro de la base de datos.
        actualizar_registro(entidad, id, nuevos_datos): Actualiza un registro en la base de datos.
        eliminar_registro(entidad, id): Elimina un registro de la base de datos.
        obtener_todas_las_disciplinas(): Obtiene todas las disciplinas registradas en la base de datos.

    Ejemplos de uso: 
        db = BaseDeDatosOlimpica()
        db.id_existe('atletas', '1')
        db.agregar_registro('atletas', ['1', 'Juan Pérez', 'Masculino', '25', '1,2'])
        db.eliminar_registro('atletas', '1')
        db.obtener_todas_las_disciplinas() 
    """

    def __init__(self):
        """Inicializa la base de datos y las rutas de los archivos CSV.
        
        Args:
            None
            
        Returns:
            None
        """
        # Definimos la ruta de la carpeta de datos
        self.ruta_datos = 'data'

        # Se crea la carpeta si no existe
        os.makedirs(self.ruta_datos, exist_ok=True)

        # Se definen las rutas de los archivos CSV
        self.entidades = {
            'atletas': os.path.join(self.ruta_datos, 'atletas.csv'),
            'entrenadores': os.path.join(self.ruta_datos, 'entrenadores.csv'),
            'disciplinas': os.path.join(self.ruta_datos, 'disciplinas.csv')
        }

    def id_existe(self, entidad, id):
        """Verifica si un ID ya está en uso en la base de datos.
        
        Args:
            entidades (str): Nombre de la entidad a la que pertenece el ID.
            id (str): ID a verificar.
            
        Returns:
            bool: True si el ID ya está en uso, False en caso contrario.
        """
        if not os.path.exists(self.entidades[entidad]):
            return False
        with open(self.entidades[entidad], 'r') as f:
            lector = csv.reader(f)
            return any(fila[0] == id for fila in lector)

    def agregar_registro(self, entidad, registro):
        """Añade un registro a la base de datos.
        
        Args:
            entidades (str): Nombre de la entidad a la que pertenece el registro.
            record (list): Lista con los datos del registro a añadir.
            
        Returns:
            None
        """
        with open(self.entidades[entidad], 'a', newline='') as f:
            escritor = csv.writer(f)
            escritor.writerow(registro)
        print(f"Registro añadido a {entidad} exitosamente.")

    def obtener_registro(self, entidad, id):
        """Obtiene un registro de la base de datos.
        
        Args:
            entidades (str): Nombre de la entidad a la que pertenece el registro.
            id (str): ID del registro a obtener.
            
        Returns:
            list: Lista con los datos del registro, o None si no se encontró el registro.
        """
        if not os.path.exists(self.entidades[entidad]):
            print(f"No hay registros en {entidad}.")
            return None
        with open(self.entidades[entidad], 'r') as f:
            lector = csv.reader(f)
            for fila in lector:
                if fila[0] == id:
                    return fila
        print(f"No se encontró el registro con ID {id} en {entidad}.")
        return None

    def actualizar_registro(self, entidad, id, nuevos_datos):
        """Actualiza un registro en la base de datos.
        
        Args:
            entidades (str): Nombre de la entidad a la que pertenece el registro.
            id (str): ID del registro a actualizar.
            new_data (list): Lista con los nuevos datos del registro.
            
        Returns:
            None
        """
        if not os.path.exists(self.entidades[entidad]):
            print(f"No hay registros en {entidad} para actualizar.")
            return
        filas = []
        actualizado = False
        with open(self.entidades[entidad], 'r') as f:
            lector = csv.reader(f)
            for fila in lector:
                if fila[0] == id:
                    fila = [id] + nuevos_datos
                    actualizado = True
                filas.append(fila)
        
        if actualizado:
            with open(self.entidades[entidad], 'w', newline='') as f:
                escritor = csv.writer(f)
                escritor.writerows(filas)
            print(f"Registro actualizado en {entidad} exitosamente.")
        else:
            print(f"No se encontró el registro con ID {id} en {entidad}.")

    def eliminar_registro(self, entidad, id):
        """Elimina un registro de la base de datos.
        
        Args:
            entidades (str): Nombre de la entidad a la que pertenece el registro.
            id (str): ID del registro a eliminar.
            
        Returns:
            None
        """
        if not os.path.exists(self.entidades[entidad]):
            print(f"No hay registros en {entidad} para eliminar.")
            return
        filas = []
        eliminado = False
        with open(self.entidades[entidad], 'r') as f:
            lector = csv.reader(f)
            for fila in lector:
                if fila[0] != id:
                    filas.append(fila)
                else:
                    eliminado = True
        
        if eliminado:
            with open(self.entidades[entidad], 'w', newline='') as f:
                escritor = csv.writer(f)
                escritor.writerows(filas)
            print(f"Registro eliminado de {entidad} exitosamente.")
        else:
            print(f"No se encontró el registro con ID {id} en {entidad}.")

    def obtener_todas_las_disciplinas(self):
        """Obtiene todas las disciplinas registradas en la base de datos.

        Args:
            None
        
        Returns:
            list: Lista de disciplinas, donde cada disciplina es una lista con los campos ID, Nombre y Fecha de inclusión.
        """
        disciplinas = []
        if os.path.exists(self.entidades['disciplinas']):
            with open(self.entidades['disciplinas'], 'r') as f:
                lector = csv.reader(f)
                disciplinas = [fila for fila in lector]
        return disciplinas

def conseguir_siguiente_id(db, entidad):
    """Obtiene el siguiente ID disponible para una entidad en la base de datos.
    
    Args:
        db (OlympicDatabase): Instancia de la base de datos.
        entidad (str): Nombre de la entidad para la que se desea obtener el siguiente ID.
        
    Returns:
        int: Siguiente ID disponible.
    """
    try:
        if not os.path.exists(db.entidades[entidad]):
            return 1
        with open(db.entidades[entidad], 'r') as f:
            reader = csv.reader(f)
            ids = [int(row[0]) for row in reader if len(row) > 0 and row[0].isdigit()]
            return max(ids) + 1 if ids else 1
    except Exception as e:
        print(f"Error al obtener el siguiente ID: {e}")
        return 1

def disciplina_existe(db, discipline_name):
    """Verifica si una disciplina existe en la base de datos.
    
    Args:
        db (OlympicDatabase): Instancia de la base de datos.
        discipline_name (str): Nombre de la disciplina a buscar.

    Returns:
        bool: True si la disciplina existe, False en caso contrario.
    """
    normalized_name = normalize_string(discipline_name)
    if not os.path.exists(db.entidades['disciplinas']):
        return False
    with open(db.entidades['disciplinas'], 'r') as f:
        reader = csv.reader(f)
        for row in reader:
            if normalize_string(row[1]) == normalized_name:
                return True
    return False

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


def ingresar_disciplinas(db):
    """Solicita al usuario ingresar las disciplinas de un atleta o entrenador.

    Args:
        db (OlympicDatabase): Instancia de la base de datos.

    Returns:
        str: Disciplinas ingresadas por el usuario.
    """
    valid_disciplines = []
    mostrar_disciplinas(db)  # Mostrar las disciplinas disponibles
    while True:
        disciplinas = input("Ingrese las disciplinas (separadas por coma): ").split(',')
        all_valid = True
        for disciplina in disciplinas:
            disciplina = disciplina.strip()
            if not disciplina_existe(db, disciplina):
                print(f"La disciplina '{disciplina}' no existe.")
                option = input(f"¿Desea agregar '{disciplina}' como una nueva disciplina? (s/n): ").lower()
                if option == 's':
                    fecha_inclusion = input("Ingrese la fecha de inclusión (YYYY-MM-DD): ")
                    id = conseguir_siguiente_id(db, 'disciplinas')
                    db.agregar_registro('disciplinas', [id, disciplina, fecha_inclusion])
                    print(f"Disciplina '{disciplina}' añadida exitosamente.")
                else:
                    all_valid = False
                    print(f"Por favor, ingrese disciplinas válidas o agregue las que falten.")
        if all_valid:
            valid_disciplines = [disciplina.strip() for disciplina in disciplinas]
            break
    return ",".join(valid_disciplines)