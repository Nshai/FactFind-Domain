SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomSearchClientByNameSecure]   
 @indigoClientId bigint,    
 @CorporateName varchar(255) = NULL,    
 @Firstname varchar(255) = NULL,    
 @LastName varchar(255) = NULL,     
 @PrimaryRef varchar(50) = NULL,    
 @IncludeDeleted bit = 0,    
 @AdviserId bigint = NULL,    
 @AdviserGroupId bigint = NULL,    
 @CreditedGroupId bigint = NULL,    
 @SecondaryRef varchar(50) = NULL,    
 @ServiceStatus varchar(50) = NULL,
 @Postcode varchar(50) = NULL,
 @_UserId bigint,    
 @_TopN int = 0    

with recompile 
AS    

BEGIN    
    
declare @indigoClientId2 bigint
set @indigoClientId2 = @indigoClientId

-- User rights    
DECLARE @RightMask int, @AdvancedMask int    
SELECT @RightMask = 1, @AdvancedMask = 0    
-- SuperViewers won't have an entry in the key table so we need to get their rights now    
IF @_UserId < 0    
 EXEC Administration..SpCustomGetSuperUserRights @_UserId, 'CRMContact', @RightMask OUTPUT, @AdvancedMask OUTPUT    
    
-- Limit rows returned?    
IF (@_TopN > 0) SET ROWCOUNT @_TopN    
    
DECLARE @spacer varchar(10)    
SELECT @spacer = '00000000'    
  
 
  
declare @SpCustomClientQuickSearchSecure Table (  
 CRMContactId bigint primary key,  
  AdvisorRef varchar(50),  
 ArchiveFg varchar(3),  
 LastName varchar(50),  
 FirstName varchar(50),  
 CorporateName varchar(255),  
 LastOrCorporateName varchar(255),  
 DOB varchar(25),  
 CurrentAdviserName varchar(255),  
 CRMContactType varchar(3),  
 CRMContactTypeName varchar(20),  
 ExternalReference varchar(50),  
 AdditionalRef varchar(50),  
 ClientRef varchar(255),  
 CreditedGroup varchar(64),  
 _RightMask varchar(20),  
 _AdvancedMask varchar(20)  
)  
  
Insert Into @SpCustomClientQuickSearchSecure  
( CRMContactId ,  AdvisorRef, ArchiveFg, LastName, FirstName, CorporateName, LastOrCorporateName,   
DOB, CurrentAdviserName, CRMContactType, CRMContactTypeName, ExternalReference,   
AdditionalRef, ClientRef, CreditedGroup, _RightMask, _AdvancedMask )  
Select  distinct
 T1.CRMContactId AS [CRMContact!1!CRMContactId],     
 ISNULL(T1.AdvisorRef, '') AS [CRMContact!1!AdvisorRef],     
 ISNULL(T1.ArchiveFg, '') AS [CRMContact!1!ArchiveFg],     
 ISNULL(T1.LastName, '') AS [CRMContact!1!LastName],     
 ISNULL(T1.FirstName, '') AS [CRMContact!1!FirstName],     
 ISNULL(T1.CorporateName, '') AS [CRMContact!1!CorporateName],     
 ISNULL(T1.CorporateName, '') + ISNULL(T1.LastName, '') AS [CRMContact!1!LastOrCorporateName],    
 ISNULL(CONVERT(varchar(24), T1.DOB, 120),'') AS [CRMContact!1!DOB],     
 ISNULL(T1.CurrentAdviserName, '') AS [CRMContact!1!CurrentAdviserName],     
 T1.CRMContactType AS [CRMContact!1!CRMContactType],     
CASE    
 WHEN T1.CRMContactType = 1 THEN 'Person'    
 WHEN T1.CRMContactType = 2 THEN 'Trust'    
 WHEN T1.CRMContactType = 3 THEN 'Corporate'    
 WHEN T1.CRMContactType = 4 THEN 'Group'    
 END AS  [CRMContact!1!CRMContactTypeName],    
 ISNULL(T1.ExternalReference, '') AS [CRMContact!1!ExternalReference],     
 ISNULL(T1.AdditionalRef, '') AS [CRMContact!1!SecondaryReference],     
 T1.AdvisorRef + '-' + (left(@spacer,8-(len(Convert(varChar(10),T1.CRMContactId))))) + Convert(varChar(10),T1.CRMContactId) AS [CRMContact!1!ClientRef],    
 ISNULL(Cg.Identifier, '') AS [CRMContact!1!CreditedGroup],    
CASE T1._OwnerId    
 WHEN ABS(@_UserId) THEN 15    
 ELSE ISNULL(TCKey.RightMask,@RightMask)|ISNULL(TEKey.RightMask, @RightMask)    
 END AS [CRMContact!1!_RightMask],    
CASE T1._OwnerId    
 WHEN ABS(@_UserId) THEN 240    
 ELSE ISNULL(TCKey.AdvancedMask,@AdvancedMask)|ISNULL(TEKey.AdvancedMask, @AdvancedMask)     
 END AS [CRMContact!1!_AdvancedMask]    
FROM     
 TCRMContact T1 WITH(NOLOCK)     
 JOIN TPractitioner A WITH(NOLOCK) ON A.CRMContactId = T1.CurrentAdviserCRMId AND A.IndClientId = @indigoClientId2    
 LEFT JOIN TCRMContactExt Ce WITH(NOLOCK) ON Ce.CRMContactId = T1.CRMContactId    
 LEFT JOIN Administration..TGroup Cg WITH(NOLOCK) ON Cg.GroupId = Ce.CreditedGroupId    
 JOIN Administration..TUser U WITH(NOLOCK) ON U.CRMContactId = A.CRMContactId AND U.IndigoClientId = @indigoClientId2    
 JOIN Administration..TGroup G WITH(NOLOCK) ON G.GroupId = U.GroupId  AND g.IndigoCLientId = @indigoClientId2   
 LEFT JOIN Administration..TGroup G2 WITH(NOLOCK) ON G2.GroupId = G.ParentId 
 LEFT JOIN Administration..TGroup G3 WITH(NOLOCK) ON G3.GroupId = G2.ParentId
 LEFT JOIN TAddress Ad WITH(NOLOCK) on Ad.CRMContactId = T1.CRMContactId
 LEFT JOIN TAddressStore Ads WITH (NOLOCK) on Ads.AddressStoreId = Ad.AddressStoreId
 -- Secure (we have two joins, one for ownership rights & one for specific user/role rights)    
 LEFT JOIN VwCRMContactKeyByCreatorId AS TCKey ON TCKey.UserId = @_UserId AND TCKey.CreatorId = T1._OwnerId    
 LEFT JOIN VwCRMContactKeyByEntityId AS TEKey ON TEKey.UserId = @_UserId AND TEKey.EntityId = T1.CRMContactId     
WHERE     
 T1.IndClientId = @indigoClientId2 AND T1.RefCRMContactStatusId = 1    
 AND (T1.CorporateName LIKE @CorporateName + '%' OR @CorporateName IS NULL)    
 AND (T1.FirstName LIKE @FirstName + '%' OR @FirstName IS NULL)    
 AND (T1.LastName LIKE @LastName + '%' OR @LastName IS NULL)    
 AND (T1.ExternalReference LIKE '%' + @PrimaryRef + '%' OR @PrimaryRef IS NULL)    
 AND ((@IncludeDeleted = 0 AND (T1.ArchiveFg = 0 OR T1.ArchiveFg IS NULL)) OR @IncludeDeleted = 1)    
 AND (A.PractitionerId = @AdviserId OR @AdviserId IS NULL)    
 AND ((G.GroupId = @AdviserGroupId OR G2.GroupId = @AdviserGroupId OR G3.GroupId = @AdviserGroupId) OR @AdviserGroupId IS NULL)    
 AND (Ce.CreditedGroupId = @CreditedGroupId OR @CreditedGroupId IS NULL)    
 AND (T1.AdditionalRef LIKE '%' + @SecondaryRef + '%' OR @SecondaryRef IS NULL)    
 AND (@_UserId < 0 OR (T1._OwnerId=@_UserId OR (TCKey.CreatorId IS NOT NULL OR TEKey.EntityId IS NOT NULL)))    
 AND (T1.RefServiceStatusId = @ServiceStatus Or @ServiceStatus IS NULL)
 AND (Ads.Postcode LIKE '%' + @Postcode + '%' OR @Postcode IS NULL)
  
  
  
SELECT    distinct
 1 AS Tag,    
 NULL AS Parent,    
 T1.CRMContactId AS [CRMContact!1!CRMContactId],     
 ISNULL(T1.AdvisorRef, '') AS [CRMContact!1!AdvisorRef],     
 ISNULL(T1.ArchiveFg, '') AS [CRMContact!1!ArchiveFg],     
 ISNULL(T1.LastName, '') AS [CRMContact!1!LastName],     
 ISNULL(T1.FirstName, '') AS [CRMContact!1!FirstName],     
 ISNULL(T1.CorporateName, '') AS [CRMContact!1!CorporateName],     
 LastOrCorporateName AS [CRMContact!1!LastOrCorporateName],    
 ISNULL(t1.CorporateName,'') + ISNULL(t1.FirstName,'') + ' ' + ISNULL(t1.LastName,'') as [CRMContact!1!ClientFullName],  
 ISNULL(CONVERT(varchar(24), T1.DOB, 120),'') AS [CRMContact!1!DOB],     
 ISNULL(T1.CurrentAdviserName, '') AS [CRMContact!1!CurrentAdviserName],     
 T1.CRMContactType AS [CRMContact!1!CRMContactType],     
CRMContactTypeName AS  [CRMContact!1!CRMContactTypeName],    
 ISNULL(T1.ExternalReference, '') AS [CRMContact!1!ExternalReference],     
    ISNULL(ast.AddressLine1,'') as [CRMContact!1!AddressLine1],    
 ISNULL(T1.AdditionalRef, '') AS [CRMContact!1!SecondaryReference],     
 ClientRef AS [CRMContact!1!ClientRef],    
CreditedGroup AS [CRMContact!1!CreditedGroup],    
_RightMask AS [CRMContact!1!_RightMask],    
_AdvancedMask AS [CRMContact!1!_AdvancedMask]    
From @SpCustomClientQuickSearchSecure T1  
LEFT JOIN   
 (    
 Select A.crmcontactid, max(A.addressstoreid) as AddressStoreId    
 from taddress A  
 Inner Join @SpCustomClientQuickSearchSecure B  
  On A.CRMContactId = B.CRMContactId  
 Where defaultfg = 1  and A.indclientid = @indigoClientId2    
 Group By A.crmcontactid  
 ) address on address.crmcontactid = t1.crmcontactid    
 LEFT JOIN TAddressStore ast ON ast.AddressStoreId = address.AddressStoreId    
ORDER BY     
 [CRMContact!1!LastOrCorporateName] ASC, [CRMContact!1!FirstName] ASC    
    
FOR XML EXPLICIT    
    
IF (@_TopN > 0) SET ROWCOUNT 0    
    

  
END    
    
RETURN (0)  




GO
