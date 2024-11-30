-- ========= PROCEDIMIENTO: REGISTRAR PARTICIPACIÓN EN EVENTO =========
/*
Propósito:
Registrar la participación de un atleta en un evento y, opcionalmente, asignar una medalla. 
El procedimiento realiza las siguientes validaciones:
1. Verifica que el evento exista y obtiene la disciplina correspondiente.
2. Asegura que el atleta esté registrado en la disciplina del evento.
3. Evita duplicados de medallas para un atleta en una misma disciplina.
4. Controla que las disciplinas individuales permitan solo una medalla por atleta.

Tabla objetivo:
- Concursa: Para registrar la participación del atleta en el evento.
- Medalla: Para registrar la asignación de una medalla al atleta.
*/


CREATE OR REPLACE PROCEDURE registrar_participacion(
    p_id_atleta INT,
    p_id_evento INT,
    p_tipo_medalla VARCHAR(10) DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_disciplina_evento INT;
    v_atleta_registrado BOOLEAN;
    v_medalla_existente BOOLEAN;
    v_disciplina_individual BOOLEAN;
BEGIN
    -- Verificar si el evento existe y obtener su disciplina
    SELECT IDDisciplina INTO v_disciplina_evento
    FROM Evento
    WHERE IDEvento = p_id_evento;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El evento con ID % no existe.', p_id_evento;
    END IF;

    -- Verificar si el atleta está registrado en la disciplina del evento
    SELECT EXISTS(
        SELECT 1
        FROM Participa
        WHERE IDAtleta = p_id_atleta
          AND IDDisciplina = v_disciplina_evento
    ) INTO v_atleta_registrado;

    IF NOT v_atleta_registrado THEN
        RAISE EXCEPTION 'El atleta con ID % no está registrado en la disciplina del evento con ID %.', 
            p_id_atleta, p_id_evento;
    END IF;

    -- Insertar la participación del atleta en el evento
    BEGIN
        INSERT INTO Concursa (IDAtleta, IDEvento)
        VALUES (p_id_atleta, p_id_evento);
        RAISE NOTICE 'Participación registrada exitosamente para el atleta con ID % en el evento con ID %.', 
            p_id_atleta, p_id_evento;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Error al registrar la participación: %', SQLERRM;
            RETURN;
    END;

    -- Validar y asignar medalla si se proporciona
    IF p_tipo_medalla IS NOT NULL THEN
        -- Verificar si el atleta ya tiene una medalla en la misma disciplina
        SELECT EXISTS(
            SELECT 1
            FROM Medalla
            WHERE IDAtleta = p_id_atleta
              AND IDDisciplina = v_disciplina_evento
        ) INTO v_medalla_existente;

        IF v_medalla_existente THEN
            RAISE EXCEPTION 'El atleta con ID % ya tiene una medalla registrada en la disciplina del evento con ID %.', 
                p_id_atleta, p_id_evento;
        END IF;

        -- Verificar si la disciplina es individual y controlar medallas únicas
        SELECT EsIndividual INTO v_disciplina_individual
        FROM Disciplina
        WHERE IDDisciplina = v_disciplina_evento;

        IF v_disciplina_individual THEN
            RAISE NOTICE 'La disciplina es individual. Solo se permite una medalla por atleta.';
        END IF;

        -- Insertar la medalla
        BEGIN
            INSERT INTO Medalla (TipoMedalla, IDDisciplina, IDAtleta)
            VALUES (p_tipo_medalla, v_disciplina_evento, p_id_atleta);
            RAISE NOTICE 'Medalla de tipo % asignada al atleta con ID % en la disciplina del evento con ID %.', 
                p_tipo_medalla, p_id_atleta, p_id_evento;
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE 'Error al asignar la medalla: %', SQLERRM;
                RETURN;
        END;
    END IF;
END;
$$;


COMMENT ON PROCEDURE registrar_participacion IS 
'Procedimiento que registra la participación de un atleta en un evento y, opcionalmente, asigna una medalla. 
Validaciones realizadas:
- Verifica que el evento exista.
- Verifica que el atleta esté registrado en la disciplina del evento.
- Evita duplicados de medallas en una misma disciplina.
- Controla que las disciplinas individuales permitan solo una medalla por atleta.

Parámetros:
- p_id_atleta: ID del atleta que se desea registrar en el evento.
- p_id_evento: ID del evento en el que se desea registrar la participación del atleta.
- p_tipo_medalla: Tipo de medalla que se desea asignar al atleta (opcional). Los valores posibles son ''Oro'', ''Plata'' o ''Bronce''. Si no se proporciona, solo se registra la participación.';


-- Pruebas
-- Registrar participación sin medalla
-- CALL registrar_participacion(1, 311);
-- Registrar participación con medalla
-- CALL registrar_participacion(65, 192, 'Oro');


-- ========= PROCEDIMIENTO: ACTUALIZAR FASE DEL EVENTO =========
/*
Este procedimiento es para cumplir el requerimiento del Caso de Uso de aumentar el precio de un evento
en 9% cada que pase una fase eliminatoria. 
Propósito:
Actualizar la fase eliminatoria de un evento y, al hacerlo, incrementar su precio en un 9%. 
El procedimiento realiza las siguientes validaciones:
1. Verifica que el evento exista en la base de datos.
2. Asegura que la fase actual del evento no sea la última (fase 3).
3. Calcula la nueva fase y el nuevo precio del evento.
4. Actualiza la tabla `Evento` con los valores calculados.

Tablas objetivo:
- Evento: Se actualizan las columnas `Fase` y `Precio` del evento.

Notificaciones:
- Utiliza RAISE NOTICE para informar del éxito de la operación.
- Genera excepciones con mensajes claros si ocurren errores durante la validación.

Parámetros:
- p_IDEvento (INT): Identificador único del evento que se desea actualizar.
*/

CREATE OR REPLACE PROCEDURE ActualizarFaseEvento(
    IN p_IDEvento INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_fase_actual INT;
    v_precio_actual INT;
    v_nueva_fase INT;
    v_nuevo_precio NUMERIC;
BEGIN
    -- Verificar que el evento existe
    SELECT Fase, Precio
    INTO v_fase_actual, v_precio_actual
    FROM Evento
    WHERE IDEvento = p_IDEvento;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El evento con ID % no existe', p_IDEvento;
    END IF;

    -- Verificar que la fase actual no sea la última (3)
    IF v_fase_actual >= 3 THEN
        RAISE EXCEPTION 'El evento con ID % ya está en la última fase (3)', p_IDEvento;
    END IF;

    -- Calcular la nueva fase y el nuevo precio
    v_nueva_fase := v_fase_actual + 1;
    v_nuevo_precio := v_precio_actual * 1.09;

    -- Actualizar la fase y el precio del evento
    UPDATE Evento
    SET Fase = v_nueva_fase,
        Precio = v_nuevo_precio
    WHERE IDEvento = p_IDEvento;

    -- Notificar los cambios realizados
    RAISE NOTICE 'El evento con ID % ha sido actualizado a la fase % y su nuevo precio es %.2f',
        p_IDEvento, v_nueva_fase, v_nuevo_precio;
END;
$$;

COMMENT ON PROCEDURE ActualizarFaseEvento IS
'Actualiza la fase de un evento incrementando su precio en un 9%. Valida que el evento exista y que no se encuentre en la última fase.';

-- Prueba 
-- CALL ActualizarFaseEvento(1);

-- ========= PROCEDIMIENTO: REGISTRAR ATLETA EN DISCIPLINA =========
/*
Propósito:
Registrar a un atleta en una disciplina específica, asegurando que no esté ya registrado en la misma.

Validaciones:
1. Verifica que la disciplina exista en la base de datos.
2. Comprueba que el atleta no esté ya registrado en la disciplina.

Tablas objetivo:
- AtletaDisciplina: Se registra la relación entre el atleta y la disciplina.

Parámetros:
- p_IDAtleta (INT): Identificador único del atleta.
- p_IDDisciplina (INT): Identificador único de la disciplina.

Notificaciones:
- Utiliza RAISE NOTICE para informar del éxito de la operación.
- Genera excepciones con mensajes claros si ocurren errores durante la validación.
*/

CREATE OR REPLACE PROCEDURE RegistrarAtletaEnDisciplina(
    IN p_IDAtleta INT,
    IN p_IDDisciplina INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Verificar que la disciplina existe
    IF NOT EXISTS (
        SELECT 1
        FROM Disciplina
        WHERE IDDisciplina = p_IDDisciplina
    ) THEN
        RAISE EXCEPTION 'La disciplina con ID % no existe', p_IDDisciplina;
    END IF;

    -- Verificar que el atleta no esté ya registrado en la disciplina
    IF EXISTS (
        SELECT 1
        FROM Participa
        WHERE IDAtleta = p_IDAtleta
          AND IDDisciplina = p_IDDisciplina
    ) THEN
        RAISE EXCEPTION 'El atleta con ID % ya está registrado en la disciplina %', p_IDAtleta, p_IDDisciplina;
    END IF;

    -- Registrar al atleta en la disciplina
    INSERT INTO Participa (IDAtleta, IDDisciplina)
    VALUES (p_IDAtleta, p_IDDisciplina);

    -- Notificar éxito
    RAISE NOTICE 'El atleta con ID % ha sido registrado en la disciplina %', p_IDAtleta, p_IDDisciplina;
END;
$$;

-- Documentación del procedimiento con COMMENT ON
COMMENT ON PROCEDURE RegistrarAtletaEnDisciplina IS
'Registra a un atleta en una disciplina específica, asegurando que no esté ya registrado. Valida la existencia de la disciplina y evita duplicados.';

-- Prueba
-- CALL RegistrarAtletaEnDisciplina(1, 88);

