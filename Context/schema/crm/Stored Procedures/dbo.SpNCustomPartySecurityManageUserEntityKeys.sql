Create Procedure SpNCustomPartySecurityManageUserEntityKeys
	@TenantId bigint,
	@UserId bigint = null,
	@ExtraData varchar(1000) = null
As

----------------------------------------
-- Get a list of users affected
-- Then select a policy for at least one role that each user has
-- 80% of users have a single role and we merge access if a user has multiple roles
----------------------------------------
declare @Result int
declare @UserIdToUse bigint = null

If @UserId is not null and @ExtraData is not null
Begin
	If CharIndex('StatusChanged', @ExtraData) > 0 OR CharIndex('SuperUserViewerChanged', @ExtraData) > 0
		Set @UserIdToUse = @UserId
End

exec @Result = dbo.SpNCustomPartySecurityManageEntitySecurityPolicyKeys @TenantId = @TenantId, @PolicyId = null, @UserId = @UserIdToUse 
If @Result > 0 return @Result

