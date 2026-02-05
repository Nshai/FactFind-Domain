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
CREATE PROCEDURE [dbo].[nio_SpCustomSearchAdvisers]
	@TenantId INT,  
	@UserId INT,
	@IsSuperUserOrSuperViewer bit,
	@FirstName varchar(255) = '%' ,  
	@LastName varchar(255) = '%',  
	@Authorised tinyint = 3,  
	@GroupingId INT = 0,  
	@GroupId INT = 0,  
	@UserCRMContactId INT = 0,
	@_TopN int = 0  
AS
DECLARE @Sql nvarchar(4000)  
SELECT @Sql = '  
-- Limit rows returned?    
IF @_TopN > 0   
	SET ROWCOUNT @_TopN
    
SELECT  
	T1.PractitionerId AS [PractitionerId],    
	T2.CRMContactID AS [PartyId],   
	T2.FirstName,        
	T2.LastName,         
	T2.FirstName + '' '' + T2.LastName AS [AdviserName],        
	T5.Identifier AS [GroupingName],     
	T4.Identifier AS [GroupName],    
	T3.Identifier AS [UserName],    
	T1.AuthorisedFG AS [AuthorisedFG],    
	T3.Reference AS [Reference],
	T3.UserId AS [AdviserRef]  
FROM 
	[CRM].[dbo].TPractitioner T1 WITH(NOLOCK)
	JOIN [CRM].[dbo].TCRMContact T2 WITH(NOLOCK) ON T1.CRMContactId = T2.CRMContactId AND T2.IndClientId = @TenantId
	JOIN [Administration].[dbo].TUser T3 WITH(NOLOCK) ON T1.CRMContactId = T3.CRMContactId  AND T3.IndigoClientId = @TenantId
    JOIN [Administration].[dbo].TGroup T4 WITH(NOLOCK) ON T4.GroupId = T3.GroupId   AND T4.IndigoClientId = @TenantId
    JOIN [Administration].[dbo].TGrouping T5 WITH(NOLOCK) ON T5.GroupingId = T4.GroupingId AND T5.IndigoClientId = @TenantId 
WHERE 
	T1.IndClientId = @TenantId'  
  
IF @UserCRMContactId > 0  
	SET @Sql = @Sql + ' AND T3.CRMContactId = @UserCRMContactId'
  
If @FirstName NOT IN ('%', '%%')
	SET @Sql = @Sql + ' AND T2.FirstName LIKE @FirstName'
  
If @LastName NOT IN ('%', '%%')
	Select @Sql = @Sql + ' AND T2.LastName LIKE @LastName'

If @GroupId > 0  
	SET @Sql = @Sql + ' AND T3.GroupId = @GroupId'
  
If @GroupingId > 0  
	SET @Sql = @Sql + ' AND T4.GroupingId = @GroupingId'  
  
IF @Authorised <> '3'  
	SET @Sql = @Sql +  ' AND T1.AuthorisedFG = @Authorised'
  
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
	@LastName varchar(255), @Authorised tinyint, @GroupingId bigint, @GroupId bigint,  
	@UserCRMContactId bigint, @_TopN int', 
	@TenantId, @UserId,	@FirstName, @LastName, @Authorised, @GroupingId,  
	@GroupId, @UserCRMContactId, @_TopN
GO
