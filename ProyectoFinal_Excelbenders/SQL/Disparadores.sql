-- Configuración de triggers para la gestión de eventos deportivos

-- Eliminar triggers y funciones existentes si existen (para evitar conflictos)
DROP TRIGGER IF EXISTS trigger_verificar_edad_atleta ON Atleta;
DROP TRIGGER IF EXISTS trigger_registrar_medallas ON Evento;
DROP TRIGGER IF EXISTS trigger_gestionar_aforo ON CompraEntrada;

DROP FUNCTION IF EXISTS verificar_edad_atleta();
DROP FUNCTION IF EXISTS registrar_medallas();
DROP FUNCTION IF EXISTS gestionar_aforo();

-- Crear tabla de registro si no existe. Se crea especialmente para este trigger
CREATE TABLE IF NOT EXISTS RegistroAforo (
    ID_Registro SERIAL PRIMARY KEY,
    ID_Evento INT,
    Fecha_Registro TIMESTAMP,
    Aforo_Total INT,
    Aforo_Disponible INT,
    Tipo_Operacion VARCHAR(20),
    Usuario VARCHAR(50),
    Detalle VARCHAR(200)
);

-- 1. Trigger para verificación de edad
CREATE OR REPLACE FUNCTION verificar_edad_atleta()
RETURNS TRIGGER AS $$
BEGIN
    IF (EXTRACT(YEAR FROM AGE(CURRENT_DATE, NEW.FechaNacimiento)) < 10) THEN
        RAISE EXCEPTION 'El atleta debe tener al menos 10 años de edad';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_verificar_edad_atleta
BEFORE INSERT OR UPDATE ON Atleta
FOR EACH ROW
EXECUTE FUNCTION verificar_edad_atleta();

-- Probamos el trigger 1
--insert into Atleta (IDAtleta, NombrePais, IDEntrenador, Temporada, Nombre, PrimerApellido, SegundoApellido, FechaNacimiento, Nacionalidad, Genero) values (1001, 'Bahamas', 48, 2022, 'Jed', 'Leathard', 'Somerfield', '2005-10-19', 'Emiratí', 'F');
--insert into Atleta (IDAtleta, NombrePais, IDEntrenador, Temporada, Nombre, PrimerApellido, SegundoApellido, FechaNacimiento, Nacionalidad, Genero) values (1002, 'Bahamas', 48, 2022, 'Jed', 'Leathard', 'Somerfield', '2023-10-19', 'Emiratí', 'F');


-- 2. Trigger para registro de medallas
-- CREATE OR REPLACE FUNCTION registrar_medallas()
-- RETURNS TRIGGER AS $$
-- BEGIN
--     IF NEW.Fase = 3 AND OLD.Fase != 3 THEN
--         -- Verificar si ya existen medallas para este evento
--         IF EXISTS (
--             SELECT 1 FROM Medalla 
--             WHERE IDDisciplina = NEW.IDDisciplina
--             AND TipoMedalla IN ('Oro', 'Plata', 'Bronce')
--         ) THEN
--             RAISE EXCEPTION 'Ya se han registrado medallas para esta disciplina en este evento';
--         END IF;

--         -- Insertar medalla de oro
--         INSERT INTO Medalla (TipoMedalla, IDDisciplina, IDAtleta)
--         SELECT 'Oro', NEW.IDDisciplina, IDAtleta
--         FROM Concursa
--         WHERE IDEvento = NEW.IDEvento

--         AND NOT EXISTS (
--             SELECT 1 FROM Medalla m 
--             WHERE m.IDDisciplina = NEW.IDDisciplina 
--             AND m.IDAtleta = Concursa.IDAtleta
--         )
--         LIMIT 1;

--         -- Insertar medalla de plata
--         INSERT INTO Medalla (TipoMedalla, IDDisciplina, IDAtleta)
--         SELECT 'Plata', NEW.IDDisciplina, IDAtleta
--         FROM Concursa
--         WHERE IDEvento = NEW.IDEvento
--         AND IDAtleta NOT IN (
--             SELECT IDAtleta 
--             FROM Medalla 
--             WHERE IDDisciplina = NEW.IDDisciplina
--         )
--         LIMIT 1;

--         -- Insertar medalla de bronce
--         INSERT INTO Medalla (TipoMedalla, IDDisciplina, IDAtleta)
--         SELECT 'Bronce', NEW.IDDisciplina, IDAtleta
--         FROM Concursa
--         WHERE IDEvento = NEW.IDEvento
--         AND IDAtleta NOT IN (
--             SELECT IDAtleta 
--             FROM Medalla 
--             WHERE IDDisciplina = NEW.IDDisciplina
--         )
--         LIMIT 1;
--     END IF;
--     RETURN NEW;
-- END;
-- $$ LANGUAGE plpgsql;

-- CREATE TRIGGER trigger_registrar_medallas
-- AFTER UPDATE ON Evento
-- FOR EACH ROW
-- EXECUTE FUNCTION registrar_medallas();

-- insert into Pais (NombrePais) values ('PaisPrueba');

-- insert into Disciplina (IDDisciplina, NombreDisciplina, Categoria) values 
-- 	(1000, 'DisciplinaPrueba', 'Individual');

-- insert into Localidad (NombreLocalidad, IDDisciplina, Calle, Numero, Ciudad, Pais, Aforo, Tipo) values 
-- 	('LocalidadPrueba', 1000, 'Calle Santo Domingo', 49, 'Toronto', 'Costa de Marfil', 800, 'Parque');

-- INSERT INTO Evento (IDEvento,NombreLocalidad, IDDisciplina, DuracionMax, Precio, FechaEvento, Fase)
-- VALUES 
--     (1000,'LocalidadPrueba', 1000, 120, 50, '2024-11-30', 1);
   
-- insert into Entrenador (IDEntrenador, IDDisciplina, Nombre, PrimerApellido, SegundoApellido, FechaNacimiento, Nacionalidad, Genero) values 
-- 	(1000, 1000, 'EntrenadorPrueba', '6969', '6969', '1989-05-24', 'PaisPrueba', 'M');
   
-- insert into Atleta (IDAtleta, NombrePais, IDEntrenador, Temporada, Nombre, PrimerApellido, SegundoApellido, FechaNacimiento, Nacionalidad, Genero) values 
-- 	(1000, 'PaisPrueba', 1000, 2024, 'Jada', 'Clere', 'Bodicam', '2007-11-02', 'PaisPrueba', 'M');

-- INSERT INTO Concursa (IDAtleta, IDEvento) VALUES 
-- 	(1000, 1000);

-- update  evento set Fase=3 where idevento =1000;


-- 3. Trigger para gestión de aforo
CREATE OR REPLACE FUNCTION gestionar_aforo()
RETURNS TRIGGER AS $$
DECLARE
    v_aforo_total INT;
    v_entradas_vendidas INT;
    v_aforo_disponible INT;
    v_precio_evento INT;
    v_fecha_evento DATE;
    v_nombre_localidad VARCHAR(50);
    v_tipo_localidad VARCHAR(50);
BEGIN
    -- Obtener información del evento y localidad
    SELECT e.Precio, e.FechaEvento, e.NombreLocalidad, l.Aforo, l.Tipo
    INTO v_precio_evento, v_fecha_evento, v_nombre_localidad, v_aforo_total, v_tipo_localidad
    FROM Evento e
    JOIN Localidad l ON e.NombreLocalidad = l.NombreLocalidad
    WHERE e.IDEvento = NEW.IDEvento;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El evento con ID % no existe', NEW.IDEvento;
    END IF;

    IF v_fecha_evento < CURRENT_DATE THEN
        RAISE EXCEPTION 'No se pueden vender entradas para eventos pasados';
    END IF;

    SELECT COUNT(*)
    INTO v_entradas_vendidas
    FROM CompraEntrada
    WHERE IDEvento = NEW.IDEvento;

    v_aforo_disponible := v_aforo_total - v_entradas_vendidas;

    IF v_aforo_disponible <= 0 THEN
        RAISE EXCEPTION 'El evento está agotado. Aforo total: %, Entradas vendidas: %', 
            v_aforo_total, v_entradas_vendidas;
    END IF;

    IF TG_OP = 'INSERT' THEN
        IF (
            SELECT COUNT(*)
            FROM CompraEntrada
            WHERE IDEvento = NEW.IDEvento AND IDCliente = NEW.IDCliente
        ) >= 4 THEN
            RAISE EXCEPTION 'Un cliente no puede comprar más de 4 entradas para el mismo evento';
        END IF;
    END IF;

    INSERT INTO RegistroAforo (
        ID_Evento,
        Fecha_Registro,
        Aforo_Total,
        Aforo_Disponible,
        Tipo_Operacion,
        Usuario,
        Detalle
    ) VALUES (
        NEW.IDEvento,
        CURRENT_TIMESTAMP,
        v_aforo_total,
        v_aforo_disponible - 1,
        TG_OP,
        CURRENT_USER,
        format('Cliente %s compró entrada para evento en %s. Localidad: %s (%s)', 
            NEW.IDCliente, 
            v_nombre_localidad,
            v_tipo_localidad,
            v_fecha_evento::TEXT
        )
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_gestionar_aforo
BEFORE INSERT OR UPDATE ON CompraEntrada
FOR EACH ROW
EXECUTE FUNCTION gestionar_aforo();

-- Probamos el trigger 3
-- insert into Disciplina (IDDisciplina, NombreDisciplina, Categoria) values 
-- 	(1000, 'DisciplinaPrueba', 'Individual');

-- insert into Localidad (NombreLocalidad, IDDisciplina, Calle, Numero, Ciudad, Pais, Aforo, Tipo) values 
-- 	('LocalidadPrueba', 1000, 'Calle Santo Domingo', 49, 'Toronto', 'Costa de Marfil', 10, 'Parque');

-- INSERT INTO Evento (IDEvento,NombreLocalidad, IDDisciplina, DuracionMax, Precio, FechaEvento, Fase)
-- VALUES 
--     (1000,'LocalidadPrueba', 1000, 120, 50, '2024-11-30', 1);

-- insert into cliente (idcliente) values
-- 	(1000), (1001)

-- insert into compraentrada (idcliente,idevento) values 
-- 	(1000,1000), --(1001,1000)
-- 	(1000,1000),
-- 	(1000,1000),
-- 	(1000,1000),
-- 	(1000,1000)
	
-- insert into compraentrada (idcliente,idevento) values
-- 	(1001,1000)

-- Mensaje de confirmación
DO $$
BEGIN
    RAISE NOTICE 'Configuración de triggers completada exitosamente.';
END $$;
