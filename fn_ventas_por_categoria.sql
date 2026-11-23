CREATE OR ALTER FUNCTION fn_ventas_por_categoria
(
	@desde DATE,
	@hasta DATE
)
RETURNS TABLE AS RETURN
(
	SELECT 
		c.nombre as categoria, 
		SUM(ISNULL(dp.cantidad,0)) as unidades_vendidas, 
		SUM(ISNULL(dp.cantidad * precio_unitario,0)) as importe_vendido 
	FROM categorias as c
	LEFT JOIN libros as l on l.categoria_id = c.id
	LEFT JOIN (
		SELECT dp.libro_id, dp.cantidad, dp.precio_unitario FROM detalle_pedidos as dp
		JOIN pedidos as p ON p.id = dp.pedido_id
		WHERE p.estado != 'CANCELADO' AND p.fecha BETWEEN @desde AND DATEADD(DAY, @hasta,1) -- Contemplamos gastos durante el transcurso del último día
	) as dp on dp.libro_id = l.id
	GROUP BY c.nombre
)