SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--[SpCustomSearchClientFullSecureByName] 99,'','','',0,null,null,'69035~system',null,-14120,250
CREATE PROCEDURE [dbo].[SpCustomSearchClientFullSecureByName]    
 @IndigoClientId bigint,    
 @CorporateName  varchar(255) = '',    
 @FirstName varchar(255) = '',    
 @LastName varchar(255) = '',     
--  @PlanTypeId bigint = 0,    
--  @PolicyNumber varchar(50) = NULL,    
--  @RefProdProviderId bigint = 0,    
  @PractitionerId bigint = 0,    
--  @ProductName varchar(50) = NULL,    
 @ServiceStatus varchar(50) = NULL,
 @RefFundManager varchar(50) = NULL,
 @Fund varchar(50) = NULL,
 @Postcode varchar(50) = NULL,
 @_UserId bigint,    
 @_TopN int = 0    

WITH RECOMPILE
AS    
-- User rights    
DECLARE @RightMask int, @AdvancedMask int    
DECLARE @LighthousePreExistingAdviceType bigint    
DECLARE @IsLimited bit    
    
    
SELECT @RightMask = 1, @AdvancedMask = 0    
SELECT @IsLimited=0    
SELECT @LighthousePreExistingAdviceType=3151    
    
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
 IF EXISTS (select* from administration..tawkwarduser where userid=@_userid and IsExempt=1)  
  SELECT @IsLimited=0   
 Else    
  SELECT @IsLimited=1    
 END     
    
END    
---------------------------------------------------------------------------------------    
-- SuperViewers won't have an entry in the key table so we need to get their rights now    
IF @_UserId < 0    
 EXEC Administration..SpCustomGetSuperUserRights @_UserId, 'CRMContact', @RightMask OUTPUT, @AdvancedMask OUTPUT    
    
Declare @CrmContactIdForPractitionerId bigint    
Select @CrmContactIdForPractitionerId = 0    
    
If @PractitionerId > 0    
Begin    
 Select @CrmContactIdForPractitionerId = CrmContactId    
 From dbo.TPractitioner    
 Where PractitionerId = @PractitionerId    
End    

declare @FundUnitId bigint,
		@NonFeedFundId bigint

if(@Fund is not null) begin

	if(ltrim(rtrim(substring(@Fund,charindex('~',@Fund)+1,25))) = 'System')
	begin
		select @FundUnitId = substring(@Fund,0,charindex('~',@Fund))
	end	else begin
		select @NonFeedFundId = substring(@Fund,0,charindex('~',@Fund))
	end
end
    
If Object_Id('tempdb..#TCrmContact') Is Not Null    
 Drop Table #TCrmContact    
    
Create Table #TCrmContact( CRMContactId bigint, FirstName varchar(50), LastName varchar(50),    
CorporateName varchar(255), CurrentAdviserName varchar(255), CRMContactType tinyint, AdvisorRef varchar(50),    
_OwnerId bigint, ExternalReference varchar(60), CurrentAdviserCRMId bigint, _RightMask int, _AdvancedMask int )    
    
    
    
Insert into #TCrmContact    
( CRMContactId, FirstName, LastName, CorporateName, CurrentAdviserName, CRMContactType, AdvisorRef,    
 _OwnerId, ExternalReference, CurrentAdviserCRMId, _RightMask, _AdvancedMask )    
Select distinct T1.CRMContactId, T1.FirstName, T1.LastName, T1.CorporateName, T1.CurrentAdviserName, T1.CRMContactType, T1.AdvisorRef,    
 T1._OwnerId, T1.ExternalReference, T1.CurrentAdviserCRMId,    
CASE T1._OwnerId        
 WHEN ABS(@_UserId) THEN 15        
 ELSE ISNULL(TCKey.RightMask,@RightMask)|ISNULL(TEKey.RightMask, @RightMask)        
 END ,        
CASE T1._OwnerId        
 WHEN ABS(@_UserId) THEN 240        
 ELSE ISNULL(TCKey.AdvancedMask,@AdvancedMask)|ISNULL(TEKey.AdvancedMask, @AdvancedMask)         
 END   
   
    
From dbo.TCrmContact T1 WITH(NOLOCK)    
LEFT JOIN TAddress Ad WITH(NOLOCK) on Ad.CRMContactId = T1.CRMContactId
LEFT JOIN TAddressStore Ads WITH (NOLOCK) on Ads.AddressStoreId = Ad.AddressStoreId
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
    T11.[Name],    
    T7.PolicyBusinessId,    
    T7.SequentialRef,
    fu.FundUnitId,
    F.FundProviderId,
	Nff.NonFeedFundId,
    Nff.CompanyId
   FROM    
    PolicyManagement..TPolicyDetail T3  WITH(NOLOCK)     
    JOIN PolicyManagement..TPolicyBusiness T7  WITH(NOLOCK)  ON T3.PolicyDetailId = T7.PolicyDetailId AND T7.IndigoClientId = @IndigoClientId    
    JOIN PolicyManagement..TPolicyOwner T2  WITH(NOLOCK)  ON T2.PolicyDetailId = T3.PolicyDetailId    
    JOIN PolicyManagement..TPlanDescription T4  WITH(NOLOCK)  ON T3.PlanDescriptionId = T4.PlanDescriptionId    
    JOIN PolicyManagement..TRefPlanType2ProdSubType T5  WITH(NOLOCK)  ON T4.RefPlanType2ProdSubTypeId = T5.RefPlanType2ProdSubTypeId    
    JOIN PolicyManagement..TRefPlanType T6  WITH(NOLOCK)  ON T5.RefPlanTypeId = T6.RefPlanTypeId     
    JOIN PolicyManagement..TRefProdProvider T8  WITH(NOLOCK) ON T8.RefProdProviderId = T4.RefProdProviderId    
    JOIN TCRMContact T9 WITH(NOLOCK) ON    T9.CRMContactId = T8.CRMContactId    
    JOIN PolicyManagement..TStatusHistory T10 WITH(NOLOCK) ON  T10.PolicyBusinessId = T7.PolicyBusinessId  AND T10.CurrentStatusFG = 1    
    JOIN PolicyManagement..TStatus T11  WITH(NOLOCK)  ON T11.StatusId = T10.StatusId AND ISNULL(T11.IntelligentOfficeStatusType, '') != 'Deleted'    
	LEFT JOIN PolicyManagement..TPolicyBusinessFund Pbf WITH(NOLOCK) ON Pbf.PolicyBusinessId = T7.PolicyBusinessId
	LEFT JOIN Fund2..TFundUnit fu WITH(NOLOCK) ON fu.FundUnitId = Pbf.FundId AND Pbf.FromFeedFg = 1 AND pbf.EquityFg = 0    
	LEFT JOIN Fund2..TFund f WITH(NOLOCK) ON f.FundId = fu.FundId
	LEFT JOIN PolicyManagement..TNonFeedFund Nff WITH(NOLOCK) ON Nff.NonFeedFundId = Pbf.FundId AND Pbf.FromFeedFg = 0  
        --And T11.IndigoClientId = @IndigoClientId    
   WHERE    
    T3.IndigoClientId = @IndigoClientId           
     AND (@IsLimited=0 OR ((T11.[Name]='In force' OR T11.[Name]='Submitted To Provider') AND @IsLimited=1))    
     AND (@IsLimited=0 OR T7.AdviceTypeId<>@LighthousePreExistingAdviceType)     
  ) AS Plans ON Plans.CRMContactId = T1.CRMContactId  

-- Secure (we have two joins, one for ownership rights & one for specific user/role rights)    
LEFT JOIN VwCRMContactKeyByCreatorId AS TCKey     
 ON TCKey.UserId = @_UserId AND TCKey.CreatorId = T1._OwnerId    
LEFT JOIN VwCRMContactKeyByEntityId AS TEKey     
 ON TEKey.UserId = @_UserId AND TEKey.EntityId = T1.CRMContactId    
Where 1=1    
  And T1.IndClientId = @IndigoClientId     
  AND ISNULL(T1.RefCRMContactStatusId,0) = 1     
  AND T1.ArchiveFG = 0    
  And IsNull(T1.CorporateName,'') LIKE @CorporateName + '%'    
  And IsNull(T1.FirstName,'') LIKE @FirstName + '%'    
  And IsNull(T1.LastName,'') LIKE @LastName + '%'    
  AND (@_UserId < 0 OR (T1._OwnerId=@_UserId OR (TCKey.CreatorId IS NOT NULL OR TEKey.EntityId IS NOT NULL)))   
  AND ((@CrmContactIdForPractitionerId = 0) Or (@CrmContactIdForPractitionerId > 0 And T1.CurrentAdviserCRMId = @CrmContactIdForPractitionerId ))    
  AND (Ads.Postcode LIKE '%' + @Postcode + '%' OR @Postcode IS NULL)
  AND (T1.RefServiceStatusId = @ServiceStatus Or @ServiceStatus IS NULL)
  AND (
		(@FundUnitId  IS NULL and @NonFeedFundId  IS NULL) OR 
		(Plans.FundUnitId = @FundUnitId and Plans.FundUnitId is not null and @NonFeedFundId  IS NULL) OR 
		(Plans.NonFeedFundId = @NonFeedFundId and Plans.NonFeedFundId is not null and @FundUnitId is null)
	  )
  AND (
		@RefFundManager IS NULL OR 
		(Plans.FundProviderId = @RefFundManager And Plans.FundProviderId is not null) OR
		(Plans.CompanyId = @RefFundManager and Plans.CompanyId is not null)       
	  )
Order By LastName, CorporateName, FirstName    
    
If Object_Id('tempdb..#SpCustomSearchClientFullSecure') Is Not Null    
Begin    
 Drop Table #SpCustomSearchClientFullSecure    
End    

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
 ExternalReference varchar(60),    
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
  T1._RightMask AS [CRMContact!1!_RightMask],    
  T1._AdvancedMask AS [CRMContact!1!_AdvancedMask]    
    
 FROM     
  #TCRMContact T1  WITH(NOLOCK)     
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
    T11.[Name],    
    T7.PolicyBusinessId,    
    T7.SequentialRef ,
	fu.FundUnitId,
    F.FundProviderId,
	Nff.NonFeedFundId,
    Nff.CompanyId  
   FROM    
    PolicyManagement..TPolicyDetail T3  WITH(NOLOCK)     
    JOIN PolicyManagement..TPolicyBusiness T7  WITH(NOLOCK)  ON T3.PolicyDetailId = T7.PolicyDetailId AND T7.IndigoClientId = @IndigoClientId    
    JOIN PolicyManagement..TPolicyOwner T2  WITH(NOLOCK)  ON T2.PolicyDetailId = T3.PolicyDetailId    
    JOIN PolicyManagement..TPlanDescription T4  WITH(NOLOCK)  ON T3.PlanDescriptionId = T4.PlanDescriptionId    
    JOIN PolicyManagement..TRefPlanType2ProdSubType T5  WITH(NOLOCK)  ON T4.RefPlanType2ProdSubTypeId = T5.RefPlanType2ProdSubTypeId    
    JOIN PolicyManagement..TRefPlanType T6  WITH(NOLOCK)  ON T5.RefPlanTypeId = T6.RefPlanTypeId     
    JOIN PolicyManagement..TRefProdProvider T8  WITH(NOLOCK) ON T8.RefProdProviderId = T4.RefProdProviderId    
    JOIN TCRMContact T9 WITH(NOLOCK) ON    T9.CRMContactId = T8.CRMContactId    
    JOIN PolicyManagement..TStatusHistory T10 WITH(NOLOCK) ON  T10.PolicyBusinessId = T7.PolicyBusinessId  AND T10.CurrentStatusFG = 1    
    JOIN PolicyManagement..TStatus T11  WITH(NOLOCK)  ON T11.StatusId = T10.StatusId AND ISNULL(T11.IntelligentOfficeStatusType, '') != 'Deleted'    
	LEFT JOIN PolicyManagement..TPolicyBusinessFund Pbf WITH(NOLOCK) ON Pbf.PolicyBusinessId = T7.PolicyBusinessId
	LEFT JOIN Fund2..TFundUnit fu WITH(NOLOCK) ON fu.FundUnitId = Pbf.FundId AND Pbf.FromFeedFg = 1 AND pbf.EquityFg = 0    
	LEFT JOIN Fund2..TFund f WITH(NOLOCK) ON f.FundId = fu.FundId
	LEFT JOIN PolicyManagement..TNonFeedFund Nff WITH(NOLOCK) ON Nff.NonFeedFundId = Pbf.FundId AND Pbf.FromFeedFg = 0 
        --And T11.IndigoClientId = @IndigoClientId    
   WHERE    
    T3.IndigoClientId = @IndigoClientId           
     AND (@IsLimited=0 OR ((T11.[Name]='In force' OR T11.[Name]='Submitted To Provider') AND @IsLimited=1))    
     AND (@IsLimited=0 OR T7.AdviceTypeId<>@LighthousePreExistingAdviceType)     
  ) AS Plans ON Plans.CRMContactId = T1.CRMContactId    
 WHERE 1=1    
  AND (@IsLimited=0 OR (@IsLimited=1 AND Plans.PolicyBusinessId IS NOT NULL))    
      AND (
		(@FundUnitId  IS NULL and @NonFeedFundId  IS NULL) OR 
		(Plans.FundUnitId = @FundUnitId and Plans.FundUnitId is not null and @NonFeedFundId  IS NULL) OR 
		(Plans.NonFeedFundId = @NonFeedFundId and Plans.NonFeedFundId is not null and @FundUnitId is null)
	  )
  AND (
		@RefFundManager IS NULL OR 
		(Plans.FundProviderId = @RefFundManager And Plans.FundProviderId is not null) OR
		(Plans.CompanyId = @RefFundManager and Plans.CompanyId is not null)       
	  )
    

    
-- Limit rows returned?    
IF (@_TopN > 0) SET ROWCOUNT @_TopN    

    
SELECT    distinct
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
