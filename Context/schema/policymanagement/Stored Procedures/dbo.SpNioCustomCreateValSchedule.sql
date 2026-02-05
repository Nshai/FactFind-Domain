--drop Procedure SpNioCustomCreateValSchedule
Create Procedure SpNioCustomCreateValSchedule
	@Guid varchar(50), 
	@ScheduledLevel varchar(255), 
	@UserCredentialOption varchar(255), 
	@StartDate datetime, 
	@Frequency varchar(255),
	@IsLocked bit,
	@UserNameForFileAccess varchar(100),
	@PasswordForFileAccess varchar(100),
	@ConcurrencyId int,
	@IndigoClientId bigint,
	@ClientCRMContactId bigint,
	@PortalCRMContactId bigint,
	@RefProdProviderId bigint,
	@RefGroupId bigint,
	@CreatedByUserId bigint
As

exec dbo.SpNioCustomOpenSymmetricKeyForPasswordEncryption

Declare @EncryptedPassword varbinary(4000)
Select @EncryptedPassword = [dbo].[FnCustomEncryptPortalPassword] (@PasswordForFileAccess)

INSERT INTO PolicyManagement.dbo.[TValSchedule] 
( Guid, ScheduledLevel, UserCredentialOption, StartDate, Frequency,
    IsLocked, UserNameForFileAccess, Password2ForFileAccess, ConcurrencyId,
    IndigoClientId, ClientCRMContactId, PortalCRMContactId, RefProdProviderId, RefGroupId
	,CreatedByUserId) 
VALUES ( @Guid, @ScheduledLevel, @UserCredentialOption, @StartDate, @Frequency,
	@IsLocked, @UserNameForFileAccess, @EncryptedPassword, @ConcurrencyId,
	@IndigoClientId, @ClientCRMContactId, @PortalCRMContactId, @RefProdProviderId, 	@RefGroupId
	,@CreatedByUserId)
	
Select SCOPE_IDENTITY()
