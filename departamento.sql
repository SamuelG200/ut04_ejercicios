-- 1. Crear la base de datos universidad con collation utf8mb4_unicode_ci
CREATE DATABASE universidad CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 2. Cambiar el collation de la base de datos a utf8mb4_general_ci
ALTER DATABASE universidad CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- Usar la base de datos universidad
USE universidad;

-- 3. Crear la tabla alumnos
CREATE TABLE alumnos (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- 4. Crear la tabla asignaturas
CREATE TABLE asignaturas (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- 5. Crear la tabla matriculas para gestionar la relación muchos a muchos
CREATE TABLE matriculas (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    alumno_id INT UNSIGNED,
    asignatura_id INT UNSIGNED,
    fecha_matricula DATE NOT NULL,
    FOREIGN KEY (alumno_id) REFERENCES alumnos(id),
    FOREIGN KEY (asignatura_id) REFERENCES asignaturas(id)
);

-- 6. Modificar la tabla matriculas para agregar una columna nota
ALTER TABLE matriculas ADD COLUMN nota DECIMAL(4,2);

-- 7. Cambiar el tamaño del campo nombre en la tabla asignaturas a 150 caracteres
ALTER TABLE asignaturas MODIFY nombre VARCHAR(150) NOT NULL;

-- 8. Eliminar la columna nota de la tabla matriculas
ALTER TABLE matriculas DROP COLUMN nota;

-- 9. Añadir un índice a la columna nombre en la tabla asignaturas
CREATE INDEX idx_nombre ON asignaturas(nombre);

-- 10. Insertar un alumno llamado "Luis Gómez"
INSERT INTO alumnos (nombre) VALUES ('Luis Gómez');

-- 11.Añadir una asignatura llamada "Matemáticas"
INSERT INTO asignaturas (nombre) VALUES ('Matemáticas');

-- 12. Matricular al alumno "Luis Gómez" en "Matemáticas" con fecha de matrícula de hoy
INSERT INTO matriculas (alumno_id, asignatura_id, fecha_matricula) 
VALUES (1, 1, CURDATE());

-- 13. Insertar dos alumnos adicionales
INSERT INTO alumnos (nombre) VALUES ('María Fernández'), ('Carlos Ruiz');

-- 14. Añadir tres asignaturas adicionales
INSERT INTO asignaturas (nombre) VALUES ('Física'), ('Historia'), ('Química');

-- 15. Matricular a los alumnos en distintas asignaturas
INSERT INTO matriculas (alumno_id, asignatura_id, fecha_matricula) 
VALUES 
(2, 2, CURDATE()), -- María en Física
(2, 3, CURDATE()), -- María en Historia
(3, 4, CURDATE()); -- Carlos en Química

-- 16. Consultar todas las asignaturas en las que está inscrito el alumno "Luis Gómez"
SELECT a.nombre 
FROM asignaturas a
JOIN matriculas m ON a.id = m.asignatura_id
JOIN alumnos al ON m.alumno_id = al.id
WHERE al.nombre = 'Luis Gómez';

-- 17. Consultar todos los alumnos que están inscritos en la asignatura "Matemáticas"
SELECT al.nombre 
FROM alumnos al
JOIN matriculas m ON al.id = m.alumno_id
JOIN asignaturas a ON m.asignatura_id = a.id
WHERE a.nombre = 'Matemáticas';

-- 18. Eliminar la inscripción de un alumno en una asignatura específica
DELETE FROM matriculas 
WHERE alumno_id = (SELECT id FROM alumnos WHERE nombre = 'Luis Gómez') 
AND asignatura_id = (SELECT id FROM asignaturas WHERE nombre = 'Matemáticas');

-- 19. Eliminar un alumno y sus matrículas asociadas
DELETE FROM matriculas WHERE alumno_id = (SELECT id FROM alumnos WHERE nombre = 'Carlos Ruiz');
DELETE FROM alumnos WHERE nombre = 'Carlos Ruiz';

-- 20. Eliminar la base de datos universidad
DROP DATABASE universidad;