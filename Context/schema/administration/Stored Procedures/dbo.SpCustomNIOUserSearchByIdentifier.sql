SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
Modification History (most recent first)
Date        Modifier        Issue                       Description
----        ---------       -------                     -------------
20250212    Nick Fairway    DEF-19197                   Performance tweak (apprx 20* faster)
20231218    Rahul E R       SE-3682                     Additional Field - User List Reports [EPIC- 3457]
20230505    Saumya Rajan    IOSE22-1695                 User Search list displayed alphabetically
*/
CREATE PROCEDURE dbo.SpCustomNIOUserSearchByIdentifier
	@UserId INT,
	@UserIdentifier VARCHAR(255) = NULL,
	@FirstName VARCHAR(255) = NULL,
	@LastName VARCHAR(255) = NULL,
	@Email VARCHAR(255) = NULL,
	@Status VARCHAR(255) = NULL,
	@GroupId INT = 0,
	@RoleName VARCHAR(255) = NULL,
	@LicenseTypeId INT = 0,
	@SearchCaller Varchar(50) = NULL
AS
DECLARE @IndigoClientId INT, @IsSecure bit = 0, @IsSuperUser bit, @UserGroupId bigint, @RefUserTypeId int

CREATE TABLE #CreatedBy (UserId INT NOT NULL PRIMARY KEY, CreatedByUserFullName Char (101))

-- Get some details about the logged in user
SELECT @IndigoClientId = IndigoClientId, @RefUserTypeId = RefUserTypeId, @UserGroupId = GroupId, @IsSuperUser = SuperUser | SuperViewer
FROM Administration.dbo.TUser
WHERE UserId = @UserId

;With CTE(UserId, CreatedByUserFullName) As (
	SELECT [user].UserId, contact.FirstName + ' ' + contact.LastName
	FROM administration..TUser AS [user] 
	INNER JOIN crm..TCRMContact contact ON [user].CRMContactId = contact.CRMContactId
	WHERE contact.IndClientId = @IndigoClientId
	AND [user].IndigoClientId = @IndigoClientId
)

INSERT #CreatedBy
SELECT UserId, CreatedByUserFullName  FROM CTE

-- For standard users we need to see if the search has been secured for this tenant.
IF @IsSuperUser = 0
	SET @IsSecure = [Administration].[dbo].[FnIsUserSearchSecured](@IndigoClientId)

IF @RoleName IS Not NULL Or @LicenseTypeId > 0 BEGIN
		
	SELECT DISTINCT U.UserId
		, U.CRMContactId As CRMContactId
		, TRIM(U.Identifier) As UserIdentifier
		, C.FirstName AS FirstName
		, C.LastName As LastName
		, C.FirstName + ' ' + C.LastName As UserFullName
		, G.Identifier As GroupIdentifier
		, dbo.FnCustomRetrieveUserRoles(U.UserId) As Roles
		, U.Status As [Status]
		, LT.LicenseTypeName AS LicenseTypeName
		, CONVERT(VARCHAR,C.CreatedDate,103) CreatedDate
		, [user].CreatedByUserFullName As CreatedBy
	FROM TUser U With(NoLock)
		Inner Join CRM..TCRMContact C With(NoLock) On C.CRMContactId = U.CRMContactId
		Inner Join TGroup G With(NoLock) On G.GroupId = U.GroupId
		inner Join TMembership M With(NoLock) ON M.UserId = U.UserId
		Inner Join TRole R With(NoLock) ON M.RoleId=R.RoleId
		Inner Join TRefLicenseType LT With(NoLock) ON R.RefLicenseTypeId=LT.RefLicenseTypeId
		LEFT JOIN crm..TPerson P With(NoLock) ON P.PersonId = C.PersonId
		LEFT JOIN #CreatedBy [user] ON [user].UserId = P.CreatedByUserId
	WHERE
		1 = 1
		AND (U.RefUserTypeId = 1 OR (@RefUserTypeId = 6 AND U.RefUserTypeId = 6)) -- Filter Out All Users Except Standard User and Support User if the user searching is a Support User
		And U.IndigoCLientId = @IndigoClientId
		AND (@UserIdentifier IS NULL OR U.Identifier LIKE @UserIdentifier + '%')
		AND (@FirstName IS NULL OR C.FirstName LIKE @FirstName + '%')
		AND (@LastName IS NULL OR C.LastName LIKE @LastName + '%')
		AND ( (U.GroupID = @GroupId) OR (@GroupId = 0) )
		AND (@RoleName IS NULL OR R.Identifier LIKE @RoleName)
		AND ( (LT.RefLicenseTypeId = @LicenseTypeId) OR (@LicenseTypeId = 0) )
		AND (
				(@Status IS NULL ) OR ( (@Status NOT LIKE 'Access Granted - All' AND U.Status LIKE @Status) 
											OR
										(@Status LIKE 'Access Granted - All' AND U.Status IN('Access Granted - Locked',
																					   'Access Granted - Logged In',
																					   'Access Granted - Not Logged In'))
				)
			)
		AND ( (@SearchCaller IS NULL) OR ( @SearchCaller = 'TaskUserSearch' AND U.Status NOT IN ('Archived - Not Logged In','Retired - Not Logged In')))
		AND (@Email IS NULL OR U.Email LIKE @Email + '%')
		-- if search has been secured then only show users in the current group or below.
		AND (@IsSecure = 0 OR U.GroupId IN (SELECT GroupId FROM [dbo].[FnGetGroupAndChildren](@UserGroupId)))
		ORDER BY TRIM(U.Identifier) ASC
END
ELSE BEGIN

	SELECT DISTINCT U.UserId
		, U.CRMContactId As CRMContactId
		, TRIM(U.Identifier) As UserIdentifier
		, C.FirstName AS FirstName
		, C.LastName As LastName
		, C.FirstName + ' ' + C.LastName As UserFullName
		, G.Identifier As GroupIdentifier
		, dbo.FnCustomRetrieveUserRoles(U.UserId) As Roles
		, U.Status As [Status]
		, LT.LicenseTypeName AS LicenseTypeName
		, CONVERT(VARCHAR,C.CreatedDate,103) CreatedDate
		, [user].CreatedByUserFullName As CreatedBy
	FROM TUser U With(NoLock)
        Inner Join CRM..TCRMContact C With(NoLock) On C.CRMContactId = U.CRMContactId
        Inner Join TGroup G With(NoLock) On G.GroupId = U.GroupId
        inner Join TMembership M With(NoLock) ON M.UserId = U.UserId
        Inner Join TRole R With(NoLock) ON M.RoleId=R.RoleId
        Inner Join TRefLicenseType LT With(NoLock) ON R.RefLicenseTypeId=LT.RefLicenseTypeId
        LEFT JOIN crm..TPerson P With(NoLock) ON P.PersonId = C.PersonId
		LEFT JOIN #CreatedBy [user] ON [user].UserId = P.CreatedByUserId
	WHERE  1 = 1
		AND (U.RefUserTypeId = 1 OR (@RefUserTypeId = 6 AND U.RefUserTypeId = 6)) -- Filter Out All Users Except Standard User and Support User if the user searching is a Support User
		And U.IndigoCLientId = @IndigoClientId
		AND (@UserIdentifier IS NULL OR U.Identifier LIKE @UserIdentifier + '%')
		AND (@FirstName IS NULL OR C.FirstName LIKE @FirstName + '%')
		AND (@LastName IS NULL OR C.LastName LIKE @LastName + '%')
		AND ( (U.GroupID = @GroupId) OR (@GroupId = 0) )
		AND (@RoleName IS NULL OR R.Identifier LIKE @RoleName)
		AND ( (LT.RefLicenseTypeId = @LicenseTypeId) OR (@LicenseTypeId = 0) )
		AND (
				(@Status IS NULL ) OR ( (@Status NOT LIKE 'Access Granted - All' AND U.Status LIKE @Status) 
											OR
										(@Status LIKE 'Access Granted - All' AND U.Status IN('Access Granted - Locked',
																					   'Access Granted - Logged In',
																					   'Access Granted - Not Logged In'))
				)
			)
		AND ( (@SearchCaller IS NULL) OR ( @SearchCaller = 'TaskUserSearch' AND U.Status NOT IN ('Archived - Not Logged In','Retired - Not Logged In')))
		AND (@Email IS NULL OR U.Email LIKE @Email + '%')
		-- if search has been secured then only show users in the current group or below.
		AND (@IsSecure = 0 OR U.GroupId IN (SELECT GroupId FROM [dbo].[FnGetGroupAndChildren](@UserGroupId)))
		ORDER BY TRIM(U.Identifier) ASC 
END
GO


