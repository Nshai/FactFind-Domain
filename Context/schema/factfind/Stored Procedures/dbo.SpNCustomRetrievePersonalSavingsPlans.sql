SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNCustomRetrievePersonalSavingsPlans] 
(
  @IndigoClientId bigint,                                
  @UserId bigint,                                
  @FactFindId bigint ,  
  @ExcludePlanPurposes BIT = 0 
)
As
Begin
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
DECLARE   
 @CRMContactId bigint, @CRMContactId2 bigint, @AdviserId bigint, @AdviserCRMId bigint, @AdviserName varchar(255),  
 @PreExistingAdviserId bigint, @PreExistingAdviserName varchar(255), @PreExistingAdviserCRMId bigint,                    
 @NewId bigint, @IncludeTopups bit, @TenantId bigint,  
 @AdviserUserId bigint, @AdviserGroupId bigint, @IncomeReplacementRate smallint, @UserIncomeReplacementRate smallint  
  
---------------------------------------------------------------------------------  
-- Get some initial settings  
---------------------------------------------------------------------------------  
 Exec dbo.SpNCustomRetrievePersonalDataInitialSettings @IndigoClientId, @UserId, @FactFindId, @ExcludePlanPurposes,@CRMContactId OutPut, 
													   @CRMContactId2 OutPut, @AdviserId OutPut, @AdviserCRMId OutPut, @AdviserName OutPut,  
													   @PreExistingAdviserId OutPut, @PreExistingAdviserName OutPut, @PreExistingAdviserCRMId OutPut,                    
													   @NewId OutPut, @IncludeTopups OutPut, @TenantId OutPut,  
													   @AdviserUserId OutPut, @AdviserGroupId OutPut, @IncomeReplacementRate OutPut, @UserIncomeReplacementRate OutPut
 
-- Basic Plan Details   
DECLARE @PlanDescription TABLE                                
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
 PlanPurposeId bigint null,            
 ParentPolicyBusinessId bigint,  
 ExcludeValuation bit,    
 ConcurrencyId bigint null,  
 PlanStatus varchar(50) null,                            
 MortgageRepayPercentage money null,   
 MortgageRepayAmount money null,  
 [IsGuaranteedToProtectOriginalInvestment] bit null,
 PlanCurrency varchar(3) null,
 SequentialRef varchar(50) null,
 IsProviderManaged bit null
)
 
 -- Basic Plan Details    
 Insert into @PlanDescription
 Select * from dbo.FnCustomGetPlanDescription(@CRMContactId, @CRMContactId2, @TenantId, @ExcludePlanPurposes, @IncludeTopups)
  
-- Update WRAPs so their valuation's are excluded if they have child plans  
UPDATE A  
SET  
 ExcludeValuation = 1   
FROM  
 -- The A's are the WRAPs  
 @PlanDescription A  
 -- The B's are child plans who's parent also appears in our list.  
 JOIN @PlanDescription B ON B.ParentPolicyBusinessId = A.PolicyBusinessId  
WHERE  
 A.UnderlyingPlanType = 'WRAP'  
 AND B.CurrentValue != 0 -- Child plan must have a value.  

        
-- savings                                
SELECT                                 
 Pd.PolicyBusinessId as SavingsPlansId,                                
 Pd.CRMContactId,                                
 Pd.CRMContactId2,                                
 Pd.Owner,    
 pd.SellingAdviserId,                          
 pd.SellingAdviserName,
 Pd.PlanType, 
 Pd.RefPlanType2ProdSubTypeId,  
 Pd.RefProdProviderId,
 Pd.Provider, 
 CASE @ExcludePlanPurposes   
  WHEN 1 THEN ''  
  ELSE ISNULL(Pd.PlanPurpose,'')  
 END PlanPurposeText,                 
 Pd.PolicyNumber,
 Pd.AgencyStatus,
 Pd.ProductName,  
 Pd.CurrentValue,  
 Pd.StartDate as SavingsPlansStartDate,                                
 Pd.MaturityDate,                                
 PBE.InterestRate,
 pd.ConcurrencyId,  
 pd.PlanStatus,  
 pd.MortgageRepayPercentage,  
 pd.MortgageRepayAmount,
 CASE @ExcludePlanPurposes     
  WHEN 1 THEN null    
  ELSE pd.PlanPurposeId    
 END As PlanPurposeId,
 CASE WHEN wrapper1.PolicyBusinessId IS NULL AND wrapper2.ParentPolicyBusinessId IS NULL
 THEN CONVERT(BIT,0)
 ELSE CONVERT(BIT,1) END AS IsWrapper,
 CASE 
	WHEN wrapper1.ParentPolicyBusinessId IS NOT NULL AND ParentPlan.IntelligentOfficeStatusType IN ('In force', 'Paid Up') THEN ISNULL(wrapper1.ParentPolicyBusinessId, 0)
	ELSE 0 
 END AS WrapPlan, 
 ParentPlan.PlanTypeName AS WrapPlanName,
 pd.PlanCurrency,
 pd.ValuationDate AS LastUpdatedDate,
 pd.SequentialRef,
 pd.IsProviderManaged,
 Tp.PensionArrangement,
 Tp.CrystallisationStatus,
 Tp.HistoricalCrystallisedPercentage,
 Tp.CurrentCrystallisedPercentage,
 Tp.CrystallisedPercentage,
 Tp.UncrystallisedPercentage
FROM   
 @PlanDescription pd           
 JOIN TRefPlanTypeToSection PTS ON PTS.RefPlanType2ProdSubTypeId = Pd.RefPlanType2ProdSubTypeId  
 LEFT JOIN Policymanagement..TPolicyBusinessExt PBE ON PBE.PolicyBusinessId = pd.PolicyBusinessId    
 LEFT JOIN Policymanagement..TWrapperPolicyBusiness wrapper1 WITH(NOLOCK) ON wrapper1.PolicyBusinessId = pd.PolicyBusinessId  
 LEFT JOIN Policymanagement..TWrapperPolicyBusiness wrapper2 WITH(NOLOCK) ON wrapper2.ParentPolicyBusinessId = pd.PolicyBusinessId 
 LEFT JOIN (SELECT PRPT.PlanTypeName,PPB.PolicyBusinessId,S.IntelligentOfficeStatusType FROM policymanagement..TPolicyBusiness PPB 
    INNER JOIN policymanagement..TPolicyDetail PPD
    ON PPD.PolicyDetailId = PPB.PolicyDetailId
    INNER JOIN policymanagement..TPlanDescription PPDes
    ON PPDes.PlanDescriptionId = PPD.PlanDescriptionId
    INNER JOIN policymanagement..TRefPlanType2ProdSubType PPTPS 
    ON PPDes.RefPlanType2ProdSubTypeId = PPTPS.RefPlanType2ProdSubTypeId   
    INNER JOIN policymanagement..TRefPlanType PRPT 
    ON PRPT.RefPlanTypeId = PPTPS.RefPlanTypeId  
    INNER JOIN policymanagement..TRefProdProvider PP
	ON PP.RefProdProviderId = PPDes.RefProdProviderId
	INNER JOIN crm..TCRMContact crm
	ON crm.CRMContactId = PP.CRMContactId 
    INNER JOIN policymanagement..TStatusHistory SH
	ON SH.PolicyBusinessId = PPB.PolicyBusinessId
	INNER JOIN policymanagement..TStatus S
	ON S.StatusId = SH.StatusId
    WHERE SH.CurrentStatusFG = 1) AS ParentPlan
    ON ParentPlan.PolicyBusinessId = wrapper1.ParentPolicyBusinessId
LEFT JOIN PolicyManagement..TPensionInfo Tp WITH(NOLOCK) ON Tp.PolicyBusinessId = Pd.PolicyBusinessId 
WHERE   
 PTS.Section = 'Savings' 
SET NOCOUNT OFF
End
GO