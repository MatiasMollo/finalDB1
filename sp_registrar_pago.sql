CREATE OR ALTER PROCEDURE sp_registrar_pago
	@pedido_id INT,
	@importe DECIMAL(10,2)
AS
BEGIN 
	BEGIN TRY
		BEGIN TRANSACTION;
			IF NOT EXISTS (SELECT 1 FROM pedidos WHERE id = @pedido_id AND estado = 'PENDIENTE')
				THROW 50010, 'El pedido no existe o su estado no es "PENDIENTE"', 1;
			
			IF @importe <= 0 OR @importe > (
				SELECT SUM(dp.cantidad * dp.precio_unitario) - SUM(ISNULL(pa.importe,0)) as deuda
				FROM detalle_pedidos as dp
				JOIN pedidos as p on p.id = dp.pedido_id
				LEFT JOIN pagos as pa ON pa.pedido_id = p.id
				WHERE p.id = @pedido_id AND p.estado != 'CANCELADO'
				GROUP BY p.id
			)
				THROW 50020, 'El importe es inválido o supera el saldo que adeuda el cliente', 1;

			INSERT INTO pagos (pedido_id, importe, fecha) VALUES (@pedido_id, @importe, GETDATE());

		COMMIT;
	END TRY
	BEGIN CATCH
		ROLLBACK;
		THROW;
	END CATCH
END