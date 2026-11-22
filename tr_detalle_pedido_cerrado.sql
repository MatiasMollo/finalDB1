CREATE OR ALTER TRIGGER tr_detalle_pedido_cerrado
ON detalle_pedidos
AFTER INSERT, UPDATE
AS
BEGIN 
	IF (SELECT estado FROM pedidos as p WHERE p.id = (SELECT pedido_id FROM inserted)) IN ('PAGADO','CANCELADO')
	BEGIN
		ROLLBACK TRANSACTION;
		THROW 50010, 'El estado del pago no permite modificar su detalle', 1;
	END;
END;