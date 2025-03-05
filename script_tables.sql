create database inventario


-- Tabla Empresas
CREATE TABLE Empresas (
    ID_Empresa SERIAL PRIMARY KEY,
    Nombre_Empresa VARCHAR(100) NOT NULL,
    Direccion VARCHAR(200)
);

-- Tabla Sucursales
CREATE TABLE Sucursales (
    ID_Sucursal SERIAL PRIMARY KEY,
    ID_Empresa INT NOT NULL,
    Nombre_Sucursal VARCHAR(100) NOT NULL,
    Ubicacion VARCHAR(200),
    FOREIGN KEY (ID_Empresa) REFERENCES Empresas(ID_Empresa) ON DELETE CASCADE
);

-- Tabla Almacenes
CREATE TABLE Almacenes (
    ID_Almacen SERIAL PRIMARY KEY,
    ID_Sucursal INT NOT NULL,
    Nombre_Almacen VARCHAR(100) NOT NULL,
    FOREIGN KEY (ID_Sucursal) REFERENCES Sucursales(ID_Sucursal) ON DELETE CASCADE
);

-- Tabla Usuarios
CREATE TABLE Usuarios (
    ID_Usuario SERIAL PRIMARY KEY,
    ID_Empresa INT NOT NULL,
    Nombre VARCHAR(100) NOT NULL,
    Correo VARCHAR(100) UNIQUE NOT NULL,
    Contrasena VARCHAR(255) NOT NULL,
    FOREIGN KEY (ID_Empresa) REFERENCES Empresas(ID_Empresa) ON DELETE CASCADE
);

-- Tabla Roles
CREATE TABLE Roles (
    ID_Rol SERIAL PRIMARY KEY,
    Nombre_Rol VARCHAR(50) NOT NULL,
    Descripcion TEXT
);

-- Tabla Usuario_Sucursal
CREATE TABLE Usuario_Sucursal (
    ID_Usuario INT NOT NULL,
    ID_Sucursal INT NOT NULL,
    PRIMARY KEY (ID_Usuario, ID_Sucursal),
    FOREIGN KEY (ID_Usuario) REFERENCES Usuarios(ID_Usuario) ON DELETE CASCADE,
    FOREIGN KEY (ID_Sucursal) REFERENCES Sucursales(ID_Sucursal) ON DELETE CASCADE
);

-- Tabla Usuario_Rol
CREATE TABLE Usuario_Rol (
    ID_Usuario INT NOT NULL,
    ID_Rol INT NOT NULL,
    PRIMARY KEY (ID_Usuario, ID_Rol),
    FOREIGN KEY (ID_Usuario) REFERENCES Usuarios(ID_Usuario) ON DELETE CASCADE,
    FOREIGN KEY (ID_Rol) REFERENCES Roles(ID_Rol) ON DELETE CASCADE
);

-- Tabla Proveedores
CREATE TABLE Proveedores (
    ID_Proveedor SERIAL PRIMARY KEY,
    Nombre_Proveedor VARCHAR(100) NOT NULL,
    Contacto VARCHAR(50),
    Direccion VARCHAR(200)
);

-- Tabla Marcas
CREATE TABLE Marcas (
    ID_Marca SERIAL PRIMARY KEY,
    Nombre_Marca VARCHAR(100) NOT NULL
);

-- Tabla Unidades_Medida
CREATE TABLE Unidades_Medida (
    ID_Unidad SERIAL PRIMARY KEY,
    Nombre_Unidad VARCHAR(50) NOT NULL,
    Factor_Conversion DECIMAL(10, 2) NOT NULL CHECK (Factor_Conversion > 0)
);

-- Tabla Tipos_Movimiento
CREATE TABLE Tipos_Movimiento (
    ID_Tipo_Movimiento SERIAL PRIMARY KEY,
    Nombre_Tipo VARCHAR(50) NOT NULL UNIQUE,
    Descripcion TEXT
);

-- Tabla Motivos_Merma
CREATE TABLE Motivos_Merma (
    ID_Motivo SERIAL PRIMARY KEY,
    Nombre_Motivo VARCHAR(50) NOT NULL UNIQUE,
    Descripcion TEXT
);

-- Tabla Categorias
CREATE TABLE Categorias (
    ID_Categoria SERIAL PRIMARY KEY,
    Nombre_Categoria VARCHAR(50) NOT NULL UNIQUE,
    Descripcion TEXT
);

-- Tabla Items
CREATE TABLE Items (
    ID_Item SERIAL PRIMARY KEY,
    Nombre_Item VARCHAR(100) NOT NULL,
    ID_Marca INT NOT NULL,
    ID_Proveedor INT NOT NULL,
    Descripcion TEXT,
    Precio_Venta DECIMAL(10, 2) CHECK (Precio_Venta >= 0),
    Porcentaje_Ganancia DECIMAL(5, 2) CHECK (Porcentaje_Ganancia >= 0),
    ID_Unidad_Base INT NOT NULL,
    FOREIGN KEY (ID_Marca) REFERENCES Marcas(ID_Marca) ON DELETE RESTRICT,
    FOREIGN KEY (ID_Proveedor) REFERENCES Proveedores(ID_Proveedor) ON DELETE RESTRICT,
    FOREIGN KEY (ID_Unidad_Base) REFERENCES Unidades_Medida(ID_Unidad) ON DELETE RESTRICT
);

-- Tabla Item_Categoria
CREATE TABLE Item_Categoria (
    ID_Item INT NOT NULL,
    ID_Categoria INT NOT NULL,
    PRIMARY KEY (ID_Item, ID_Categoria),
    FOREIGN KEY (ID_Item) REFERENCES Items(ID_Item) ON DELETE CASCADE,
    FOREIGN KEY (ID_Categoria) REFERENCES Categorias(ID_Categoria) ON DELETE RESTRICT
);

-- Tabla Inventario
CREATE TABLE Inventario (
    ID_Inventario SERIAL PRIMARY KEY,
    ID_Item INT NOT NULL,
    ID_Almacen INT NOT NULL,
    Cantidad_Total DECIMAL(10, 2) NOT NULL CHECK (Cantidad_Total >= 0),
    FOREIGN KEY (ID_Item) REFERENCES Items(ID_Item) ON DELETE RESTRICT,
    FOREIGN KEY (ID_Almacen) REFERENCES Almacenes(ID_Almacen) ON DELETE RESTRICT,
    UNIQUE (ID_Item, ID_Almacen)
);

-- Tabla Lotes
CREATE TABLE Lotes (
    ID_Lote SERIAL PRIMARY KEY,
    ID_Inventario INT NOT NULL,
    Numero_Lote VARCHAR(50) NOT NULL,
    Fecha_Vencimiento DATE,
    Cantidad DECIMAL(10, 2) NOT NULL CHECK (Cantidad >= 0),
    Precio_Compra DECIMAL(10, 2) NOT NULL CHECK (Precio_Compra >= 0),
    FOREIGN KEY (ID_Inventario) REFERENCES Inventario(ID_Inventario) ON DELETE CASCADE
);

-- Tabla Movimientos (Cabecera)
CREATE TABLE Movimientos (
    ID_Movimiento SERIAL PRIMARY KEY,
    ID_Almacen INT NOT NULL,
    ID_Almacen_Destino INT,
    ID_Tipo_Movimiento INT NOT NULL,
    Fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Fecha_Efectiva DATE NOT NULL DEFAULT CURRENT_DATE,
    ID_Usuario INT NOT NULL,
    Descripcion TEXT,
    FOREIGN KEY (ID_Almacen) REFERENCES Almacenes(ID_Almacen) ON DELETE RESTRICT,
    FOREIGN KEY (ID_Almacen_Destino) REFERENCES Almacenes(ID_Almacen) ON DELETE RESTRICT,
    FOREIGN KEY (ID_Tipo_Movimiento) REFERENCES Tipos_Movimiento(ID_Tipo_Movimiento) ON DELETE RESTRICT,
    FOREIGN KEY (ID_Usuario) REFERENCES Usuarios(ID_Usuario) ON DELETE RESTRICT
);

-- Tabla Movimiento_Detalle (Detalle)
CREATE TABLE Movimiento_Detalle (
    ID_Detalle SERIAL PRIMARY KEY,
    ID_Movimiento INT NOT NULL,
    ID_Lote INT,
    ID_Item INT NOT NULL,
    Cantidad DECIMAL(10, 2) NOT NULL CHECK (Cantidad > 0),
    ID_Unidad INT NOT NULL,
    Precio_Compra DECIMAL(10, 2),
    Fecha_Vencimiento DATE,
    ID_Motivo INT,
    FOREIGN KEY (ID_Movimiento) REFERENCES Movimientos(ID_Movimiento) ON DELETE CASCADE,
    FOREIGN KEY (ID_Lote) REFERENCES Lotes(ID_Lote) ON DELETE RESTRICT,
    FOREIGN KEY (ID_Item) REFERENCES Items(ID_Item) ON DELETE RESTRICT,
    FOREIGN KEY (ID_Unidad) REFERENCES Unidades_Medida(ID_Unidad) ON DELETE RESTRICT,
    FOREIGN KEY (ID_Motivo) REFERENCES Motivos_Merma(ID_Motivo) ON DELETE SET NULL
);

-- Disparador para actualizar Lotes
CREATE OR REPLACE FUNCTION actualizar_lotes()
RETURNS TRIGGER AS $$
DECLARE
    factor DECIMAL;
    cantidad_convertida DECIMAL(10, 2);
    nuevo_id_lote INT;
    id_inventario INT;
    id_inventario_destino INT;
    tipo_nombre VARCHAR(50);
BEGIN
    SELECT Factor_Conversion INTO factor FROM Unidades_Medida WHERE ID_Unidad = NEW.ID_Unidad;
    cantidad_convertida := NEW.Cantidad * factor;

    SELECT Nombre_Tipo INTO tipo_nombre
    FROM Tipos_Movimiento
    WHERE ID_Tipo_Movimiento = (SELECT ID_Tipo_Movimiento FROM Movimientos WHERE ID_Movimiento = NEW.ID_Movimiento);

    IF tipo_nombre = 'Entrada' THEN
        IF NEW.ID_Lote IS NULL THEN
            SELECT ID_Inventario INTO id_inventario
            FROM Inventario
            WHERE ID_Item = NEW.ID_Item
              AND ID_Almacen = (SELECT ID_Almacen FROM Movimientos WHERE ID_Movimiento = NEW.ID_Movimiento);

            IF id_inventario IS NULL THEN
                INSERT INTO Inventario (ID_Item, ID_Almacen, Cantidad_Total)
                VALUES (NEW.ID_Item, (SELECT ID_Almacen FROM Movimientos WHERE ID_Movimiento = NEW.ID_Movimiento), 0)
                RETURNING ID_Inventario INTO id_inventario;
            END IF;

            INSERT INTO Lotes (ID_Inventario, Numero_Lote, Fecha_Vencimiento, Cantidad, Precio_Compra)
            VALUES (id_inventario, 'Lote' || NEXTVAL('lotes_id_lote_seq'), NEW.Fecha_Vencimiento, 0, 0)
            RETURNING ID_Lote INTO nuevo_id_lote;

            UPDATE Movimiento_Detalle
            SET ID_Lote = nuevo_id_lote
            WHERE ID_Detalle = NEW.ID_Detalle;
            NEW.ID_Lote := nuevo_id_lote;
        END IF;

        UPDATE Lotes
        SET Cantidad = Cantidad + cantidad_convertida,
            Precio_Compra = COALESCE(NEW.Precio_Compra / factor, Precio_Compra)
        WHERE ID_Lote = NEW.ID_Lote;

    ELSIF tipo_nombre = 'Salida' OR tipo_nombre = 'Merma' OR tipo_nombre = 'Ajuste Negativo' THEN
        UPDATE Lotes
        SET Cantidad = Cantidad - cantidad_convertida
        WHERE ID_Lote = NEW.ID_Lote;
        IF (SELECT Cantidad FROM Lotes WHERE ID_Lote = NEW.ID_Lote) < 0 THEN
            RAISE EXCEPTION 'La cantidad no puede ser negativa';
        END IF;

    ELSIF tipo_nombre = 'Traslado' THEN
        UPDATE Lotes
        SET Cantidad = Cantidad - cantidad_convertida
        WHERE ID_Lote = NEW.ID_Lote;
        IF (SELECT Cantidad FROM Lotes WHERE ID_Lote = NEW.ID_Lote) < 0 THEN
            RAISE EXCEPTION 'La cantidad no puede ser negativa en el almacén origen';
        END IF;

        SELECT ID_Inventario INTO id_inventario_destino
        FROM Inventario
        WHERE ID_Item = NEW.ID_Item
          AND ID_Almacen = (SELECT ID_Almacen_Destino FROM Movimientos WHERE ID_Movimiento = NEW.ID_Movimiento);

        IF id_inventario_destino IS NULL THEN
            INSERT INTO Inventario (ID_Item, ID_Almacen, Cantidad_Total)
            VALUES (NEW.ID_Item, (SELECT ID_Almacen_Destino FROM Movimientos WHERE ID_Movimiento = NEW.ID_Movimiento), 0)
            RETURNING ID_Inventario INTO id_inventario_destino;
        END IF;

        INSERT INTO Lotes (ID_Inventario, Numero_Lote, Fecha_Vencimiento, Cantidad, Precio_Compra)
        SELECT id_inventario_destino, Numero_Lote, Fecha_Vencimiento, 0, Precio_Compra
        FROM Lotes WHERE ID_Lote = NEW.ID_Lote
        RETURNING ID_Lote INTO nuevo_id_lote;

        UPDATE Lotes
        SET Cantidad = Cantidad + cantidad_convertida
        WHERE ID_Lote = nuevo_id_lote;

    ELSIF tipo_nombre = 'Ajuste Positivo' THEN
        UPDATE Lotes
        SET Cantidad = Cantidad + cantidad_convertida
        WHERE ID_Lote = NEW.ID_Lote;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_actualizar_lotes
AFTER INSERT ON Movimiento_Detalle
FOR EACH ROW
EXECUTE FUNCTION actualizar_lotes();

-- Disparador para actualizar Inventario
CREATE OR REPLACE FUNCTION actualizar_inventario()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE Inventario
        SET Cantidad_Total = Cantidad_Total + NEW.Cantidad
        WHERE ID_Inventario = NEW.ID_Inventario;
    ELSIF TG_OP = 'UPDATE' THEN
        UPDATE Inventario
        SET Cantidad_Total = Cantidad_Total + (NEW.Cantidad - OLD.Cantidad)
        WHERE ID_Inventario = NEW.ID_Inventario;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE Inventario
        SET Cantidad_Total = Cantidad_Total - OLD.Cantidad
        WHERE ID_Inventario = OLD.ID_Inventario;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_actualizar_inventario
AFTER INSERT OR UPDATE OR DELETE ON Lotes
FOR EACH ROW
EXECUTE FUNCTION actualizar_inventario();

SELECT extname FROM pg_extension WHERE extname = 'vector';