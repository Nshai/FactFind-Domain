SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
Modification History (most recent first)
Date        Modifier        Issue          Description
----        ---------       -------        -------------
20230505    Saumya Rajan    IOSE22-1695    User Search list displayed alphabetically

*/
CREATE PROCEDURE [dbo].[SpCustomNIOUserSearchByGroup]
	@UserId INT,
	@UserIdentifier VARCHAR(255) = NULL,
	@GroupId INT = NULL
AS
DECLARE @IndigoClientId INT, @IsSecure bit = 0, @IsSuperUser bit, @UserGroupId bigint, @RefUserTypeId int

-- Get some details about the logged in user
SELECT @IndigoClientId = IndigoClientId, @RefUserTypeId = RefUserTypeId, @UserGroupId = GroupId, @IsSuperUser = SuperUser | SuperViewer
FROM Administration.dbo.TUser
WHERE UserId = @UserId

-- For standard users we need to see if the search has been secured for this tenant.
IF @IsSuperUser = 0
	SET @IsSecure = [Administration].[dbo].[FnIsUserSearchSecured](@IndigoClientId)

SELECT DISTINCT
	U.UserId
	, U.CRMContactId As CRMContactId
	, TRIM(U.Identifier) As UserIdentifier
	, C.FirstName AS FirstName
	, C.LastName As LastName
	, C.FirstName + ' ' + C.LastName As UserFullName
	, G.Identifier As GroupIdentifier
	, dbo.FnCustomRetrieveUserRoles(U.UserId) As Roles
	, U.Status As [Status]
	, '' AS LicenceTypeName
FROM 
	TUser U With(NoLock)
	INNER JOIN CRM..TCRMContact C With(NoLock) On C.CRMContactId = U.CRMContactId AND U.IndigoClientId = C.IndClientId 
	INNER JOIN TGroup G With(NoLock) On G.GroupId = U.GroupId
	LEFT JOIN TRole R With(NoLock) ON R.RoleId = U.ActiveRole
	LEFT OUTER JOIN TMembership M With(NoLock) ON M.UserId = U.UserId
WHERE
	1=1
	AND (U.RefUserTypeId = 1 OR (@RefUserTypeId = 6 AND U.RefUserTypeId = 6)) -- Filter Out All Users Except Standard User and Support User if the user searching is a Support User
	AND U.IndigoCLientId = @IndigoClientId
	AND (@UserIdentifier IS NULL OR U.Identifier LIKE @UserIdentifier + '%')
	AND (@GroupId IS NULL OR G.GroupId = @GroupId)
	-- if search has been secured then only show users in the current group or below.
	AND (@IsSecure = 0 OR U.GroupId IN (SELECT GroupId FROM [dbo].[FnGetGroupAndChildren](@UserGroupId)))
	ORDER BY TRIM(U.Identifier) ASC
GO
