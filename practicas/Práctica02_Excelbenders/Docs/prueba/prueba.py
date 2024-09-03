import csv
import os

class OlympicDatabase:
    def __init__(self):
        self.entities = {
            'atletas': 'atletas.csv',
            'entrenadores': 'entrenadores.csv',
            'disciplinas': 'disciplinas.csv'
        }

    def id_exists(self, entity, id):
        if not os.path.exists(self.entities[entity]):
            return False
        with open(self.entities[entity], 'r') as f:
            reader = csv.reader(f)
            return any(row[0] == id for row in reader)

    def add_record(self, entity, record):
        with open(self.entities[entity], 'a', newline='') as f:
            writer = csv.writer(f)
            writer.writerow(record)
        print(f"Registro añadido a {entity} exitosamente.")

    def get_record(self, entity, id):
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
        disciplines = []
        if os.path.exists(self.entities['disciplinas']):
            with open(self.entities['disciplinas'], 'r') as f:
                reader = csv.reader(f)
                disciplines = [row for row in reader]
        return disciplines

def validate_number(prompt):
    while True:
        try:
            return int(input(prompt))
        except ValueError:
            print("Por favor, ingrese un número válido.")

def validate_id(db, entity, prompt):
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
    disciplines = db.get_all_disciplines()
    if disciplines:
        print("\nDisciplinas disponibles:")
        for discipline in disciplines:
            print(f"ID: {discipline[0]}, Nombre: {discipline[1]}, Fecha de inclusión: {discipline[2]}")
    else:
        print("No hay disciplinas registradas.")

def consult_record_menu(db):
    entity = select_entity()
    id = input(f"Ingrese el ID del {entity[:-1]} a consultar: ")
    record = db.get_record(entity, id)
    if record:
        print(f"\nRegistro encontrado:")
        headers = ['ID', 'Nombre', 'Sexo', 'Edad', 'Disciplinas/Disciplina'] if entity != 'disciplinas' else ['ID', 'Nombre', 'Fecha de inclusión']
        for header, value in zip(headers, record):
            print(f"{header}: {value}")

def main_menu():
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
            id = validate_id(db, 'atletas', "Ingrese el ID del atleta: ")
            nombre = input("Ingrese el nombre del atleta: ")
            sexo = select_sex()
            edad = validate_number("Ingrese la edad del atleta: ")
            show_disciplines(db)
            disciplinas = input("Ingrese las disciplinas del atleta (separadas por coma): ")
            db.add_record('atletas', [id, nombre, sexo, edad, disciplinas])
        elif choice == 2:
            id = validate_id(db, 'entrenadores', "Ingrese el ID del entrenador: ")
            nombre = input("Ingrese el nombre del entrenador: ")
            sexo = select_sex()
            edad = validate_number("Ingrese la edad del entrenador: ")
            show_disciplines(db)
            disciplina = input("Ingrese la disciplina del entrenador: ")
            db.add_record('entrenadores', [id, nombre, sexo, edad, disciplina])
        elif choice == 3:
            id = validate_id(db, 'disciplinas', "Ingrese el ID de la disciplina: ")
            nombre = input("Ingrese el nombre de la disciplina: ")
            fecha_inclusion = input("Ingrese la fecha de inclusión (YYYY-MM-DD): ")
            db.add_record('disciplinas', [id, nombre, fecha_inclusion])
        elif choice == 4:
            consult_record_menu(db)
        elif choice == 5:
            entity = select_entity()
            id = input("Ingrese el ID a editar: ")
            if entity == 'atletas':
                nombre = input("Ingrese el nuevo nombre del atleta: ")
                sexo = select_sex()
                edad = validate_number("Ingrese la nueva edad del atleta: ")
                show_disciplines(db)
                disciplinas = input("Ingrese las nuevas disciplinas del atleta (separadas por coma): ")
                db.update_record(entity, id, [nombre, sexo, edad, disciplinas])
            elif entity == 'entrenadores':
                nombre = input("Ingrese el nuevo nombre del entrenador: ")
                sexo = select_sex()
                edad = validate_number("Ingrese la nueva edad del entrenador: ")
                show_disciplines(db)
                disciplina = input("Ingrese la nueva disciplina del entrenador: ")
                db.update_record(entity, id, [nombre, sexo, edad, disciplina])
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
