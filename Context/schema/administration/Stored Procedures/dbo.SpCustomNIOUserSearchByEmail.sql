SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
Modification History (most recent first)
Date        Modifier        Issue          Description
----        ---------       -------        -------------
20231218    Rahul E R       SE-3682        Additional Field - User List Reports [EPIC- 3457]
20230505    Saumya Rajan    IOSE22-1695    User Search list displayed alphabetically

*/
CREATE PROCEDURE [dbo].[SpCustomNIOUserSearchByEmail]
	@UserId INT,
	@UserIdentifier VARCHAR(255) = NULL,
	@Email VARCHAR(255) = NULL
AS
DECLARE @IndigoClientId INT, @IsSecure bit = 0, @IsSuperUser bit, @UserGroupId bigint, @RefUserTypeId int

-- Get some details about the logged in user
SELECT @IndigoClientId = IndigoClientId, @RefUserTypeId = RefUserTypeId, @UserGroupId = GroupId, @IsSuperUser = SuperUser | SuperViewer
FROM Administration.dbo.TUser
WHERE UserId = @UserId

;With CTE(CreatedByUserFullName,UserId) As (
	SELECT contact.FirstName + ' ' + contact.LastName,[user].UserId FROM administration..TUser AS [user] INNER JOIN crm..TCRMContact contact ON [user].CRMContactId = contact.CRMContactId 
)
SELECT CreatedByUserFullName,UserId INTO #CreatedBy FROM CTE

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
	, CONVERT(VARCHAR,C.CreatedDate,103) CreatedDate
	, [user].CreatedByUserFullName As CreatedBy
FROM 
	TUser U With(NoLock)
	Inner Join CRM..TCRMContact C With(NoLock) On C.CRMContactId = U.CRMContactId AND U.IndigoClientId = C.IndClientId
	Inner Join TGroup G With(NoLock) On G.GroupId = U.GroupId
	Left Join TRole R With(NoLock) ON R.RoleId = U.ActiveRole
	LEFT Outer Join TMembership M With(NoLock) ON M.UserId = U.UserId
	LEFT JOIN crm..TPerson P With(NoLock) ON P.PersonId = C.PersonId
	LEFT JOIN #CreatedBy [user] ON [user].UserId = P.CreatedByUserId
WHERE
	1=1
	AND (U.RefUserTypeId = 1 OR (@RefUserTypeId = 6 AND U.RefUserTypeId = 6)) -- Filter Out All Users Except Standard User and Support User if the user searching is a Support User
	And U.IndigoCLientId = @IndigoClientId
	AND (@UserIdentifier IS NULL OR U.Identifier LIKE @UserIdentifier + '%')
	AND (@Email IS NULL OR U.Email LIKE @Email + '%')
	-- if search has been secured then only show users in the current group or below.
	AND (@IsSecure = 0 OR U.GroupId IN (SELECT GroupId FROM [dbo].[FnGetGroupAndChildren](@UserGroupId)))
	ORDER BY TRIM(U.Identifier) ASC
GO
