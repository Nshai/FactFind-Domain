--use policymanagement
 
SET QUOTED_IDENTIFIER OFF
GO
/*
Modification History (most recent first)
Date        Modifier                  Issue            Description
----        ------------              -------          -------------
20250620    Lilly Steny Mendez        IOSC-1778        New DD fields Plan Target Market and Plan Advice type 
*/
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomGetPartyPolicies]	
	@PartyId BIGINT,
	@RelatedPartyId BIGINT,
	@TenantId BIGINT
AS


SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

--DECLARE @PartyId BIGINT = 4670733
--DECLARE @RelatedPartyId BIGINT = 4670731
--DECLARE @TenantId bigint = 10155


-- Get a list of plan ids for these clients      
DECLARE @PlanList TABLE (BusinessId bigint PRIMARY KEY, DetailId bigint, StatusId bigint,  StatusName varchar(255),  Categories varchar(max))  
    
INSERT INTO @PlanList (BusinessId, DetailId, StatusId, StatusName)     
SELECT      
	PB.PolicyBusinessId, 
	PB.PolicyDetailId,
	st.StatusId,
	st.Name 
FROM                                
	TPolicyOwner PO WITH(NOLOCK)                                
	JOIN TPolicyBusiness PB WITH(NOLOCK) ON PB.PolicyDetailId = PO.PolicyDetailId    
	JOIN TStatusHistory Sh WITH(NOLOCK) On Sh.PolicyBusinessId = Pb.PolicyBusinessId AND CurrentStatusFg = 1                                  
	JOIN TStatus st WITH(NOLOCK) ON st.StatusId = Sh.StatusId     
WHERE                                
	 CRMContactId IN (@PartyId, @RelatedPartyId) 
	 AND st.IntelligentOfficeStatusType <> 'Deleted'
	 AND PB.IndigoClientId = @TenantId
GROUP BY  
	 PB.PolicyBusinessId, PB.PolicyDetailId, st.StatusId, st.Name 


UPDATE p
SET Categories = Convert(varchar(max), (
       select ',' +  ISNULL(at.Section, '')
       from   FactFind..TRefPlanTypeToSection at 
       WHERE at.RefPlanType2ProdSubTypeId = PDesc.RefPlanType2ProdSubTypeId
       for xml path(''), type))
FROM @PlanList p
JOIN TPolicyDetail Pd  WITH(NOLOCK) ON pd.PolicyDetailId = p.DetailId
JOIN TPlanDescription PDesc WITH(NOLOCK) ON PDesc.PlanDescriptionId = pd.PlanDescriptionId 


SELECT 
   Pb.PolicyBusinessId                                                        as Id
,  Pb.SequentialRef                                                           as IobRef
,  POWN1.CRMContactId                                                            as Owner1Id
,  POWN2.CRMContactId                                                            as Owner2Id
,  ao.CRMContactId                                                               as Owner3Id
,  ao2.CRMContactId																 as Owner4Id
,  PlanToProd.RefPlanType2ProdSubTypeId											 as PlanTypeId
,  PType.PlanTypeName                                                            as PlanTypeValue -- check this on sdb
,  pb.ProductName                                                                as ProductName
,  pb.PolicyNumber                                                               as PolicyNumber
,  ISNULL(pb.BaseCurrency, administration.dbo.FnGetRegionalCurrency())           as BaseCurrency
,  pbe.PortalReference															 as PortalReferenceNumber
,  pb.PolicyStartDate                                                            as PolicyStartDate
,  pb.MaturityDate                                                               as MaturityDate
,  PInf.CentrelinkDeductibleAmount                                               as CentrelinkDeductibleAmount
,  PInf.TaxFreePercentageOfIncome                                                as TaxFreePercentageOfIncome
,  PInf.TaxedPensionAmount                                                       as TaxedPensionAmount
,  PInf.UntaxedPensionAmount                                                     as UntaxedPensionAmount
,     CASE WHEN ISNULL(pb.TotalRegularPremium, 0) > 0 
              THEN ISNULL(pb.TotalRegularPremium, 0)                               
              ELSE ISNULL(pb.TotalLumpSum,0)                                
       END                                                                       as CurrentRegularPremium
,  pb.PremiumType                                                                as CurrentRegularPremiumFrequency
,  Rpp.RefProdProviderId														 as ProviderId
,  RppC.CorporateName                                                            as ProviderName
,  prac.PractitionerId                                                           as SellingAdviserId
,  pracCRM.FirstName + ' '+ pracCRM.LastName									 as SellingAdviserName
,  agn.AgencyNumber																 as AgencyNumber
,  pl.StatusId																	 as StatusId
,  pl.StatusName                                                                 as StatusValue
,  GSh.GroupSchemeId                                                             as GroupSchemeId
,  ISNULL(pb.TotalLumpSum, 0)													 as TotalLumpSum
,  ISNULL(pb.TotalRegularPremium, 0)											 as TotalRegularPremium
,  ISNULL(Pb.TotalLumpSum, 0) + 
   ISNULL(Pb.TotalRegularPremium, 0)											 as TotalPremiumstoDate
,  ISNULL(Withdrawals.TotalWithdrawalsToDate, 0)								 as TotalWithdrawalsToDate
,  CASE WHEN Val.PlanValue IS NOT NULL 
         THEN Val.PlanValue
         ELSE ISNULL(Fund.FundValue, 0)
    END																			 as CurrentValuation                               
                                                              
 ,  CASE WHEN Val.PlanValue IS NOT NULL 
         THEN Val.PlanValueDate
         ELSE Fund.PriceChangeDate
    END																			 as CurrentValuationDate

,   Val.SurrenderTransferValue													 as TransferValue

,  pb.AdviceTypeId                                                               as PlanAdviceTypeId
,  at.[Description]																 as PlanAdviceTypeValue
,  pl.Categories                                                                 as PlanTypeCategorySection
,  PP.Descriptor                                                                 as PlanPurpose
, CASE WHEN 
                     ISNULL(pb.TopupMasterPolicyBusinessId, 0) <> 0 
                     THEN 1 ELSE 0 
   END                                                                           as IsTopUp
, CASE WHEN EXISTS(SELECT 1 
			FROM TWrapperPolicyBusiness WITH(NOLOCK)
			WHERE ParentPolicyBusinessId = pb.PolicyBusinessId) 
       THEN 1 
	   ELSE 0 
   END                                                                           as IsWrapper -- decide to flag it with plan type
, (SELECT TOP 1 ParentPolicyBusinessId 
              FROM TWrapperPolicyBusiness  WITH(NOLOCK)
              WHERE PolicyBusinessId = pb.PolicyBusinessId AND pb.IndigoClientId=@TenantId)   as ParentPlanId
, cats.Category																				  as ProductCategory
, cats.SubCategory                                                                as ProductSubCategory
, PBE.ReportNotes                                                                 as ReportNotes
, pb.PolicyDetailId                                                               as PolicyDetailId
, PBE.AgencyStatus                                                                as AgencyStatus
, PT.PropositionTypeName														  as Proposition
, pvt.[Description]                                                               AS ValuationBasis
, PF.Title                                                                        AS ModelPortfolioName
, AT.Description                                                                  As AdviceType
, CASE WHEN PBE.IsTargetMarket = 1 THEN "Yes" 
  WHEN PBE.IsTargetMarket = 0 THEN "No"
  WHEN PBE.IsTargetMarket = 2 THEN "Closed" END                                    AS TargetMarket
, PBE.TargetMarketExplanation                                                      AS TargetMarketNotes
FROM                                   
 TPolicyDetail Pd WITH(NOLOCK)      
 JOIN TPolicyBusiness Pb WITH(NOLOCK)  ON Pb.PolicyDetailId = Pd.PolicyDetailId    
 JOIN @PlanList pl on pl.BusinessId = pb.PolicyBusinessId and pl.DetailId = pb.PolicyDetailId      
 INNER JOIN TPolicyBusinessExt PBE WITH(NOLOCK)  ON PBE.PolicyBusinessId = Pb.PolicyBusinessId    
 JOIN TStatusHistory Sh WITH(NOLOCK) On Sh.PolicyBusinessId = Pb.PolicyBusinessId AND CurrentStatusFg = 1                                  
 JOIN TStatus Status WITH(NOLOCK) ON Status.StatusId = Sh.StatusId                                 
 JOIN TPlanDescription PDesc WITH(NOLOCK) ON PDesc.PlanDescriptionId = Pd.PlanDescriptionId    
 JOIN TRefPlanType2ProdSubType PlanToProd WITH(NOLOCK) ON PlanToProd.RefPlanType2ProdSubTypeId = PDesc.RefPlanType2ProdSubTypeId              
 LEFT JOIN TProdSubType Pst WITH(NOLOCK) ON Pst.ProdSubTypeId = PlanToProd.ProdSubTypeId                                  
 JOIN TRefPlanType PType WITH(NOLOCK) ON PType.RefPlanTypeId = PlanToProd.RefPlanTypeId                                  
 JOIN TRefProdProvider Rpp WITH(NOLOCK) ON Rpp.RefProdProviderId = PDesc.RefProdProviderId                                   
 JOIN [CRM]..TCRMContact RppC WITH(NOLOCK) ON RppC.CRMContactId = Rpp.CRMContactId                                  
 JOIN [CRM]..TPractitioner prac WITH (NOLOCK) ON prac.PractitionerId = pb.PractitionerId                            
 JOIN [CRM]..TCRMContact pracCRM WITH (NOLOCK) ON pracCRM.CRMContactId = prac.CRMContactId     
 JOIN TAdviceType AT ON AT.AdviceTypeId = pb.AdviceTypeId   
 JOIN reports.dbo.FnCustomRetrievePortfolioReportCategories(@TenantId) cats on cats.RefPlanType2ProdSubTypeId = PDesc.RefPlanType2ProdSubTypeId
 LEFT JOIN crm.dbo.TPropositionType PT ON  PT.PropositionTypeId = Pb.PropositionTypeId                              
 LEFT JOIN TPensionInfo PInf ON Pb.PolicyBusinessId = PInf.PolicyBusinessId
 LEFT JOIN TPortfolio PF WITH(NOLOCK) ON PBE.ModelId = PF.PortfolioId
 -- Owners      
 JOIN 
 (        
       SELECT       
       COUNT(PolicyOwnerId) AS OwnerCount,      
       PolicyDetailId,      
       MIN(PolicyOwnerId) AS Owner1Id,                                  
       CASE MAX(PolicyOwnerId)                                  
              WHEN MIN(PolicyOwnerId) THEN NULL                                  
              ELSE MAX(PolicyOwnerId)                                  
       END AS Owner2Id                                  
       FROM TPolicyOwner    
       WHERE PolicyDetailId IN (SELECT DetailId FROM @PlanList)        
       GROUP BY PolicyDetailId
) 
 AS PolicyOwners ON Pd.PolicyDetailId = PolicyOwners.PolicyDetailId  
 JOIN TPolicyOwner POWN1 WITH (NOLOCK) ON PolicyOwners.Owner1Id = POWN1.PolicyOwnerId 
 LEFT JOIN TPolicyOwner POWN2 WITH (NOLOCK) ON PolicyOwners.Owner2Id = POWN2.PolicyOwnerId
 LEFT JOIN TPolicyMoneyIn PMI WITH (NOLOCK) ON PMI.PolicyBusinessId = pb.PolicyBusinessId
    AND PMI.CurrentFG = 1 
    AND PMI.RefContributionTypeId = 1 -- Regular Contribution
    AND PMI.RefContributorTypeId = 1 -- Self Contributions
    AND PMI.RefFrequencyId != 10 -- Exclude single frequency -- BAU 2133, BAU-2135, (BAU-809) 
 LEFT JOIN TRefFrequency pmif WITH (NOLOCK) ON pmif.RefFrequencyId = pmi.RefFrequencyId

 -- Total withdrawals
LEFT JOIN 
(                                  
  SELECT                                  
   PolicyBusinessId,                                  
   SUM(Amount) AS TotalWithdrawalsToDate                                  
  FROM     
   TPolicyMoneyOut WITH(NOLOCK)                                    
  WHERE   
    
   PolicyBusinessId IN (SELECT BusinessId FROM @PlanList)      
  GROUP BY     
   PolicyBusinessId
) AS Withdrawals ON Withdrawals.PolicyBusinessId = Pb.PolicyBusinessId  
               
 --Plan Purpose                                  
LEFT JOIN
(                                  
  SELECT     
   PolicyBusinessId,    
   MIN(PolicyBusinessPurposeId) AS PolicyBusinessPurposeId                               
  FROM     
   TPolicyBusinessPurpose  
  WHERE       
   PolicyBusinessId IN (SELECT BusinessId FROM @PlanList
)       
GROUP BY     
	PolicyBusinessId) AS MinPurpose ON MinPurpose.PolicyBusinessId = Pb.PolicyBusinessId  
LEFT JOIN TPolicyBusinessPurpose PBP ON MinPurpose.PolicyBusinessPurposeId = PBP.PolicyBusinessPurposeId
LEFT JOIN TPlanPurpose PP ON PBP.PlanPurposeId = PP.PlanPurposeId                                 
 
 --Latest valuation                                  
 LEFT JOIN 
(                                  
  SELECT                                   
   BusinessId AS PolicyBusinessId,     
   PolicyManagement.dbo.[FnCustomGetLatestPlanValuationIdByValuationDate](BusinessId) AS PlanValuationId    
   FROM     
   @PlanList    
) AS LastVal ON LastVal.PolicyBusinessId = PB.PolicyBusinessId    

   -- Join back to plan valuation using the latest date      
 LEFT JOIN TPlanValuation Val ON Val.PlanValuationId = LastVal.PlanValuationId    
 -- Fund Price                                  
 LEFT JOIN 
(                                  
  SELECT                                     
   PolicyBusinessId,    
   MAX(LastPriceChangeDate) AS PriceChangeDate,                                   
   SUM(ISNULL(CurrentPrice, 0) * ISNULL(CurrentUnitQuantity, 0)) AS FundValue                                  
  FROM                                  
   TPolicyBusinessFund WITH(NOLOCK)                                   
  WHERE     
  FundIndigoClientId =@TenantId AND
   PolicyBusinessId IN (SELECT BusinessId FROM @PlanList)      
  GROUP BY     
   PolicyBusinessId
) AS Fund ON Fund.PolicyBusinessId = Pb.PolicyBusinessId                                
 
LEFT OUTER JOIN
   (
          SELECT
          MIN(AdditionalOwnerId) AS AdditionalOwnerId1,
          MAX(AdditionalOwnerId) AS AdditionalOwnerId2,
          PolicyBusinessId
          FROM
          tAdditionalOwner
          WHERE     
          
          PolicyBusinessId IN (SELECT BusinessId FROM @PlanList) 
          GROUP BY
   PolicyBusinessId
   ) AdditionalOwners ON AdditionalOwners.PolicyBusinessId = pb.PolicyBusinessId
   LEFT OUTER JOIN tAdditionalOwner ao ON ao.AdditionalOwnerId = AdditionalOwners.AdditionalOwnerId1   
   LEFT OUTER JOIN tAdditionalOwner ao2 ON ao2.AdditionalOwnerId = AdditionalOwners.AdditionalOwnerId2
   AND (AdditionalOwners.AdditionalOwnerId2 != AdditionalOwners.AdditionalOwnerId1 )
   
   
 -- Agency numbers
LEFT JOIN(
              SELECT     
                     ag.RefProdProviderId, 
                     ag.PractitionerId,    
                     Max(ag.AgencyNumberId) AS AgencyNumberId                               
              FROM     
                     crm..TAgencyNumber  ag
                     JOIN TRefProdProvider r WITH(NOLOCK) ON r.RefProdProviderId = ag.RefProdProviderId 
                      JOIN [CRM]..TPractitioner p WITH (NOLOCK) ON p.PractitionerId = ag.PractitionerId  
              WHERE     
                     p.IndClientId = @TenantId      
              GROUP BY  
                     ag.RefProdProviderId, ag.PractitionerId
) AS ag ON ag.RefProdProviderId = PDesc.RefProdProviderId AND ag.PractitionerId = pb.PractitionerId
LEFT JOIN crm..TAgencyNumber AGN ON agn.AgencyNumberId = ag.AgencyNumberId 

--Scheme Details
LEFT JOIN (
   --Main Group Plan
       Select
       GS.GroupSchemeId, GS.SchemeName, JoiningDate = Null, LeavingDate = Null, GS.PolicyBusinessId, CategoryName = Null, NominatedBeneficiary = Null
       From
       TGroupScheme GS
       Where
       GS.TenantId =  @TenantId and
       GS.PolicyBusinessId IN (SELECT BusinessId FROM @PlanList)   

       Union ALL

       --Member Plan
       Select
       GS.GroupSchemeId, GS.SchemeName, GSM.JoiningDate, GSM.LeavingDate, GSM.PolicyBusinessId, GSC.CategoryName, GSM.NominatedBeneficiary
       From
       TGroupSchemeMember GSM
       JOIN TGroupScheme GS ON GSM.GroupSchemeId = GS.GroupSchemeId
       LEFT JOIN TGroupSchemeCategory GSC ON GSM.GroupSchemeCategoryId = GSC.GroupSchemeCategoryId
       Where
       GSM.TenantId = @TenantId and
       GSM.PolicyBusinessId IN (SELECT BusinessId FROM @PlanList)   
   ) GSh ON GSh.PolicyBusinessId = Pb.PolicyBusinessId

LEFT JOIN [dbo].[TPolicyBusinessTotalPlanValuationType] pbpvt WITH (NOLOCK) ON pbpvt.PolicyBusinessId = Pb.PolicyBusinessId
LEFT JOIN [dbo].[TRefTotalPlanValuationType] pvt WITH (NOLOCK) ON pvt.RefTotalPlanValuationTypeId = pbpvt.RefTotalPlanValuationTypeId
WHERE
Pd.IndigoClientId = @TenantId




 



