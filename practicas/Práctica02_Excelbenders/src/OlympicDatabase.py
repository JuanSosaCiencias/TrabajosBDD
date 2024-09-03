# OlympicDatabase.py

import csv
import os

class BaseDeDatosOlimpica:
    def __init__(self):
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
        """Verifica si un ID existe en la entidad especificada."""
        if not os.path.exists(self.entidades[entidad]):
            return False
        with open(self.entidades[entidad], 'r') as f:
            lector = csv.reader(f)
            return any(fila[0] == id for fila in lector)

    def agregar_registro(self, entidad, registro):
        """Agrega un nuevo registro a la entidad especificada."""
        with open(self.entidades[entidad], 'a', newline='') as f:
            escritor = csv.writer(f)
            escritor.writerow(registro)
        print(f"Registro añadido a {entidad} exitosamente.")

    def obtener_registro(self, entidad, id):
        """Obtiene un registro por ID de la entidad especificada."""
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
        """Actualiza un registro existente por ID en la entidad especificada."""
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
        """Elimina un registro por ID de la entidad especificada."""
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
        """Obtiene todas las disciplinas registradas."""
        disciplinas = []
        if os.path.exists(self.entidades['disciplinas']):
            with open(self.entidades['disciplinas'], 'r') as f:
                lector = csv.reader(f)
                disciplinas = [fila for fila in lector]
        return disciplinas

