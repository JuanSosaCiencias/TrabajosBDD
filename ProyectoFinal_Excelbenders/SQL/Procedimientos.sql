-- ========= PROCEDIMIENTO: REGISTRAR PARTICIPACIÓN =========
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

