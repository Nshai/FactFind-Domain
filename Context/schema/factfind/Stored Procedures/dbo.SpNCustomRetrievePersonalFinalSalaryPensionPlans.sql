SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNCustomRetrievePersonalFinalSalaryPensionPlans] 
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
 
-- final salary plans                                
SELECT                                 
 Pd.PolicyBusinessId as FinalSalaryPensionPlansId,                                
 pd.CRMContactId,                           
 pd.CRMContactId2,                                
 pd.[Owner],                          
 pd.SellingAdviserId,                          
 pd.SellingAdviserName,                          
 pd.RefProdProviderId,
 pd.Provider,
 pd.AgencyStatus,
 ext.Employer,  
 tpi.SRA as NormalSchemeRetirementAge,                                
 tpi.AccrualRate as AccrualRateText,                                
 pd.StartDate as DateJoined,                                   
 tpi.ExpectedYearsOfService,                     
 tpi.PensionableSalary,                                
 tpi.IsCurrent as Preserved,                                
 tpi.IsIndexed as Indexed,  
 pd.ConcurrencyId,
 pd.ProductName,  
 pd.PlanStatus,  
 pd.MortgageRepayPercentage,  
 pd.MortgageRepayAmount,
 CASE WHEN wrapper1.PolicyBusinessId IS NULL AND wrapper2.ParentPolicyBusinessId IS NULL
 THEN CONVERT(BIT,0)
 ELSE CONVERT(BIT,1) END AS IsWrapper,
 tpi.GMPAmount,
 tpi.ProspectivePensionAtRetirement,
 tpi.ProspectivePensionAtRetirementLumpSumTaken,
 tpi.ProspectiveLumpSumAtRetirement,
 tpi.EarlyRetirementFactorNotes,
 tpi.DependantBenefits,
 tpi.IndexationNotes,
 PBE.AdditionalNotes,
 tpi.ServiceBenefitSpouseEntitled AS DeathInServiceSpousalBenefits,
 tpi.YearsPurchaseAvailability,
 tpi.YearsPurchaseAvailabilityDetails,
 tpi.AffinityContributionAvailability,
 tpi.AffinityContributionAvailabilityDetails,
 tpi.CashEquivalentTransferValue,
 tpi.TransferExpiryDate,
 pd.PlanCurrency,
 pd.SequentialRef,
 pd.IsProviderManaged,
 tpi.PensionArrangement,
 tpi.CrystallisationStatus,
 tpi.HistoricalCrystallisedPercentage,
 tpi.CurrentCrystallisedPercentage,
 tpi.CrystallisedPercentage,
 tpi.UncrystallisedPercentage
FROM   
 @PlanDescription pd              
 JOIN TRefPlanTypeToSection PTS ON PTS.RefPlanType2ProdSubTypeId = Pd.RefPlanType2ProdSubTypeId  
 LEFT JOIN PolicyManagement..TPensionInfo tpi WITH(NOLOCK) ON tpi.PolicyBusinessId = pd.PolicyBusinessId                                
 LEFT JOIN PolicyManagement..TRefSchemeBasis rsb WITH(NOLOCK) ON tpi.RefSchemeBasisId = rsb.RefSchemeBasisId                                
 LEFT JOIN TFinalSalaryPensionsPlanFFExt ext WITH(NOLOCK) ON ext.PolicyBusinessId = pd.PolicyBusinessId                                
 LEFT JOIN Policymanagement..TWrapperPolicyBusiness wrapper1 WITH(NOLOCK) ON wrapper1.PolicyBusinessId = Pd.PolicyBusinessId  
 LEFT JOIN Policymanagement..TWrapperPolicyBusiness wrapper2 WITH(NOLOCK) ON wrapper2.ParentPolicyBusinessId = Pd.PolicyBusinessId 
 LEFT JOIN policymanagement..TPolicyBusinessExt PBE ON PBE.PolicyBusinessId = pd.PolicyBusinessId
WHERE   
 PTS.Section = 'Final Salary Schemes' 
SET NOCOUNT OFF
End
GO