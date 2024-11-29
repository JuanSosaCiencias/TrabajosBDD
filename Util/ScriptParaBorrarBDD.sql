-- Ejecutar desde aqui para borrar datos
SET session_replication_role = 'replica';

DO $$
BEGIN
    EXECUTE (
        SELECT string_agg('TRUNCATE TABLE ' || tablename || ' CASCADE;', ' ')
        FROM pg_tables
        WHERE schemaname = 'public'
    );
END;
$$;

SET session_replication_role = 'origin';
-- Hasta aca termina borrar datos


-- Eliminar los triggers
DO $$ 
DECLARE
    trigger_record RECORD;
BEGIN
    FOR trigger_record IN 
        SELECT trigger_name, event_object_table
        FROM information_schema.triggers
    LOOP
        EXECUTE format('DROP TRIGGER IF EXISTS %I ON %I;', 
                       trigger_record.trigger_name, 
                       trigger_record.event_object_table);
    END LOOP;
END $$;

-- Eliminar funciones 
DO $$ 
DECLARE
    function_record RECORD;
BEGIN
    FOR function_record IN 
        SELECT proname, oid::regprocedure::text AS signature
        FROM pg_proc
        WHERE pronamespace = 'public'::regnamespace
    LOOP
        EXECUTE format('DROP FUNCTION IF EXISTS %s;', function_record.signature);
    END LOOP;
END $$;

-- Ejecutar desde aqui hasta abajo para quitar las tablas
DO $$ 
BEGIN
    -- Genera y ejecuta comandos para eliminar todas las tablas en el esquema público
    EXECUTE (
        SELECT string_agg('DROP TABLE IF EXISTS ' || tablename || ' CASCADE;', ' ')
        FROM pg_tables
        WHERE schemaname = 'public'
    );
END;
$$;