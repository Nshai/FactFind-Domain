SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpUpdateValPortalSetupByIdAndConcurrencyId]
	@KeyValPortalSetupId Bigint,
	@KeyConcurrencyId bigint,
	@StampUser varchar (255),
	@CRMContactId bigint, 
	@RefProdProviderId bigint, 
	@UserName varchar(50)  = NULL, 
	@Password varchar(255)  = NULL, 
	@ShowHowToScreen bit, 
	@CreatedDate datetime = NULL
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
			CRMContactId, 
			RefProdProviderId, 
			UserName, 
			Password, 
			ShowHowToScreen, 
			CreatedDate,
			ConcurrencyId,
			ValPortalSetupId,
			'U',
    		GetDate(),
    		@StampUser
		FROM TValPortalSetup T1
		WHERE ValPortalSetupId = @KeyValPortalSetupId And T1.ConcurrencyId = @KeyConcurrencyId
	UPDATE T1
	SET
		T1.CRMContactId = @CRMContactId, 
		T1.RefProdProviderId = @RefProdProviderId, 
		T1.UserName = @UserName, 
		T1.Password = @Password, 
		T1.ShowHowToScreen = @ShowHowToScreen, 
		T1.CreatedDate = @CreatedDate, 
		T1.ConcurrencyId = T1.ConcurrencyId + 1

	FROM TValPortalSetup T1
	WHERE  T1.ValPortalSetupId = @KeyValPortalSetupId And T1.ConcurrencyId = @KeyConcurrencyId
	
	SELECT * FROM TValPortalSetup [ValPortalSetup]
	WHERE [ValPortalSetup].ValPortalSetupId = @KeyValPortalSetupId And [ValPortalSetup].ConcurrencyId = @KeyConcurrencyId + 1
	FOR XML AUTO

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
