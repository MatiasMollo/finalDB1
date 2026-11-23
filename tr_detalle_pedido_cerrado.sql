CREATE OR ALTER TRIGGER tr_detalle_pedido_cerrado
ON detalle_pedidos
AFTER INSERT, UPDATE
AS
BEGIN 
	IF EXISTS (
		SELECT 1 FROM inserted as i 
		JOIN pedidos as p ON p.id = i.pedido_id
		WHERE p.estado IN ('PAGADO','CANCELADO')
	)
	BEGIN
		ROLLBACK TRANSACTION;
		THROW 50010, 'El estado del pago no permite modificar su detalle', 1;
	END;
END;