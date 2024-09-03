# CSVManager.py

import csv
import os

def leer_csv(ruta_archivo):
    """Lee el contenido de un archivo CSV y devuelve las filas como una lista."""
    if os.path.exists(ruta_archivo):
        with open(ruta_archivo, 'r') as f:
            lector = csv.reader(f)
            return list(lector)
    return []

def escribir_csv(ruta_archivo, filas):
    """Escribe una lista de filas en un archivo CSV, sobrescribiendo el contenido existente."""
    with open(ruta_archivo, 'w', newline='') as f:
        escritor = csv.writer(f)
        escritor.writerows(filas)

def agregar_a_csv(ruta_archivo, fila):
    """Agrega una sola fila al final de un archivo CSV existente."""
    with open(ruta_archivo, 'a', newline='') as f:
        escritor = csv.writer(f)
        escritor.writerow(fila)

