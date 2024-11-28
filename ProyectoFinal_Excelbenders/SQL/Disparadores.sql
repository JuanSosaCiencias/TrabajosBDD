CREATE OR REPLACE FUNCTION verificar_edad_atleta()
RETURNS TRIGGER AS $$
BEGIN
    IF (EXTRACT(YEAR FROM AGE(CURRENT_DATE, NEW.FechaNacimiento)) < 18) THEN
        RAISE EXCEPTION 'El atleta debe tener al menos 18 años de edad';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_verificar_edad_atleta
BEFORE INSERT OR UPDATE ON Atleta
FOR EACH ROW
EXECUTE FUNCTION verificar_edad_atleta();

CREATE OR REPLACE FUNCTION registrar_medallas()
RETURNS TRIGGER AS $$
BEGIN
    -- Verificar si el evento está en su fase final (fase 3)
    IF NEW.Fase = 3 AND OLD.Fase != 3 THEN
        -- Verificar si ya existen medallas para este evento
        IF EXISTS (
            SELECT 1 FROM Medalla 
            WHERE IDDisciplina = NEW.IDDisciplina
            AND TipoMedalla IN ('Oro', 'Plata', 'Bronce')
        ) THEN
            RAISE EXCEPTION 'Ya se han registrado medallas para esta disciplina en este evento';
        END IF;

        -- Insertar medalla de oro
        INSERT INTO Medalla (TipoMedalla, IDDisciplina, IDAtleta)
        SELECT 'Oro', NEW.IDDisciplina, IDAtleta
        FROM Concursa
        WHERE IDEvento = NEW.IDEvento
        AND NOT EXISTS (
            SELECT 1 FROM Medalla m 
            WHERE m.IDDisciplina = NEW.IDDisciplina 
            AND m.IDAtleta = Concursa.IDAtleta
        )
        LIMIT 1;

        -- Insertar medalla de plata
        INSERT INTO Medalla (TipoMedalla, IDDisciplina, IDAtleta)
        SELECT 'Plata', NEW.IDDisciplina, IDAtleta
        FROM Concursa
        WHERE IDEvento = NEW.IDEvento
        AND IDAtleta NOT IN (
            SELECT IDAtleta 
            FROM Medalla 
            WHERE IDDisciplina = NEW.IDDisciplina
        )
        LIMIT 1;

        -- Insertar medalla de bronce
        INSERT INTO Medalla (TipoMedalla, IDDisciplina, IDAtleta)
        SELECT 'Bronce', NEW.IDDisciplina, IDAtleta
        FROM Concursa
        WHERE IDEvento = NEW.IDEvento
        AND IDAtleta NOT IN (
            SELECT IDAtleta 
            FROM Medalla 
            WHERE IDDisciplina = NEW.IDDisciplina
        )
        LIMIT 1;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_registrar_medallas
AFTER UPDATE ON Evento
FOR EACH ROW
EXECUTE FUNCTION registrar_medallas();


-- Primero creamos una tabla para el registro de cambios de aforo
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
/* gestión de aforo en los eventos, verificando múltiples condiciones y manteniendo un 
** registro de cambios. Este trigger se activará cuando se inserten o actualicen registros en la tabla
** CompraEntrada */

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
    v_limite_anticipacion INT := 80; -- días máximos de anticipación permitidos
BEGIN
    -- Obtener información del evento y localidad
    SELECT e.Precio, e.FechaEvento, e.NombreLocalidad, l.Aforo, l.Tipo
    INTO v_precio_evento, v_fecha_evento, v_nombre_localidad, v_aforo_total, v_tipo_localidad
    FROM Evento e
    JOIN Localidad l ON e.NombreLocalidad = l.NombreLocalidad
    WHERE e.IDEvento = NEW.IDEvento;

    -- Verificar si el evento existe
    IF NOT FOUND THEN
        RAISE EXCEPTION 'El evento con ID % no existe', NEW.IDEvento;
    END IF;

    -- Verificar si la fecha del evento ya pasó
    IF v_fecha_evento < CURRENT_DATE THEN
        RAISE EXCEPTION 'No se pueden vender entradas para eventos pasados';
    END IF;

    -- Verificar si la compra se realiza con demasiada anticipación
    IF (v_fecha_evento - CURRENT_DATE) > v_limite_anticipacion THEN
        RAISE EXCEPTION 'No se pueden comprar entradas con más de % días de anticipación', v_limite_anticipacion;
    END IF;

    -- Calcular entradas vendidas y aforo disponible
    SELECT COUNT(*)
    INTO v_entradas_vendidas
    FROM CompraEntrada
    WHERE IDEvento = NEW.IDEvento;

    v_aforo_disponible := v_aforo_total - v_entradas_vendidas;

    -- Verificar si hay espacio disponible
    IF v_aforo_disponible <= 0 THEN
        RAISE EXCEPTION 'El evento está agotado. Aforo total: %, Entradas vendidas: %', 
            v_aforo_total, v_entradas_vendidas;
    END IF;

    -- Verificar límite de compras por cliente
    IF TG_OP = 'INSERT' THEN
        IF (
            SELECT COUNT(*)
            FROM CompraEntrada
            WHERE IDEvento = NEW.IDEvento AND IDCliente = NEW.IDCliente
        ) >= 4 THEN
            RAISE EXCEPTION 'Un cliente no puede comprar más de 4 entradas para el mismo evento';
        END IF;
    END IF;

    -- Registrar la operación en el log
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

    -- Si todo está bien, permitir la operación
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear el trigger
CREATE TRIGGER trigger_gestionar_aforo
BEFORE INSERT OR UPDATE ON CompraEntrada
FOR EACH ROW
EXECUTE FUNCTION gestionar_aforo();
