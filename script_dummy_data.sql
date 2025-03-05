-- Empresas
INSERT INTO Empresas (Nombre_Empresa, Direccion) 
VALUES ('Comercial XYZ', 'Av. Principal 123');

-- Sucursales
INSERT INTO Sucursales (ID_Empresa, Nombre_Sucursal, Ubicacion) 
VALUES 
    (1, 'Sucursal Norte', 'Zona Norte'),
    (1, 'Sucursal Sur', 'Zona Sur');

-- Almacenes
INSERT INTO Almacenes (ID_Sucursal, Nombre_Almacen) 
VALUES 
    (1, 'Almacén Norte'), -- ID_Almacen = 1
    (2, 'Almacén Sur');   -- ID_Almacen = 2

-- Usuarios
INSERT INTO Usuarios (ID_Empresa, Nombre, Correo, Contrasena) 
VALUES 
    (1, 'Juan Pérez', 'juan@xyz.com', 'hashed_password1'),
    (1, 'Ana Gómez', 'ana@xyz.com', 'hashed_password2');

-- Roles
INSERT INTO Roles (Nombre_Rol, Descripcion) 
VALUES 
    ('Administrador', 'Acceso total'),
    ('Almacenero', 'Gestión de almacén');

-- Usuario_Rol
INSERT INTO Usuario_Rol (ID_Usuario, ID_Rol) 
VALUES 
    (1, 1), -- Juan es Admin
    (2, 2); -- Ana es Almacenera

-- Usuario_Sucursal
INSERT INTO Usuario_Sucursal (ID_Usuario, ID_Sucursal) 
VALUES 
    (1, 1), (1, 2), -- Juan en ambas sucursales
    (2, 1);         -- Ana solo en Norte

-- Proveedores
INSERT INTO Proveedores (Nombre_Proveedor, Contacto, Direccion) 
VALUES 
    ('Proveedor Genérico', '555-1234', 'Calle 10'),
    ('FarmaCorp', '555-5678', 'Av. Salud 456');

-- Marcas
INSERT INTO Marcas (Nombre_Marca) 
VALUES 
    ('Genérico'),
    ('Premium');

-- Unidades_Medida
INSERT INTO Unidades_Medida (Nombre_Unidad, Factor_Conversion) 
VALUES 
    ('Unidad', 1),
    ('Six-Pack', 6),
    ('Kilo', 1),
    ('Caja', 10);

-- Tipos_Movimiento
INSERT INTO Tipos_Movimiento (Nombre_Tipo, Descripcion) 
VALUES 
    ('Entrada', 'Registro de recepción de ítems'),       -- ID = 1
    ('Salida', 'Registro de salida de ítems'),           -- ID = 2
    ('Traslado', 'Movimiento de ítems entre almacenes'), -- ID = 3
    ('Merma', 'Pérdida de inventario'),                  -- ID = 4
    ('Ajuste Positivo', 'Aumento por conteo físico'),    -- ID = 5
    ('Ajuste Negativo', 'Reducción por conteo físico');  -- ID = 6

-- Motivos_Merma
INSERT INTO Motivos_Merma (Nombre_Motivo, Descripcion) 
VALUES 
    ('Vencimiento', 'Producto caducado'), -- ID = 1
    ('Daño', 'Producto roto'),            -- ID = 2
    ('Robo', 'Pérdida por hurto');        -- ID = 3

-- Categorias
INSERT INTO Categorias (Nombre_Categoria, Descripcion) 
VALUES 
    ('Herramientas', 'Productos de ferretería'),    -- ID = 1
    ('Abarrotes', 'Productos de consumo diario'),   -- ID = 2
    ('Analgésicos', 'Medicamentos para el dolor'),  -- ID = 3
    ('Psicótropicos', 'Medicamentos controlados');  -- ID = 4

-- Items
INSERT INTO Items (Nombre_Item, ID_Marca, ID_Proveedor, Descripcion, Precio_Venta, Porcentaje_Ganancia, ID_Unidad_Base) 
VALUES 
    ('Martillo', 1, 1, 'Martillo de acero', 15.00, 20.00, 1),           -- ID_Item = 1 (Ferretería)
    ('Arroz', 1, 1, 'Arroz blanco 1kg', 2.50, 15.00, 3),               -- ID_Item = 2 (Abarrotes)
    ('Cerveza', 2, 1, 'Cerveza 330ml', 1.20, 25.00, 1),                -- ID_Item = 3 (Abarrotes)
    ('Paracetamol', 1, 2, 'Analgésico 500mg', 0.50, 30.00, 1);         -- ID_Item = 4 (Farmacia)

-- Item_Categoria
INSERT INTO Item_Categoria (ID_Item, ID_Categoria) 
VALUES 
    (1, 1), -- Martillo: Herramientas
    (2, 2), -- Arroz: Abarrotes
    (3, 2), -- Cerveza: Abarrotes
    (4, 3); -- Paracetamol: Analgésicos

-- Inventario
INSERT INTO Inventario (ID_Item, ID_Almacen, Cantidad_Total) 
VALUES 
    (1, 1, 10.00), -- Martillos en Norte
    (2, 1, 50.50), -- Arroz en Norte
    (3, 1, 12.00), -- Cervezas en Norte
    (4, 1, 100.00);-- Paracetamol en Norte

-- Lotes
INSERT INTO Lotes (ID_Inventario, Numero_Lote, Fecha_Vencimiento, Cantidad, Precio_Compra) 
VALUES 
    (1, 'LoteM001', NULL, 10.00, 12.00),         -- Martillos sin vencimiento
    (2, 'LoteA001', '2025-12-31', 50.50, 2.00),  -- Arroz
    (3, 'LoteC001', '2026-02-28', 12.00, 1.00),  -- Cerveza
    (4, 'LoteP001', '2027-02-28', 100.00, 0.40); -- Paracetamol

-- Movimientos
INSERT INTO Movimientos (ID_Almacen, ID_Tipo_Movimiento, ID_Usuario, Descripcion, Fecha_Efectiva) 
VALUES 
    (1, 1, 1, 'Entrada inicial de martillos', '2025-02-20'),       -- ID = 1
    (1, 1, 1, 'Entrada inicial de arroz', '2025-02-20'),          -- ID = 2
    (1, 1, 1, 'Entrada inicial de cervezas', '2025-02-25'),       -- ID = 3
    (1, 1, 1, 'Entrada inicial de paracetamol', '2025-02-25'),    -- ID = 4
    (1, 4, 2, 'Merma de cervezas dañadas', '2025-02-26');        -- ID = 5

-- Movimiento_Detalle
INSERT INTO Movimiento_Detalle (ID_Movimiento, ID_Lote, ID_Item, Cantidad, ID_Unidad, Precio_Compra, Fecha_Vencimiento, ID_Motivo) 
VALUES 
    (1, 1, 1, 10.00, 1, 12.00, NULL, NULL),          -- Martillos
    (2, 2, 2, 50.50, 3, 2.00, '2025-12-31', NULL),   -- Arroz
    (3, 3, 3, 2.00, 2, 6.00, '2026-02-28', NULL),    -- Cervezas (2 Six-Packs = 12)
    (4, 4, 4, 100.00, 1, 0.40, '2027-02-28', NULL),  -- Paracetamol
    (5, 3, 3, 2.00, 1, NULL, NULL, 2);               -- Merma de 2 cervezas (daño)