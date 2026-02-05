CREATE PROCEDURE [dbo].[SpNCustomRetrievePartyAssets] 
(
  @CRMContactId BIGINT,                            
  @CRMContactId2 BIGINT,                       
  @TenantId bigint,
  @CurrentUserDate datetime = NULL
)
As

DECLARE @assets TABLE (AssetId bigint, PolicyBusinessId bigint)  
INSERT INTO @assets(AssetId, PolicyBusinessId)

SELECT 
DISTINCT     
	M.AssetsId
,	PB.PolicyBusinessId
FROM                                
	PolicyManagement..TPolicyOwner PO WITH(NOLOCK)     
	  JOIN PolicyManagement..TPolicyBusiness PB WITH(NOLOCK) ON PB.PolicyDetailId = PO.PolicyDetailId 
	  JOIN PolicyManagement..TPolicyDetail PD WITH(NOLOCK) ON PD.PolicyDetailId = PB.PolicyDetailId         
	  JOIN PolicyManagement..TPlanDescription PDS WITH(NOLOCK) ON PDS.PlanDescriptionId = PD.PlanDescriptionId    
	  JOIN PolicyManagement..TRefPlanType2ProdSubType RPT WITH(NOLOCK) ON RPT.RefPlanType2ProdSubTypeId = PDS.RefPlanType2ProdSubTypeId    
	  JOIN factfind..TRefPlanTypeToSection  PS WITH(NOLOCK) ON PS.RefPlanType2ProdSubTypeId = PDS.RefPlanType2ProdSubTypeId  
	  JOIN PolicyManagement..TStatusHistory Sh WITH(NOLOCK) On Sh.PolicyBusinessId = Pb.PolicyBusinessId AND CurrentStatusFg = 1                                  
	  JOIN PolicyManagement..TStatus Status WITH(NOLOCK) ON Status.StatusId = Sh.StatusId AND Status.IntelligentOfficeStatusType <> 'Deleted'  
	  JOIN PolicyManagement..TMortgage M WITH(NOLOCK) ON M.PolicyBusinessId = PB.PolicyBusinessId -- AND ISNULL(M.AssetsId, 0) > 0
WHERE PB.IndigoClientId = @TenantId and Ps.Section ='mortgage' 
		AND CRMContactId IN (@CRMContactId, @CRMContactId2)  and RPT.RefPlanTypeId IN (63, 1039, 1078) -- Mortgages, Mortgage Non-Regulated
		AND ISNULL(M.AssetsId, 0) > 0

UNION

SELECT 
DISTINCT     
	EQ.AssetsId
,	PB.PolicyBusinessId
FROM                                
  PolicyManagement..TPolicyOwner PO WITH(NOLOCK)     
	  JOIN PolicyManagement..TPolicyBusiness PB WITH(NOLOCK) ON PB.PolicyDetailId = PO.PolicyDetailId 
	  JOIN PolicyManagement..TPolicyDetail PD WITH(NOLOCK) ON PD.PolicyDetailId = PB.PolicyDetailId         
	  JOIN PolicyManagement..TPlanDescription PDS WITH(NOLOCK) ON PDS.PlanDescriptionId = PD.PlanDescriptionId    
	  JOIN PolicyManagement..TRefPlanType2ProdSubType RPT WITH(NOLOCK) ON RPT.RefPlanType2ProdSubTypeId = PDS.RefPlanType2ProdSubTypeId    
	  JOIN factfind..TRefPlanTypeToSection  PS WITH(NOLOCK) ON PS.RefPlanType2ProdSubTypeId = PDS.RefPlanType2ProdSubTypeId  
	  JOIN PolicyManagement..TStatusHistory Sh WITH(NOLOCK) On Sh.PolicyBusinessId = Pb.PolicyBusinessId AND CurrentStatusFg = 1                                  
	  JOIN PolicyManagement..TStatus Status WITH(NOLOCK) ON Status.StatusId = Sh.StatusId AND Status.IntelligentOfficeStatusType <> 'Deleted'  
	  JOIN PolicyManagement..TEquityRelease EQ WITH(NOLOCK) ON EQ.PolicyBusinessId = PB.PolicyBusinessId 
WHERE PB.IndigoClientId = @TenantId AND Ps.Section = 'equity release' AND CRMContactId IN (@CRMContactId, @CRMContactId2)  
		AND RPT.RefPlanTypeId IN (64)  -- Equity Release
		AND ISNULL(EQ.AssetsId, 0) > 0

UNION

SELECT 
DISTINCT 
	a.AssetsId
,	a.PolicyBusinessId
FROM   FactFind.dbo.TAssets a  
WHERE  a.CRMContactId IN (@CRMContactId, @CRMContactId2) AND ISNULL(a.CRMContactId2, 0) = 0

UNION 

SELECT 
DISTINCT 
	a.AssetsId
,	a.PolicyBusinessId
FROM   FactFind.dbo.TAssets a  
WHERE a.CRMContactId = @CRMContactId
         AND a.CRMContactId2 = @CRMContactId2

UNION 

SELECT 
DISTINCT 
	a.AssetsId
,	a.PolicyBusinessId
FROM   FactFind.dbo.TAssets a  
WHERE a.CRMContactId = @CRMContactId2
         AND a.CRMContactId2 = @CRMContactId

-- Remove duplicate asset with null policy business.
DELETE a
FROM @assets a
JOIN 
(
	SELECT 
		AssetId
	,	MAX(PolicyBusinessId) PolicyBusinessId
	FROM @assets 
	WHERE ISNULL(PolicyBusinessId, 0) <> 0
	GROUP BY AssetId
) b ON a.AssetId = b.AssetId
WHERE ISNULL(a.PolicyBusinessId, 0) = 0


DECLARE @PartyAddresses TABLE (AddressStoreId varchar(max), Addressline1 varchar(255),  Postcode varchar(255))    
INSERT INTO @PartyAddresses(AddressStoreId, Addressline1, Postcode)
SELECT DISTINCT CAST (a.AddressStoreId as varchar(max))
,				Addressline1
,				Postcode
FROM crm..TAddress a
		JOIN crm..TAddressStore s ON a.AddressStoreId = s.AddressStoreId
WHERE CrmcontactId IN (@CRMContactId, @CRMContactId2)and a.IndClientId = @TenantId

DECLARE @AssetIdsString varchar(max);
--concatenate Ids into string separated by comma
SELECT @AssetIdsString = COALESCE(@AssetIdsString + ', ' + CAST(AssetId as varchar(20)), CAST(AssetId as varchar(20))) 
	FROM @assets;
DECLARE @AssetCurrentValues TABLE(AssetId int, AssetValuationHistoryId int, Valuation money, ValuationDate DateTime);
INSERT INTO @AssetCurrentValues 
SELECT AssetId, AssetValuationHistoryId, Valuation, ValuationDate 
	FROM [FnRetrieveAssetCurrentValues] (@AssetIdsString);

SELECT 
distinct 
				asset.AssetsId						AssetId                                                                
,               CASE 
				WHEN ISNULL(asset.CRMContactId2, 0) > 0 OR asset.Owner ='Joint'
					THEN
					'Joint'   
					ELSE                     
					ISNULL(owner1.CorporateName, 
					(CAST(owner1.FirstName as NVARCHAR(255)) + ' ' + CAST(owner1.LastName as NVARCHAR(255))))     
				END	[Owner]                                                             
,               assetcategory.CategoryName          AssetCategory                                                             
,               asset.Description                   [Description]                                                             
,               asset.PercentOwnership              PercentOwnership                                                             
,               refplantype.RefPlanTypeId			RefPlanTypeId                                                             
,               policy.PolicyBusinessId				PolicyBusinessId                                                             
,               (policy.SequentialRef + ': ' + refprovider.Name + ' - ' + refplantype.PlanTypeName + 
					(case
                        when (policy.PolicyNumber is not null
                            and not (policy.PolicyNumber = '')) then (' (' + policy.PolicyNumber + ')')
                        else '' 
                    end))							RelatedToPlan
,               ISNULL(
                    policyownercontact.CorporateName,
                    CAST(policyownercontact.FirstName as NVARCHAR(255)) + ' ' + CAST(policyownercontact.LastName as NVARCHAR(255))
                ) RelatedToPlanOwner
,               policy.SequentialRef RelatedToPlanIOBReference
,               refprovider.Name RelatedToProvider
,               refplantype.PlanTypeName RelatedToPlanType
,               policy.PolicyNumber RelatedToPolicyNumber
,               CASE
                  WHEN policy.PolicyBusinessId IS NOT NULL
                  THEN policyStatus.IntelligentOfficeStatusType
                  ELSE '' 
                END RelatedToPlanStatus
,               policy.ProductName RelatedToProductName
,               policy.PolicyStartDate RelatedToPolicyStartDate
,               CASE
                  WHEN policy.PolicyBusinessId IS NOT NULL
                  THEN (CASE WHEN policyowners.OwnersCount > 1 THEN 1 ELSE 0 END)
                  ELSE NULL
                END RelatedToPlanIsJoint
,               CASE
                  WHEN policy.PolicyBusinessId IS NOT NULL
                  THEN PolicyManagement.dbo.FnCustomGetPlanValuationFromValuationTab(policy.PolicyBusinessId)
                  ELSE NULL
                END RelatedToPlanValuation
,               refplancategory.Identifier RelatedToProductCategory
,               refplansubcategory.Identifier RelatedToProductSubCategory
,               CASE
                  WHEN policy.PolicyBusinessId IS NOT NULL
                  THEN policyStatus.IntelligentOfficeStatusType
                  ELSE '' 
                END								    PolicyStatus                                                                              
,               asset.PurchasePrice					OriginalValue 
,               asset.PurchasedOn					DatePurchased
,               asset.RelatedtoAddress				RelatedtoAddress                                                                      
,               currentValuation.Valuation				CurrentValue   
,				currentValuation.ValuationDate			DateValued
,				CASE
					WHEN asset.IncomeId IS NOT NULL THEN factfind.dbo.FnCustomGetMonthlyIncomeNetAmount(incomes.NetAmount, incomes.Frequency)
					ELSE 0
				END as NetMonthlyIncome
, asset.CurrencyCode AS Currency

FROM   @assets temp 
JOIN FactFind.dbo.TAssets asset ON temp.AssetId = asset.AssetsId
       inner join CRM.dbo.TCRMContact owner1
         on asset.CRMContactId = owner1.CRMContactId
       inner join FactFind.dbo.TAssetCategory assetcategory
         on asset.AssetCategoryId = assetcategory.AssetCategoryId
       left outer join PolicyManagement.dbo.TPolicyBusiness policy
         on temp.PolicyBusinessId = policy.PolicyBusinessId
       left outer join PolicyManagement.dbo.[TPolicyDetail] policydetail
         on policy.PolicyDetailId = policydetail.PolicyDetailId
       left outer join PolicyManagement.dbo.TPlanDescription plandescr
         on plandescr.PlanDescriptionId = policydetail.PlanDescriptionId
       left outer join Reporter.dbo.TPlanSetting planSetting
         on planSetting.RefPlanType2ProdSubTypeId = plandescr.RefPlanType2ProdSubTypeId
       left outer join (
         SELECT PO.PolicyDetailId, COUNT(*) AS OwnersCount, MIN(PO.PolicyOwnerId) AS PolicyOwnerId
         FROM PolicyManagement.dbo.TPolicyOwner PO
         GROUP BY PO.PolicyDetailId
       ) policyowners
         on policydetail.PolicyDetailId = policyowners.PolicyDetailId
       left outer join PolicyManagement.dbo.TPolicyOwner policyowner
         on policyowners.PolicyOwnerId = policyowner.PolicyOwnerId
       left outer join CRM.dbo.TCRMContact policyownercontact
         on policyownercontact.CRMContactId = policyowner.CRMContactId
       left outer join PolicyManagement.dbo.[VPlanDescription] plandesc
         on policydetail.PlanDescriptionId = plandesc.PlanDescriptionId
       left outer join PolicyManagement.dbo.TRefPlanType2ProdSubType refplantype2subtype
         on plandesc.RefPlanType2ProdSubTypeId = refplantype2subtype.RefPlanType2ProdSubTypeId
       left outer join PolicyManagement.dbo.TRefPlanType refplantype
         on refplantype2subtype.RefPlanTypeId = refplantype.RefPlanTypeId
       left outer join PolicyManagement.dbo.[VProvider] refprovider
         on plandesc.RefProdProviderId = refprovider.RefProdProviderId
       left join @AssetCurrentValues currentValuation
         on currentValuation.AssetId = temp.AssetId
       left join factfind..TDetailedincomebreakdown incomes on asset.IncomeId = incomes.DetailedincomebreakdownId
       LEFT JOIN policymanagement.dbo.TStatusHistory statushistory WITH(NOLOCK) On statushistory.PolicyBusinessId = policy.PolicyBusinessId AND CurrentStatusFg = 1                                  
	   LEFT JOIN policymanagement.dbo.TStatus policyStatus WITH(NOLOCK) ON policyStatus.StatusId = statushistory.StatusId AND policyStatus.IntelligentOfficeStatusType <> 'Deleted'  
       left join Reporter.dbo.TRefPlanCategory refplancategory
         on planSetting.RefPlanCategoryId = refplancategory.RefPlanCategoryId
       left join Reporter.dbo.TRefPlanSubCategory refplansubcategory
         on planSetting.RefPlanSubCategoryId = refplansubcategory.RefPlanSubCategoryId
  where @CurrentUserDate is null or (incomes.EndDate is null or incomes.EndDate > @CurrentUserDate);