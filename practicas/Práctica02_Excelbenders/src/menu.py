# menu.py

from OlympicDatabase import BaseDeDatosOlimpica
from validators import validar_numero, seleccionar_entidad, validar_id, seleccionar_sexo, mostrar_disciplinas, menu_consultar_registro 


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


def menu_principal():
    db = BaseDeDatosOlimpica()
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
        
        opcion = validar_numero("Seleccione una opción: ")
        
        if opcion == 1:
            id = validar_id(db, 'atletas', "Ingrese el ID del atleta: ")
            nombre = input("Ingrese el nombre del atleta: ")
            sexo = seleccionar_sexo()
            edad = validar_numero("Ingrese la edad del atleta: ")
            mostrar_disciplinas(db)
            disciplinas = input("Ingrese las disciplinas del atleta (separadas por coma): ")
            db.agregar_registro('atletas', [id, nombre, sexo, edad, disciplinas])
        elif opcion == 2:
            id = validar_id(db, 'entrenadores', "Ingrese el ID del entrenador: ")
            nombre = input("Ingrese el nombre del entrenador: ")
            sexo = seleccionar_sexo()
            edad = validar_numero("Ingrese la edad del entrenador: ")
            mostrar_disciplinas(db)
            disciplina = input("Ingrese la disciplina del entrenador: ")
            db.agregar_registro('entrenadores', [id, nombre, sexo, edad, disciplina])
        elif opcion == 3:
            id = validar_id(db, 'disciplinas', "Ingrese el ID de la disciplina: ")
            nombre = input("Ingrese el nombre de la disciplina: ")
            fecha_inclusion = input("Ingrese la fecha de inclusión (YYYY-MM-DD): ")
            db.agregar_registro('disciplinas', [id, nombre, fecha_inclusion])
        elif opcion == 4:
            menu_consultar_registro(db)
        elif opcion == 5:
            entidad = seleccionar_entidad()
            id = input("Ingrese el ID a editar: ")
            if entidad == 'atletas':
                nombre = input("Ingrese el nuevo nombre del atleta: ")
                sexo = seleccionar_sexo()
                edad = validar_numero("Ingrese la nueva edad del atleta: ")
                mostrar_disciplinas(db)
                disciplinas = input("Ingrese las nuevas disciplinas del atleta (separadas por coma): ")
                db.actualizar_registro(entidad, id, [nombre, sexo, edad, disciplinas])
            elif entidad == 'entrenadores':
                nombre = input("Ingrese el nuevo nombre del entrenador: ")
                sexo = seleccionar_sexo()
                edad = validar_numero("Ingrese la nueva edad del entrenador: ")
                mostrar_disciplinas(db)
                disciplina = input("Ingrese la nueva disciplina del entrenador: ")
                db.actualizar_registro(entidad, id, [nombre, sexo, edad, disciplina])
            elif entidad == 'disciplinas':
                nombre = input("Ingrese el nuevo nombre de la disciplina: ")
                fecha_inclusion = input("Ingrese la nueva fecha de inclusión (YYYY-MM-DD): ")
                db.actualizar_registro(entidad, id, [nombre, fecha_inclusion])
        elif opcion == 6:
            entidad = seleccionar_entidad()
            id = input("Ingrese el ID a eliminar: ")
            db.eliminar_registro(entidad, id)
        elif opcion == 7:
            mostrar_disciplinas(db)
        elif opcion == 8:
            print("Gracias por usar el sistema. ¡Hasta luego!")
            break
        else:
            print("Opción no válida. Por favor, intente de nuevo.")

if __name__ == "__main__":
    menu_principal()
