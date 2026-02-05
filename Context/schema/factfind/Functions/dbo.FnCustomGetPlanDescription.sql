SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*###############################################################################

Name          : dbo.FnCustomGetPlanDescription 
Used From     : 1.SpNCustomRetrievePersonalExistingProtectionPlans
				2.SpNCustomRetrieveGeneralInsurancePlan
				3.SpNCustomRetrievePersonalExistingMortgagePlans
				4.SpNCustomRetrievePersonalFinalSalaryPensionPlans
				5.SpNCustomRetrievePersonalMoneyPurchasePensionPlans
				6.SpNCustomRetrievePersonalSavingsPlans
				7.SpNCustomRetrievePersonalPensionPlans
				8.SpNCustomRetrievePersonalAnnuityPlans
        9.SpNCustomRetrievePersonalEquityReleasePlans
#################################################################################*/
CREATE FUNCTION dbo.FnCustomGetPlanDescription  
(  
@CRMContactId  bigint,  
@CRMContactId2 bigint,  
@TenantId bigint,  
@ExcludePlanPurposes BIT = 0,  
@IncludeTopups bit  
)  
RETURNS  @PlanDescription TABLE                                  
(                                  
 PolicyBusinessId bigint not null PRIMARY KEY,                                  
 PolicyDetailId bigint not null,                                  
 CRMContactId bigint not null,                                  
 CRMContactId2 bigint null,                                  
 [Owner] varchar(16) not null,                                  
 OwnerCount int not null,        
 RefPlanType2ProdSubTypeId bigint not NULL,     
 PlanType varchar(128) not null,               
 UnderlyingPlanType varchar(128) not null,                      
 RefProdProviderId bigint not null,    
 Provider varchar(128) not null,                                  
 PolicyNumber varchar(64) null,                                  
 AgencyStatus varchar(50) null,                                  
 StartDate datetime null,                                  
 MaturityDate datetime null,                                  
 StatusDate datetime null,                                  
 Term tinyint null,                                      
 RegularPremium money null,                                  
 ActualRegularPremium money null,                                  
 TotalLumpSum money null,                                  
 TotalPremium money null,                                  
 Frequency varchar(32) null,                                  
 Valuation money null,                                  
 CurrentValue money null,                                  
 ValuationDate datetime,                                  
 ProductName varchar(255) null,                                  
 RefPlanTypeId bigint,                                  
 SellingAdviserId bigint,                                  
 SellingAdviserName varchar(255),                                  
 PlanPurpose varchar(255),     
 PlanPurposeId bigint,       
 ParentPolicyBusinessId bigint,    
 ExcludeValuation bit,      
 ConcurrencyId bigint null,    
 PlanStatus varchar(50) null,                              
 MortgageRepayPercentage money null,     
 MortgageRepayAmount money null,    
 [IsGuaranteedToProtectOriginalInvestment] bit null ,
 BaseCurrency varchar(3) null,
 SequentialRef varchar(50) null,
 IsProviderManaged bit null
)  
AS  
BEGIN
-- Get a list of plan ids for these clients      
DECLARE @PlanList TABLE (BusinessId bigint PRIMARY KEY, DetailId bigint)      
INSERT INTO @PlanList      
SELECT DISTINCT     
 PB.PolicyBusinessId, PB.PolicyDetailId      
FROM                                
  PolicyManagement..TPolicyOwner PO WITH(NOLOCK)                                
  JOIN PolicyManagement..TPolicyBusiness PB WITH(NOLOCK) ON PB.PolicyDetailId = PO.PolicyDetailId      
WHERE                                
 CRMContactId IN (@CRMContactId, @CRMContactId2)   
   
    
 -- Basic Plan Details      
INSERT INTO @PlanDescription                                  
SELECT                                  
 Pb.PolicyBusinessId,                                  
 Pd.PolicyDetailId,                                  
 POWN1.CRMContactId,                                  
 POWN2.CRMContactId,                                  
 CASE PolicyOwners.OwnerCount                                  
  WHEN 1 THEN                                  
   CASE POWN1.CRMContactId                                  
    WHEN @CRMContactId THEN 'Client 1'                                  
    ELSE 'Client 2'                                  
   END                                  
  ELSE 'Joint'                                      
 END,                                  
 PolicyOwners.OwnerCount,      
 PlanToProd.RefPlanType2ProdSubTypeId,    
 CASE                                   
  WHEN LEN(ISNULL(Pst.ProdSubTypeName, '')) > 0 THEN  PType.PlanTypeName + ' (' + Pst.ProdSubTypeName + ')'                                  
  ELSE PType.PlanTypeName                              
 END,            
 PType.PlanTypeName,     
 Rpp.RefProdProviderId,                           
 RppC.CorporateName,                    
 Pb.PolicyNumber,
 PBE.AgencyStatus,
 Pb.PolicyStartDate,                                  
 Pb.MaturityDate,          
 Sh.DateOfChange,                 
 Pd.TermYears,                                  
 CASE    
  WHEN ISNULL(pb.TotalRegularPremium,0) > 0 THEN pb.TotalRegularPremium                                
  ELSE ISNULL(pb.TotalLumpSum,0)                                
 END,                                
 ISNULL(Pb.TotalRegularPremium, 0), -- Actual regular premium                                    
 ISNULL(Pb.TotalLumpSum, 0),                                    
 ISNULL(Pb.TotalLumpSum, 0) + ISNULL(Pb.TotalRegularPremium, 0),                                    
 pb.PremiumType,                                  
 -- Valuation                                  
 Val.PlanValue,                                  
 -- CurrentValue
 CASE
  WHEN Val.PlanValue IS NOT NULL THEN Val.PlanValue
  ELSE ISNULL(Fund.FundValue, 0)
 END,
 --Valuation Date
 CASE
  WHEN Val.PlanValue IS NOT NULL THEN Val.PlanValueDate
  ELSE Fund.PriceChangeDate
 END,
 pb.ProductName,                                  
 pType.RefPlanTypeId,                                  
 pb.PractitionerId,                                  
 ISNULL(pracCRM.FirstName,'') + ' ' + ISNULL(pracCRM.LastName,''),                                  
 CASE @ExcludePlanPurposes     
  WHEN 1 THEN ''    
  ELSE ISNULL(PP.Descriptor,'')    
 END,  
 CASE @ExcludePlanPurposes     
  WHEN 1 THEN null    
  ELSE PP.PlanPurposeId    
 END,   
 W.ParentPolicyBusinessId,        
 NULL, -- Exclude Valuation                             
 pb.ConcurrencyId,    
 [Status].Name,    
 PBE.MortgageRepayPercentage,    
 PBE.MortgageRepayAmount,    
 Pb.[IsGuaranteedToProtectOriginalInvestment],
 ISNULL(Pb.BaseCurrency, administration.dbo.FnGetRegionalCurrency()),
 Pb.SequentialRef,
 PBE.IsProviderManaged
FROM
 PolicyManagement..TPolicyDetail Pd WITH(NOLOCK)
 JOIN PolicyManagement..TPolicyBusiness Pb WITH(NOLOCK)  ON Pb.PolicyDetailId = Pd.PolicyDetailId          
 LEFT JOIN PolicyManagement..TPolicyBusinessExt PBE WITH(NOLOCK)  ON PBE.PolicyBusinessId = Pb.PolicyBusinessId    
 JOIN PolicyManagement..TStatusHistory Sh WITH(NOLOCK) On Sh.PolicyBusinessId = Pb.PolicyBusinessId AND CurrentStatusFg = 1                                  
 JOIN PolicyManagement..TStatus Status WITH(NOLOCK) ON Status.StatusId = Sh.StatusId AND Status.IntelligentOfficeStatusType IN ('In Force', 'Paid Up')                                 
 JOIN PolicyManagement..TPlanDescription PDesc WITH(NOLOCK) ON PDesc.PlanDescriptionId = Pd.PlanDescriptionId    
 JOIN PolicyManagement..TRefPlanType2ProdSubType PlanToProd WITH(NOLOCK) ON PlanToProd.RefPlanType2ProdSubTypeId = PDesc.RefPlanType2ProdSubTypeId              
 LEFT JOIN PolicyManagement..TProdSubType Pst WITH(NOLOCK) ON Pst.ProdSubTypeId = PlanToProd.ProdSubTypeId                                  
 JOIN PolicyManagement..TRefPlanType PType WITH(NOLOCK) ON PType.RefPlanTypeId = PlanToProd.RefPlanTypeId                                  
 JOIN PolicyManagement..TRefProdProvider Rpp WITH(NOLOCK) ON Rpp.RefProdProviderId = PDesc.RefProdProviderId                                   
 JOIN [CRM]..TCRMContact RppC WITH(NOLOCK) ON RppC.CRMContactId = Rpp.CRMContactId                                  
 JOIN [CRM]..TPractitioner prac WITH (NOLOCK) ON prac.PractitionerId = pb.PractitionerId                            
 JOIN [CRM]..TCRMContact pracCRM WITH (NOLOCK) ON pracCRM.CRMContactId = prac.CRMContactId                                   
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
	FROM PolicyManagement..TPolicyOwner WITH(NOLOCK)
	WHERE PolicyDetailId IN (SELECT DetailId FROM @PlanList)        
	GROUP BY PolicyDetailId
 ) 
 AS PolicyOwners ON Pd.PolicyDetailId = PolicyOwners.PolicyDetailId  
 JOIN PolicyManagement..TPolicyOwner POWN1 WITH(NOLOCK) ON PolicyOwners.Owner1Id = POWN1.PolicyOwnerId
 LEFT JOIN PolicyManagement..TPolicyOwner POWN2 WITH(NOLOCK) ON PolicyOwners.Owner2Id = POWN2.PolicyOwnerId
                    
 --Plan Purpose                                  
 LEFT JOIN(                                  
  SELECT     
   PolicyBusinessId,    
   MIN(PolicyBusinessPurposeId) AS PolicyBusinessPurposeId 
  FROM     
   PolicyManagement..TPolicyBusinessPurpose WITH(NOLOCK)
  WHERE     
   PolicyBusinessId IN (SELECT BusinessId FROM @PlanList)      
  GROUP BY     
   PolicyBusinessId) AS MinPurpose ON MinPurpose.PolicyBusinessId = Pb.PolicyBusinessId  
 LEFT JOIN PolicyManagement..TPolicyBusinessPurpose PBP WITH(NOLOCK) ON MinPurpose.PolicyBusinessPurposeId = PBP.PolicyBusinessPurposeId
 LEFT JOIN PolicyManagement..TPlanPurpose PP WITH(NOLOCK) ON PBP.PlanPurposeId = PP.PlanPurposeId                                 
 -- Latest valuation                                  
 LEFT JOIN (                                  
  SELECT                                   
   BusinessId AS PolicyBusinessId,     
   PolicyManagement.dbo.[FnCustomGetLatestPlanValuationIdByValuationDate](BusinessId) AS PlanValuationId    
   FROM     
   @PlanList    
  ) AS LastVal ON LastVal.PolicyBusinessId = PB.PolicyBusinessId    
   -- Join back to plan valuation using the latest date      
 LEFT JOIN PolicyManagement..TPlanValuation Val WITH(NOLOCK) ON Val.PlanValuationId = LastVal.PlanValuationId    
 -- Fund Price                                  
 LEFT JOIN (                                  
  SELECT                                     
   PolicyBusinessId,    
   MAX(LastPriceChangeDate) AS PriceChangeDate,                                   
   SUM(ISNULL(CurrentPrice, 0) * ISNULL(CurrentUnitQuantity, 0)) AS FundValue                                  
  FROM                                  
   PolicyManagement..TPolicyBusinessFund WITH(NOLOCK)                                   
  WHERE     
   PolicyBusinessId IN (SELECT BusinessId FROM @PlanList)      
  GROUP BY     
   PolicyBusinessId) AS Fund ON Fund.PolicyBusinessId = Pb.PolicyBusinessId                                
 -- Look for single contribution                                  
 LEFT JOIN (                                  
  SELECT                                  
   PolicyBusinessId,                                  
   COUNT(*) AS Number                                  
  FROM     
   PolicyManagement..TPolicyMoneyIn WITH(NOLOCK)                                    
  WHERE     
   PolicyBusinessId IN (SELECT BusinessId FROM @PlanList)      
  GROUP BY     
   PolicyBusinessId) AS Contributions ON Contributions.PolicyBusinessId = Pb.PolicyBusinessId                                  
 -- Identify wrappers    
 LEFT JOIN PolicyManagement..TWrapperPolicyBusiness W WITH(NOLOCK) ON W.PolicyBusinessId = Pb.PolicyBusinessId 
WHERE
 Pd.IndigoClientId = @TenantId
 AND PB.IndigoClientId = @TenantId
 AND Pd.PolicyDetailId IN (SELECT DetailId FROM @PlanList)
 AND PB.PolicyBusinessId IN (SELECT BusinessId FROM @PlanList)
 -- check whether to include topups.
 AND (@IncludeTopups = 1 OR PB.TopupMasterPolicyBusinessId IS NULL)

RETURN

END
GO