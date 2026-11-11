DROP TABLE IF EXISTS recursos, reservas, horarios, tutor_materia, materias, administradores, tutores, estudiantes CASCADE;

CREATE TABLE estudiantes (
	id_estudiante SERIAL PRIMARY KEY,
	cod_institucional BIGINT NOT NULL, 
	nombre VARCHAR(100) NOT NULL,
	correo VARCHAR(100) NOT NULL, 
	contrasena VARCHAR(100) NOT NULL
);

CREATE TABLE tutores (
	id_tutor SERIAL PRIMARY KEY,
	cod_institucional BIGINT NOT NULL, 
	nombre VARCHAR(100) NOT NULL, 
	correo VARCHAR(100) NOT NULL,
	contrasena VARCHAR(100) NOT NULL
);

CREATE TABLE administradores (
	id_admin SERIAL PRIMARY KEY,
	cod_institucional BIGINT NOT NULL, 
	nombre VARCHAR(100) NOT NULL, 
	correo VARCHAR(100) NOT NULL, 
	contrasena VARCHAR(100) NOT NULL
);
	
CREATE TABLE materias (
	id_materia SERIAL PRIMARY KEY,
	nom_materia VARCHAR(100) NOT NULL
);

CREATE TABLE tutor_materia (
	id_tutor INT NOT NULL, 
	id_materia INT NOT NULL,
	PRIMARY KEY (id_tutor, id_materia)
);

CREATE TABLE horarios (
	id_horario SERIAL PRIMARY KEY, 
	fecha DATE NOT NULL, 
	hora_inicio TIME NOT NULL, 
	hora_fin TIME NOT NULL, 
	cupo_max INT NOT NULL, 
	id_tutor INT NOT NULL,
	id_materia INT NOT NULL
);

CREATE TABLE reservas (
	id_reserva SERIAL PRIMARY KEY, 
	fecha_transaccion TIMESTAMP, 
	id_estudiante INT NOT NULL, 
	id_horario INT NOT NULL
);

CREATE TABLE recursos (
	id_recurso SERIAL PRIMARY KEY, 
	url_drive VARCHAR(299) NOT NULL, 
	nom_archivo VARCHAR(100) NOT NULL, 
	id_materia INT NOT NULL, 
	id_tutor INT, 
	id_admin INT
);

-- 1. Estudiantes (Incluye uno sin reservas)

INSERT INTO estudiantes (cod_institucional, nombre, correo, contrasena) VALUES

(20232020026, 'Juan Camilo Carvajal', 'jcarvajal@ud.edu.co', 'hash123'),

(20232020067, 'Jenny Vanesa Leon', 'jleon@ud.edu.co', 'hash456'),

(20232020111, 'Carlos Perez', 'cperez@ud.edu.co', 'hash789'),

(20232020222, 'Maria Gomez', 'mgomez@ud.edu.co', 'hashabc'),

(20232020999, 'Estudiante Fantasma', 'fantasma@ud.edu.co', 'hash000'); 

-- 2. Tutores (Incluye uno sin horarios)

INSERT INTO tutores (cod_institucional, nombre, correo, contrasena) VALUES

(20232020052, 'Manuel Arturo Rueda', 'mrueda@ud.edu.co', 'tut123'),

(20232020055, 'Juan Esteban Galindo', 'jgalindo@ud.edu.co', 'tut456'),

(20232020333, 'Laura Sanchez', 'lsanchez@ud.edu.co', 'tut789'),

(20232020444, 'Andres Felipe', 'afelipe@ud.edu.co', 'tutabc'),

(20232020888, 'Tutor SinHorario', 'sinhorario@ud.edu.co', 'tut000'); 

-- 3. Administradores

INSERT INTO administradores (cod_institucional, nombre, correo, contrasena) VALUES

(20211020001, 'Admin Principal', 'admin1@ud.edu.co', 'adm123'),

(20211020002, 'Admin Secundario', 'admin2@ud.edu.co', 'adm456'),

(20211020003, 'Soporte Tecnico', 'soporte@ud.edu.co', 'adm789'),

(20211020004, 'Coordinador', 'coord@ud.edu.co', 'admabc'),

(20211020005, 'Auditor', 'auditor@ud.edu.co', 'admxyz');

-- 4. Materias (Incluye una materia huérfana para cumplir con la rúbrica)

INSERT INTO materias (nom_materia) VALUES

('Bases de Datos'),

('Cálculo Diferencial'),

('Física Mecánica'),

('Programación Orientada a Objetos'),

('Cálculo Integral'),

('Inglés I'); -- Materia que nadie dicta ni tiene horarios

-- 5. Tutor_Materia (Asignamos varias materias a algunos tutores)

INSERT INTO tutor_materia (id_tutor, id_materia) VALUES

(1, 1), (1, 4), -- Manuel enseña BD y POO

(2, 2), (2, 5), -- Juan Esteban enseña Cálculos

(3, 3),         -- Laura enseña Física

(4, 1);         -- Andres enseña BD

-- 6. Horarios (Incluye un horario que nadie reservará)

INSERT INTO horarios (fecha, hora_inicio, hora_fin, cupo_max, id_tutor, id_materia) VALUES

('2026-11-01', '10:00:00', '12:00:00', 5, 1, 1),

('2026-11-02', '14:00:00', '16:00:00', 10, 2, 2),

('2026-11-03', '08:00:00', '10:00:00', 3, 3, 3),

('2026-11-04', '16:00:00', '18:00:00', 15, 1, 4),

('2026-11-05', '12:00:00', '14:00:00', 4, 4, 1); -- Horario vacío sin reservas a propósito

-- 7. Reservas

INSERT INTO reservas (id_estudiante, id_horario) VALUES

(1, 1),

(2, 1),

(1, 2),

(2, 3),

(3, 4);

-- 8. Recursos (Subidos por tutores y admins)

INSERT INTO recursos (url_drive, nom_archivo, id_materia, id_tutor, id_admin) VALUES

('drive.com/bd1', 'Taller SQL', 1, 1, NULL),

('drive.com/calc1', 'Derivadas', 2, 2, NULL),

('drive.com/fis1', 'Leyes Newton', 3, 3, NULL),

('drive.com/poo1', 'Guia Java', 4, 1, NULL),

('drive.com/reglas', 'Reglamento Tutorias', 1, NULL, 1); -- Subido por Admin

-- CORRECCIONES TABLA ESTUDIANTES
ALTER TABLE estudiantes 
  ADD CONSTRAINT uq_estudiantes_correo UNIQUE (correo);

-- CORRECCIONES TABLA TUTORES
ALTER TABLE tutores 
  ADD CONSTRAINT uq_tutores_correo UNIQUE (correo);
  
-- CORRECCIONES ADMINISTRADORES
ALTER TABLE administradores 
  ADD CONSTRAINT uq_admin_correo UNIQUE (correo);

-- CORRECCIONES TABLA RECURSOS
ALTER TABLE recursos
  ADD CONSTRAINT fk_recursos_materia FOREIGN KEY (id_materia) 
      REFERENCES materias(id_materia) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT fk_recursos_tutor FOREIGN KEY (id_tutor) 
      REFERENCES tutores(id_tutor) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT fk_recursos_admin FOREIGN KEY (id_admin) 
      REFERENCES administradores(id_admin) ON DELETE SET NULL ON UPDATE CASCADE;

-- CORRECIONES TABLA MATERIAS
ALTER TABLE materias 
  ADD CONSTRAINT uq_materias_nombre UNIQUE (nom_materia);

-- CORRECIONES TABLA HORARIOS
ALTER TABLE horarios
  ADD CONSTRAINT chk_horarios_cupo CHECK (cupo_max > 0),
  ADD CONSTRAINT fk_horarios_tutor FOREIGN KEY (id_tutor) 
      REFERENCES tutores(id_tutor) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT fk_horarios_materia FOREIGN KEY (id_materia) 
      REFERENCES materias(id_materia) ON DELETE RESTRICT ON UPDATE CASCADE;

-- CORRECCIONES TABLA RESERVAS
ALTER TABLE reservas
  ALTER COLUMN fecha_transaccion SET DEFAULT CURRENT_TIMESTAMP,
  ADD CONSTRAINT fk_reservas_estudiante FOREIGN KEY (id_estudiante) 
      REFERENCES estudiantes(id_estudiante) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT fk_reservas_horario FOREIGN KEY (id_horario) 
      REFERENCES horarios(id_horario) ON DELETE RESTRICT ON UPDATE CASCADE;

-- CORRECCIONES TABLA TUTOR_MATERIA
ALTER TABLE tutor_materia
  ADD CONSTRAINT fk_tm_tutor FOREIGN KEY (id_tutor) 
      REFERENCES tutores(id_tutor) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT fk_tm_materia FOREIGN KEY (id_materia) 
      REFERENCES materias(id_materia) ON DELETE CASCADE ON UPDATE CASCADE;


-- CREACIÓN DE VISTAS
--VISTA 1
CREATE VIEW v_horarios_detallados AS
SELECT h.id_horario,
       h.fecha,
       h.hora_inicio,
       h.hora_fin,
       h.cupo_max,
       t.nombre AS nombre_tutor,
       m.nom_materia AS nombre_materia
FROM horarios h
JOIN tutores t ON h.id_tutor = t.id_tutor
JOIN materias m ON h.id_materia = m.id_materia;

-- SELECT DE PRUEBA 1 (Filtro por materia)
SELECT * FROM v_horarios_detallados 
WHERE nombre_materia = 'Bases de Datos';

-- SELECT DE PRUEBA 2 (Agregación: cantidad de horarios por tutor)
SELECT nombre_tutor, COUNT(*) AS total_horarios
FROM v_horarios_detallados
GROUP BY nombre_tutor;

--VISTA 2
CREATE VIEW v_demanda_materias AS
SELECT m.nom_materia AS materia,
       COUNT(r.id_reserva) AS total_reservas
FROM materias m
LEFT JOIN horarios h ON m.id_materia = h.id_materia
LEFT JOIN reservas r ON h.id_horario = r.id_horario
GROUP BY m.id_materia, m.nom_materia
ORDER BY total_reservas DESC;

-- SELECT DE PRUEBA
SELECT * FROM v_demanda_materias;


-- VISTA 3
CREATE VIEW v_horarios_amplios AS
SELECT id_horario, fecha, hora_inicio, hora_fin, cupo_max, id_tutor, id_materia
FROM horarios
WHERE cupo_max >= 5
WITH CHECK OPTION;

-- PRUEBA DE INSERCIÓN INVÁLIDA (Violación del check option por tener cupo 3)
INSERT INTO v_horarios_amplios (fecha, hora_inicio, hora_fin, cupo_max, id_tutor, id_materia)
VALUES ('2026-11-20', '10:00:00', '12:00:00', 3, 1, 1);


--VISTA 4
CREATE VIEW v_estudiantes_publico AS
SELECT id_estudiante, cod_institucional, nombre, correo
FROM estudiantes;

-- SELECT DE PRUEBA
SELECT * FROM v_estudiantes_publico;


-- CREACIÓND DE ROLES EN EL OTRO QUERYTOOL

