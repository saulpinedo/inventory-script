Diseña una base de datos en PostgreSQL para un sistema de inventario genérico que sea adaptable a diferentes tipos de almacenes (ferretería, abarrotes, farmacia). Incluye las siguientes características:

1. Empresas con sucursales y almacenes.
2. Usuarios con roles y permisos por sucursal.
3. Proveedores y marcas para ítems.
4. Ítems con categorías múltiples (ej. un medicamento puede ser analgésico y psicotrópico).
5. Unidades de medida flexibles (unidades, paquetes, kilos) con factores de conversión.
6. Inventario por almacén y lotes con cantidades decimales (DECIMAL(10,2)), fechas de vencimiento opcionales, y precios en DECIMAL(10,2).
7. Movimientos con cabecera (fecha de creación y fecha efectiva) y detalle, soportando tipos de movimiento: Entrada, Salida, Traslado, Merma, Ajuste Positivo y Ajuste Negativo.
8. Mermas con motivos específicos (vencimiento, daño, robo).
9. Disparadores para actualizar automáticamente Lotes e Inventario tras insertar en Movimiento_Detalle.
10. Corrección de errores mediante movimientos correctivos (Merma + Entrada).

Proporciona el script SQL completo con todas las tablas, claves foráneas, restricciones y disparadores. No incluyas datos de ejemplo, solo el esquema.