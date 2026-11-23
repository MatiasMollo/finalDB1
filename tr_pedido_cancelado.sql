CREATE OR ALTER TRIGGER tr_pedido_cancelado
ON pedidos
AFTER UPDATE
AS
BEGIN
	IF EXISTS (SELECT 1 FROM pedidos WHERE id IN (SELECT id FROM inserted) AND estado = 'PAGADO')
	BEGIN
		ROLLBACK TRANSACTION;
		THROW 50010, 'El estado del pedido no permite cancelarlo', 1;
	END

	IF EXISTS (SELECT 1 FROM inserted WHERE estado = 'CANCELADO') AND NOT EXISTS (SELECT 1 FROM pedidos WHERE id = (SELECT id FROM inserted) AND estado = 'CANCELADO')
	BEGIN
		UPDATE libros SET stock = stock + pedido.cantidad FROM libros
		JOIN (
			SELECT dp.libro_id, SUM(dp.cantidad) as cantidad
			FROM detalle_pedidos as dp
			JOIN pedidos as p ON p.id = dp.pedido_id
			WHERE p.id IN (SELECT id FROM inserted) AND (SELECT estado FROM inserted) = 'CANCELADO'
			GROUP BY dp.libro_id
		) as pedido on pedido.libro_id = libros.id
	END
END