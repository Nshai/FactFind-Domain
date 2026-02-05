Create Procedure SpNCustomPartySecurityListUsersForUserSecurity
	@TenantId bigint,
	@UserId bigint = null,
	@AdviserOnly bit = null
As

------------------------------------------------
-- Superusers/Superviewers have access to all
-- RefUserTypeId = 1 only
-- Non Superusers/Superviewers have access to users in their group and lower
-- Status: 'Access Granted%'
------------------------------------------------

declare @UserRightMask int, @Result int
exec @Result = SpNCustomPartySecurityGetIdsDefaults @DefaultRightMask = @UserRightMask output
If @Result <> 0 return @Result

Select UserId, GroupId, CRMContactId
Into #Managers
From administration..TUser u
Where 1=1
And IndigoClientId = @TenantId
And SuperUser =0 and SuperViewer=0
And u.Status like 'Access Granted%'
And RefUserTypeId=1
And (@UserId Is Null OR (@UserId Is Not Null And UserId = @UserId ))

If @AdviserOnly is not null and @AdviserOnly = 0
Begin
	delete from m
	from #Managers m
	join TPractitioner p on m.CRMContactId = p.CRMContactId
	Where p.IndClientId = @TenantId
End
Else If @AdviserOnly is not null and @AdviserOnly = 1
Begin
	delete from m
	from #Managers m
	left join TPractitioner p on m.CRMContactId = p.CRMContactId and p.IndClientId = @TenantId
	Where p.CRMContactId is null
End
-- Select * From #Managers

-- Group hierarchy
Begin
	;WITH GroupHierarchy (UserId, GroupId, GroupParentId) AS
    (
    SELECT U.UserId, grp.GroupId, grp.ParentId as GroupParentId
    FROM administration..TGroup AS grp
	Join #Managers as U on grp.GroupId=U.GroupId
    WHERE 1=1
    And IndigoClientId = @TenantId
    UNION ALL
    SELECT d.UserId, grp.GroupId, grp.ParentId as GroupParentId
    FROM administration..TGroup AS grp
    --INNER JOIN GroupHierarchy AS d ON grp.GroupId = d.ParentId -- navigate up the hierarchy
    INNER JOIN GroupHierarchy AS d ON grp.ParentId = d.GroupId -- navigate down the hierarchy
    Where 1=1
    And grp.IndigoClientId = @TenantId
    )

    SELECT Distinct grp.UserId as ManagerUserId, grp.GroupId, u.UserId as CreatorUserId, u.CRMContactId as CreatorPartyId, @UserRightMask as RightMask
    FROM GroupHierarchy grp
	Join administration..TUser u On grp.GroupId = u.GroupId
	Where 1=1 
	And IndigoClientId = @TenantId
	And u.CRMContactId is not null
	And u.RefUserTypeId = 1
--    order by  grp.UserId
    OPTION (MAXRECURSION 10)

End

