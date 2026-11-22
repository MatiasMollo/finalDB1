CREATE OR ALTER PROCEDURE sp_crear_pedido
	@cliente_id INT,
	@libro_id INT,
	@cantidad INT,
	@pedido_id INT OUTPUT
AS BEGIN 
	BEGIN TRY
		BEGIN TRANSACTION;

		IF NOT EXISTS (SELECT 1 FROM clientes WHERE id = @cliente_id)
			THROW 50010, 'El cliente no existe', 1;

		IF NOT EXISTS (SELECT 1 FROM libros where id = @libro_id)
			THROW 50020, 'El libro no existe en la base de datos', 1;

		IF @cantidad > (SELECT stock from libros WHERE id = @libro_id)
			THROW 50021, 'No hay stock de libros suficientes', 1;

		IF @cantidad < 1
			THROW 50030, 'La cantidad debe ser mayor a 0', 1;

		INSERT INTO pedidos (cliente_id, fecha, estado) VALUES (@cliente_id, GETDATE(), 'PENDIENTE');
		SET @pedido_id = SCOPE_IDENTITY();
		
		INSERT INTO detalle_pedidos (pedido_id, libro_id, cantidad, precio_unitario) VALUES (
			@pedido_id,
			@libro_id,
			@cantidad,
			(SELECT precio FROM libros WHERE id = @libro_id)
		);

		COMMIT;
	END TRY
	BEGIN CATCH
		ROLLBACK;
		THROW;
	END CATCH
END;
