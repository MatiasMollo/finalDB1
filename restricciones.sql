-- El stock negativo no tiene sentido y puede dar problemas en caso de restar de forma manual en la DB

ALTER TABLE libros ADD CONSTRAINT check_precio_libros CHECK(precio > 0);
ALTER TABLE detalle_pedidos ADD CONSTRAINT check_cantidad_detalle_pedido CHECK(cantidad > 0);

ALTER TABLE detalle_pedidos ADD constraint unique_pedido_libro UNIQUE (pedido_id, libro_id);

CREATE INDEX indice_nombre_clientes ON clientes(nombre);
CREATE INDEX indice_fecha_pedido ON pedidos(fecha);

ALTER TABLE libros ADD CONSTRAINT libros_check_min_stock CHECK(stock > 0);
