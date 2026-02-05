SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_SpCustomNIOCRMContactSearchByCorporateTrustNameAdvisorRefSecure]  
	@TenantId bigint,  
	@CorporateName  varchar(255) = NULL,  
	@Firstname  varchar(255) = NULL,  
	@LastName varchar(255) = NULL ,   
	@AdvisorRef  varchar(255) = '',  -- Doesn't appear to be used
	@ArchiveFG bit = 0,  -- Doesn't appear to be used
	@_UserId bigint,  
	@_TopN int = 0  
AS  
-- Check for super user
DECLARE @IsSuperUser bit = 0
SELECT @IsSuperUser = SuperUser | SuperViewer
FROM Administration..TUser WHERE UserId = @_UserId

-- Limit rows returned?  
IF (@_TopN > 0) SET ROWCOUNT @_TopN  
                 
SELECT  
	T1.CRMContactId AS [PartyId],   
	T1.AdvisorRef AS [AdvisorRef],   
	T1.ArchiveFg AS [ArchiveFg],   
	T1.LastName AS [LastName],   
	T1.FirstName AS [FirstName],   
	T1.CorporateName AS [CorporateName],   
	T1.CurrentAdviserName AS [CurrentAdviserName],   
	CASE  
		WHEN T1.CRMContactType = 1 THEN (T1.FirstName + ' ' + T1.LastName)  
		ELSE T1.CorporateName
	END AS [FullName],  
	T1.IndClientId AS [TenantId]  
FROM   
	TCRMContact T1  
	-- Secure clause  (we have two joins, one for ownership rights & one for specific user/role rights)  
	LEFT JOIN CRM.dbo.VwCRMContactKeyByCreatorId AS TCKey WITH(NOLOCK) ON TCKey.UserId = @_UserId And TCKey.CreatorId = T1._OwnerId 
	LEFT JOIN CRM.dbo.VwCRMContactKeyByEntityId AS TEKey WITH(NOLOCK) ON TEKey.UserId = @_UserId AND TEKey.EntityId = T1.CRMContactId 
WHERE   
	T1.IndClientId = @TenantId
	AND T1.RefCRMContactStatusId = 1   
	AND (T1.ArchiveFg = 0 OR T1.ArchiveFg IS NULL)  
	AND (@CorporateName IS NULL OR T1.CorporateName LIKE @CorporateName)
	AND (@LastName IS NULL OR T1.LastName LIKE @LastName)
	AND (@FirstName IS NULL OR T1.FirstName LIKE @FirstName)
	AND (@IsSuperUser = 1 OR (T1._OwnerId = @_UserId OR TCKey.CreatorId IS NOT NULL OR TEKey.EntityId IS NOT NULL))
ORDER BY 
	[LastName] DESC, [FirstName] DESC  
   
IF (@_TopN > 0) SET ROWCOUNT 0   
GO
