Create Procedure SpNCustomPartySecurityDeleteUserKeys
	@TenantId bigint,
	@UserId bigint = null,
	@ForceDelete bit = 0
As

------------------------------
/* 
If a user has 
 - been made a superuser / superview 
 - status is not 'access granted..'
 - no roles
 then we need to delete out their existing keys 
*/
------------------------------
Declare @result int, @DeleteBatchSize int 
exec @result = dbo.SpNCustomPartySecurityGetIdsDefaultBatchSize @DeleteBatchSize = @DeleteBatchSize output
If @result > 0 return @result

Create Table #UsersToDelete(ManagerUserId bigint)

If @ForceDelete = 0
Begin
	Insert Into #UsersToDelete
	(ManagerUserId)
	Select UserId
	From administration..TUser
	Where 1=1
	And IndigoClientId = @TenantId
	And [Status] Not Like 'Access Granted%'
	And (@UserId is null or (@UserId is not null and UserId = @UserId))

	Insert Into #UsersToDelete
	(ManagerUserId)
	Select UserId
	From administration..TUser
	Where 1=1
	And IndigoClientId = @TenantId
	And (SuperUser=1 Or SuperViewer=1)
	And (@UserId is null or (@UserId is not null and UserId = @UserId))

	Insert Into #UsersToDelete
	(ManagerUserId)
	Select u.UserId
	From administration..TUser u
	Left Join administration..TMembership m on u.UserId = m.UserId
	Where 1=1
	And IndigoClientId = @TenantId
	And (@UserId is null or (@UserId is not null and u.UserId = @UserId))
	And m.UserId is null
End
Else
Begin
	Insert Into #UsersToDelete
	(ManagerUserId)
	Select u.UserId
	From administration..TUser u
	Where 1=1
	And IndigoClientId = @TenantId
	And (@UserId is null or (@UserId is not null and u.UserId = @UserId))
End

While(1=1)
Begin
	DELETE Top (@DeleteBatchSize) 
	From pk
	From TPartyKey pk
	Join #UsersToDelete u on pk.UserId = u.ManagerUserId
	Where 1=1
	And TenantId=@TenantId
	And IsDerived = 1
   
	If @@ROWCOUNT = 0
		break; 
End

return 0

