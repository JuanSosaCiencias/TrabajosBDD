-- Configuración de triggers para la gestión de eventos deportivos

-- ========= LIMPIEZA INICIAL =========
-- Eliminar triggers y funciones existentes si existen (para evitar conflictos)
DROP TRIGGER IF EXISTS trigger_verificar_edad_atleta ON Atleta;
DROP TRIGGER IF EXISTS trg_validar_medalla ON Medalla;
DROP TRIGGER IF EXISTS trigger_gestionar_aforo ON CompraEntrada;
DROP TRIGGER IF EXISTS trigger_verificar_disciplina_concursa ON Concursa;

DROP FUNCTION IF EXISTS verificar_edad_atleta();
DROP FUNCTION IF EXISTS validar_medalla();
DROP FUNCTION IF EXISTS gestionar_aforo();
DROP FUNCTION IF EXISTS verificar_disciplina_concursa();

-- ========= TABLA DE REGISTRO DE AFORO =========
-- Tabla auxiliar para mantener un registro de historial de cambios en el aforo. Se crea especialmente para el trigger 3
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
COMMENT ON TABLE RegistroAforo IS 'Tabla que almacena el historial de cambios en el aforo de eventos';
COMMENT ON COLUMN RegistroAforo.ID_Registro IS 'Identificador único del registro de aforo';
COMMENT ON COLUMN RegistroAforo.ID_Evento IS 'Identificador del evento relacionado';
COMMENT ON COLUMN RegistroAforo.Fecha_Registro IS 'Fecha y hora del registro';
COMMENT ON COLUMN RegistroAforo.Aforo_Total IS 'Capacidad total del evento';
COMMENT ON COLUMN RegistroAforo.Aforo_Disponible IS 'Lugares disponibles al momento del registro';
COMMENT ON COLUMN RegistroAforo.Tipo_Operacion IS 'Tipo de operación realizada (INSERT/UPDATE)';
COMMENT ON COLUMN RegistroAforo.Usuario IS 'Usuario que realizó la operación';
COMMENT ON COLUMN RegistroAforo.Detalle IS 'Descripción detallada del registro';

-- ========= TRIGGER 1: VERIFICACIÓN DE EDAD =========
/*
Propósito: Asegurar que los atletas registrados tengan al menos 10 años
Tabla objetivo: Atleta
Momento: BEFORE INSERT OR UPDATE
*/
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

COMMENT ON FUNCTION verificar_edad_atleta() IS 'Función que verifica que los atletas tengan al menos 10 años de edad';
COMMENT ON TRIGGER trigger_verificar_edad_atleta ON Atleta IS 'Trigger que se ejecuta antes de insertar o actualizar un atleta para verificar su edad';

-- Probamos el trigger 1
-- Permitida:
--insert into Atleta (IDAtleta, NombrePais, IDEntrenador, Temporada, Nombre, PrimerApellido, SegundoApellido, FechaNacimiento, Nacionalidad, Genero) values (1001, 'Bahamas', 48, 2022, 'Jed', 'Leathard', 'Somerfield', '2005-10-19', 'Emiratí', 'F');
-- No permitida:
--insert into Atleta (IDAtleta, NombrePais, IDEntrenador, Temporada, Nombre, PrimerApellido, SegundoApellido, FechaNacimiento, Nacionalidad, Genero) values (1002, 'Bahamas', 48, 2022, 'Jed', 'Leathard', 'Somerfield', '2023-10-19', 'Emiratí', 'F');


-- ========= TRIGGER 2: VALIDACIÓN DE MEDALLAS =========
/*
Propósito: Garantizar la integridad en la asignación de medallas:
- Evitar duplicados de medallas por atleta en una disciplina
- Verificar participación del atleta en la disciplina
- Controlar medallas únicas en disciplinas individuales
Tabla objetivo: Medalla
Momento: BEFORE INSERT OR UPDATE
*/
CREATE OR REPLACE FUNCTION validar_medalla()
RETURNS TRIGGER AS $$
	BEGIN
	    -- Verificar que el atleta no tenga ya una medalla en la misma disciplina
	    IF EXISTS (
	        SELECT 1
	        FROM Medalla
	        WHERE IDAtleta = NEW.IDAtleta
	          AND IDDisciplina = NEW.IDDisciplina
	    ) THEN
	        RAISE EXCEPTION 'El atleta ya tiene una medalla en esta disciplina.';
	    END IF;
	
	    -- Verificar que el atleta concursa en la disciplina
	    IF NOT EXISTS (
	        SELECT 1
	        FROM Participa
	        WHERE IDAtleta = NEW.IDAtleta
	          AND IDDisciplina = NEW.IDDisciplina
	    ) THEN
	        RAISE EXCEPTION 'El atleta no participa en esta disciplina.';
	    END IF;
	
	    -- Verificar si la disciplina es individual
	    IF EXISTS (
	        SELECT 1
	        FROM Disciplina
	        WHERE IDDisciplina = NEW.IDDisciplina
	          AND Categoria = 'Individual'
	    ) THEN
	        -- Asegurarse de que solo haya una medalla de cada tipo en disciplinas individuales
	        IF EXISTS (
	            SELECT 1
	            FROM Medalla
	            WHERE IDDisciplina = NEW.IDDisciplina
	              AND TipoMedalla = NEW.TipoMedalla
	        ) THEN
	            RAISE EXCEPTION 'Ya existe una medalla % en esta disciplina individual.', NEW.TipoMedalla;
	        END IF;
	    END IF;
	
	    RETURN NEW;
	END;
	$$ LANGUAGE plpgsql;

-- Crear el trigger
CREATE TRIGGER trg_validar_medalla
BEFORE INSERT OR UPDATE ON Medalla
FOR EACH ROW
EXECUTE FUNCTION validar_medalla();

COMMENT ON FUNCTION validar_medalla() IS 'Función que valida las reglas de asignación de medallas: no duplicados, participación en disciplina y control de medallas individuales';
COMMENT ON TRIGGER trg_validar_medalla ON Medalla IS 'Trigger que se ejecuta antes de insertar o actualizar una medalla para validar su asignación';

-- Probamos el trigger 2

-- insert into Pais (NombrePais) values ('PaisPrueba');
-- insert into Disciplina (IDDisciplina, NombreDisciplina, Categoria) values (1000, 'DisciplinaPrueba', 'Duos');
-- insert into Entrenador (IDEntrenador, IDDisciplina, Nombre, PrimerApellido, SegundoApellido, FechaNacimiento, Nacionalidad, Genero) values (1000, 1000, 'EntrenadorPrueba', '6969', '6969', '1989-05-24', 'PaisPrueba', 'M');
-- insert into Atleta (IDAtleta, NombrePais, IDEntrenador, Temporada, Nombre, PrimerApellido, SegundoApellido, FechaNacimiento, Nacionalidad, Genero) values 
-- 	(1000, 'PaisPrueba', 1000, 2024, 'Jada', 'Clere', 'Bodicam', '2007-11-02', 'PaisPrueba', 'M'),
-- 	(1001, 'PaisPrueba', 1000, 2024, 'Jada', 'Clere', 'Bodicam', '2007-11-02', 'PaisPrueba', 'M');
-- insert into Participa (IDAtleta, IDDisciplina) values (1000, 1000), (1001, 1000);
-- insert into Medalla (TipoMedalla, IDDisciplina, IDAtleta) values ('Oro', 1000,1000), ('Oro', 1000,1001);

-- Lanza mensaje de error:
-- insert into Medalla (TipoMedalla, IDDisciplina, IDAtleta) values ('Plata', 1000,1000);


-- ========= TRIGGER 3: GESTIÓN DE AFORO =========
/*
Propósito: Controlar la venta de entradas:
- Verificar disponibilidad de aforo
- Evitar ventas para eventos pasados
- Limitar cantidad de entradas por cliente
- Registrar historial de ventas
Tabla objetivo: CompraEntrada
Momento: BEFORE INSERT OR UPDATE
*/
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

COMMENT ON FUNCTION gestionar_aforo() IS 'Función que controla la venta de entradas, verificando aforo, fechas y límites por cliente';
COMMENT ON TRIGGER trigger_gestionar_aforo ON CompraEntrada IS 'Trigger que se ejecuta antes de insertar o actualizar una compra de entrada para gestionar el aforo';

-- Probamos el trigger 3
-- insert into Disciplina (IDDisciplina, NombreDisciplina, Categoria) values 
-- 	(1000, 'DisciplinaPrueba', 'Individual');

-- insert into Localidad (NombreLocalidad, IDDisciplina, Calle, Numero, Ciudad, Pais, Aforo, Tipo) values 
-- 	('LocalidadPrueba', 1000, 'Calle Santo Domingo', 49, 'Toronto', 'Costa de Marfil', 10, 'Parque');

-- INSERT INTO Evento (IDEvento,NombreLocalidad, IDDisciplina, DuracionMax, Precio, FechaEvento, Fase) VALUES (1000,'LocalidadPrueba', 1000, 120, 50, '2024-11-30', 1);

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

-- ========= TRIGGER 4: VALIDACIÓN DE CONCURSA =========
/*
Propósito: Asegurar que los atletas solo concursen en eventos 
de disciplinas en las que están registrados.
Tabla objetivo: Concursa
Momento: BEFORE INSERT OR UPDATE
*/
CREATE OR REPLACE FUNCTION verificar_disciplina_concursa()
RETURNS TRIGGER AS $$
	BEGIN
	    -- Verificar si el atleta participa en la disciplina del evento
	    IF NOT EXISTS (
	        SELECT 1
	        FROM Participa p
	        INNER JOIN Evento e
	        ON p.IDDisciplina = e.IDDisciplina
	        WHERE p.IDAtleta = NEW.IDAtleta
	          AND e.IDEvento = NEW.IDEvento
	    ) THEN
	        RAISE EXCEPTION 'La combinación de atleta y evento no es válida: el atleta no participa en la disciplina del evento.';
	    END IF;
	
	    -- Si pasa la validación, permitir la operación
	    RETURN NEW;
	END;
	$$ LANGUAGE plpgsql;

-- Crear el trigger que llama a la función en inserciones o actualizaciones
CREATE TRIGGER trigger_verificar_disciplina_concursa
BEFORE INSERT OR UPDATE ON Concursa
FOR EACH ROW
EXECUTE FUNCTION verificar_disciplina_concursa();

COMMENT ON FUNCTION verificar_disciplina_concursa() IS 'Función que verifica que los atletas solo concursen en eventos de disciplinas en las que están registrados';
COMMENT ON TRIGGER trigger_verificar_disciplina_concursa ON Concursa IS 'Trigger que se ejecuta antes de insertar o actualizar un registro en Concursa para validar la participación del atleta';

-- probamos el trigger 4
-- insert into Pais (NombrePais) values ('PaisPrueba');

-- insert into Disciplina (IDDisciplina, NombreDisciplina, Categoria) values 
-- 	(1000, 'DisciplinaPrueba', 'Duos'), (1001, 'DisciplinaPrueba', 'Duos');
   
-- insert into Entrenador (IDEntrenador, IDDisciplina, Nombre, PrimerApellido, SegundoApellido, FechaNacimiento, Nacionalidad, Genero) values  
-- 	(1000, 1000, 'EntrenadorPrueba', '6969', '6969', '1989-05-24', 'PaisPrueba', 'M');
   
--  insert into Atleta (IDAtleta, NombrePais, IDEntrenador, Temporada, Nombre, PrimerApellido, SegundoApellido, FechaNacimiento, Nacionalidad, Genero) values 
--  	(1000, 'PaisPrueba', 1000, 2024, 'Jada', 'Clere', 'Bodicam', '2007-11-02', 'PaisPrueba', 'M');

-- insert into Participa (IDAtleta, IDDisciplina) values (1000, 1000);

-- insert into Localidad (NombreLocalidad, IDDisciplina, Calle, Numero, Ciudad, Pais, Aforo, Tipo) values 
-- 	('LocalidadPrueba', 1000, 'Calle Santo Domingo', 49, 'Toronto', 'Costa de Marfil', 10, 'Parque');

--  INSERT INTO Evento (IDEvento,NombreLocalidad, IDDisciplina, DuracionMax, Precio, FechaEvento, Fase) VALUES 
--      (1000,'LocalidadPrueba', 1000, 120, 50, '2025-11-30', 1);
 
-- insert into concursa (IDAtleta, IDEvento) values
-- 	(1000, 1000);

-- Este trigger fue el que me hizo darme cuenta de la utilidad, podemos checar la condicion super eficientemente; tuve que hacer un codigo en python para verificar que los inserts que ya teniamos lo cumplieran y estuvo bien feo al final tuve que crear nuevos inserts concursa porque habia como 10 que cumplian la condicion.


-- Mensaje de confirmación
DO $$
BEGIN
    RAISE NOTICE 'Configuración de triggers completada exitosamente.';
END $$;
