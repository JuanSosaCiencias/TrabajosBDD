# CSVManager.py

import csv
import os

def leer_csv(ruta_archivo):
    """Lee un archivo CSV y devuelve su contenido como una lista de listas.
    
    Args:
        ruta_archivo (str): Ruta del archivo CSV a leer.
        
    Returns:
        list: Lista de listas, donde cada lista representa una fila del archivo CSV.
    """
    if os.path.exists(ruta_archivo):
        with open(ruta_archivo, 'r') as f:
            lector = csv.reader(f)
            return list(lector)
    return []

def escribir_csv(ruta_archivo, filas):
    """Escribe una lista de listas en un archivo CSV.
    
    Args:
        ruta_archivo (str): Ruta del archivo CSV a escribir.
        filas (list): Lista de listas, donde cada lista representa una fila del archivo CSV.
        
    Returns:
        None
    """
    with open(ruta_archivo, 'w', newline='') as f:
        escritor = csv.writer(f)
        escritor.writerows(filas)

def agregar_a_csv(ruta_archivo, fila):
    """Agrega una fila al final de un archivo CSV.
    
    Args:
        ruta_archivo (str): Ruta del archivo CSV a escribir.
        fila (list): Lista que representa una fila del archivo CSV.
        
    Returns:
        None
    """
    with open(ruta_archivo, 'a', newline='') as f:
        escritor = csv.writer(f)
        escritor.writerow(fila)

