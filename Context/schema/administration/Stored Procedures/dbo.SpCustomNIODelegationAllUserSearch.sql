SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomNIODelegationAllUserSearch]
	@SearchTenantId BIGINT,
	@SearchTenantName varchar(500) = '',
	@UserName varchar(500) = '',
	@FirstName varchar(500) = '',
	@LastName varchar(500) = ''
	
AS

		
	SELECT DISTINCT U.UserId
		, U.CRMContactId As CRMContactId
		, U.Identifier As UserName
		, U.[Status] as UserCurrentStatus		
		, C.FirstName + ' ' + C.LastName As UserFullName
		, I.IndigoClientId as TenantId
		, I.Identifier as TenantName
		
			  
	FROM TUser U With(NoLock)
		Inner Join CRM..TCRMContact C With(NoLock) On C.CRMContactId = U.CRMContactId
		Inner Join TIndigoClient I with(nolock) ON U.IndigoClientId = I.IndigoClientId
		
	WHERE U.IndigoClientId = @SearchTenantId
	AND  I.IndigoClientId = @SearchTenantId
	AND C.IndClientId = @SearchTenantId
	AND ((ISNULL(@SearchTenantName, '') = '') OR (ISNULL(@SearchTenantName, '') != ''  AND I.Identifier like '%' + @SearchTenantName + '%'))
	AND ((ISNULL(@UserName, '') = '') OR (ISNULL(@UserName, '') != ''  AND U.Identifier like '%' + @UserName + '%'))
	AND ((ISNULL(@FirstName, '') = '') OR (ISNULL(@FirstName, '') != ''  AND C.FirstName like '%' + @FirstName + '%'))
	AND ((ISNULL(@LastName, '') = '') OR (ISNULL(@LastName, '') != ''  AND C.LastName like '%' + @LastName + '%'))

	--IP-21343 Hard coded for now, will create a blacklst if more requests come in
	AND U.IndigoClientId NOT IN (
		10816, --Cavendish Brooke
		14 -- In Focos
	)


GO
