CREATE OR ALTER PROCEDURE sp_cancelar_pedidos_vencidos
	@dias INT
AS
BEGIN 
	BEGIN TRY
		BEGIN TRANSACTION

		IF @dias < 0
		THROW 50010, 'La cantidad de días no puede ser negativo', 1;

		DECLARE @resultado as TABLE (
			pedido_id INT,
			cliente_id INT,
			dias_antiguedad INT
		);

		DECLARE @pedido_id INT;

		DECLARE cursor_pedidos CURSOR FOR
			SELECT id as pedido_id FROM pedidos as p 
			WHERE p.estado = 'PENDIENTE' AND fecha < GETDATE() - @dias;

		OPEN cursor_pedidos;
		FETCH NEXT FROM cursor_pedidos INTO @pedido_id;

		WHILE @@FETCH_STATUS = 0
		BEGIN
			UPDATE pedidos set estado = 'CANCELADO' where id = @pedido_id;
			FETCH NEXT FROM cursor_pedidos INTO @pedido_id;
		END;

		CLOSE cursor_pedidos;
		DEALLOCATE cursor_pedidos;
		
		COMMIT
	END TRY
	BEGIN CATCH
		ROLLBACK;
		CLOSE cursor_pedidos;
		DEALLOCATE cursor_pedidos;
		THROW;
	END CATCH
END
