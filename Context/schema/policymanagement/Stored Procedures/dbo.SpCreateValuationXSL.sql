SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateValuationXSL]
	@StampUser varchar (255),
	@Description varchar(500)  = NULL, 
	@XSL varchar(7000) 	
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
	
	DECLARE @ValuationXSLId bigint
			
	
	INSERT INTO TValuationXSL (
		Description, 
		XSL, 
		ConcurrencyId)
		
	VALUES(
		@Description, 
		@XSL,
		1)

	SELECT @ValuationXSLId = SCOPE_IDENTITY()

	INSERT INTO TValuationXSLAudit (
		Description, 
		XSL, 
		ConcurrencyId,
		ValuationXSLId,
		StampAction,
    	StampDateTime,
    	StampUser)
	SELECT  
		Description, 
		XSL, 
		ConcurrencyId,
		ValuationXSLId,
		'C',
    	GetDate(),
    	@StampUser
	FROM TValuationXSL
	WHERE ValuationXSLId = @ValuationXSLId

	EXEC SpRetrieveValuationXSLById @ValuationXSLId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)

GO
