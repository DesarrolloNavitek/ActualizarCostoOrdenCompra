--exec dbo.xp_NVK_ActualizaCostos 21088,20480.0,0,'L-0006',121.0
SET DATEFIRST 7  
SET ANSI_NULLS OFF  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET LOCK_TIMEOUT-1  
SET QUOTED_IDENTIFIER OFF  
GO 
IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'xp_NVK_ActualizaCostos' AND schema_id = SCHEMA_ID('dbo'))
DROP PROCEDURE dbo.xp_NVK_ActualizaCostos
GO
CREATE PROC  dbo.xp_NVK_ActualizaCostos
@ID			int,
@Renglon	float,
@RenglonSub	int,
@Articulo	varchar(20),
@CostoN		float
AS
BEGIN
DECLARE
@Cantidad		float,
@CantidadP		float

SELECT
	@Cantidad = Cantidad, @CantidadP = CantidadPendiente
FROM
	CompraD
WHERE
		ID 				= @ID
	AND RENGLON 		= @Renglon
	AND RENGLONSUB 		= @RenglonSub
	AND Articulo 		= @Articulo	

	
IF @CantidadP <= @Cantidad
BEGIN
	
UPDATE
	CompraD
SET
	Costo = @CostoN
WHERE
	ID 					= @ID
	AND RENGLON 		= @Renglon
	AND RENGLONSUB 		= @RenglonSub
	AND Articulo 		= @Articulo
	
	SELECT 'Se actualizo el costo con éxito'
	RETURN
END
ELSE

	SELECT 'La Cantidad Pendiente del Articulo '+@Articulo+' debe ser mayor a cero'
	RETURN

RETURN
END