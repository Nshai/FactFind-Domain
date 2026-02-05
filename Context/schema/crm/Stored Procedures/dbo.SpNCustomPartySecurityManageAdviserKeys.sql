Create Procedure SpNCustomPartySecurityManageAdviserKeys
	@TenantId bigint,
	@UserId bigint = null,
	@AdviserId bigint = null
As

Declare @AdviserUserId bigint = null, @AdviserPartyId bigint = null

If @AdviserId Is Not Null
Begin
	Select @AdviserUserId = UserId , @AdviserPartyId = a.CRMContactId
	From administration..tuser a
	Join TPractitioner b on a.CRMContactId = b.CRMContactId
	Where 1=1
	And b.PractitionerId = @AdviserId
	And a.IndigoClientId = @TenantId
	And b.IndClientId = @TenantId
End

declare @AdviserPartyRoleId int, @AdviserEntityId tinyint, @Result int, @DeleteBatchSize int 
exec @Result = SpNCustomPartySecurityGetIds @IsAdviser=1, @PartyRoleId = @AdviserPartyRoleId output, @EntityId = @AdviserEntityId output
If @Result <> 0 return @Result

declare @UserPartyRoleId int, @UserEntityId int
exec @result = dbo.SpNCustomPartySecurityGetIds @IsUser=1, @PartyRoleId = @UserPartyRoleId output, @EntityId = @UserEntityId output
If @Result <> 0 return @Result

exec @result = dbo.SpNCustomPartySecurityGetIdsDefaultBatchSize @DeleteBatchSize = @DeleteBatchSize output
If @Result > 0 return @Result

-- Get user keys based on entity security
Create table #UserKeysFromEntitySecurity(CreatorUserId int, ManagerUserId int, RightMask tinyint)
Insert Into #UserKeysFromEntitySecurity(ManagerUserId, CreatorUserId,  RightMask)
exec @Result = SpNCustomPartySecurityListUsersForEntitySecurity @TenantId = @TenantId,  @EntityId = @AdviserEntityId, @UserId=@UserId 
If @Result <> 0 return @Result

--select 1,* From #UserKeysFromEntitySecurity where Creatoruserid = 28002

-- Get user keys base on user security
Create table #UserKeysFromUserSecurity (ManagerUserId bigint, GroupId bigint, CreatorUserId bigint, CreatorPartyId bigint, RightMask tinyint)
Insert Into #UserKeysFromUserSecurity
Exec @Result = SpNCustomPartySecurityListUsersForUserSecurity @TenantId = @TenantId , @UserId = @UserId--, @AdviserOnly=1
If @Result <> 0 return @Result

--select 2,* From #UserKeysFromUserSecurity where Creatoruserid = 28002

If @AdviserUserId Is Not Null
Begin
	Delete #UserKeysFromEntitySecurity Where CreatorUserId <> @AdviserUserId
	Delete #UserKeysFromUserSecurity Where CreatorUserId <> @AdviserUserId
End

create table #Merged(ManagerUserId bigint, CreatorUserId bigint, RightMask tinyint, KeyType varchar(50))

declare @KeyTypeBoth varchar(20) = 'Both', @KeyTypeAdviserOnly varchar(20) = 'AdviserOnly', @KeyTypeUserOnly varchar(20) = 'UserOnly'

-- keys in both souces
Insert Into #Merged (ManagerUserId, CreatorUserId, RightMask, KeyType)
Select e.ManagerUserId, e.CreatorUserId, Case When max(e.RightMask) > max(u.RightMask) Then max(e.RightMask) Else max(u.RightMask) End, @KeyTypeBoth
From #UserKeysFromEntitySecurity e
Join #UserKeysFromUserSecurity u on e.ManagerUserId = u.ManagerUserId and e.CreatorUserId = u.CreatorUserId
Group by e.ManagerUserId, e.CreatorUserId

-- keys only in entity security
Insert Into #Merged (ManagerUserId, CreatorUserId, RightMask, KeyType)
Select e.ManagerUserId, e.CreatorUserId, max(e.RightMask), @KeyTypeAdviserOnly
From #UserKeysFromEntitySecurity e
Left Join #UserKeysFromUserSecurity u on e.ManagerUserId = u.ManagerUserId and e.CreatorUserId = u.CreatorUserId
Where u.ManagerUserId is null
Group by e.ManagerUserId, e.CreatorUserId

-- keys only in user security
Insert Into #Merged (ManagerUserId, CreatorUserId, RightMask, KeyType)
Select u.ManagerUserId, u.CreatorUserId, max(u.RightMask), @KeyTypeUserOnly
From #UserKeysFromUserSecurity u
Left Join #UserKeysFromEntitySecurity e on e.ManagerUserId = u.ManagerUserId and e.CreatorUserId = u.CreatorUserId
Where e.ManagerUserId is null
Group by u.ManagerUserId, u.CreatorUserId

--select'mer', @DeleteBatchSize, * From #Merged Order by ManagerUserId, CreatorUserId

-- delete exisitng keys
If @AdviserUserId Is Null
Begin
	While(1=1)
	Begin
		DELETE Top (@DeleteBatchSize) 
		From pk
		From TPartyKey pk
		Join #Merged uk on pk.UserId = uk.ManagerUserId
		Where 1=1
		And TenantId=@TenantId
		And IsDerived = 1
		And partyRoleId = @AdviserPartyRoleId
		And KeyType in (@KeyTypeBoth, @KeyTypeAdviserOnly)
		--And (@UserId is null or (@UserId is not null And uk.ManagerUserId Is Not Null))
   
		If @@ROWCOUNT < @DeleteBatchSize
			break; 
	End

	While(1=1)
	Begin
		DELETE Top (@DeleteBatchSize) 
		From pk
		From TPartyKey pk
		Join #Merged uk on pk.UserId = uk.ManagerUserId
		Where 1=1
		And TenantId=@TenantId
		And IsDerived = 1
		And partyRoleId = @UserPartyRoleId
		And KeyType in (@KeyTypeBoth, @KeyTypeUserOnly)
		--And (@UserId is null or (@UserId is not null And uk.ManagerUserId Is Not Null))
   
		If @@ROWCOUNT < @DeleteBatchSize
			break; 
	End
End
Else
Begin
	While(1=1)
	Begin
		DELETE Top (@DeleteBatchSize) 
		From pk
		From TPartyKey pk
		Join #Merged uk on pk.UserId = uk.ManagerUserId
		Where 1=1
		And TenantId=@TenantId
		And IsDerived = 1
		And partyRoleId in ( @AdviserPartyRoleId, @UserPartyRoleId)
		And PartyId=@AdviserPartyId

		If @@ROWCOUNT < @DeleteBatchSize
			break; 
	End
End


-- Create adviser keys
Begin
	-- Create adviser keys
	Insert Into TPartyKey
	(TenantId, UserId, PartyId, RightMask, IsDerived, PartyRoleId)
	Select distinct @TenantId, ManagerUserId, c.CRMContactId, u.RightMask, 1, @AdviserPartyRoleId
	From #Merged u
	Join TPractitioner c on u.CreatorUserId = c._OwnerId
	Where 1=1
	And c._OwnerId Is Not Null
	And c.IndClientId = @TenantId
	And u.RightMask > 0
	And KeyType in (@KeyTypeBoth, @KeyTypeAdviserOnly)

	-- Create user keys
	Insert Into TPartyKey
	(TenantId, UserId, PartyId, RightMask, IsDerived, PartyRoleId)
	Select distinct @TenantId, u.ManagerUserId, CreatorPartyId, u.RightMask, 1, @UserPartyRoleId
	From #Merged u
	Join #UserKeysFromUserSecurity us on u.ManagerUserId = us.ManagerUserId and u.CreatorUserId = us.CreatorUserId
	Where 1=1
	And KeyType in (@KeyTypeBoth, @KeyTypeUserOnly)
End

