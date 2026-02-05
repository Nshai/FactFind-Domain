SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/*
Modification History (most recent first)
Date        Modifier                  Issue            Description
----        ------------              -------          -------------
20250620    Lilly Steny Mendez        IOSC-1778        New DD fields Plan Target Market and Plan Advice type 
*/
CREATE PROCEDURE [dbo].[SpNCustomGetTrustPolicies]
	@PartyId BIGINT,
	@TenantId BIGINT
    AS

DECLARE @PlanList TABLE (BusinessId bigint PRIMARY KEY, DetailId bigint, StatusId bigint,  StatusName varchar(255))

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
    CRMContactId = @PartyId 
    AND st.IntelligentOfficeStatusType <> 'Deleted'
	AND PB.IndigoClientId = @TenantId
GROUP BY  
    PB.PolicyBusinessId, PB.PolicyDetailId, st.StatusId, st.Name 

SELECT 
   Pb.PolicyBusinessId as Id,
   Pb.SequentialRef as IobRef,
   @PartyId as Owner1Id,
   PlanToProd.RefPlanType2ProdSubTypeId as PlanTypeId,
   PType.PlanTypeName as PlanTypeValue,
   pb.ProductName as ProductName,
   pb.PolicyNumber as PolicyNumber,
   ISNULL(pb.BaseCurrency, administration.dbo.FnGetRegionalCurrency()) as BaseCurrency,
   pbe.PortalReference as PortalReferenceNumber,
   pb.PolicyStartDate as PolicyStartDate,
   pb.MaturityDate as MaturityDate,

   CASE WHEN ISNULL(pb.TotalRegularPremium, 0) > 0 
    THEN ISNULL(pb.TotalRegularPremium, 0)                               
    ELSE ISNULL(pb.TotalLumpSum,0)                                
    END as CurrentRegularPremium,

   pb.PremiumType as CurrentRegularPremiumFrequency,
   Rpp.RefProdProviderId as ProviderId,
   RppC.CorporateName as ProviderName,
   prac.PractitionerId as SellingAdviserId,
   pracCRM.FirstName + ' '+ pracCRM.LastName as SellingAdviserName,
   agn.AgencyNumber as AgencyNumber,
   pl.StatusId as StatusId,
   pl.StatusName as StatusValue,
   ISNULL(pb.TotalLumpSum, 0) as TotalLumpSum,

   CASE WHEN Val.PlanValue IS NOT NULL 
        THEN Val.PlanValue
        ELSE ISNULL(Fund.FundValue, 0)
        END	as CurrentValuation,
    
    CASE WHEN Val.PlanValue IS NOT NULL 
         THEN Val.PlanValueDate
         ELSE Fund.PriceChangeDate
         END as CurrentValuationDate,

    Val.SurrenderTransferValue as TransferValue,
    at.[Description] as PlanAdviceTypeValue,
    
    CASE WHEN 
    ISNULL(pb.TopupMasterPolicyBusinessId, 0) <> 0 
    THEN 1 ELSE 0 
    END as IsTopUp,
    
    CASE WHEN EXISTS(SELECT 1 
			FROM TWrapperPolicyBusiness WITH(NOLOCK)
			WHERE ParentPolicyBusinessId = pb.PolicyBusinessId) 
            THEN 1 ELSE 0 
            END as IsWrapper,
    
    (SELECT TOP 1 ParentPolicyBusinessId 
              FROM TWrapperPolicyBusiness  WITH(NOLOCK)
              WHERE PolicyBusinessId = pb.PolicyBusinessId AND pb.IndigoClientId=@TenantId) as ParentPlanId,
    cats.Category as ProductCategory,
    cats.SubCategory as ProductSubCategory,
    PBE.ReportNotes as ReportNotes,
    pb.PolicyDetailId as PolicyDetailId,
    PBE.AgencyStatus as AgencyStatus,
    PT.PropositionTypeName as Proposition,
    pvt.[Description] as ValuationBasis,
    PlanToProd.RefPlanType2ProdSubTypeId,
    discriminator.PlanDiscriminatorName as Discriminator,
    AT.Description As AdviceType,
    CASE WHEN PBE.IsTargetMarket = 1 THEN "Yes"
    WHEN PBE.IsTargetMarket = 0 THEN "No" 
    WHEN PBE.IsTargetMarket = 2 THEN "Closed" 
    END AS TargetMarket,
    PBE.TargetMarketExplanation AS TargetMarketNotes
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
    JOIN TRefPlanType2ProdSubType AS plan2ProdType WITH(NOLOCK) ON plan2ProdType.RefPlanType2ProdSubTypeId = PDesc.RefPlanType2ProdSubTypeId  
    JOIN dbo.TRefPlanDiscriminator AS discriminator ON plan2ProdType.RefPlanDiscriminatorId = discriminator.RefPlanDiscriminatorId

 --Plan Purpose                                  
LEFT JOIN
(                              
  SELECT     
   PolicyBusinessId,    
   MIN(PolicyBusinessPurposeId) AS PolicyBusinessPurposeId                               
  FROM     
   TPolicyBusinessPurpose  
  WHERE       
   PolicyBusinessId IN (SELECT BusinessId FROM @PlanList)       
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
   
 -- Agency numbers
LEFT JOIN(
    SELECT     
        ag.RefProdProviderId, 
        ag.PractitionerId,    
        Max(ag.AgencyNumberId) AS AgencyNumberId                               
            FROM crm..TAgencyNumber  ag
                JOIN TRefProdProvider r WITH(NOLOCK) ON r.RefProdProviderId = ag.RefProdProviderId 
                JOIN [CRM]..TPractitioner p WITH (NOLOCK) ON p.PractitionerId = ag.PractitionerId  
            WHERE     
                p.IndClientId = @TenantId      
            GROUP BY  
                ag.RefProdProviderId, ag.PractitionerId
) AS ag ON ag.RefProdProviderId = PDesc.RefProdProviderId AND ag.PractitionerId = pb.PractitionerId
    LEFT JOIN crm..TAgencyNumber AGN ON agn.AgencyNumberId = ag.AgencyNumberId 

    LEFT JOIN [dbo].[TPolicyBusinessTotalPlanValuationType] pbpvt WITH (NOLOCK) ON pbpvt.PolicyBusinessId = Pb.PolicyBusinessId
    LEFT JOIN [dbo].[TRefTotalPlanValuationType] pvt WITH (NOLOCK) ON pvt.RefTotalPlanValuationTypeId = pbpvt.RefTotalPlanValuationTypeId
WHERE
    Pd.IndigoClientId = @TenantId