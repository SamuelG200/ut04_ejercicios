-- 1. Crear base de datos con collation utf8mb4_unicode_ci
CREATE DATABASE instituto CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 2.Cambiar collation a utf8mb4_general_ci
ALTER DATABASE instituto CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- Usar la base de datos
USE instituto;

-- 3. Crear tabla profesores
CREATE TABLE profesores (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- 4. Crear tabla cursos
CREATE TABLE cursos (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT
);

-- 5. Crear tabla intermedia profesores_cursos
CREATE TABLE profesores_cursos (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    profesor_id INT UNSIGNED NOT NULL,
    curso_id INT UNSIGNED NOT NULL,
    fecha_asignacion DATE NOT NULL,
    FOREIGN KEY (profesor_id) REFERENCES profesores(id),
    FOREIGN KEY (curso_id) REFERENCES cursos(id)
);

-- 6. Modificar tabla para agregar columna horas_clase
ALTER TABLE profesores_cursos ADD COLUMN horas_clase INT;

-- 7. Cambiar tamaño del campo nombre en cursos
ALTER TABLE cursos MODIFY nombre VARCHAR(200) NOT NULL;

-- 8. Eliminar columna horas_clase
ALTER TABLE profesores_cursos DROP COLUMN horas_clase;

-- 9. Añadir índice al nombre en cursos
CREATE INDEX idx_nombre ON cursos(nombre);

-- 10. Insertar Juan Perez
INSERT INTO profesores (nombre) VALUES ('Juan Pérez');
-- 11. Añade un Matematicas
INSERT INTO cursos (nombre, descripcion) VALUES ('Matemáticas', 'Curso de álgebra y geometría');

-- 12. Asignar profesor a curso
INSERT INTO profesores_cursos (profesor_id, curso_id, fecha_asignacion)
VALUES (1, 1, CURDATE());

-- 13. nsertar profesores adicionales
INSERT INTO profesores (nombre) VALUES ('Ana Rodríguez'), ('Luis Gómez');

-- 14. Insertar cursos adicionales
INSERT INTO cursos (nombre) VALUES ('Física'), ('Historia'), ('Química');

-- 15. Asignar profesores a cursos 
INSERT INTO profesores_cursos (profesor_id, curso_id, fecha_asignacion)
VALUES 
    (2, 2, CURDATE()),  -- Ana enseña Física
    (3, 1, CURDATE()),  -- Luis enseña Matemáticas
    (1, 3, CURDATE()),  -- Juan enseña Historia
    (2, 4, CURDATE());  -- Ana enseña Química

-- 16. Consultar cursos de Juan Pérez
SELECT c.nombre 
FROM cursos c
JOIN profesores_cursos pc ON c.id = pc.curso_id
JOIN profesores p ON p.id = pc.profesor_id
WHERE p.nombre = 'Juan Pérez';

-- 17. Consultar profesores que enseñan Matemáticas
SELECT p.nombre 
FROM profesores p
JOIN profesores_cursos pc ON p.id = pc.profesor_id
JOIN cursos c ON c.id = pc.curso_id
WHERE c.nombre = 'Matemáticas';

-- 18. Eliminar asignación de profesor a curso 
DELETE FROM profesores_cursos 
WHERE profesor_id = 1 AND curso_id = 3;

-- 19. Eliminar un profesor y sus registros de cursos 
DELETE FROM profesores_cursos WHERE profesor_id = 3;
DELETE FROM profesores WHERE id = 3;

-- 20. Eliminar la base de datos 
DROP DATABASE instituto;