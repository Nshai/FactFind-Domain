SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateValUserSetup]
	@StampUser varchar (255),
	@UserId bigint, 
	@UseValuationFundsFg bit, 
	@UseValuationAssetsFg bit = 0	
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
	
	DECLARE @ValUserSetupId bigint
			
	
	INSERT INTO TValUserSetup (
		UserId, 
		UseValuationFundsFg, 
		UseValuationAssetsFg, 
		ConcurrencyId)
		
	VALUES(
		@UserId, 
		@UseValuationFundsFg, 
		@UseValuationAssetsFg,
		1)

	SELECT @ValUserSetupId = SCOPE_IDENTITY()
	
	INSERT INTO TValUserSetupAudit (
		UserId, 
		UseValuationFundsFg, 
		UseValuationAssetsFg, 
		ConcurrencyId,
		ValUserSetupId,
		StampAction,
    	StampDateTime,
    	StampUser)
	SELECT  
		UserId, 
		UseValuationFundsFg, 
		UseValuationAssetsFg, 
		ConcurrencyId,
		ValUserSetupId,
		'C',
    	GetDate(),
    	@StampUser
	FROM TValUserSetup
	WHERE ValUserSetupId = @ValUserSetupId
	EXEC SpRetrieveValUserSetupById @ValUserSetupId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
