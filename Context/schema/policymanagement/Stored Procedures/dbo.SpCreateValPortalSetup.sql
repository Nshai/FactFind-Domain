SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateValPortalSetup]
	@StampUser varchar (255),
	@CRMContactId bigint, 
	@RefProdProviderId bigint, 
	@UserName varchar(50)  = NULL, 
	@Password varchar(255)  = NULL, 
	@ShowHowToScreen bit = 1, 
	@CreatedDate datetime = NULL	
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
	IF @CreatedDate IS NULL SET @CreatedDate = getdate()
	
	DECLARE @ValPortalSetupId bigint
			
	
	INSERT INTO TValPortalSetup (
		CRMContactId, 
		RefProdProviderId, 
		UserName, 
		Password, 
		ShowHowToScreen, 
		CreatedDate, 
		ConcurrencyId)
		
	VALUES(
		@CRMContactId, 
		@RefProdProviderId, 
		@UserName, 
		@Password, 
		@ShowHowToScreen, 
		@CreatedDate,
		1)

	SELECT @ValPortalSetupId = SCOPE_IDENTITY()
	
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
		CRMContactId, 
		RefProdProviderId, 
		UserName, 
		Password, 
		ShowHowToScreen, 
		CreatedDate, 
		ConcurrencyId,
		ValPortalSetupId,
		'C',
    	GetDate(),
    	@StampUser
	FROM TValPortalSetup
	WHERE ValPortalSetupId = @ValPortalSetupId
	EXEC SpRetrieveValPortalSetupById @ValPortalSetupId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
