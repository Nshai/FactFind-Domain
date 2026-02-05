SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomApplyPolicyGetKeysWithoutPropogation]
	@PolicyId bigint,
	@UserId bigint = null -- get keys for a specific user
AS
--Declarations
DECLARE @RoleId bigint, @RightMask int, @AdvancedMask int

-- Get role & right information for the security policy
SELECT 
	@RoleId = RoleId, @RightMask = RightMask, @AdvancedMask = AdvancedMask 
FROM 
	TPolicy 
WHERE 
	PolicyId = @PolicyId

-- Now get the keys
SELECT 
	Creators.UserId AS CreatorId, 
	Managers.UserId AS UserId, 
	@RightMask AS RightMask, 
	@AdvancedMask AS AdvancedMask, 
	@RoleId AS RoleId
FROM
	-- Which users belong to this policy's role (these users are likely to by managers)
	(
	SELECT DISTINCT -- This needs to be distinct as the membership table sometimes contains duplicates
		U.UserId, U.GroupId
	FROM
		TMembership M 		
		JOIN TRole R ON R.RoleId = M.RoleId AND R.RoleId = @RoleId
		JOIN TUser U ON U.UserId = M.UserId
	WHERE
		(
			U.UserId = @UserId -- always generate keys for a specific user (this is so that new users get keys)
			OR (@UserId IS NULL	AND U.Status NOT LIKE 'Access Denied%') -- only generate keys for users that have access 
		)
		AND U.SuperUser = 0 AND U.SuperViewer = 0
	) Managers
	-- Which Users can the managers see, this equates to all users in the same group?
	JOIN TUser Creators ON Creators.GroupId = Managers.GroupId 
WHERE 
	@RightMask > 0
GO
