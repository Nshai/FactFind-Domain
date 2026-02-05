Create Procedure SpNCustomPartySecurityManageGroupKeys
	@TenantId bigint,
	@UserId bigint = null
As

--------------------------------------------
-- This just manages the user access to groups
-- group hierarchy change also affects access all other entities. It is complicated to work out
-- which keys to remove and it can only happen in script and very in-frequently so we re-build the tenant to solve this.
--------------------------------------------
Declare @Result int, @DeleteBatchSize int 
declare @GroupPartyRoleId int, @GroupEntityId tinyint
exec SpNCustomPartySecurityGetIds @IsGroup=1, @PartyRoleId = @GroupPartyRoleId output, @EntityId = @GroupEntityId output
If @Result <> 0 return @Result


exec @result = dbo.SpNCustomPartySecurityGetIdsDefaultBatchSize @DeleteBatchSize = @DeleteBatchSize output
If @Result <> 0 return @Result

Create table #UserGroupHierarchy (ManagerUserId bigint, GroupId bigint, CreatorPartyId bigint, RightMask tinyint)

Insert Into #UserGroupHierarchy
Exec SpNCustomPartySecurityListUsersForGroupSecurity @TenantId = @TenantId, @UserId = @UserId
If @Result > 0 return @Result

While(1=1)
Begin
	DELETE Top (@DeleteBatchSize) 
	From pk
	From TPartyKey pk
	Join #UserGroupHierarchy u on pk.UserId = u.ManagerUserId
	Where 1=1
	And TenantId=@TenantId
	And IsDerived = 1
	And PartyRoleId=@GroupPartyRoleId
   
	If @@ROWCOUNT = 0
		break; 
End

Insert Into TPartyKey
(TenantId, UserId, PartyId, RightMask, IsDerived, PartyRoleId)
Select @TenantId, ManagerUserId, CreatorPartyId, RightMask, 1, @GroupPartyRoleId
From #UserGroupHierarchy u


