Create Procedure SpNCustomPartySecurityManageCRMContactOwnerKeys
	@TenantId bigint,
	@PartyId bigint
As

Declare @Result int = 0, @CreatorUserId bigint, @EntityId bigint, @DeleteBatchSize int 
Declare @IsClient bit, @IsLead bit, @IsAdviser bit, @IsAccount bit, @PartyRoleId tinyint 

-- get entity id and party role id
exec @Result = SpNCustomPartySecurityGetCRMContactDetails @TenantId, @PartyId, @EntityId output, @PartyRoleId = @PartyRoleId output, 
		@CreatorUserId = @CreatorUserId output, @IsClient = @IsClient output,
		@IsLead = @IsLead output, @IsAccount = @IsAccount output
If @Result <> 0 return @Result

exec @result = dbo.SpNCustomPartySecurityGetIdsDefaultBatchSize @DeleteBatchSize = @DeleteBatchSize output
If @Result > 0 return @Result

If @CreatorUserId Is Null OR @PartyRoleId Is Null OR @EntityId Is Null
Begin
	Declare @Message varchar(100) = 'Invalid CRMContactOwnerChanged:'
	If @CreatorUserId Is Null Select @Message = @Message + '@CreatorUserId,'
	If @PartyRoleId Is Null Select @Message = @Message + '@PartyRoleId,'
	If @EntityId Is Null Select @Message = @Message + '@EntityId'

	Raiserror('Invalid CRMContactOwnerChanged', 16, 1)
	return 1
End

Create table #UserKeys(CreatorUserId int, ManagerUserId int, RightMask tinyint)
Insert Into #UserKeys(ManagerUserId, CreatorUserId,  RightMask)
exec @Result = SpNCustomPartySecurityListUsersForEntitySecurity @TenantId = @TenantId, @EntityId = @EntityId
If @Result > 0 return @Result

--select @EntityId, * From #UserKeys--  Where CreatorUserId=28005

While(1=1)
Begin
	DELETE Top (@DeleteBatchSize) 
	From pk
	From TPartyKey pk
	Where 1=1
	And TenantId=@TenantId
	And IsDerived = 1
	And PartyId = @PartyId
   
	If @@ROWCOUNT = 0
		break; 
End


If @IsClient = 1
Begin
	Insert Into TPartyKey
	(TenantId, UserId, PartyId, RightMask, IsDerived, PartyRoleId)
	Select @TenantId, ManagerUserId, c.CRMContactId, u.RightMask, 1, @PartyRoleId
	From #UserKeys u
	Join TCRMContact c on u.CreatorUserId = c._OwnerId
	Where 1=1
	And c._OwnerId Is Not Null
	And RefCRMContactStatusId is not null and RefCRMContactStatusId = 1
	And c.IndClientId = @TenantId
	And c.CRMContactId = @PartyId
	And u.RightMask > 0
End
Else If @IsLead = 1
Begin
	Insert Into TPartyKey
	(TenantId, UserId, PartyId, RightMask, IsDerived, PartyRoleId)
	Select @TenantId, ManagerUserId, c.CRMContactId, u.RightMask, 1, @PartyRoleId
	From #UserKeys u
	Join TCRMContact c on u.CreatorUserId = c._OwnerId
	Where 1=1
	And c._OwnerId Is Not Null
	And RefCRMContactStatusId is not null and RefCRMContactStatusId = 2
	And c.IndClientId = @TenantId
	And c.CRMContactId = @PartyId
	And u.RightMask > 0
End
Else If @IsAccount=1
Begin
	Insert Into TPartyKey
	(TenantId, UserId, PartyId, RightMask, IsDerived, PartyRoleId)
	Select @TenantId, ManagerUserId, c.CRMContactId, u.RightMask, 1, @PartyRoleId
	From #UserKeys u
	Join TCRMContact c on u.CreatorUserId = c._OwnerId
	Join TAccount a on c.CRMContactId = a.CRMContactId
	Where 1=1
	And c._OwnerId Is Not Null
	And c.IndClientId = @TenantId
	And a.IndigoClientId = @TenantId
	And c.CRMContactId = @PartyId
	And u.RightMask > 0
End


