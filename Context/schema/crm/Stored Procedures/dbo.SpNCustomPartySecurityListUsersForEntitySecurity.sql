Create Procedure SpNCustomPartySecurityListUsersForEntitySecurity
	@TenantId bigint,
	@EntityId bigint,
	@RoleId bigint = null,
	@UserId bigint = null
As

If Not Exists(Select top 1 1 from administration..TEntity Where EntityId = @EntityId)
Begin
	Raiserror('EntityId not found',16,1)
	return 1
End

Declare @TenantIdInternal bigint = @TenantId
Create Table #Managers(UserId int, GroupId int, RightMask tinyint, Propogate tinyint, HasPolicy bit, MaxPolicyId int, RoleIdForRightMask int, RoleIdForPropogate int)
Create Table #UserRoles(UserId int, RoleId int)
Create Nonclustered Index IX_UserRoles_RoleId On #UserRoles(RoleId)
Create Nonclustered Index IX_UserRoles_UserId On #UserRoles(UserId)

Declare @DefaultRightMask tinyint, @Result int
Exec @Result = SpNCustomPartySecurityGetIdsDefaults @DefaultRightMask = @DefaultRightMask output
If @Result <> 0 return @Result

-- Which users belong to this policy's role (these users are likely to by managers)
Insert Into #Managers(UserId, GroupId, HasPolicy, MaxPolicyId)
SELECT DISTINCT -- This needs to be distinct as the membership table sometimes contains duplicates
		U.UserId, Max(U.GroupId), 
		Case when p.EntityId is null then 0 Else 1 End, Max(p.PolicyId)
FROM Administration..TUser U
Left Join Administration..TMembership M ON U.UserId = M.UserId
Left JOIN Administration..TRole R ON M.RoleId = R.RoleId AND R.IndigoClientId = @TenantIdInternal AND (@RoleId is null OR (@RoleId Is Not Null AND R.RoleId = @RoleId)) 
Left Join Administration..TPolicy P on R.RoleId = P.RoleId and P.EntityId = @EntityId AND P.IndigoClientId = @TenantIdInternal AND (@RoleId is null OR (@RoleId Is Not Null AND P.RoleId = @RoleId)) 
WHERE 1=1
	AND U.Status NOT LIKE 'Access Denied%'
	AND U.SuperUser = 0 AND U.SuperViewer = 0
	AND U.IndigoClientId = @TenantIdInternal
	AND U.RefUserTypeId = 1
	AND (@UserId is null OR (@UserId Is Not Null AND U.UserId = @UserId)) 
Group By P.IndigoClientId, U.UserId, EntityId

Update m
Set m.RightMask = p.RightMask, m.Propogate = p.Propogate, m.RoleIdForRightMask = p.RoleId, m.RoleIdForPropogate = p.RoleId
From #Managers m
Join Administration..TPolicy P on m.MaxPolicyId = p.PolicyId

-- select '#Managers', * From #Managers

	Create table #ManagersOtherRoleAccess
	(Id int Identity(1,1), UserId bigint, RoleId bigint, RightMask tinyint, 
		Propogate tinyint, UseForRightMask bit default(0), UseForPropogate bit default(0))

	Insert Into #ManagersOtherRoleAccess
	(UserId, RoleId, RightMask, Propogate)
	-- These managers may have other role that grants them higher privileges for the same entity
	Select Distinct a.UserId, r.RoleId, Max(p.RightMask) as RightMask, Max(convert(tinyint, p.Propogate)) as Progogate
	From #Managers a
	Join administration..TMembership m on a.UserId = m.UserId
	Join administration..TRole r on m.RoleId=r.RoleId
	Join administration..TPolicy p on r.RoleId=p.RoleId and p.EntityId=@EntityId
	Where 1=1
	and r.RoleId <> a.RoleIdForRightMask
	and p.IndigoClientId = @TenantIdInternal
	and r.IndigoClientId = @TenantIdInternal
	Group By a.UserId, r.RoleId

	Update a
	Set a.RoleIdForRightMask = b.RoleId, a.RightMask=b.RightMask
	From #Managers a
	Join (
			Select distinct b.UserId, Max(b.RoleId) as RoleId, Max(A.RightMask) as RightMask
			From (
					select UserId, Max(RightMask) as RightMask
					From #ManagersOtherRoleAccess
					Group by UserId
				 ) a
			Join #ManagersOtherRoleAccess b on a.UserId = b.UserId and a.RightMask=b.RightMask
			Group by b.UserId
		) b on a.UserId = b.UserId
	Where b.RightMask > a.RightMask

	Update a
	Set a.RoleIdForPropogate = b.RoleId, a.Propogate=b.Propogate
	From #Managers a
	Join (
			Select distinct b.UserId, Max(b.RoleId) as RoleId, Max(A.Propogate) as Propogate
			From (
					select UserId, Max(Propogate) as Propogate
					From #ManagersOtherRoleAccess
					Group by UserId
				 ) a
			Join #ManagersOtherRoleAccess b on a.UserId = b.UserId and a.Propogate=b.Propogate
			Group by b.UserId
		) b on a.UserId = b.UserId
	Where b.Propogate > a.Propogate

	
Insert Into #UserRoles(UserId, RoleId)
Select UserId, RoleIdForRightMask
From #Managers
Union 
Select UserId, RoleIdForPropogate
From #Managers

--select * From #UserRoles


-- Propogate = 1
SELECT distinct Managers.UserId as ManagerUserId, Creators.UserId as CreatorUserId, Managers.RightMask
FROM #Managers Managers
-- Which Users can the managers see? We need to work down the organisational hierarchy to work this out
JOIN
	(
		SELECT DISTINCT creatorUser.UserId, G.GroupId, R.RoleId
		FROM Administration..TRole R 
		JOIN Administration..TGrouping Gpg ON Gpg.GroupingId = R.GroupingId
		JOIN Administration..TGroup G ON G.GroupingId = Gpg.GroupingId
		LEFT JOIN Administration..TGroup G2 ON G2.ParentId = G.GroupId And G2.IndigoClientId = @TenantIdInternal
		LEFT JOIN Administration..TGroup G3 ON G3.ParentId = G2.GroupId And G3.IndigoClientId = @TenantIdInternal
		LEFT JOIN Administration..TGroup G4 ON G4.ParentId = G3.GroupId And G4.IndigoClientId = @TenantIdInternal
		LEFT JOIN Administration..TGroup G5 ON G5.ParentId = G4.GroupId And G5.IndigoClientId = @TenantIdInternal
		JOIN Administration..TUser creatorUser ON (creatorUser.GroupId = G.GroupId OR creatorUser.GroupId = G2.GroupId 
			OR creatorUser.GroupId = G3.GroupId OR creatorUser.GroupId = G4.GroupId OR creatorUser.GroupId = G5.GroupId)
		--Join #UserRoles ur on r.RoleId = ur.RoleId --and u.UserId = ur.UserId
		WHERE 1=1
		And creatorUser.RefUserTypeId = 1
		And creatorUser.IndigoClientId = @TenantIdInternal
		And R.IndigoClientId = @TenantIdInternal
		And G.IndigoClientId = @TenantIdInternal
		And Gpg.IndigoClientId = @TenantIdInternal
		And R.RoleId In (Select Distinct RoleId From #UserRoles)
	) Creators ON Creators.GroupId = Managers.GroupId
Join #UserRoles roles on Managers.UserId = roles.UserId
WHERE 1=1
	And Managers.Propogate=1
	And Managers.HasPolicy=1
	And Managers.UserId <> Creators.UserId

Union All

-- Propogate = 0
SELECT distinct Managers.UserId, Creators.UserId, Managers.RightMask
FROM #Managers Managers
-- Which Users can the managers see, this equates to all users in the same group?
JOIN Administration..TUser Creators ON Creators.GroupId = Managers.GroupId 
WHERE 1=1 
	And Managers.Propogate=0
	And Managers.UserId <> Creators.UserId
	And HasPolicy=1
	And Creators.IndigoClientId = @TenantIdInternal
	And Creators.RefUserTypeId=1

Union All

-- Users have access to themselves with read/write access
SELECT distinct Managers.UserId, Managers.UserId, @DefaultRightMask
FROM #Managers Managers
Where 1=1


return 0


