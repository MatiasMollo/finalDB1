CREATE OR ALTER FUNCTION fn_total_comprado_cliente
(
	@cliente_id INT
)
RETURNS TABLE
AS 
RETURN
(
	SELECT SUM(dp.cantidad * dp.precio_unitario) as total_gastado FROM detalle_pedidos as dp
	JOIN pedidos as p on p.id = dp.pedido_id
	WHERE p.cliente_id = @cliente_id AND p.estado != 'CANCELADO'
	GROUP BY p.cliente_id
);