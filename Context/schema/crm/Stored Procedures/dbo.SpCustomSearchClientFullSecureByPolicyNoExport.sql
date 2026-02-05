SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomSearchClientFullSecureByPolicyNoExport]    
 @IndigoClientId bigint,    
 @PolicyNumber varchar(50) = '',    
 @SequentialRef varchar(50)=NULL,    
 @_UserId bigint,    
 @_TopN int = 0    
AS    
    
-- User rights    
DECLARE @RightMask int, @AdvancedMask int    
DECLARE @LighthousePreExistingAdviceType bigint    
DECLARE @IsLimited bit    
    
SELECT @RightMask = 1, @AdvancedMask = 0    
SELECT @IsLimited=0    
SELECT @LighthousePreExistingAdviceType=3151    
    
    
IF ISNULL(@SequentialRef,'')<>''    
BEGIN    
 SET @SequentialRef='IOB' + RIGHT(REPLICATE('0',8) + @SequentialRef,8)    
END    
    
-- aahm01    
IF @PolicyNumber=''    
 Set @PolicyNumber=NULL    
    
    
--For Lighthouse Limited Access to Advisers Who are members of a non-organisation group    
IF @IndigoClientId=213    
BEGIN    
 DECLARE @PositiveUserId bigint    
 SELECT @PositiveUserId=@_UserId    
 IF @_UserId<0     
 BEGIN    
  SELECT @PositiveUserId=@PositiveUserId * -1    
 END    
 DECLARE @OrgGroupId bigint,@UserGroupId bigint    
 SELECT @OrgGroupId=550    
 SELECT @UserGroupId=GroupId FROM Administration..TUser WHERE UserId=@PositiveUserId AND IndigoClientId=@IndigoClientId    
     
 IF @UserGroupId<>@OrgGroupId    
 BEGIN    
  SELECT @IsLimited=1    
 END     
    
END    
---------------------------------------------------------------------------------------    
-- SuperViewers won't have an entry in the key table so we need to get their rights now    
IF @_UserId < 0    
 EXEC Administration..SpCustomGetSuperUserRights @_UserId, 'CRMContact', @RightMask OUTPUT, @AdvancedMask OUTPUT    
    
-- Limit rows returned?    
IF (@_TopN > 0) SET ROWCOUNT @_TopN    
    
If Object_Id('tempdb..#TPolicyBusiness') Is Not Null    
 Drop Table #TPolicyBusiness    
    
Create Table #TPolicyBusiness(PolicyBusinessId Bigint, PolicyDetailId Bigint,    
 PolicyNumber varchar(50), ProductName varchar(50), AdviceTypeId bigint, SequentialRef varchar(50))    
    
Insert into #TPolicyBusiness    
( PolicyBusinessId, PolicyDetailId, PolicyNumber, ProductName, AdviceTypeId, SequentialRef )    
Select PolicyBusinessId, PolicyDetailId, PolicyNumber, ProductName, AdviceTypeId,SequentialRef    
From PolicyManagement..TPolicyBusiness T7    
Where T7.IndigoClientId = @IndigoClientId        
 AND (ISNULL(@PolicyNumber,'')='' Or T7.PolicyNumber LIKE @PolicyNumber + '%')    
  AND (ISNULL(@SequentialRef,'')='' OR T7.SequentialRef = @SequentialRef)      
    
If Object_Id('tempdb..#SpCustomSearchClientFullSecure') Is Not Null    
 Drop Table #SpCustomSearchClientFullSecure    
    
Create Table #SpCustomSearchClientFullSecure(    
 CRMContactId varchar(20),    
 CRMContactType varchar(3),
 PersonId varchar(20),
 CorporateId varchar(20),
 TrustId varchar(20),      
 AdvisorRef varchar(50),    
 CurrentAdvisername varchar(255),
 OriginalAdviserCRMId varchar(50),  
 CurrentAdviserCRMId varchar(50),     
 LastName varchar(150),    
 FirstName varchar(150),    
 CorporateName varchar(255),    
 ClientName varchar(355),    
 CRMContactLastNameCorporateName varchar(355),    
 PolicyBusinessId bigint,    
 ChangedToDate varchar(10),    
 PolicyNumber  varchar(50),    
 ProductName varchar(50),    
 PolicyStatus varchar(50),    
 PolicyType varchar(255),    
 ExternalReference varchar(60),    
 UserGroupId bigint,    
 OrganisationGroupId bigint,    
 IOBReference varchar(50),
  AddressLine1 varchar(50),  
 AddressLine2 varchar(50),
 AddressLine3 varchar(50),
 AddressLine4 varchar(50),
 CityTown varchar(50),
 PostCode varchar(50),  
 CountyName varchar(50),
 CountryName varchar(50),  
 Title varchar(50),
 Telephone varchar(50),  
 Mobile varchar(50),  
 Fax varchar(50),  
 EMail varchar(50),  
 Web varchar(50),  
 ConcurrencyId varchar(10),   
 _RightMask varchar(20),    
 _AdvancedMask varchar(20),
 _OwnerId varchar(20)    
)    
    
    
BEGIN    
 Insert Into #SpCustomSearchClientFullSecure    
 (CRMContactId,    
 CRMContactType, 
 PersonId,
 CorporateId,
 TrustId,   
 AdvisorRef,    
 CurrentAdviserName,
 OriginalAdviserCRMId,  
 CurrentAdviserCRMId,  
 LastName,    
 FirstName,    
 CorporateName,    
 ClientName,    
 CRMContactLastNameCorporateName,    
 PolicyBusinessId,    
 ChangedToDate,    
 PolicyNumber,    
 ProductName,    
 PolicyStatus,    
 PolicyType,    
 ExternalReference,     
 IOBReference,
 AddressLine1,  
 AddressLine2,
 AddressLine3,
 AddressLine4,
 CityTown,
 PostCode,  
 CountyName,
 CountryName,  
 Title,
 Telephone,  
 Mobile,  
 Fax,  
 EMail,  
 Web, 
 ConcurrencyId,    
 _RightMask,    
 _AdvancedMask,
 _OwnerId)    
    
 Select    
  T1.CRMContactId AS [CRMContact!1!CRMContactId],     
  T1.CRMContactType AS [CRMContact!1!CRMContactType], 
  ISNULL(T1.PersonId,'')[CRMContact!1!PersonId],     
  ISNULL(T1.CorporateId,'')[CRMContact!1!CorporateId],     
  ISNULL(T1.TrustId,'')[CRMContact!1!TrustId], 
  ISNULL(T1.AdvisorRef, '') AS [CRMContact!1!AdvisorRef],     
  ISNULL(T1.CurrentAdviserName, '') AS [CRMContact!1!CurrentAdviserName],    
  ISNULL(T1.OriginalAdviserCRMId, '') AS [CRMContact!1!OriginalAdviserCRMId],
  ISNULL(T1.CurrentAdviserCRMId, '') AS [CRMContact!1!CurrentAdviserCRMId],
  ISNULL(T1.LastName, '') AS [CRMContact!1!LastName],     
  ISNULL(T1.FirstName, '') AS [CRMContact!1!FirstName],     
  ISNULL(T1.CorporateName, '') AS [CRMContact!1!CorporateName],     
  ISNULL(T1.CorporateName, '') + ISNULL(T1.FirstName + ' ' + T1.LastName, '') AS [CRMContact!1!ClientName],    
  ISNULL(T1.CorporateName, '') + ISNULL(T1.LastName, '') AS [CRMContact!1!CRMContactLastNameCorporateName],    
  ISNULL(Plans.PolicyBusinessId,0) AS [CRMContact!1!PolicyBusinessId],    
  Plans.ChangedToDate AS [CRMContact!1!ChangedToDate],    
  ISNULL(Plans.PolicyNumber, '') AS [CRMContact!1!PolicyNumber],    
  ISNULL(Plans.ProductName, '') AS [CRMContact!1!ProductName],    
  ISNULL(Plans.Status, '') AS [CRMContact!1!PolicyStatus],    
  ISNULL(Plans.PlanTypeName, '') AS [CRMContact!1!PolicyType],    
  ISNULL(T1.ExternalReference, '') AS [CRMContact!1!ExternalReference],      
  ISNULL(Plans.[SequentialRef], '') AS [CRMContact!1!IOBReference],
  ISNULL(T14.AddressLine1, '') AS [CRMContact!1!AddressLine1],  
  ISNULL(T14.AddressLine2, '') AS [CRMContact!1!AddressLine2],  
  ISNULL(T14.AddressLine3, '') AS [CRMContact!1!AddressLine3],  
  ISNULL(T14.AddressLine4, '') AS [CRMContact!1!AddressLine4],  
  ISNULL(T14.CityTown, '') AS [CRMContact!1!CityTown],  
  ISNULL(T14.PostCode, '') AS [CRMContact!1!PostCode],  
  ISNULL(T15.CountyName, '') AS [CRMContact!1!County],  
  ISNULL(T16.CountryName, '') AS [CRMContact!1!Country],  
  ISNULL(T18.Title, '') AS [CRMContact!1!Title],  
  ISNULL(T19.Value, '') AS [CRMContact!1!Telephone],  
  ISNULL(T20.Value, '') AS [CRMContact!1!Mobile],  
  ISNULL(T21.Value, '') AS [CRMContact!1!Fax],  
  ISNULL(T22.Value, '') AS [CRMContact!1!EMail],  
  ISNULL(T23.Value, '') AS [CRMContact!1!Web],    
  T1.ConcurrencyId AS [CRMContact!1!ConcurrencyId],   
CASE T1._OwnerId        
 WHEN ABS(@_UserId) THEN 15        
 ELSE ISNULL(TCKey.RightMask,@RightMask)|ISNULL(TEKey.RightMask, @RightMask)        
 END AS [CRMContact!1!_RightMask],        
CASE T1._OwnerId        
 WHEN ABS(@_UserId) THEN 240        
 ELSE ISNULL(TCKey.AdvancedMask,@AdvancedMask)|ISNULL(TEKey.AdvancedMask, @AdvancedMask)         
 END AS [CRMContact!1!_AdvancedMask],
 T1._OwnerId   
    
 FROM     
  TCRMContact T1  WITH(NOLOCK)     
  LEFT JOIN    
  (    
   SELECT    
    T2.CRMContactId,    
    T7.PolicyNumber,    
    T7.ProductName,    
    T6.RefPlanTypeId,    
    T6.PlanTypeName,    
    T8.RefProdProviderId,    
    ISNULL(CONVERT(varchar,T10.ChangedToDate,103),'n/a') ChangedToDate,    
    T9.CorporateName,  --Provider Name    
    T11.[Name] 'Status',    
    T7.PolicyBusinessId,    
    T7.SequentialRef    
   FROM    
    PolicyManagement..TPolicyDetail T3  WITH(NOLOCK)     
    -- JOIN PolicyManagement..TPolicyBusiness T7  WITH(NOLOCK)  ON T3.PolicyDetailId = T7.PolicyDetailId AND T7.IndigoClientId = @IndigoClientId    
    JOIN #TPolicyBusiness T7  WITH(NOLOCK)  ON T3.PolicyDetailId = T7.PolicyDetailId    
    JOIN PolicyManagement..TPolicyOwner T2  WITH(NOLOCK)  ON T2.PolicyDetailId = T3.PolicyDetailId    
    JOIN PolicyManagement..TPlanDescription T4  WITH(NOLOCK)  ON T3.PlanDescriptionId = T4.PlanDescriptionId    
    JOIN PolicyManagement..TRefPlanType2ProdSubType T5  WITH(NOLOCK)  ON T4.RefPlanType2ProdSubTypeId = T5.RefPlanType2ProdSubTypeId    
    JOIN PolicyManagement..TRefPlanType T6  WITH(NOLOCK)  ON T5.RefPlanTypeId = T6.RefPlanTypeId     
    JOIN PolicyManagement..TRefProdProvider T8  WITH(NOLOCK) ON T8.RefProdProviderId = T4.RefProdProviderId    
    JOIN TCRMContact T9 WITH(NOLOCK) ON    T9.CRMContactId = T8.CRMContactId    
    JOIN PolicyManagement..TStatusHistory T10  WITH(NOLOCK) ON  T10.PolicyBusinessId = T7.PolicyBusinessId  AND T10.CurrentStatusFG = 1    
    JOIN PolicyManagement..TStatus T11  WITH(NOLOCK)  ON T11.StatusId = T10.StatusId AND ISNULL(T11.IntelligentOfficeStatusType, '') != 'Deleted'    
        And T11.IndigoClientId = @IndigoClientId  	
   WHERE    
    T3.IndigoClientId = @IndigoClientId        
    AND (@PolicyNumber IS NULL OR T7.PolicyNumber LIKE @PolicyNumber)    
    AND (@IsLimited=0 OR ((T11.[Name]='In force' OR T11.[Name]='Submitted To Provider') AND @IsLimited=1))    
    AND (@IsLimited=0 OR T7.AdviceTypeId<>@LighthousePreExistingAdviceType)    
    AND (@SequentialRef IS NULL OR T7.SequentialRef = @SequentialRef)      
  ) AS Plans ON Plans.CRMContactId = T1.CRMContactId  
  LEFT JOIN TAddress T13 WITH(NOLOCK) ON T13.CRMContactId = T1.CRMContactId AND T13.DefaultFG = 1  
  LEFT JOIN TAddressStore T14 WITH(NOLOCK) ON T14.AddressStoreId = T13.AddressStoreId  
  LEFT JOIN TRefCounty T15 WITH(NOLOCK) ON T15.RefCountyId = T14.RefCountyId  
  LEFT JOIN TRefCountry T16 WITH(NOLOCK) ON T16.RefCountryId = T14.RefCountryId  
  LEFT JOIN TPerson T18 WITH(NOLOCK) ON T18.PersonId = T1.PersonId  
  LEFT JOIN TContact T19 WITH(NOLOCK) ON T19.CRMContactId = T1.CRMContactId AND T19.DefaultFG = 1 AND T19.RefContactType = 'Telephone'  
  LEFT JOIN TContact T20 WITH(NOLOCK) ON T20.CRMContactId = T1.CRMContactId AND T20.DefaultFG = 1 AND T20.RefContactType = 'Mobile'  
  LEFT JOIN TContact T21 WITH(NOLOCK) ON T21.CRMContactId = T1.CRMContactId AND T21.DefaultFG = 1 AND T21.RefContactType = 'Fax'  
  LEFT JOIN TContact T22 WITH(NOLOCK) ON T22.CRMContactId = T1.CRMContactId AND T22.DefaultFG = 1 AND T22.RefContactType = 'E-Mail'  
  LEFT JOIN TContact T23 WITH(NOLOCK) ON T23.CRMContactId = T1.CRMContactId AND T23.DefaultFG = 1 AND T23.RefContactType = 'Web Site'
  -- Secure (we have two joins, one for ownership rights & one for specific user/role rights)    
  LEFT JOIN VwCRMContactKeyByCreatorId AS TCKey ON TCKey.UserId = @_UserId AND TCKey.CreatorId = T1._OwnerId    
  LEFT JOIN VwCRMContactKeyByEntityId AS TEKey ON TEKey.UserId = @_UserId AND TEKey.EntityId = T1.CRMContactId    
 WHERE     
  T1.IndClientId = @IndigoClientId AND ISNULL(T1.RefCRMContactStatusId,0) = 1 AND T1.ArchiveFG=0      
  AND (@PolicyNumber IS NULL OR Plans.PolicyNumber LIKE @PolicyNumber + '%')    
  AND (@_UserId < 0 OR (T1._OwnerId=@_UserId OR (TCKey.CreatorId IS NOT NULL OR TEKey.EntityId IS NOT NULL)))    
  AND (@IsLimited=0 OR (@IsLimited=1 AND Plans.PolicyBusinessId IS NOT NULL))    
  AND (@SequentialRef IS NULL OR Plans.SequentialRef = @SequentialRef)      
    
-- Order By T1.LastName, T1.CorporateName, T1.FirstName    
    
    
SELECT    
  1 AS Tag,    
  NULL AS Parent,    
  t1.CRMContactId AS [CRMContact!1!CRMContactId],     
  CRMContactType AS [CRMContact!1!CRMContactType],  
ISNULL(T1.PersonId, '') AS [CRMContact!1!PersonId],   
 ISNULL(T1.CorporateId, '') AS [CRMContact!1!CorporateId],   
 ISNULL(T1.TrustId, '') AS [CRMContact!1!TrustId],      
  AdvisorRef AS [CRMContact!1!AdvisorRef],       
  LastName AS [CRMContact!1!LastName],     
  FirstName AS [CRMContact!1!FirstName],     
  CorporateName AS [CRMContact!1!CorporateName],
  CASE  
	  WHEN T1.CRMContactType = 1 THEN 'Person'  
	  WHEN T1.CRMContactType = 2 THEN 'Trust'  
	  WHEN T1.CRMContactType = 3 THEN 'Corporate'  
	  WHEN T1.CRMContactType = 4 THEN 'Group'  
  END AS  [CRMContact!1!CRMContactTypeName],
  ISNULL(T1.CorporateName, '') + ISNULL(T1.FirstName + ' ' + T1.LastName, '') AS [CRMContact!1!ClientName],  
  ISNULL(T1.CorporateName, '') + ISNULL(T1.LastName, '') AS [CRMContact!1!CRMContactLastNameCorporateName],       
 ISNULL(t1.PolicyNumber, '') AS [CRMContact!1!PolicyNumber],  
 ISNULL(t1.ProductName, '') AS [CRMContact!1!ProductName],  
 ISNULL(t1.PolicyStatus, '') AS [CRMContact!1!PolicyStatus],  
 CONVERT(varchar(24), t1.ChangedToDate, 120) AS [CRMContact!1!StatusDate],  
 ISNULL(t1.PolicyType, '') AS [CRMContact!1!PolicyType],  
 ISNULL(t1.CorporateName, '') AS [CRMContact!1!ProviderName],  
 T1.OriginalAdviserCRMId AS [CRMContact!1!OriginalAdviserCRMId],   
 T1.CurrentAdviserCRMId AS [CRMContact!1!CurrentAdviserCRMId],   
 ISNULL(T1.CurrentAdviserName, '') AS [CRMContact!1!CurrentAdviserName],  
 ISNULL(T1.ExternalReference, '') AS [CRMContact!1!ExternalReference],  
 T1.ConcurrencyId AS [CRMContact!1!ConcurrencyId],   
 ISNULL(T1.AddressLine1, '') AS [CRMContact!1!AddressLine1],  
 ISNULL(T1.AddressLine2, '') AS [CRMContact!1!AddressLine2],  
 ISNULL(T1.AddressLine3, '') AS [CRMContact!1!AddressLine3],  
 ISNULL(T1.AddressLine4, '') AS [CRMContact!1!AddressLine4],  
 ISNULL(T1.CityTown, '') AS [CRMContact!1!CityTown],  
 ISNULL(T1.PostCode, '') AS [CRMContact!1!PostCode],  
 ISNULL(T1.CountyName, '') AS [CRMContact!1!County],  
 ISNULL(T1.CountryName, '') AS [CRMContact!1!Country],  
 ISNULL(T1.Title, '') AS [CRMContact!1!Title],  
 ISNULL(T1.Telephone, '') AS [CRMContact!1!Telephone],  
 ISNULL(T1.Mobile, '') AS [CRMContact!1!Mobile],  
 ISNULL(T1.Fax, '') AS [CRMContact!1!Fax],  
 ISNULL(T1.EMail, '') AS [CRMContact!1!E-Mail],  
 ISNULL(T1.Web, '') AS [CRMContact!1!Web],  
 ISNULL(T1._RightMask,'') AS [CRMContact!1!_RightMask],  
 ISNULL(T1._AdvancedMask,'') AS [CRMContact!1!_AdvancedMask],  
 ISNULL(T1.IOBReference, '') AS [CRMContact!1!IOBReference],  
 ISNULL(T1.PolicyBusinessId,0) AS [CRMContact!1!PolicyBusinessId] 
 From #SpCustomSearchClientFullSecure t1    
    
LEFT JOIN     
  (      
  Select A.crmcontactid, max(A.addressstoreid) as AddressStoreId      
  from taddress A WITH(NOLOCK)     
  Inner Join #SpCustomSearchClientFullSecure B    
   On A.CRMContactId = B.CRMContactId    
  Where defaultfg = 1  and A.indclientid = @indigoClientId      
  Group By A.crmcontactid    
  ) address on address.crmcontactid = t1.crmcontactid      
  LEFT JOIN TAddressStore ast WITH(NOLOCK)  ON ast.AddressStoreId = address.AddressStoreId     
    
 ORDER BY [CRMContact!1!CRMContactLastNameCorporateName] ASC, [CRMContact!1!FirstName] ASC 


 FOR XML EXPLICIT    
    
 IF (@_TopN > 0) SET ROWCOUNT 0    
END    
    
RETURN (0)  
  
  
GO
