-- 1. Crear la base de datos con utf8mb4_unicode_ci
CREATE DATABASE usuarios_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 2. Modificar la collation de la base de datos a utf8mb4_general_ci
ALTER DATABASE usuarios_db COLLATE utf8mb4_general_ci;

-- Usar la base de datos
USE usuarios_db;

-- 3. Crear la tabla usuarios
CREATE TABLE usuarios (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- 4. Crear la tabla direcciones con clave foránea única
CREATE TABLE direcciones (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT UNSIGNED UNIQUE, 
    direccion VARCHAR(255) NOT NULL,
    CONSTRAINT fk_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

-- 5. Modificar direcciones para hacer usuario_id clave primaria y foránea
ALTER TABLE direcciones DROP PRIMARY KEY;
ALTER TABLE direcciones ADD PRIMARY KEY (usuario_id);
ALTER TABLE direcciones ADD CONSTRAINT fk_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios(id);

-- 6. Cambiar tamaño del campo nombre a 150 caracteres
ALTER TABLE usuarios MODIFY nombre VARCHAR(150) NOT NULL;

-- 7. Agregar la columna telefono después de nombre
ALTER TABLE usuarios ADD COLUMN telefono VARCHAR(15) AFTER nombre;

-- 8. Cambiar tipo de telefono a BIGINT
ALTER TABLE usuarios MODIFY COLUMN telefono BIGINT;

-- 9. Eliminar la columna telefono
ALTER TABLE usuarios DROP COLUMN telefono;

-- 10. Insertar un usuario "Juan Pérez"
INSERT INTO usuarios (nombre) VALUES ('Juan Pérez');

-- 11. Insertar la dirección de "Juan Pérez"
INSERT INTO direcciones (usuario_id, direccion) 
VALUES ((SELECT id FROM usuarios WHERE nombre = 'Juan Pérez'), 'Calle Mayor 123');

-- 12. Insertar dos usuarios adicionales
INSERT INTO usuarios (nombre) VALUES ('Ana Gómez'), ('Carlos Ruiz');

-- 13. Añadir direcciones para los nuevos usuarios
INSERT INTO direcciones (usuario_id, direccion) 
VALUES 
((SELECT id FROM usuarios WHERE nombre = 'Ana Gómez'), 'Calle Osa Mayor'),
((SELECT id FROM usuarios WHERE nombre = 'Carlos Ruiz'), 'Avenida Los Guanches ');

-- 14. Consultar todas las direcciones junto con el nombre del usuario
SELECT usuarios.nombre, direcciones.direccion 
FROM usuarios 
JOIN direcciones ON usuarios.id = direcciones.usuario_id;

-- 15. Mostrar todos los usuarios que no tienen dirección registrada
SELECT nombre FROM usuarios 
WHERE id NOT IN (SELECT usuario_id FROM direcciones);

-- 16. Actualizar la dirección de "Juan Pérez"
UPDATE direcciones 
SET direccion = 'Avenida Central 456' 
WHERE usuario_id = (SELECT id FROM usuarios WHERE nombre = 'Juan Pérez');

-- 17. Eliminar la dirección de "Carlos Ruiz"
DELETE FROM direcciones 
WHERE usuario_id = (SELECT id FROM usuarios WHERE nombre = 'Carlos Ruiz');

-- 18. Consultar la estructura de la tabla direcciones
DESCRIBE direcciones;

-- 19. Eliminar las tablas direcciones y usuarios
DROP TABLE IF EXISTS direcciones;
DROP TABLE IF EXISTS usuarios;

-- 20. Eliminar la base de datos usuarios_db
DROP DATABASE IF EXISTS usuarios_db;

