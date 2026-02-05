SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCustomSearchClientFullSecureDefault]  
 @IndigoClientId bigint,    
 @CorporateName  varchar(255) = NULL,    
 @FirstName varchar(255) = NULL,    
 @LastName varchar(255) = NULL,     
 @PlanTypeId bigint = 0,    
 @PolicyNumber varchar(50) = NULL,    
 @RefProdProviderId bigint = 0,    
 @PractitionerId bigint = 0,    
 @ProductName varchar(50) = NULL,    
 @IOBReference varchar(50)=NULL,  
 @ServiceStatus varchar(50) = NULL,
 @RefFundManager varchar(50) = NULL,
 @Fund varchar(50) = NULL,
 @Postcode varchar(50) = NULL,
 @_UserId bigint,    
 @_TopN int = 0    
AS    
  
DECLARE @IndigoClientId2 bigint  
set @IndigoClientId2 = @IndigoClientId   
  
-- User rights    
DECLARE @RightMask int, @AdvancedMask int    
DECLARE @LighthousePreExistingAdviceType bigint    
DECLARE @IsLimited bit    
    
SELECT @RightMask = 1, @AdvancedMask = 0    
SELECT @IsLimited=0    
SELECT @LighthousePreExistingAdviceType=3151    
  
IF ISNULL(@IOBReference,'')<>''  
BEGIN  
 SET @IOBReference='IOB' + RIGHT(REPLICATE('0',8) + @IOBReference,8)  
END  

--For Lighthouse Limited Access to Advisers Who are members of a non-organisation group    
IF @IndigoClientId2 = 213    
BEGIN    
	DECLARE @PositiveUserId bigint    
 	SET @PositiveUserId = ABS(@_UserId)
 
	-- get the limited user setting
	DECLARE @UserSetting TABLE (IsLimited bit)

	INSERT INTO @UserSetting
	EXEC Administration..SpCustomIsUserGroupDifferentToOrgGroup @PositiveUserId

	SELECT @IsLimited = IsLimited FROM @UserSetting
END    
---------------------------------------------------------------------------------------    
-- SuperViewers won't have an entry in the key table so we need to get their rights now    
IF @_UserId < 0    
  EXEC Administration..SpCustomGetSuperUserRights @_UserId, 'CRMContact', @RightMask OUTPUT, @AdvancedMask OUTPUT    
    
-- Limit rows returned?    
IF (@_TopN > 0) SET ROWCOUNT @_TopN    
    

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

Declare @SqlScript1 varchar(8000)  
  
Create Table #SpCustomSearchClientFullSecure (  
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
 PolicyNumber  varchar(255),    
 ProductName varchar(255),    
 PolicyStatus varchar(50),    
 PolicyType varchar(255),    
 ExternalReference varchar(255),    
 UserGroupId bigint,    
 OrganisationGroupId bigint,    
 IOBReference varchar(50),  
 _RightMask varchar(20),    
 _AdvancedMask varchar(20)    
)      
    
    
BEGIN    
Select @SqlScript1 = 'Insert Into #SpCustomSearchClientFullSecure    
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
  ISNULL(T1.AdvisorRef, '''') AS [CRMContact!1!AdvisorRef],     
  ISNULL(T1.CurrentAdviserName, '''') AS [CRMContact!1!CurrentAdviserName],    
  ISNULL(T1.LastName, '''') AS [CRMContact!1!LastName],     
  ISNULL(T1.FirstName, '''') AS [CRMContact!1!FirstName],     
 ISNULL(T1.CorporateName, '''') AS [CRMContact!1!CorporateName],     
  ISNULL(T1.CorporateName, '''') + ISNULL(T1.FirstName + '' '' + T1.LastName, '''') AS [CRMContact!1!ClientName],    
  ISNULL(T1.CorporateName, '''') + ISNULL(T1.LastName, '''') AS [CRMContact!1!CRMContactLastNameCorporateName],    
  ISNULL(Plans.PolicyBusinessId, 0) AS [CRMContact!1!PolicyBusinessId],    
  Plans.ChangedToDate AS [CRMContact!1!ChangedToDate],    
  ISNULL(Plans.PolicyNumber, '''') AS [CRMContact!1!PolicyNumber],    
  ISNULL(Plans.ProductName, '''') AS [CRMContact!1!ProductName],    
  ISNULL(Plans.[Name], '''') AS [CRMContact!1!PolicyStatus],    
  ISNULL(Plans.PlanTypeName, '''') AS [CRMContact!1!PolicyType],    
  ISNULL(T1.ExternalReference, '''') AS [CRMContact!1!ExternalReference],      
ISNULL(Plans.[SequentialRef], '''') AS [CRMContact!1!IOBReference],    
CASE T1._OwnerId      
 WHEN ABS(' + Convert(varchar(50), @_UserId) + ') THEN 15      
 ELSE ISNULL(TCKey.RightMask,' + Convert(varchar(50), @RightMask) + ')|ISNULL(TEKey.RightMask, ' + Convert(varchar(50), @RightMask) + ')      
 END AS [CRMContact!1!_RightMask],      
CASE T1._OwnerId      
 WHEN ABS(' + Convert(varchar(50), @_UserId) + ') THEN 240      
 ELSE ISNULL(TCKey.AdvancedMask,' + Convert(varchar(50), @AdvancedMask) + ')|ISNULL(TEKey.AdvancedMask, ' + Convert(varchar(50), @AdvancedMask) + ')       
 END AS [CRMContact!1!_AdvancedMask]       
 FROM     
  TCRMContact T1  WITH(NOLOCK) 
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
    ISNULL(CONVERT(varchar,T10.ChangedToDate,103),''n/a'') ChangedToDate,    
    T9.CorporateName,  --Provider Name    
    T11.[Name],    
    T7.PolicyBusinessId,  
T7.SequentialRef  ,
  fu.FundUnitId,
    F.FundProviderId,
	Nff.NonFeedFundId,
    Nff.CompanyId
   FROM   
    PolicyManagement..TPolicyDetail T3  WITH(NOLOCK)     
    JOIN PolicyManagement..TPolicyBusiness T7  WITH(NOLOCK)    
  ON T3.PolicyDetailId = T7.PolicyDetailId   
   AND T3.IndigoClientId = ' + Convert(varchar(50), @IndigoClientId2)  + '  
   AND T7.IndigoClientId = ' + Convert(varchar(50), @IndigoClientId2)  + '  
    JOIN PolicyManagement..TPolicyOwner T2  WITH(NOLOCK)  ON T2.PolicyDetailId = T3.PolicyDetailId    
    JOIN PolicyManagement..TPlanDescription T4  WITH(NOLOCK)  ON T3.PlanDescriptionId = T4.PlanDescriptionId    
    JOIN PolicyManagement..TRefPlanType2ProdSubType T5  WITH(NOLOCK)  ON T4.RefPlanType2ProdSubTypeId = T5.RefPlanType2ProdSubTypeId    
    JOIN PolicyManagement..TRefPlanType T6  WITH(NOLOCK)  ON T5.RefPlanTypeId = T6.RefPlanTypeId     
    JOIN PolicyManagement..TRefProdProvider T8  WITH(NOLOCK) ON T8.RefProdProviderId = T4.RefProdProviderId    
    JOIN TCRMContact T9 WITH(NOLOCK) ON    T9.CRMContactId = T8.CRMContactId    
    JOIN PolicyManagement..TStatusHistory T10  WITH(NOLOCK) ON  T10.PolicyBusinessId = T7.PolicyBusinessId  AND T10.CurrentStatusFG = 1    
    JOIN PolicyManagement..TStatus T11  WITH(NOLOCK)  ON T11.StatusId = T10.StatusId AND ISNULL(T11.IntelligentOfficeStatusType, '''') != ''Deleted'' And T11.IndigoClientId = ' + Convert(varchar(50), @IndigoClientId2) + '  
	LEFT JOIN PolicyManagement..TPolicyBusinessFund Pbf WITH(NOLOCK) ON Pbf.PolicyBusinessId = T7.PolicyBusinessId
	LEFT JOIN Fund2..TFundUnit fu WITH(NOLOCK) ON fu.FundUnitId = Pbf.FundId AND Pbf.FromFeedFg = 1 AND pbf.EquityFg = 0    
	LEFT JOIN Fund2..TFund f WITH(NOLOCK) ON f.FundId = fu.FundId
	LEFT JOIN PolicyManagement..TNonFeedFund Nff WITH(NOLOCK) ON Nff.NonFeedFundId = Pbf.FundId AND Pbf.FromFeedFg = 0  
    WHERE    
 T3.IndigoClientId = ' + Convert(varchar(50), @IndigoClientId2) + '  
    '  
  
 If IsNull(@PlanTypeId, 0) > 0  
  Select @SqlScript1 = @SqlScript1 + ' And T6.RefPlanTypeId = ' + Convert(varchar(50), @PlanTypeId) + '  
    '  
 If @PolicyNumber Is Not Null  
  Select @SqlScript1 = @SqlScript1 + ' And T7.PolicyNumber LIKE ''' + @PolicyNumber + '''  
    '  
 If  @ProductName Is Not Null  
  Select @SqlScript1 = @SqlScript1 + ' And T7.ProductName LIKE ''' + @ProductName + '%''  
    '  
 If IsNull(@RefProdProviderId, 0) > 0  
  Select @SqlScript1 = @SqlScript1 + ' And T4.RefProdProviderId = ' + Convert(varchar(50), @RefProdProviderId ) + '  
    '  
     If @IsLimited <> 0  
  Select @SqlScript1 = @SqlScript1 + ' And T11.[Name] In (''In force'', ''Submitted To Provider'')  
     And T7.AdviceTypeId <> ' + Convert(varchar(50), @LighthousePreExistingAdviceType) + '  
    '  
 If @IOBReference Is Not Null  
  Select @SqlScript1 = @SqlScript1 + ' And T7.SequentialRef = ''' + @IOBReference + '''  
    '  
   
Select @SqlScript1 = @SqlScript1 + '  ) AS Plans ON Plans.CRMContactId = T1.CRMContactId    
  LEFT JOIN TPractitioner T12  WITH(NOLOCK)  ON T12.CRMContactId = T1.CurrentAdviserCRMId    
  -- Secure (we have two joins, one for ownership rights & one for specific user/role rights)    
  LEFT JOIN VwCRMContactKeyByCreatorId AS TCKey ON TCKey.UserId = ' + Convert(varchar(50), @_UserId) + ' AND TCKey.CreatorId = T1._OwnerId    
  LEFT JOIN VwCRMContactKeyByEntityId AS TEKey ON TEKey.UserId = ' + Convert(varchar(50), @_UserId) + ' AND TEKey.EntityId = T1.CRMContactId    
 WHERE     
  T1.IndClientId = ' + Convert(varchar(50), @IndigoClientId2) + ' AND ISNULL(T1.RefCRMContactStatusId,0) = 1 AND T1.ArchiveFG=0  
    '  
 If IsNull(@PractitionerId, 0) > 0  
  Select @SqlScript1 = @SqlScript1 + ' And T12.PractitionerId = ' + Convert(varchar(50), @PractitionerId) + '  
     '  
 If @CorporateName Is Not Null  
  Select @SqlScript1 = @SqlScript1 + ' And T1.CorporateName LIKE ''' + REPLACE(@CorporateName, '''', '''''') +  '%''  
     '  
 If @FirstName Is Not Null  
  Select @SqlScript1 = @SqlScript1 + ' And T1.FirstName LIKE ''' + REPLACE(@FirstName, '''', '''''') +  '%''  
     '  
 If @LastName Is Not Null  
  Select @SqlScript1 = @SqlScript1 + ' And T1.LastName LIKE ''' + REPLACE(@LastName, '''', '''''') +  '%''  
     '  
 If IsNull(@PlanTypeId, 0) > 0  
  Select @SqlScript1 = @SqlScript1 + ' And Plans.RefPlanTypeId = ' + Convert(varchar(50), @PlanTypeId) + '  
     '  
 If @PolicyNumber Is Not Null  
  Select @SqlScript1 = @SqlScript1 + ' And Plans.PolicyNumber LIKE ''' + @PolicyNumber + '''  
     '  
 If @ProductName Is Not Null  
  Select @SqlScript1 = @SqlScript1 + ' And Plans.ProductName LIKE ''' + @ProductName +  '%''  
     '  
 If IsNull(@RefProdProviderId, 0) > 0  
  Select @SqlScript1 = @SqlScript1 + ' And Plans.RefProdProviderId = ' + Convert(varchar(50), @RefProdProviderId) + '  
     '  
 If IsNull(@_UserId, 0) > 0  
  Select @SqlScript1 = @SqlScript1 + ' And (T1._OwnerId = ' + Convert(varchar(50), @_UserId) + ' OR (TCKey.CreatorId IS NOT NULL OR TEKey.EntityId IS NOT NULL))  
    '  
 If @IsLimited > 0  
  Select @SqlScript1 = @SqlScript1 + ' And Plans.PolicyBusinessId IS NOT NULL  
    '  
 If @IOBReference Is Not Null  
  Select @SqlScript1 = @SqlScript1 + ' And Plans.SequentialRef = ''' + @IOBReference + '''  
	'  
 If @ServiceStatus Is Not Null  
  Select @SqlScript1 = @SqlScript1 + ' And T1.RefServiceStatusId = ''' + @ServiceStatus + '''  
	' 
 If @Postcode Is Not Null  
  Select @SqlScript1 = @SqlScript1 + ' And ads.Postcode LIKE ''' + @Postcode + '%''  
	' 

 If @RefFundManager Is Not Null  
  Select @SqlScript1 = @SqlScript1 + ' And (Plans.FundProviderId = ''' + @RefFundManager + '''   OR Plans.CompanyId = ''' + @RefFundManager + '''  )    
    '  

 If @FundUnitId Is Not Null  
  Select @SqlScript1 = @SqlScript1 + ' And Plans.FundUnitId = ''' + @FundUnitId + '''
    '  

 If @NonFeedFundId Is Not Null  
  Select @SqlScript1 = @SqlScript1 + ' And Plans.NonFeedFundId = ''' + @NonFeedFundId + '''
    ' 

Execute( @SqlScript1 )  
    
SELECT distinct  
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
IOBReference AS [CRMContact!1!SequentialRef], --IOBReference],    
  _RightMask AS [CRMContact!1!_RightMask],    
     _AdvancedMask AS [CRMContact!1!_AdvancedMask]    
 From #SpCustomSearchClientFullSecure t1    
    
LEFT JOIN     
  (      
  Select   
 A.crmcontactid,   
 max(A.addressstoreid) as AddressStoreId      
   
 from taddress A WITH(NOLOCK)     
 join #SpCustomSearchClientFullSecure B  On A.CRMContactId = B.CRMContactId    
 Where defaultfg = 1    
 and A.indclientid = @IndigoClientId2      
 Group By A.crmcontactid    
  
  ) address on address.crmcontactid = t1.crmcontactid      
  LEFT JOIN TAddressStore ast WITH(NOLOCK)  ON ast.AddressStoreId = address.AddressStoreId     
 

 ORDER BY [CRMContact!1!CRMContactLastNameCorporateName] ASC, [CRMContact!1!FirstName] ASC    
     
 FOR XML EXPLICIT    
    
 IF (@_TopN > 0) SET ROWCOUNT 0    
  
Drop Table #SpCustomSearchClientFullSecure  
  
END    
    
RETURN (0)  

GO
