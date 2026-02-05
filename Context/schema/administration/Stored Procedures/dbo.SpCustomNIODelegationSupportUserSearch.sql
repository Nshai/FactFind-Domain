SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomNIODelegationSupportUserSearch]
	@SearchTenantId BIGINT = 0, --TenantId as aParameter is a reserved word and assumes you users current logged in tenant Id ... which is WRONG for this  cross tenant search
	@SearchTenantName varchar(500) = ''
	
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
		Inner Join TIndigoClient I with(nolock) ON U.IndigoClientId = I .IndigoClientId
		
	WHERE U.RefUserTypeId = 6 -- Support Users  only
	AND ((@SearchTenantId = 0) OR (@SearchTenantId > 0 AND I.IndigoClientId = @SearchTenantId))
	AND ((ISNULL(@SearchTenantName, '') = '') OR (ISNULL(@SearchTenantName, '') != ''  AND I.Identifier like '%' + @SearchTenantName + '%'))
	
	--IP-21343 Hard coded for now, will create a blacklst if more requests come in
	AND U.IndigoClientId NOT IN (
		10816, --Cavendish Brooke
		14 -- In Focos
	)
GO
