-- 1. Tabla usuarios
CREATE TABLE usuarios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    contrasena_hash VARCHAR(255) NOT NULL,
    rol ENUM('admin', 'tecnico', 'cliente') NOT NULL
);

-- 2. Tabla técnicos
CREATE TABLE tecnicos (
    usuario_id INT PRIMARY KEY,
    especialidad VARCHAR(100) NOT NULL,
    estado ENUM('activo', 'inactivo') DEFAULT 'activo',
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE
);

-- 3. Tabla equipos
CREATE TABLE equipos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT NOT NULL,
    nombre_equipo VARCHAR(100) NOT NULL,
    marca VARCHAR(50) NOT NULL,
    modelo VARCHAR(50) NOT NULL,
    tipo ENUM('Computadora', 'Celular', 'Tablet') NOT NULL,
    problema TEXT,
    FOREIGN KEY (cliente_id) REFERENCES usuarios(id)
);

-- 4. Tabla especificaciones_tecnicas
CREATE TABLE especificaciones_tecnicas (
    equipo_id INT PRIMARY KEY,
    ram_tipo VARCHAR(50),
    ram_capacidad VARCHAR(20),
    ram_velocidad VARCHAR(20),
    procesador_marca VARCHAR(50),
    procesador_nombre VARCHAR(50),
    so_nombre VARCHAR(50),
    so_version VARCHAR(50),
    disco_capacidad VARCHAR(50),
    disco_particiones TEXT,
    tarjeta_madre VARCHAR(50),
    puertos TEXT,
    otra_informacion TEXT,
    FOREIGN KEY (equipo_id) REFERENCES equipos(id) ON DELETE CASCADE
);

-- 5. Tabla reparaciones
CREATE TABLE reparaciones (
    id INT PRIMARY KEY AUTO_INCREMENT,
    equipo_id INT NOT NULL,
    cliente_id INT NOT NULL,
    tecnico_id INT NOT NULL,
    servicio_solicitado TEXT NOT NULL,
    fecha_ingreso DATETIME DEFAULT CURRENT_TIMESTAMP,
    tipo_mantenimiento ENUM('Preventivo', 'Correctivo') NOT NULL,
    estado ENUM('Recibido', 'Diagnóstico', 'Reparación', 'Completado', 'Entregado') DEFAULT 'Recibido',
    FOREIGN KEY (equipo_id) REFERENCES equipos(id),
    FOREIGN KEY (cliente_id) REFERENCES usuarios(id),
    FOREIGN KEY (tecnico_id) REFERENCES tecnicos(usuario_id)
);

-- 6. Tabla diagnósticos
CREATE TABLE diagnosticos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    reparacion_id INT NOT NULL,
    descripcion TEXT NOT NULL,
    repuestos_necesarios TEXT,
    tiempo_estimado_horas INT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (reparacion_id) REFERENCES reparaciones(id)
);

-- 7. Tabla productos
CREATE TABLE productos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    imagen VARCHAR(255),
    cantidad INT NOT NULL DEFAULT 0,
    categoria VARCHAR(100) NOT NULL
);

-- 8. Productos
CREATE TABLE repuestos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    marca VARCHAR(50),
    precio_unitario DECIMAL(10,2),
    stock INT DEFAULT 0
);

-- 9. Tabla repuestos_utilizados
CREATE TABLE repuestos_utilizados (
    id INT PRIMARY KEY AUTO_INCREMENT,
    reparacion_id INT NOT NULL,
    repuesto_id INT NOT NULL,
    cantidad INT NOT NULL DEFAULT 1,
    FOREIGN KEY (reparacion_id) REFERENCES reparaciones(id),
    FOREIGN KEY (repuesto_id) REFERENCES repuestos(id)
);

-- ====== DATOS DE PRUEBA ====== --

-- Usuarios
INSERT INTO usuarios (nombre, correo, telefono, contrasena_hash, rol) VALUES
('Admin Principal', 'admin@misterpc.com', '2222-0000', '$2a$10$5VYzO3W6uZ7J7q3b8b1B0', 'admin'),
('Roberto Jiménez', 'tecnico1@misterpc.com', '7777-8888', '$2a$10$1A2B3C4D5E6F7G8H9I0J1', 'tecnico'),
('Laura Castro', 'tecnico2@misterpc.com', '7777-9999', '$2a$10$9Z8Y7X6W5V4U3T2S1R0Q', 'tecnico'),
('María Rodríguez', 'maria@correo.com', '7123-4567', '$2a$10$abc123', 'cliente'),
('Carlos López', 'carlos@mail.com', '7890-1234', '$2a$10$def456', 'cliente');

-- Técnicos
INSERT INTO tecnicos (usuario_id, especialidad, estado) VALUES
(2, 'Hardware y sobrecalentamiento', 'activo'),
(3, 'Pantallas y componentes móviles', 'activo');

-- Equipos
INSERT INTO equipos (cliente_id, nombre_equipo, marca, modelo, tipo, problema) VALUES
(4, 'Laptop María', 'HP', 'Pavilion 15', 'Computadora', 'Sobrecalentamiento y apagado repentino'),
(4, 'Celular María', 'Samsung', 'Galaxy S21', 'Celular', 'Pantalla rota'),
(5, 'Tablet Carlos', 'Apple', 'iPad Air', 'Tablet', 'No carga la batería');

-- Especificaciones técnicas
INSERT INTO especificaciones_tecnicas (equipo_id, ram_tipo, ram_capacidad, procesador_marca, so_nombre) VALUES
(1, 'DDR4', '16GB', 'Intel i7', 'Windows 11');

-- Reparaciones CORREGIDAS
INSERT INTO reparaciones (
    equipo_id,
    cliente_id,
    tecnico_id,
    servicio_solicitado,
    tipo_mantenimiento,
    estado
) VALUES
(1, 4, 2, 'Limpieza interna y cambio de pasta térmica', 'Preventivo', 'Completado'),  -- tecnico_id = 2
(2, 4, 3, 'Reemplazo de pantalla', 'Correctivo', 'Reparación'),                      -- tecnico_id = 3
(3, 5, 2, 'Reemplazo de puerto de carga', 'Correctivo', 'Diagnóstico');             -- tecnico_id = 2

-- Diagnósticos
INSERT INTO diagnosticos (reparacion_id, descripcion, repuestos_necesarios, tiempo_estimado_horas) VALUES
(1, 'Ventilador obstruido por polvo y pasta térmica seca', 'Pasta térmica MX-4', 2),
(2, 'Pantalla OLED rota, requiere reemplazo completo', 'Pantalla Samsung Galaxy S21 Original', 3);

-- Productos
INSERT INTO productos (nombre, precio, imagen, cantidad, categoria) VALUES
('Tarjeta Madre Asus', 200.00, 'img/tarjetas/asus123.jpg', 10, 'Tarjetas madre'),
('Memoria RAM DDR4 16GB', 85.50, 'img/ram/ddr4.jpg', 25, 'Memorias RAM');

-- Repuestos
INSERT INTO repuestos (nombre, marca, precio_unitario, stock) VALUES
('Pasta térmica MX-4', 'Arctic', 8.50, 15),
('Pantalla Galaxy S21', 'Samsung', 89.99, 3);

-- Repuestos utilizados
INSERT INTO repuestos_utilizados (reparacion_id, repuesto_id, cantidad) VALUES
(1, 1, 1),
(2, 2, 1);

-- Generar hash de contraseña (en aplicación real se haría con bcrypt)
SET @password = 'SecureAdminPass123!';  -- Contraseña en texto plano
SET @salt = SUBSTRING(SHA2(RAND(), 256), 1, 16);  -- Sal aleatorio
SET @hashed_password = CONCAT('$2a$10$', @salt, SHA2(CONCAT(@salt, @password), 256));  -- Hash estilo bcrypt


-- Inserciones de prueba 

-- Insertar nuevo administrador
INSERT INTO usuarios (
    nombre, 
    correo, 
    telefono, 
    contrasena_hash, 
    rol
) VALUES (
    'Astrelio',
    'astrelio7@serene.com',
    '5000-0000',  -- Teléfono genérico
    @hashed_password,
    'admin'
);

-- Consultas de verificación
SELECT * FROM usuarios;
SELECT * FROM tecnicos;
SELECT * FROM equipos;
SELECT * FROM especificaciones_tecnicas;
SELECT * FROM reparaciones;
SELECT * FROM diagnosticos;
SELECT * FROM productos;
SELECT * FROM repuestos;
SELECT * FROM repuestos_utilizados;