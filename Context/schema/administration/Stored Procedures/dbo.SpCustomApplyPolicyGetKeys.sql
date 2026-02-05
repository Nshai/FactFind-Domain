SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomApplyPolicyGetKeys]
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
	-- Which Users can the managers see? We need to work down the organisational hierarchy to work this out
	JOIN
		(
		SELECT DISTINCT
			U.UserId, G.GroupId
		FROM
			TRole R 
			JOIN TGrouping Gpg ON Gpg.GroupingId = R.GroupingId
			JOIN TGroup G ON G.GroupingId = Gpg.GroupingId
			LEFT JOIN TGroup G2 ON G2.ParentId = G.GroupId
			LEFT JOIN TGroup G3 ON G3.ParentId = G2.GroupId
			LEFT JOIN TGroup G4 ON G4.ParentId = G3.GroupId
			LEFT JOIN TGroup G5 ON G5.ParentId = G4.GroupId
			JOIN TUser U ON (U.GroupId = G.GroupId OR U.GroupId = G2.GroupId OR U.GroupId = G3.GroupId OR U.GroupId = G4.GroupId OR U.GroupId = G5.GroupId)
		WHERE
			R.RoleId = @RoleId
		) Creators ON Creators.GroupId = Managers.GroupId
WHERE 
	@RightMask > 0
GO
