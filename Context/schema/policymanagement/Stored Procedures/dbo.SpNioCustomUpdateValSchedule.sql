-- drop Procedure SpNioCustomUpdateValSchedule
Create Procedure SpNioCustomUpdateValSchedule
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
	@Id bigint,
	@CreatedByUserId bigint
As

exec dbo.SpNioCustomOpenSymmetricKeyForPasswordEncryption

Declare @EncryptedPassword varbinary(4000)
Select @EncryptedPassword = [dbo].[FnCustomEncryptPortalPassword] (@PasswordForFileAccess)

UPDATE PolicyManagement.dbo.[TValSchedule] 
SET Guid = @Guid,
    ScheduledLevel = @ScheduledLevel,
    UserCredentialOption = @UserCredentialOption,
    StartDate = @StartDate,
    Frequency = @Frequency,
    IsLocked = @IsLocked,
    UserNameForFileAccess = @UserNameForFileAccess,
    Password2ForFileAccess = @EncryptedPassword,
    ConcurrencyId = @ConcurrencyId,
    IndigoClientId = @IndigoClientId,
    ClientCRMContactId = @ClientCRMContactId,
    PortalCRMContactId = @PortalCRMContactId,
    RefProdProviderId = @RefProdProviderId,
    RefGroupId = @RefGroupId,
	CreatedByUserId = @CreatedByUserId

WHERE ValScheduleId = @Id

Select @@Rowcount


