Create Procedure SpNCustomPartySecurityListUsersForGroupSecurity
	@TenantId bigint,
	@UserId bigint = null
As

------------------------------------------------
-- Superusers/Superviewers have access to all
-- RefUserTypeId = 1 only
-- Non Superusers/Superviewers have access to users in their group and lower
------------------------------------------------

declare @UserRightMask int, @Result int
exec @Result = SpNCustomPartySecurityGetIdsDefaults @DefaultRightMask = @UserRightMask output
If @Result <> 0 return @Result

Select UserId, GroupId
Into #Managers
From administration..TUser u
Where 1=1
And IndigoClientId = @TenantId
And SuperUser =0 and SuperViewer=0
And RefUserTypeId=1
And (@UserId Is Null OR (@UserId Is Not Null And UserId = @UserId ))

-- Select * From #Managers

-- Group hierarchy
Begin
	;WITH GroupHierarchy (UserId, GroupId, GroupParentId, GroupPartyId) AS
    (
    SELECT U.UserId, grp.GroupId, grp.ParentId as GroupParentId, grp.CRMContactId as GroupPartyId
    FROM administration..TGroup AS grp
	Join #Managers as U on grp.GroupId=U.GroupId
    WHERE 1=1
    And IndigoClientId = @TenantId
	And grp.CRMContactId is not null

    UNION ALL

    SELECT d.UserId, grp.GroupId, grp.ParentId as GroupParentId, grp.CRMContactId as GroupPartyId
    FROM administration..TGroup AS grp
    --INNER JOIN GroupHierarchy AS d ON grp.GroupId = d.ParentId -- navigate up the hierarchy
    INNER JOIN GroupHierarchy AS d ON grp.ParentId = d.GroupId -- navigate down the hierarchy
    Where 1=1
    And grp.IndigoClientId = @TenantId
	And grp.CRMContactId is not null
    )

    SELECT Distinct grp.UserId as ManagerUserId, grp.GroupId, GroupPartyId as CreatorPartyId, @UserRightMask as RightMask
    FROM GroupHierarchy grp
	Where 1=1 
    OPTION (MAXRECURSION 10)

End


