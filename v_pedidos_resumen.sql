CREATE OR ALTER VIEW v_pedidos_resumen
AS 
SELECT 
	p.id as pedido_id, c.nombre as cliente,
	p.fecha,
	p.estado,
	SUM(dp.cantidad) as cantidad_items,
	SUM(dp.cantidad * dp.precio_unitario) as total,
	CASE WHEN ((SELECT SUM(importe) FROM pagos WHERE pedido_id = p.id) > 0) THEN (SELECT SUM(importe) FROM pagos WHERE pedido_id = p.id) ELSE 0 END AS total_pagado,
	((SELECT SUM(importe) FROM pagos WHERE pedido_id = p.id) - SUM(dp.cantidad * dp.precio_unitario)) * -1 as saldo
FROM pedidos as p
JOIN clientes as c on c.id = p.cliente_id
JOIN detalle_pedidos as dp on dp.pedido_id = p.id
GROUP BY p.id, c.nombre, p.fecha, p.estado
