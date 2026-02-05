USE [policymanagement]
GO

/****** Object:  StoredProcedure [dbo].[nio_ContractEnquiry_UpdateUserPortalSetup]    Script Date: 07/11/2013 10:13:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


/*
	Custom SP for saving the portal details.
	LIO Procedure: SpUpdateValPortalSetupById
*/  

  
CREATE PROCEDURE [dbo].[nio_ContractEnquiry_UpdateUserPortalSetup]
	@ValPortalSetupId Bigint,
	@StampUser varchar (255),
	@RefProdProviderId bigint, 
	@UserName varchar(50)  = NULL, 
	@Password varchar(255)  = NULL, 
	@Passcode varchar(255) = NULL,
	@CreatedDate datetime = getdate
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
			'U',
	    	GetDate(),
	    	@StampUser
		FROM TValPortalSetup
		WHERE ValPortalSetupId = @ValPortalSetupId

	exec dbo.SpNioCustomOpenSymmetricKeyForPasswordEncryption	
	
	Declare @EncryptedPassword varbinary(4000)
	Select @EncryptedPassword = [dbo].[FnCustomEncryptPortalPassword] (@Password)
	
	
	UPDATE T1
	SET
		T1.RefProdProviderId = @RefProdProviderId,
		T1.UserName = @UserName,
		T1.Password2 = @EncryptedPassword,
		T1.Passcode = @Passcode,
		T1.CreatedDate = @CreatedDate,
		T1.ConcurrencyId = T1.ConcurrencyId + 1
		
	FROM TValPortalSetup T1
	WHERE  T1.ValPortalSetupId = @ValPortalSetupId


IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)


GO


