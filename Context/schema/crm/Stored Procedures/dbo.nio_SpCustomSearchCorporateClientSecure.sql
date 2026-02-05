SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_SpCustomSearchCorporateClientSecure] 
	@TenantId BIGINT,     
	@CorporateName VARCHAR(255) = '', 
	@PrimaryRef VARCHAR(255) = '',
	@IncludeDeleted bit = 0,  
	@_UserId bigint,  
	@_TopN int = 0    

AS

BEGIN

-- SuperUser and SuperViewer processing   
-- (Need to do this because NIO does not pass the @_UserId as a negated value for SuperUsers and SuperViewers  
-- A negative Id results in Entity Security being overridden  
IF(@_UserId > 0) BEGIN  
  
 IF EXISTS (SELECT 1 FROM Administration..TUser WHERE UserId = @_UserId AND (SuperUser = 1 OR SuperViewer = 1))   
  SET @_UserId = @_UserId * -1  
  
END  

-- User Rights
DECLARE @RightMask INT
DECLARE @AdvancedMask INT
DECLARE @HasPolicy BIT
SELECT @RightMask = 1, @AdvancedMask = 0, @HasPolicy = 0        
IF @_UserId < 0        
 EXEC Administration..SpCustomGetSuperUserRights @_UserId, 'Account', @RightMask OUTPUT, @AdvancedMask OUTPUT        
     
IF EXISTS         
 (        
 SELECT         
  *          
 FROM         
  Administration..TPolicy P        
  JOIN Administration..TEntity E ON E.EntityId = P.EntityId         
  JOIN Administration..TMembership M ON M.RoleId = P.RoleId        
 WHERE        
  E.Identifier = 'Account'        
  AND M.UserId = @_UserId        
 )        
 SELECT @HasPolicy = 1

-- Limit rows returned?    
IF (@_TopN > 0) SET ROWCOUNT @_TopN    

-- START SEARCHING
SELECT        
	C.CRMContactId AS [PartyId],   
	C.CRMContactType AS [CRMContactType],     
	ISNULL(C.AdvisorRef, '') AS [AdvisorRef],     
	ISNULL(C.CurrentAdviserName, '') AS [CurrentAdviserName],     
	'' AS [LastName],      
	'' AS [FirstName],     
	ISNULL(C.CorporateName, '') AS [CorporateName],      
	NULL AS [ClientName], 
    ISNULL(C.CorporateName, '') AS [CRMContactLastNameCorporateName],   
    ISNULL(C.CorporateName, '') AS [ClientFullName], 
	ISNULL(C.CorporateName, '') AS [ClientSortName], 
	0 AS [PolicyBusinessId],    
	NULL AS [ChangedToDate],    
	NULL AS [PolicyNumber],    
	NULL AS [ProductName],    
	NULL AS [PolicyStatus],    
	NULL AS [PolicyType],    
	ISNULL(ast.AddressLine1,'') as [AddressLine1],
	NULL AS [ExternalReference],    	 	
	NULL AS [SequentialRef],

--	C.IndClientId AS [TenantId],          
--	C.CorporateName AS [FullName],        
--	'' AS FirstName,
--	'' AS LastName,
--	C.ArchiveFG as [ArchiveFG],
--	C.CorporateName AS [CorporateName],        
--	'' AS [ContactStatus],        
--	NULL as [DOB],
--	ISNULL(ast.AddressLine1,'') as [AddressLine1],
--
	CASE C._OwnerId        
	WHEN ABS(@_UserId) THEN 15        
		ELSE ISNULL(TCKey.RightMask,@RightMask)|ISNULL(TEKey.RightMask, @RightMask)        
	END AS [_RightMask],        
  
	CASE C._OwnerId        
	WHEN ABS(@_UserId) THEN 240        
		ELSE ISNULL(TCKey.AdvancedMask,@AdvancedMask)|ISNULL(TEKey.AdvancedMask, @AdvancedMask)         
	END AS [_AdvancedMask]        

FROM         
 CRM..TCRMContact C WITH(NOLOCK)      
 LEFT JOIN   
 (    
 Select A.crmcontactid, max(A.addressstoreid) as AddressStoreId    
 from taddress A  
 Where A.defaultfg = 1  and A.indclientid = @TenantId    
 Group By A.crmcontactid  
 ) address on address.crmcontactid = C.crmcontactid    
 LEFT JOIN TAddressStore ast ON ast.AddressStoreId = address.AddressStoreId   
    
 -- Secure (we have two joins, one for ownership rights & one for specific user/role rights)        
 LEFT JOIN VwLeadKeyByCreatorId AS TCKey ON TCKey.UserId = @_UserId AND TCKey.CreatorId = C._OwnerId        
 LEFT JOIN VwLeadKeyByEntityId AS TEKey ON TEKey.UserId = @_UserId AND TEKey.EntityId = C.CRMContactId        
WHERE         
	C.IndClientId = @TenantId         
	AND ISNULL(C.InternalContactFG, 0) != 1  
	AND C.ArchiveFG = @IncludeDeleted
	AND (C.CRMContactType = 3)
	AND (@CorporateName IS NULL OR C.CorporateName LIKE @CorporateName + '%')        
	AND (@PrimaryRef IS NULL OR C.ExternalReference LIKE @PrimaryRef + '%')        

  -- Secure        
 AND (@HasPolicy = 0 OR @_UserId < 0 OR (C._OwnerId=@_UserId OR (TCKey.CreatorId IS NOT NULL OR TEKey.EntityId IS NOT NULL)))        
ORDER BY         
 C.[CorporateName] DESC       


END








GO
