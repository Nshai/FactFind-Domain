SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpDeleteValPortalSetupByIdAndConcurrencyId]
	@ValPortalSetupId Bigint,
	@ConcurrencyId int,
	@StampUser varchar (255)
	
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
	
	INSERT INTO TValPortalSetupAudit (
		CRMContactId, 
		RefProdProviderId, 
		UserName, 
		Password, 
		ShowHowToScreen, 
		CreatedDate, 
		ConcurrencyId,
		ValPortalSetupId,
		StampAction,
    		StampDateTime,
    		StampUser)
		
	SELECT 
		T1.CRMContactId, 
		T1.RefProdProviderId, 
		T1.UserName, 
		T1.Password, 
		T1.ShowHowToScreen, 
		T1.CreatedDate, 
		T1.ConcurrencyId,
		T1.ValPortalSetupId,
		'D',
    		GetDate(),
    		@StampUser 
	FROM TValPortalSetup T1	
	WHERE T1.ValPortalSetupId = @ValPortalSetupId
	AND T1.ConcurrencyId = @ConcurrencyId
	
	

	DELETE T1 FROM TValPortalSetup T1
	WHERE T1.ValPortalSetupId = @ValPortalSetupId
	AND T1.ConcurrencyId = @ConcurrencyId

	SELECT 'deleted' = @@ROWCOUNT FOR XML RAW

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
