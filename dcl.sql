-- dcl.sql
DROP OWNED BY usuario_app, usuario_reportes, rol_lectura;
DROP ROLE IF EXISTS usuario_app, usuario_reportes, rol_lectura;

-- 1. Creación de Roles y Usuarios
CREATE ROLE rol_lectura;
CREATE USER usuario_app PASSWORD 'app_1234';
CREATE USER usuario_reportes PASSWORD 'rep_1234';

-- Asignar el rol al usuario de reportes
GRANT rol_lectura TO usuario_reportes;

-- 2. Permisos del Usuario de Operación (usuario_app)
-- (Se incluye 'estudiantes' para que la app pueda validar usuarios)
GRANT SELECT ON estudiantes, materias, tutores, horarios, v_horarios_detallados TO usuario_app;
GRANT SELECT, INSERT ON reservas TO usuario_app;

-- Dar permiso a la secuencia es obligatorio para poder hacer INSERT en reservas con campo SERIAL
GRANT USAGE ON SEQUENCE reservas_id_reserva_seq TO usuario_app;

-- 3. Permisos de Solo Lectura (rol_lectura / usuario_reportes)
-- Solo lee las vistas, NO las tablas base
GRANT SELECT ON v_demanda_materias, v_estudiantes_publico TO rol_lectura;



-- VERIFICCIÓN PERMISOS TABLAS Y VISTAS
SELECT grantee, table_name, privilege_type
FROM information_schema.role_table_grants
WHERE grantee IN ('usuario_app', 'usuario_reportes', 'rol_lectura')
	AND table_schema = 'public'
ORDER BY grantee, table_name;

-- VERIFICAR ROLES HEREDADOS
SELECT u.rolname AS usuario, r.rolname AS rol_heredado
FROM pg_auth_members m
JOIN pg_roles r ON m.roleid = r.oid
JOIN pg_roles u ON m.member = u.oid
WHERE u.rolname IN ('usuario_app', 'usuario_reportes');

-- PRUEBAS DE USUARIO
SET ROLE usuario_app;

-- 1 Prueba permitida (Agendar una reserva):
INSERT INTO reservas (id_estudiante, id_horario) VALUES (1, 2);

-- 2 Prueba rechazada (Intentar borrar un tutor - dará error):
DELETE FROM tutores WHERE id_tutor = 1;

-- 3 Volver al usuario original:
RESET ROLE;

-- PRUEBA USUARIO SOLO LECTURA

SET ROLE usuario_reportes;

-- 1 Prueba permitida (Ver el reporte de demanda):
SELECT * FROM v_demanda_materias;

-- 2 Prueba rechazada (Intentar leer la tabla base de estudiantes - dará error):
SELECT * FROM estudiantes;

-- 3 Volver al usuario original:
RESET ROLE;
