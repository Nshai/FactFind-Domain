SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/*
Modification History (most recent first)
Date        Modifier        Issue          Description
----        ---------       -------        -------------
20230505    Saumya Rajan    IOSE22-1695    User Search list displayed alphabetically

*/
CREATE PROCEDURE dbo.nio_SpCustomSearchActiveAdvisers
	@TenantId INT,
	@UserId INT,
	@IsSuperUserOrSuperViewer bit,
	@FirstName VARCHAR(255) = '%',
	@LastName VARCHAR(255) = '%',
	@GroupingId INT = NULL,
	@GroupId INT = NULL,
	@UserPartyId INT = NULL,
	@_TopN int = 0
AS
DECLARE @Sql nvarchar(4000)
SET @Sql = '
-- Limit rows returned?
IF (@_TopN > 0) SET ROWCOUNT @_TopN
		
SELECT
	T1.CRMContactID AS CRMContactId,
	T1.PractitionerId AS PractitionerId,
	T1.CRMContactId AS UserPartyId,
	T2.FirstName + '' '' + T2.LastName AS AdviserName, 
	T5.Identifier AS GroupingName, 
	T4.Identifier AS GroupName,
	T3.Identifier AS UserName
FROM 
	[CRM].[dbo].TPractitioner T1
	JOIN [CRM].[dbo].TCRMContact T2 ON T2.CRMContactId = T1.CRMContactId AND T2.IndClientId = @TenantID
	JOIN [Administration].[dbo].TUser T3 ON T3.CRMContactId = T2.CRMContactId
	JOIN [Administration].[dbo].TGroup T4 ON T4.GroupId = T3.GroupId
	JOIN [Administration].[dbo].TGrouping T5 ON T5.GroupingId = T4.GroupingId
WHERE 
	T3.IndigoClientId = @TenantId	
	AND T1.AuthorisedFG = 1'
	
IF @UserPartyId IS NOT NULL
	SET @Sql = @Sql + ' AND T1.CRMContactId = @UserPartyId'
  
If @FirstName NOT IN ('%', '%%')
	SET @Sql = @Sql + ' AND T2.FirstName LIKE @FirstName'
  
If @LastName NOT IN ('%', '%%')
	Select @Sql = @Sql + ' AND T2.LastName LIKE @LastName'

If @GroupId IS NOT NULL
	SET @Sql = @Sql + ' AND T3.GroupId = @GroupId'
  
If @GroupingId IS NOT NULL
	SET @Sql = @Sql + ' AND T4.GroupingId = @GroupingId'  
	
IF @IsSuperUserOrSuperViewer = 0 BEGIN
	-- Secure search by preference.
	IF [Administration].[dbo].[FnIsAdviserSearchSecured](@TenantId) = 1
		SET @Sql = @Sql + ' AND T1._OwnerId IN (
			SELECT @UserId
			UNION ALL 
			SELECT DISTINCT CreatorId 
			FROM CRM.dbo.TPractitionerKey
			WHERE UserId = @UserId)'
END
--Sorting based on FirstName, Lastname     
	SET @Sql = @Sql + ' ORDER BY TRIM(T2.FirstName) ASC, TRIM(T2.LastName) ASC '   

EXEC sp_executesql @Sql, 
	N'@TenantId bigint, @UserId bigint, @FirstName varchar(255),  
	@LastName varchar(255), @GroupingId bigint, @GroupId bigint,  
	@UserPartyId bigint, @_TopN int', 
	@TenantId, @UserId,	@FirstName, 
	@LastName, @GroupingId, @GroupId, 
	@UserPartyId, @_TopN	
GO
