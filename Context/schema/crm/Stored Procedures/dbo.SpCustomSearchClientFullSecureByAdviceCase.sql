SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomSearchClientFullSecureByAdviceCase]    
 @IndigoClientId bigint,    
 @SequentialRef varchar(50)=NULL,    
 @AdviceCaseName varchar(50)=NULL, 
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


--------------------------------------------------------------------------------------
--For Lighthouse Limited Access to Advisers Who are members of a non-organisation group    
--------------------------------------------------------------------------------------
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
Select B.PolicyBusinessId, PolicyDetailId, PolicyNumber, ProductName, AdviceTypeId, C.SequentialRef    
From CRM..TAdviceCase A
JOIN CRM..TAdviceCasePlan B ON A.AdviceCaseId=B.AdviceCaseId
JOIN PolicyManagement..TPolicyBusiness C ON B.PolicyBusinessId=C.PolicyBusinessId    
Where C.IndigoClientId = @IndigoClientId        
AND (ISNULL(@SequentialRef,'')!='' AND ltrim(rtrim(A.CaseRef))=@SequentialRef) OR(ISNULL(@AdviceCaseName,'')!='' AND A.CaseName like @AdviceCaseName)

    
If Object_Id('tempdb..#SpCustomSearchClientFullSecure') Is Not Null    
 Drop Table #SpCustomSearchClientFullSecure    
    
Create Table #SpCustomSearchClientFullSecure(    
 CRMContactId varchar(20),    
 CRMContactType varchar(3),    
 AdvisorRef varchar(50),    
 CurrentAdvisername varchar(255),    
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
 ExternalReference varchar(50),    
 UserGroupId bigint,    
 OrganisationGroupId bigint,    
 IOBReference varchar(50),    
 _RightMask varchar(20),    
     _AdvancedMask varchar(20)    
)    
    
    
BEGIN    
 Insert Into #SpCustomSearchClientFullSecure    
 (CRMContactId,    
 CRMContactType,    
 AdvisorRef,    
 CurrentAdviserName,    
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
 _RightMask,    
    _AdvancedMask)    
    
Select    
  T1.CRMContactId AS [CRMContact!1!CRMContactId],     
  T1.CRMContactType AS [CRMContact!1!CRMContactType],     
  ISNULL(T1.AdvisorRef, '') AS [CRMContact!1!AdvisorRef],     
  ISNULL(T1.CurrentAdviserName, '') AS [CRMContact!1!CurrentAdviserName],    
  ISNULL(T1.LastName, '') AS [CRMContact!1!LastName],     
  ISNULL(T1.FirstName, '') AS [CRMContact!1!FirstName],     
  ISNULL(T1.CorporateName, '') AS [CRMContact!1!CorporateName],     
  ISNULL(T1.CorporateName, '') + ISNULL(T1.FirstName + ' ' + T1.LastName, '') AS [CRMContact!1!ClientName],    
  ISNULL(T1.CorporateName, '') + ISNULL(T1.LastName, '') AS [CRMContact!1!CRMContactLastNameCorporateName],    
  ISNULL(Plans.PolicyBusinessId,0) AS [CRMContact!1!PolicyBusinessId],    
  Plans.ChangedToDate AS [CRMContact!1!ChangedToDate],    
  ISNULL(Plans.PolicyNumber, '') AS [CRMContact!1!PolicyNumber],    
  ISNULL(Plans.ProductName, '') AS [CRMContact!1!ProductName],    
  ISNULL(Plans.[Name], '') AS [CRMContact!1!PolicyStatus],    
  ISNULL(Plans.PlanTypeName, '') AS [CRMContact!1!PolicyType],    
  ISNULL(T1.ExternalReference, '') AS [CRMContact!1!ExternalReference],      
  ISNULL(Plans.[SequentialRef], '') AS [CRMContact!1!IOBReference],    
CASE T1._OwnerId        
 WHEN ABS(@_UserId) THEN 15        
 ELSE ISNULL(TCKey.RightMask,@RightMask)|ISNULL(TEKey.RightMask, @RightMask)        
 END AS [CRMContact!1!_RightMask],        
CASE T1._OwnerId        
 WHEN ABS(@_UserId) THEN 240        
 ELSE ISNULL(TCKey.AdvancedMask,@AdvancedMask)|ISNULL(TEKey.AdvancedMask, @AdvancedMask)         
 END AS [CRMContact!1!_AdvancedMask]    
    
 FROM     
  TCRMContact T1  WITH(NOLOCK)     
  JOIN    
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
    T11.[Name],    
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
    AND (@IsLimited=0 OR ((T11.[Name]='In force' OR T11.[Name]='Submitted To Provider') AND @IsLimited=1))    
    AND (@IsLimited=0 OR T7.AdviceTypeId<>@LighthousePreExistingAdviceType)        
  ) AS Plans ON Plans.CRMContactId = T1.CRMContactId    
  LEFT JOIN VwCRMContactKeyByCreatorId AS TCKey ON TCKey.UserId = @_UserId AND TCKey.CreatorId = T1._OwnerId    
  LEFT JOIN VwCRMContactKeyByEntityId AS TEKey ON TEKey.UserId = @_UserId AND TEKey.EntityId = T1.CRMContactId    
 WHERE     
  T1.IndClientId = @IndigoClientId AND ISNULL(T1.RefCRMContactStatusId,0) = 1 AND T1.ArchiveFG=0        
  AND (@_UserId < 0 OR (T1._OwnerId=@_UserId OR (TCKey.CreatorId IS NOT NULL OR TEKey.EntityId IS NOT NULL)))    
  AND (@IsLimited=0 OR (@IsLimited=1 AND Plans.PolicyBusinessId IS NOT NULL))    
    
SELECT    
  1 AS Tag,    
  NULL AS Parent,    
  t1.CRMContactId AS [CRMContact!1!CRMContactId],     
  CRMContactType AS [CRMContact!1!CRMContactType],     
  AdvisorRef AS [CRMContact!1!AdvisorRef],     
  ISNULL(T1.CurrentAdviserName, '') AS [CRMContact!1!CurrentAdviserName],    
  LastName AS [CRMContact!1!LastName],     
  FirstName AS [CRMContact!1!FirstName],     
  CorporateName AS [CRMContact!1!CorporateName],     
  ClientName AS [CRMContact!1!ClientName],    
  CRMContactLastNameCorporateName AS [CRMContact!1!CRMContactLastNameCorporateName],    
   ISNULL(t1.CorporateName,'') + ISNULL(t1.FirstName,'') + ' ' + ISNULL(t1.LastName,'') as [CRMContact!1!ClientFullName],    
  PolicyBusinessId AS [CRMContact!1!PolicyBusinessId],    
  CASE PolicyStatus    
   WHEN 'In Force' THEN ChangedToDate    
   ELSE ''    
  END AS [CRMContact!1!ChangedToDate],    
  PolicyNumber AS [CRMContact!1!PolicyNumber],    
  ProductName AS [CRMContact!1!ProductName],    
  PolicyStatus AS [CRMContact!1!PolicyStatus],    
  PolicyType AS [CRMContact!1!PolicyType],    
  ISNULL(ast.AddressLine1,'') as [CRMContact!1!AddressLine1],     
  ExternalReference AS [CRMContact!1!ExternalReference],    
  IOBReference AS [CRMContact!1!SequentialRef],    
  _RightMask AS [CRMContact!1!_RightMask],    
     _AdvancedMask AS [CRMContact!1!_AdvancedMask]    
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
