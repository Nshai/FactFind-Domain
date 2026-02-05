Create Procedure SpNCustomPartySecurityManageEntitySecurityPolicyKeys
	@TenantId bigint,
	@PolicyId bigint = null,
	@UserId bigint = null
As

Select Distinct EntityId
Into #Entities
From administration..TPolicy
Where 1=1
	And IndigoClientId=@TenantId 
	And (@PolicyId is null Or (@PolicyId Is Not Null And PolicyId = @PolicyId))

If @@rowcount = 0
Begin
	Raiserror('Policy not found', 16, 1)
	return
End 

Declare @EntityId int
Declare @Result int, @DeleteBatchSize int
Declare @IsClient bit, @IsLead bit, @IsAdviser bit, @IsAccount bit, @PartyRoleId tinyint


While(1=1)
Begin

	Select @EntityId = EntityId From #Entities
	
	If @@rowcount = 0
	Begin
		break
	End 

	exec @Result = SpNCustomPartySecurityGetIdsForEntityId @EntityId, @IsClient output, @IsLead output, @IsAdviser output, @IsAccount output, @PartyRoleId output
	If @Result <> 0 return @Result
 
	exec @result = dbo.SpNCustomPartySecurityGetIdsDefaultBatchSize @DeleteBatchSize = @DeleteBatchSize output
	If @Result <> 0 return @Result

	If @IsAdviser = 1
	Begin
		exec @Result = SpNCustomPartySecurityManageAdviserKeys @TenantId = @TenantId, @UserId = @UserId
		return @Result
	End
	
	Create table #UserKeys(CreatorUserId int, ManagerUserId int, RightMask tinyint)
	Insert Into #UserKeys(ManagerUserId, CreatorUserId, RightMask)
	exec @Result= SpNCustomPartySecurityListUsersForEntitySecurity @TenantId = @TenantId,  @EntityId =@EntityId, @UserId=@UserId 
	If @Result <> 0 return @Result

	--select * From #UserKeys

	While(1=1)
	Begin
		DELETE Top (@DeleteBatchSize) 
		From pk
		From TPartyKey pk
		Join #UserKeys uk on pk.userid = uk.ManagerUserId
		Where 1=1
		And TenantId=@TenantId
		And IsDerived = 1
		And partyRoleId = @PartyRoleId
   
		If @@ROWCOUNT = 0
			break; 
	End

	If @IsClient = 1
	Begin
		Insert Into TPartyKey
		(TenantId, UserId, PartyId, RightMask, IsDerived, PartyRoleId)
		Select @TenantId, ManagerUserId, c.CRMContactId, u.RightMask, 1, @PartyRoleId
		From #UserKeys u
		Join dbo.TCRMContact c on u.CreatorUserId = c._OwnerId
		Where 1=1
		And c._OwnerId Is Not Null
		And RefCRMContactStatusId is not null and RefCRMContactStatusId = 1
		And c.IndClientId = @TenantId
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
	End
	Else If @IsAccount = 1
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
	End

	Delete From #Entities Where EntityId = @EntityId 
	Drop table #UserKeys
End

return 0

