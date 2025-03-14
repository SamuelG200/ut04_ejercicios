-- 1. Crear la base de datos con utf8mb4_unicode_ci
CREATE DATABASE biblioteca CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 2. Modificar la collation de la base de datos
ALTER DATABASE biblioteca COLLATE utf8mb4_general_ci;

-- Usar la base de datos
USE biblioteca;

-- 3. Crear la tabla bibliotecas
CREATE TABLE bibliotecas (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- 4. Crear la tabla libros
CREATE TABLE libros (
    id INT AUTO_INCREMENT PRIMARY KEY,
    biblioteca_id INT UNSIGNED,
    titulo VARCHAR(255) NOT NULL,
    autor VARCHAR(100) NOT NULL,
    anio_publicacion YEAR NOT NULL,
    FOREIGN KEY (biblioteca_id) REFERENCES bibliotecas(id)
);

-- 5. Modificar la tabla libros para agregar la columna genero
ALTER TABLE libros ADD COLUMN genero VARCHAR(50);

-- 6. Cambiar el tamaño de la columna nombre en bibliotecas a 150 caracteres
ALTER TABLE bibliotecas MODIFY nombre VARCHAR(150) NOT NULL;

-- 7. Eliminar la columna genero de libros
ALTER TABLE libros DROP COLUMN genero;

-- 8. Añadir una nueva columna isbn después de titulo en libros
ALTER TABLE libros ADD COLUMN isbn VARCHAR(20) AFTER titulo;

-- 9. Cambiar el tipo de dato de isbn a CHAR(13)
ALTER TABLE libros MODIFY isbn CHAR(13);

-- Insertar una biblioteca llamada "Biblioteca Central"
INSERT INTO bibliotecas (nombre) VALUES ('Biblioteca Central');

-- 10. Obtener el ID de la biblioteca recién insertada
SET @biblioteca_id = LAST_INSERT_ID();

-- 11. Insertar un libro "El Quijote" en la Biblioteca Central
INSERT INTO libros (biblioteca_id, titulo, isbn, autor, anio_publicacion) 
VALUES (@biblioteca_id, 'El Quijote', '9781234567890', 'Miguel de Cervantes', 1605);

-- 12. Insertar dos libros adicionales en la Biblioteca Central
INSERT INTO libros (biblioteca_id, titulo, isbn, autor, anio_publicacion) 
VALUES 
(@biblioteca_id, '1984', '9780451524935', 'George Orwell', 1949),
(@biblioteca_id, 'Cien años de soledad', '9780307474728', 'Gabriel García Márquez', 1967);

-- 13. Consultar todos los libros con su biblioteca
SELECT libros.id, libros.titulo, libros.autor, libros.anio_publicacion, bibliotecas.nombre AS biblioteca 
FROM libros 
JOIN bibliotecas ON libros.biblioteca_id = bibliotecas.id;

-- 14. Mostrar todas las bibliotecas sin libros registrados
SELECT * FROM bibliotecas WHERE id NOT IN (SELECT DISTINCT biblioteca_id FROM libros);

-- 15. Actualizar el año de publicación de "1984" a 1950
UPDATE libros SET anio_publicacion = 1950 WHERE titulo = '1984';

-- 16. Eliminar un libro con id = 1
DELETE FROM libros WHERE id = 1;

-- 17. Eliminar la Biblioteca Central y todos sus libros
DELETE FROM libros WHERE biblioteca_id = @biblioteca_id;
DELETE FROM bibliotecas WHERE id = @biblioteca_id;

-- 18. Consultar la estructura de la tabla libros
DESCRIBE libros;

-- 19. Eliminar las tablas libros y bibliotecas
DROP TABLE IF EXISTS libros;
DROP TABLE IF EXISTS bibliotecas;

-- 20. Eliminar la base de datos biblioteca
DROP DATABASE IF EXISTS biblioteca;
