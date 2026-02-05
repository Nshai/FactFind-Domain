SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/*
	Custom SP for saving the portal details.
	LIO Procedure: SpCreateValPortalSetup
*/  

  
CREATE PROCEDURE [dbo].[nio_ContractEnquiry_CreateUserPortalSetup]
	@StampUser varchar (255),
	@CRMContactId bigint, 
	@RefProdProviderId bigint, 
	@UserName varchar(50)  = NULL, 
	@Password varchar(255)  = NULL, 
	@Passcode varchar(255) = NULL,
	@CreatedDate datetime = NULL	
AS

SET NOCOUNT ON

exec dbo.SpNioCustomOpenSymmetricKeyForPasswordEncryption

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
	IF @CreatedDate IS NULL SET @CreatedDate = getdate()
	
	DECLARE @ValPortalSetupId bigint
	
	exec dbo.SpNioCustomOpenSymmetricKeyForPasswordEncryption	
	
	Declare @EncryptedPassword varbinary(4000)
	Select @EncryptedPassword = [dbo].[FnCustomEncryptPortalPassword] (@Password)
	
	INSERT INTO TValPortalSetup (
		CRMContactId, 
		RefProdProviderId, 
		UserName, 
		Password2, 
		Passcode,
		CreatedDate, 
		ConcurrencyId)
		
	VALUES(
		@CRMContactId, 
		@RefProdProviderId, 
		@UserName, 
		@EncryptedPassword, 
		@Passcode,
		@CreatedDate,
		1)

	SELECT @ValPortalSetupId = SCOPE_IDENTITY()
	
	INSERT INTO TValPortalSetupAudit (
		CRMContactId, 
		RefProdProviderId, 
		UserName, 
		Password, 
		Password2, 
		Passcode,
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
		Password2, 
		Passcode,
		ShowHowToScreen, 
		CreatedDate, 
		ConcurrencyId,
		ValPortalSetupId,
		'C',
    	GetDate(),
    	@StampUser
	FROM TValPortalSetup
	WHERE ValPortalSetupId = @ValPortalSetupId


IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
