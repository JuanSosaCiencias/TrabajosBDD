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
