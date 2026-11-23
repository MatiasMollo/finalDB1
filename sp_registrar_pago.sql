CREATE OR ALTER PROCEDURE sp_registrar_pago
	@pedido_id INT,
	@importe DECIMAL(10,2)
AS
BEGIN 
	BEGIN TRY
		BEGIN TRANSACTION;
			IF NOT EXISTS (SELECT 1 FROM pedidos WHERE id = @pedido_id AND estado = 'PENDIENTE')
				THROW 50010, 'El pedido no existe o su estado no es "PENDIENTE"', 1;

			DECLARE @saldo DECIMAL(10,2);
				SELECT @saldo = SUM(pa.importe) FROM pagos as pa
				JOIN pedidos as p on p.id = pa.pedido_id
				WHERE pa.pedido_id = @pedido_id  AND p.estado != 'CANCELADO'
				GROUP BY p.id;

			DECLARE @deuda DECIMAL(10,2);
				SELECT @deuda = SUM(dp.cantidad * dp.precio_unitario) FROM detalle_pedidos as dp
				JOIN pedidos as p on p.id = dp.pedido_id
				WHERE p.estado != 'CANCELADO';
			
			IF @importe <= 0 OR @importe > (@deuda - ISNULL(@saldo,0))
				THROW 50020, 'El importe es inválido o supera el saldo que adeuda el cliente', 1;

			INSERT INTO pagos (pedido_id, importe, fecha) VALUES (@pedido_id, @importe, GETDATE());
			UPDATE pedidos SET estado = 'PAGADO' WHERE id = @pedido_id;

		COMMIT;
	END TRY
	BEGIN CATCH
		ROLLBACK;
		THROW;
	END CATCH
END