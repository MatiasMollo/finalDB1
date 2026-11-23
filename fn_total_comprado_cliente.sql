CREATE OR ALTER FUNCTION fn_total_comprado_cliente
(
	@cliente_id INT
)
RETURNS DECIMAL(10,2)
AS 
BEGIN
	DECLARE @total DECIMAL(10,2);

	SELECT @total = SUM(dp.cantidad * dp.precio_unitario)
	FROM detalle_pedidos as dp
	JOIN pedidos as p on p.id = dp.pedido_id
	WHERE p.cliente_id = @cliente_id AND p.estado != 'CANCELADO'

	RETURN ISNULL(@total,0);
END;