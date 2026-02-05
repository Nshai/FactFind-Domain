Create Procedure SpNCustomPartySecurityManageNonAdviserUserKeys
	@TenantId bigint,
	@UserId bigint = null,
	@ExtraData varchar(1000) = null
As


declare @UserPartyRoleId int, @UserEntityId tinyint, @Result int, @DeleteBatchSize int 
declare @UserIdToUse bigint = null
exec @result = dbo.SpNCustomPartySecurityGetIds @IsUser=1, @PartyRoleId = @UserPartyRoleId output, @EntityId = @UserEntityId output
If @Result <> 0 return @Result

exec @result = dbo.SpNCustomPartySecurityGetIdsDefaultBatchSize @DeleteBatchSize = @DeleteBatchSize output
If @Result <> 0 return @Result

If @UserId is not null and @ExtraData is not null
Begin
	If CharIndex('StatusChanged', @ExtraData) > 0 OR CharIndex('SuperUserViewerChanged', @ExtraData) > 0
		Set @UserIdToUse = @UserId
End

Create table #UserHierarchy (ManagerUserId bigint, GroupId bigint, CreatorUserId bigint, CreatorPartyId bigint, RightMask tinyint)

Insert Into #UserHierarchy
Exec @result = dbo.SpNCustomPartySecurityListUsersForUserSecurity @TenantId = @TenantId, @UserId = @UserIdToUse, @AdviserOnly=0
If @Result <> 0 return @Result

While(1=1)
Begin
	DELETE Top (@DeleteBatchSize) 
	From pk
	From TPartyKey pk
	Join #UserHierarchy u on pk.UserId = u.ManagerUserId
	Where 1=1
	And TenantId=@TenantId
	And IsDerived = 1
	And PartyRoleId=@UserPartyRoleId
   
	If @@ROWCOUNT = 0
		break; 
End

Insert Into TPartyKey
(TenantId, UserId, PartyId, RightMask, IsDerived, PartyRoleId)
Select @TenantId, ManagerUserId, CreatorPartyId, RightMask, 1, @UserPartyRoleId
From #UserHierarchy u


