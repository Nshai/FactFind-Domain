SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
Modification History (most recent first)
Date        Modifier        Issue       Description
----        ---------       -------     -------------
20230119    Aswani kumar P  IOSE22-1143 Added salutation as search parameter
20210521    Nick Fairway    DEF-2859    Often suffers from bad perfromance sniffing on joins between TCRMContact and TLead. Option Recompile added, but MERGE JOIN hint would also work.

*/
CREATE PROCEDURE [dbo].[nio_SpCustomLeadSearchSecure]      
  @TenantId bigint,        
  @CorporateOrTrustName  varchar(255) = NULL,        
  @FirstName varchar(255) = NULL,        
  @LastName varchar(255) = NULL,      
  @PostCode varchar(20) = NULL,     
  @AdviserCRMContactId bigint = 0,    
  @LeadStatusId bigint = 0,        
  @SecondaryRef varchar(255) = NULL,        
  @CampaignTypeId bigint = 0,        
  @CampaignSourceId bigint = 0,       
  @Description varchar(255) = NULL,
  @IntroducerId bigint = 0,    
  @IntroducerBranchId bigint = -99,    
  @IncludeDeleted bit = 0,
  @_UserId bigint = 0,     
  @_TopN int = 0,
  @Salutation varchar(50) = NULL
      
AS            
BEGIN    

--If Introducer Branch Id is -1 or above we know that an introducer manager is running the search
--so we need to find all the users for all the branches he is connected to.
DECLARE @IntroducerEmployees TABLE(IntroducerEmployeeId bigint)

--If AND Introducer User Is running the search then he should only see the leads he has added
DECLARE @IntroducerEmployeeId bigint


SELECT @IntroducerEmployeeId=ISNULL(IntroducerEmployeeId,0) FROM CRM..TIntroducerEmployee WITH(NOLOCK) WHERE UserId=@_UserId AND TenantId=@TenantId

--Add this to the Introducer Employees table as we will use it to search on
IF ISNULL(@IntroducerEmployeeId,0)>0
BEGIN
	INSERT @IntroducerEmployees(IntroducerEmployeeId)
	SELECT @IntroducerEmployeeId
END

--If IntroducerEmployee is not a manager then restrict results to only those
--added by introducer user

DECLARE @RestrictResultsForIntroducerUser bit

SELECT @RestrictResultsForIntroducerUser=0

IF @IntroducerBranchId=-99 AND ISNULL(@IntroducerEmployeeId,0)>0
BEGIN
	SELECT @RestrictResultsForIntroducerUser=1
END


--Add Users FROM Branches IF BranchId is -1 Or Greater
IF @IntroducerBranchId!=-99
BEGIN
	INSERT @IntroducerEmployees(IntroducerEmployeeId)
	SELECT D.IntroducerEmployeeId
	FROM CRM..TIntroducerEmployee A WITH(NOLOCK)
	JOIN CRM..TIntroducerEmployeeBranch B WITH(NOLOCK) ON A.IntroducerEmployeeId=B.IntroducerEmployeeId
	JOIN CRM..TIntroducerEmployeeBranch C WITH(NOLOCK) ON B.IntroducerBranchId=C.IntroducerBranchId
	JOIN CRM..TIntroducerEmployee D WITH(NOLOCK) ON C.IntroducerEmployeeId=D.IntroducerEmployeeId 
	WHERE A.IntroducerEmployeeId=@IntroducerEmployeeId
	AND (@IntroducerBranchId=-1 OR B.IntroducerBranchId=@IntroducerBranchId)
	AND D.IntroducerEmployeeId!=@IntroducerEmployeeId
END
    
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


--SELECT @IntroducerEmployeeId = ISNULL(IntroducerEmployeeId,0) FROM CRM..TIntroducerEmployee WHERE UserId=@_UserId  

SELECT @RightMask = 1, @AdvancedMask = 0, @HasPolicy = 0            
IF @_UserId < 0            
 EXEC Administration..SpCustomGetSuperUserRights @_UserId, 'Lead', @RightMask OUTPUT, @AdvancedMask OUTPUT            
         
IF EXISTS             
 (            
 SELECT             
  TOP 1 1          
 FROM             
  Administration..TPolicy P            
  JOIN Administration..TEntity E ON E.EntityId = P.EntityId             
  JOIN Administration..TMembership M ON M.RoleId = P.RoleId            
 WHERE            
  E.Identifier = 'Lead'            
  AND M.UserId = @_UserId            
  AND P.Applied = 'yes'    
 )            
 SELECT @HasPolicy = 1    
    
-- Limit rows returned?        
IF (@_TopN > 0) SET ROWCOUNT @_TopN        
      
/* Retrieve adviserid/practitionerid from @AdviserCRMContactId */      
DECLARE @AdviserId BIGINT     
SET @AdviserId = 0    
IF @AdviserCRMContactId > 0  BEGIN    
 SELECT @AdviserId = PractitionerId from dbo.TPractitioner where CRMContactId =@AdviserCRMContactId         
END    

IF(@PostCode IS NULL)
BEGIN 
-- START SEARCHING - don't need joins to taddress and taddressstore if no post code search
SELECT  distinct          
 L.LeadId AS [LeadId],       
 C.CRMContactId AS [PartyId],           
 C.IndClientId AS [TenantId],             
 CASE            
  WHEN C.CRMContactType = 1 THEN (C.FirstName + ' ' + C.LastName)            
  WHEN C.CRMContactType in (2,3,4) THEN (C.CorporateName)            
 END AS  [LeadFullName],            
    
 CASE            
  WHEN C.CRMContactType = 1 THEN 'Person'            
  WHEN C.CRMContactType = 2 THEN 'Trust'            
  WHEN C.CRMContactType = 3 THEN 'Corporate'            
  WHEN C.CRMContactType = 4 THEN 'Group'            
 END AS  [LeadTypeName],            
    
 ISNULL(C.CurrentAdviserName, '') AS [AdviserName],             
 IsNull(C.AdditionalRef,'') AS [SecondaryRef],            
 ISNULL(Ls.Descriptor, '') AS [LeadStatus],            
 ISNULL(tct.CampaignType,'') AS [CampaignType],            
 ISNULL(tc.CampaignName,'') AS [CampaignSource],            
 ISNULL(tcd.Description,'') AS [Description],            
    
  CASE C._OwnerId            
  WHEN ABS(@_UserId) THEN 15            
    ELSE ISNULL(TCKey.RightMask,@RightMask)|ISNULL(TEKey.RightMask, @RightMask)            
  END AS [_RightMask],            
      
  CASE C._OwnerId            
  WHEN ABS(@_UserId) THEN 240            
 ELSE ISNULL(TCKey.AdvancedMask,@AdvancedMask)|ISNULL(TEKey.AdvancedMask, @AdvancedMask)             
  END AS [_AdvancedMask],
 C.ArchiveFg AS [IsDeleted],
 C.FirstName,
 C.LastName 
FROM             
 CRM..TCRMContact C WITH(NOLOCK)          
 JOIN CRM..TLead L WITH(NOLOCK) ON L.CRMContactId = C.CRMContactId            
 JOIN CRM..TLeadStatusHistory Lsh WITH(NOLOCK) ON Lsh.LeadId = L.LeadId AND Lsh.CurrentFg = 1            
    JOIN CRM..TLeadStatus Ls WITH(NOLOCK) ON Ls.LeadStatusId = Lsh.LeadStatusId            
 LEFT JOIN CRM..TCampaignData tcd WITH(NOLOCK) ON tcd.CampaignDataId = c.CampaignDataId            
 LEFT JOIN CRM..TCampaign tc WITH(NOLOCK) ON tc.CampaignId = tcd.CampaignId            
 LEFT JOIN CRM..TCampaignType tct WITH(NOLOCK) ON tct.CampaignTypeId = tc.CampaignTypeId            
 
 -- Secure (we have two joins, one for ownership rights & one for specific user/role rights)            
 LEFT JOIN VwLeadKeyByCreatorId AS TCKey ON TCKey.UserId = @_UserId AND TCKey.CreatorId = C._OwnerId            
 LEFT JOIN VwLeadKeyByEntityId AS TEKey ON TEKey.UserId = @_UserId AND TEKey.EntityId = C.CRMContactId
 LEFT JOIN TPerson p WITH(NOLOCK) ON p.PersonId=C.PersonId
WHERE             
 C.IndClientId = @TenantId             
 AND ISNULL(C.InternalContactFG, 0) != 1      
 AND (
		(@IncludeDeleted =0 AND C.ArchiveFG=@IncludeDeleted)
		OR 
		(@IncludeDeleted =1 AND C.ArchiveFG IN (0,1) )
	) 
  AND ((@AdviserCRMContactId = 0) Or (@AdviserCRMContactId > 0 And C.CurrentAdviserCRMId = @AdviserCRMContactId ))  
 AND (Ls.LeadStatusId = @LeadStatusId OR @LeadStatusId = 0)            
 AND (@CorporateOrTrustName IS NULL OR C.CorporateName LIKE @CorporateOrTrustName + '%')            
 AND (@FirstName IS NULL OR C.FirstName LIKE @FirstName + '%')            
 AND (@LastName IS NULL OR C.LastName LIKE @LastName + '%')            
 AND (@SecondaryRef IS NULL OR C.AdditionalRef LIKE @SecondaryRef + '%')            
 AND (@CampaignTypeId = 0 OR tct.CampaignTypeId = @CampaignTypeId)            
 AND (@CampaignSourceId = 0 OR tc.CampaignId = @CampaignSourceId)            
 AND (@Description IS NULL OR tcd.Description LIKE @Description + '%')            
  -- Secure            
 AND (@HasPolicy = 0 OR @_UserId < 0 OR (C._OwnerId=@_UserId OR (TCKey.CreatorId IS NOT NULL OR TEKey.EntityId IS NOT NULL))) 
 AND (ISNULL(@IntroducerEmployeeId,0)=0  OR (ISNULL(@IntroducerEmployeeId,0)>0 AND L.IntroducerEmployeeId IN (SELECT IntroducerEmployeeId FROM @IntroducerEmployees)))
 AND (ISNULL(@IntroducerBranchId,0) < 0 OR L.IntroducerBranchId = @IntroducerBranchId) 
 AND (@RestrictResultsForIntroducerUser=0 OR @RestrictResultsForIntroducerUser=1 AND L.IntroducerEmployeeId=@IntroducerEmployeeId)
 AND (@Salutation IS NULL OR p.Salutation LIKE @Salutation + '%')         
ORDER BY             
 [LastName] DESC, [FirstName] DESC
 OPTION (RECOMPILE)       
END 
ELSE
BEGIN
-- START SEARCHING  - with extra joins if Post Code is part of the search
SELECT  distinct          
 L.LeadId AS [LeadId],       
 C.CRMContactId AS [PartyId],           
 C.IndClientId AS [TenantId],             
 CASE            
  WHEN C.CRMContactType = 1 THEN (C.FirstName + ' ' + C.LastName)            
  WHEN C.CRMContactType in (2,3,4) THEN (C.CorporateName)            
 END AS  [LeadFullName],            
    
 CASE            
  WHEN C.CRMContactType = 1 THEN 'Person'            
  WHEN C.CRMContactType = 2 THEN 'Trust'            
  WHEN C.CRMContactType = 3 THEN 'Corporate'            
  WHEN C.CRMContactType = 4 THEN 'Group'            
 END AS  [LeadTypeName],            
    
 ISNULL(C.CurrentAdviserName, '') AS [AdviserName],             
 IsNull(C.AdditionalRef,'') AS [SecondaryRef],            
 ISNULL(Ls.Descriptor, '') AS [LeadStatus],            
 ISNULL(tct.CampaignType,'') AS [CampaignType],            
 ISNULL(tc.CampaignName,'') AS [CampaignSource],            
 ISNULL(tcd.Description,'') AS [Description],            
    
  CASE C._OwnerId            
  WHEN ABS(@_UserId) THEN 15            
    ELSE ISNULL(TCKey.RightMask,@RightMask)|ISNULL(TEKey.RightMask, @RightMask)            
  END AS [_RightMask],            
      
  CASE C._OwnerId            
  WHEN ABS(@_UserId) THEN 240            
 ELSE ISNULL(TCKey.AdvancedMask,@AdvancedMask)|ISNULL(TEKey.AdvancedMask, @AdvancedMask)             
  END AS [_AdvancedMask],
 C.ArchiveFg AS [IsDeleted],
 C.FirstName,
 C.LastName 
FROM             
 CRM..TCRMContact C WITH(NOLOCK)          
 JOIN CRM..TLead L WITH(NOLOCK) ON L.CRMContactId = C.CRMContactId            
 JOIN CRM..TLeadStatusHistory Lsh WITH(NOLOCK) ON Lsh.LeadId = L.LeadId AND Lsh.CurrentFg = 1            
 JOIN CRM..TLeadStatus Ls WITH(NOLOCK) ON Ls.LeadStatusId = Lsh.LeadStatusId            
 JOIN CRM..TAddress Ad WITH(NOLOCK) ON Ad.CRMContactId = C.CRMContactId AND Ad.DefaultFG = 1         
 JOIN CRM..TAddressStore Ads WITH(NOLOCK) ON Ads.AddressStoreId = Ad.AddressStoreId    
 LEFT JOIN CRM..TCampaignData tcd WITH(NOLOCK) ON tcd.CampaignDataId = c.CampaignDataId            
 LEFT JOIN CRM..TCampaign tc WITH(NOLOCK) ON tc.CampaignId = tcd.CampaignId            
 LEFT JOIN CRM..TCampaignType tct WITH(NOLOCK) ON tct.CampaignTypeId = tc.CampaignTypeId            
 -- Secure (we have two joins, one for ownership rights & one for specific user/role rights)            
 LEFT JOIN VwLeadKeyByCreatorId AS TCKey ON TCKey.UserId = @_UserId AND TCKey.CreatorId = C._OwnerId            
 LEFT JOIN VwLeadKeyByEntityId AS TEKey ON TEKey.UserId = @_UserId AND TEKey.EntityId = C.CRMContactId
 LEFT JOIN TPerson p WITH(NOLOCK) ON p.PersonId=C.PersonId
WHERE             
 C.IndClientId = @TenantId             
 AND ISNULL(C.InternalContactFG, 0) != 1      
 AND (
		(@IncludeDeleted =0 AND C.ArchiveFG=@IncludeDeleted)
		OR 
		(@IncludeDeleted =1 AND C.ArchiveFG IN (0,1) )
	)                      
AND (ADS.Postcode like @PostCode + '%')                      
 AND ((@AdviserCRMContactId = 0) Or (@AdviserCRMContactId > 0 And C.CurrentAdviserCRMId = @AdviserCRMContactId ))  
 AND (Ls.LeadStatusId = @LeadStatusId OR @LeadStatusId = 0)            
 AND (@CorporateOrTrustName IS NULL OR C.CorporateName LIKE @CorporateOrTrustName + '%')            
 AND (@FirstName IS NULL OR C.FirstName LIKE @FirstName + '%')            
 AND (@LastName IS NULL OR C.LastName LIKE @LastName + '%')            
 AND (@SecondaryRef IS NULL OR C.AdditionalRef LIKE @SecondaryRef + '%')    
 
 AND (@PostCode IS NULL OR ADS.Postcode like @PostCode + '%')        
 AND (@CampaignTypeId = 0 OR tct.CampaignTypeId = @CampaignTypeId)            
 AND (@CampaignSourceId = 0 OR tc.CampaignId = @CampaignSourceId)            
 AND (@Description IS NULL OR tcd.Description LIKE @Description + '%')            
  -- Secure            
 AND (@HasPolicy = 0 OR @_UserId < 0 OR (C._OwnerId=@_UserId OR (TCKey.CreatorId IS NOT NULL OR TEKey.EntityId IS NOT NULL))) 
 AND (ISNULL(@IntroducerEmployeeId,0)=0  OR (ISNULL(@IntroducerEmployeeId,0)>0 AND L.IntroducerEmployeeId IN (SELECT IntroducerEmployeeId FROM @IntroducerEmployees)))
 AND (ISNULL(@IntroducerBranchId,0) < 0 OR L.IntroducerBranchId = @IntroducerBranchId) 
 AND (@RestrictResultsForIntroducerUser=0 OR @RestrictResultsForIntroducerUser=1 AND L.IntroducerEmployeeId=@IntroducerEmployeeId)
 AND (@Salutation IS NULL OR p.Salutation LIKE @Salutation + '%') 
ORDER BY             
 [LastName] DESC, [FirstName] DESC  
 OPTION (RECOMPILE)
END
END 
GO
