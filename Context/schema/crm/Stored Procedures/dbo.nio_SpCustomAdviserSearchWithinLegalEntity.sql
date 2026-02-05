SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================      
-- Author:  <Leena T.>      
-- Create date: <21-09-2012>      
-- Description: <this sp will search for the advisers which are in the servicing adviser's legal entity>      
-- =============================================      
/*
Modification History (most recent first)
Date        Modifier        Issue          Description
----        ---------       -------        -------------
20230505    Saumya Rajan    IOSE22-1695    User Search list displayed alphabetically
*/
CREATE PROCEDURE [dbo].[nio_SpCustomAdviserSearchWithinLegalEntity]      
	@TenantId bigint,
	@UserId INT,
	@IsSuperUserOrSuperViewer bit,	
	@FirstName varchar(255) = '%' ,      
	@LastName varchar(255) = '%',      
	@ServicingAdviserId bigint = NULL, --This is the adviser's practitioner id
	@_TopN INT = 0      
AS      
-- don't know why this makes a difference, but it reduces the cost from 1.68 to 0.117  
DECLARE @IndClientId2 INT = @TenantId
DECLARE @LegalEntityId bigint, @IsSecureSearch bit = 0

--Fetch the legal entity for the servicing adviser
SET @LegalEntityId = CRM.[dbo].FnGetLegalEntityIdForAdviser(@ServicingAdviserId)
    
-- See if we need to secure the search.    
IF @IsSuperUserOrSuperViewer = 0
	SET @IsSecureSearch = [Administration].[dbo].[FnIsAdviserSearchSecured](@TenantId)
	
-- Limit rows returned?    
IF (@_TopN > 0) SET ROWCOUNT @_TopN;
     
--Now find all advisers which match the search criteria and in thje servicing adviser's legal entity
WITH GroupHierarchy(GroupId, Identifier, GroupingId, IndigoClientId) AS (  
	SELECT   
		GroupId, Identifier, GroupingId, IndigoClientId  
	FROM   
		Administration..TGroup LegalEntity  
	WHERE   
		GroupId = @LegalEntityId  
		AND IndigoClientId = @IndClientId2  

	UNION ALL  

	SELECT   
		Child.GroupId, Child.Identifier, Child.GroupingId, Child.IndigoClientId  
	FROM   
		Administration..TGroup Child  
		JOIN GroupHierarchy H ON H.GroupId = Child.ParentId AND Child.IndigoClientId = @IndClientId2  
)      
SELECT     
	T2.CRMContactId,  
	T3.UserId,  
	T1.PractitionerId,  
	T2.FirstName + ' ' + T2.LastName AS AdviserName,     
	GHing.Identifier AS GroupingName,  
	GH.Identifier AS GroupName,  
	T3.Identifier AS UserName,  
	T1.AuthorisedFG AS AuthorisedFG,  
	T3.Reference AS Reference  
FROM      
	CRM.dbo.TPractitioner T1  WITH(NOLOCK)  
	JOIN CRM.dbo.TCRMContact T2 WITH(NOLOCK) ON T1.CRMContactId = T2.CRMContactId AND T2.IndClientId = @IndClientId2    
	JOIN Administration.dbo.TUser T3 WITH(NOLOCK) ON T1.CRMContactId = T3.CRMContactId AND T3.IndigoClientId = @IndClientId2  
	JOIN GroupHierarchy GH ON GH.GroupId = T3.GroupId AND GH.IndigoClientId = @IndClientId2  
	JOIN Administration.dbo.TGrouping GHing WITH(NOLOCK) ON GHing.GroupingId = GH.GroupingId AND GHing.IndigoClientId = @IndClientId2
	LEFT JOIN (
		SELECT DISTINCT
			CreatorId
		FROM 
			CRM..TPractitionerKey WITH(NOLOCK)
		WHERE
			UserId = @UserId) AS TCKey ON TCKey.CreatorId = T1._OwnerId AND @IsSecureSearch = 1
WHERE   
	T1.IndClientId = @IndClientId2
	AND T1.AuthorisedFG = 1
	AND T1.PractitionerId != @ServicingAdviserId
	AND T2.FirstName LIKE @FirstName  
	AND T2.LastName LIKE @LastName
	-- If we're securing the search then don't return an adviser if they are
	-- not owned by the User AND the User does not have a revelant security key.
	AND (@IsSecureSearch = 0 OR (T1._OwnerId = @UserId OR TCKey.CreatorId IS NOT NULL))
	ORDER BY TRIM(T2.FirstName) ASC, TRIM(T2.LastName) ASC
GO
