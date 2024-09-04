# menu.py

from OlympicDatabase import *
from validators import *

# Códigos de color para decoracion:D
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

def mostrar_disciplinas(db):
    """Muestra todas las disciplinas disponibles en la base de datos.
    
    Args:
        db (OlympicDatabase): Instancia de la base de datos.

    """
    disciplinas = db.obtener_todas_las_disciplinas()
    if disciplinas:
        print(f"\n{AZUL_CLARO}{NEGRITA}Disciplinas disponibles:{RESET}")
        for disciplina in disciplinas:
            print(f"ID: {disciplina[0]}, Nombre: {disciplina[1]}, Fecha de inclusión: {disciplina[2]}, Categoría: {disciplina[3]}, Numero de participantes: {disciplina[4]}")
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
        print(f"\n{AZUL_CLARO}Registro encontrado:{RESET}")
        cabeceras = ['ID', 'Nombre','Apellido Materno','Apellido Paterno','Nacionalidad', 'Sexo', 'Fecha de Nacimiento','Correo', 'Teléfono', 'Disciplina(s)'] if entidad != 'disciplinas' else ['ID', 'Nombre', 'Fecha de inclusión', 'Categoría', 'Participantes']
        for cabecera, valor in zip(cabeceras, registro):
            print(f"{cabecera}: {valor}")


def menu_principal():
    """Menú principal del sistema.
    
    Muestra las opciones disponibles y permite al usuario seleccionar una de ellas.
    """
    db = BaseDeDatosOlimpica()
    while True:
        print(f"{NEGRITA}{AMARILLO_CLARO}\n~~~~ Menú Principal ~~~~{RESET}")
        print(f"{NEGRITA}{NARANJA}1.{RESET} Agregar atleta")
        print(f"{NEGRITA}{AZUL}2.{RESET} Agregar entrenador")
        print(f"{NEGRITA}{MAGENTA_BRILLANTE}3.{RESET} Agregar disciplina")
        print(f"{NEGRITA}{CYAN_BRILLANTE}4.{RESET} Consultar registro")
        print(f"{NEGRITA}{VERDE}5.{RESET} Editar registro")
        print(f"{NEGRITA}{MARRON}6.{RESET} Eliminar registro")
        print(f"{NEGRITA}{CORAL}7.{RESET} Mostrar todas las disciplinas")
        print(f"{NEGRITA}{ROJO}8.{RESET} Salir")
        
        opcion = validar_numero("Seleccione una opción: ")
        
        if opcion == 1:
            id = conseguir_siguiente_id(db, 'atletas')
            print(f"{VERDE}ID asignado al atleta: {id}{RESET}")
            nombre = validar_nombre("Ingrese el nombre del atleta: ")
            apellido_paterno = validar_nombre("Ingrese el apellido paterno del atleta: ")
            apellido_materno = validar_nombre("Ingrese el apellido materno del atleta: ")
            nacionalidad= validar_nacionalidad("Ingrese la nacionalidad del atleta: ")
            sexo = seleccionar_sexo()
            fecha_nacimiento = validar_fecha("Ingrese la fecha de nacimiento del atleta (YYYY-MM-DD): ")
            correo= validar_formato_correo("Ingrese el correo del atleta: ")
            telefono= validar_numero("Ingrese el número telefónico del atleta: ")
            disciplinas = ingresar_disciplinas(db)
            db.agregar_registro('atletas', [id, nombre, apellido_paterno, apellido_materno, nacionalidad, sexo, fecha_nacimiento, correo, telefono, disciplinas])

        elif opcion == 2:
            id = conseguir_siguiente_id(db, 'entrenadores')
            print(f"{VERDE}ID asignado al entrenador: {id}{RESET}")
            nombre = validar_nombre("Ingrese el nombre del entrenador: ")
            apellido_paterno = validar_nombre("Ingrese el apellido paterno del entrenador: ")
            apellido_materno = validar_nombre("Ingrese el apellido materno del entrenador: ")
            nacionalidad= validar_nacionalidad("Ingrese la nacionalidad del entrenador: ")
            sexo = seleccionar_sexo()
            fecha_nacimiento = validar_fecha("Ingrese la fecha de nacimiento del entrenador (YYYY-MM-DD): ")
            correo= validar_formato_correo("Ingrese el correo del entrenador: ")
            telefono= validar_numero("Ingrese el número telefónico del entrenador: ")
            disciplina = ingresar_disciplinas(db)
            db.agregar_registro('entrenadores', [id, nombre, apellido_paterno, apellido_materno, nacionalidad, sexo, fecha_nacimiento, correo, telefono, disciplina])

        elif opcion == 3:
            id = conseguir_siguiente_id(db, 'disciplinas')
            print(f"ID asignado a la disciplina: {id}")
            while True:
                nombre = input("Ingrese el nombre de la disciplina: ")
                if not disciplina_existe(db, nombre):
                    break
                print(f"{ROJO}La disciplina '{nombre}' ya existe. Por favor, ingrese otra.{RESET}")
            fecha_inclusion = validar_fecha("Ingrese la fecha de inclusión (YYYY-MM-DD): ")
            categoria=input("Ingrese la categoría (individual/equipo): ")
            participantes= validar_numero("Ingrese el total de participantes (ej. 1,2,...): ")
            db.agregar_registro('disciplinas',[id, nombre,fecha_inclusion,categoria,participantes])

        elif opcion == 4:
            menu_consultar_registro(db)

        elif opcion == 5:
            entidad = seleccionar_entidad()
            id = input("Ingrese el ID a editar: ")
            if entidad == 'atletas':
                nombre = validar_nombre("Ingrese el nuevo nombre del atleta: ")
                apellido_paterno = validar_nombre("Ingrese el nuevo apellido paterno del atleta: ")
                apellido_materno = validar_nombre("Ingrese el nuevo apellido materno del atleta: ")
                sexo = seleccionar_sexo()
                fecha_nacimiento = validar_fecha("Ingrese la nueva fecha de nacimiento del entrenador (YYYY-MM-DD): ")
                correo= validar_formato_correo("Ingrese el nuevo correo del atleta: ")
                telefono= validar_numero("Ingrese el nuevo número telefónico del atleta: ")
                disciplinas = input("Ingrese las nuevas disciplinas del atleta (separadas por coma): ")
                db.actualizar_registro(entidad, id, [nombre, apellido_paterno, apellido_materno, nacionalidad, sexo, fecha_nacimiento, correo, telefono, disciplinas])
            elif entidad == 'entrenadores':
                nombre = validar_nombre("Ingrese el nuevo nombre del entrenador: ")
                apellido_paterno = validar_nombre("Ingrese el nuevo apellido paterno del entrenador: ")
                apellido_materno = validar_nombre("Ingrese el nuevo apellido materno del entrenador: ")
                sexo = seleccionar_sexo()
                fecha_nacimiento = validar_fecha("Ingrese la nueva fecha de nacimiento del entrenador (YYYY-MM-DD): ")
                correo= validar_formato_correo("Ingrese el nuevo correo del atleta: ")
                telefono= validar_numero("Ingrese el nuevo número telefónico del atleta: ")
                disciplina = input("Ingrese la nueva disciplina del entrenador: ")
                db.actualizar_registro(entidad, id, [nombre, apellido_paterno, apellido_materno, nacionalidad, sexo, fecha_nacimiento, correo, telefono, disciplina])
            elif entidad == 'disciplinas':
                nombre = validar_nombre("Ingrese el nuevo nombre de la disciplina: ")
                fecha_inclusion = validar_fecha("Ingrese la nueva fecha de inclusión (YYYY-MM-DD): ")
                categoria=input("Ingrese la nueva categoría (individual/equipos): ")
                participantes= validar_numero("Ingrese el nuevo número total de participantes (ej. 1,2,...): ")
                db.actualizar_registro(entidad, id, [nombre, fecha_inclusion, categoria, participantes])

        elif opcion == 6:
            entidad = seleccionar_entidad()
            id = input("Ingrese el ID a eliminar: ")
            db.eliminar_registro(entidad, id)

        elif opcion == 7:
            mostrar_disciplinas(db)

        elif opcion == 8:
            print(f"{VERDE}Gracias por usar el sistema. ¡Hasta luego!{RESET}")
            break

        else:
            print(f"{ROJO}Opción no válida. Por favor, intente de nuevo.{RESET}")

if __name__ == "__main__":
    menu_principal()
