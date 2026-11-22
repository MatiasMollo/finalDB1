CREATE DATABASE LibreriaFinal;
GO
USE LibreriaFinal;
GO

CREATE TABLE categorias (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE clientes (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    fecha_alta DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    activo BIT NOT NULL DEFAULT 1
);

CREATE TABLE libros (
    id INT IDENTITY(1,1) PRIMARY KEY,
    titulo VARCHAR(120) NOT NULL,
    categoria_id INT NOT NULL REFERENCES categorias(id),
    precio DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL
);

CREATE TABLE pedidos (
    id INT IDENTITY(1,1) PRIMARY KEY,
    cliente_id INT NOT NULL REFERENCES clientes(id),
    fecha DATETIME NOT NULL DEFAULT GETDATE(),
    estado VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE'
        CHECK (estado IN ('PENDIENTE','PAGADO','CANCELADO'))
);

CREATE TABLE detalle_pedidos (
    id INT IDENTITY(1,1) PRIMARY KEY,
    pedido_id INT NOT NULL REFERENCES pedidos(id),
    libro_id INT NOT NULL REFERENCES libros(id),
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL
);

CREATE TABLE pagos (
    id INT IDENTITY(1,1) PRIMARY KEY,
    pedido_id INT NOT NULL REFERENCES pedidos(id),
    importe DECIMAL(10,2) NOT NULL,
    fecha DATETIME NOT NULL DEFAULT GETDATE()
);
GO

INSERT INTO categorias (nombre) VALUES ('Novela'), ('Tecnología'), ('Historia'), ('Infantil');

INSERT INTO clientes (nombre, email, fecha_alta, activo) VALUES
('Ana Pérez', 'ana@mail.com', '2026-01-10', 1),
('Bruno Díaz', 'bruno@mail.com', '2026-02-15', 1),
('Carla Gómez', 'carla@mail.com', '2026-03-20', 1),
('Diego Ruiz', 'diego@mail.com', '2026-04-05', 0);

INSERT INTO libros (titulo, categoria_id, precio, stock) VALUES
('Rayuela', 1, 15000.00, 10),
('El Aleph', 1, 12000.00, 5),
('SQL para todos', 2, 25000.00, 8),
('Redes y sistemas', 2, 30000.00, 3),
('Historia Argentina', 3, 18000.00, 6),
('Cuentos de la selva', 4, 9000.00, 20);

INSERT INTO pedidos (cliente_id, fecha, estado) VALUES
(1, '2026-10-01', 'PAGADO'),
(1, '2026-10-20', 'PENDIENTE'),
(2, '2026-09-01', 'PENDIENTE'),
(3, '2026-11-10', 'PENDIENTE'),
(2, '2026-10-05', 'CANCELADO');

INSERT INTO detalle_pedidos (pedido_id, libro_id, cantidad, precio_unitario) VALUES
(1, 1, 1, 15000.00),
(1, 3, 1, 25000.00),
(2, 2, 2, 12000.00),
(3, 4, 1, 30000.00),
(3, 6, 3, 9000.00),
(4, 5, 1, 18000.00),
(5, 1, 1, 15000.00);

INSERT INTO pagos (pedido_id, importe, fecha) VALUES
(1, 40000.00, '2026-10-02'),
(2, 10000.00, '2026-10-22'),
(3, 20000.00, '2026-09-10');
GO