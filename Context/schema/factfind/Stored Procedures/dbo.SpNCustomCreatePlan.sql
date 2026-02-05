SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomCreatePlan]          
 @CRMContactId bigint,                  
 @CRMContactId2 bigint,
 @CurrentUserDateTime datetime,
 @Timezone varchar(100),
 @PlanType varchar(255) = null,                
 @PlanPurpose varchar(255) = null,                  
 @PolicyNumber varchar(50)=null,                  
 @Owner varchar(50),                  
 @ContributionAmount money = null,                  
 @ContributionFrequency varchar(50) = null,                  
 @MaturityDate datetime = null,                  
 @IndigoClientId bigint,                  
 @ProductName varchar(255) = null,                  
 @StampUser varchar(50),                  
 @StartDate datetime = null,                  
 @SellingAdviserId bigint,                  
 @ReturnId bigint OUTPUT,          
 @RefPlanType2ProdSubTypeId bigint = null,           
 @RefProdProviderId bigint,          
 @RefContributionFrequencyId bigint = null,          
 @ContributionStartDate datetime = null,          
 @LumpSumContributionAmount money = null,          
 @TransferContributionAmount money = null,          
 @MortgageRepayPercentage money = null,          
 @MortgageRepayAmount money = null,          
 @IsGuaranteedToProtectOriginalInvestment bit = null,          
 @RefAnnuityPaymentTypeId bigint = null,          
 @CapitalElement money = null,              
 @AssumedGrowthRatePercentage decimal(5, 2) = null,        
 @LowMaturityValue money = null,        
 @MediumMaturityValue money = null,        
 @HighMaturityValue money = null,  
 @ProjectionDetails varchar(5000) = null,
 @PlanPurposeId bigint = null,
 @InterestRate [money] = null,
 @PlanCurrency varchar(3),
 @AgencyStatus varchar(50) = null,
 @RefContributorTypeId int = null
AS                  
DECLARE @BandingTemplateId bigint,  @InForceDate datetime ,@TnCCoachId bigint            
IF ISNULL(@CRMContactId, 0) = 0                
 RAISERROR('Error creating plan, client id information is required', 11, 1);          
                  
-----------------------------------------------------------------------------------          
-- Get reference data...          
-----------------------------------------------------------------------------------                  
-- Get the default BandingTemplateId for this selling adviser                          
SELECT @BandingTemplateId = BandingTemplateId                   
FROM Commissions..TBandingTemplate                  
WHERE PractitionerId = @SellingAdviserId AND DefaultFg = 1               
            
-- Get the tnccoach                
select @TnCCoachId=A.TnCCoachId                 
from CRM..TPractitioner A                
where a.PractitionerId = @SellingAdviserId               
                 
IF((ISNULL(@PlanPurpose,'') <> '') and (@PlanPurposeId IS NULL))
 SELECT @PlanPurposeId=PlanPurposeId FROM PolicyManagement..TPlanPurpose WHERE IndigoClientId=@IndigoClientId AND Descriptor=@PlanPurpose               
                
IF @StartDate IS NOT NULL          
 SET @InForceDate = @StartDate                
ELSE                
 SET @InForceDate = CONVERT(varchar(12), @CurrentUserDateTime, 106)
                          
-- set the MaturityDate to null if we've passed in ''                  
if @MaturityDate = '1900-01-01'                  
 SET @MaturityDate = null                  
                          
-- Get the RefPlanType2ProdSubTypeId for the chosen plan /sub type                  
IF @RefPlanType2ProdSubTypeId IS NULL          
 SELECT @RefPlanType2ProdSubTypeId = t.RefPlanType2ProdSubTypeId                  
 FROM PolicyManagement..TRefPlanType2ProdSubType t                  
  JOIN PolicyManagement..TRefPlanType rpt ON rpt.RefPlanTypeId = t.RefPlanTypeId                  
  LEFT JOIN PolicyManagement..TProdSubType pst ON pst.ProdSubTypeId = t.ProdSubTypeId                  
 WHERE rpt.PlanTypeName + isnull(' (' + pst.ProdSubTypeName + ')','') = @PlanType                   
                  
-- quit here if we haven't got one of these required ids...                  
IF @RefPlanType2ProdSubTypeId IS NULL                 
 RAISERROR ('Plan Type information is missing', 11, 1)       

IF @PlanCurrency IS NULL
    SELECT @PlanCurrency = administration.dbo.FnGetRegionalCurrency()
                  
-----------------------------------------------------------------------------------                  
-- Create a TPlanDescription record                  
-----------------------------------------------------------------------------------          
DECLARE @PlanDescriptionId bigint                  
                  
INSERT INTO PolicyManagement..TPlanDescription (RefPlanType2ProdSubTypeId, RefProdProviderId, ConcurrencyId )                   
VALUES (@RefPlanType2ProdSubTypeId, @RefProdProviderId,  1)                   
              
SET @PlanDescriptionId = SCOPE_IDENTITY()                  
-- Audit          
EXEC PolicyManagement..SpNAuditPlanDescription @StampUser, @PlanDescriptionId, 'C'          
              
-----------------------------------------------------------------------------------              
-- Create a TPolicyDetail record                  
-----------------------------------------------------------------------------------          
DECLARE @PolicyDetailId bigint                  
                  
INSERT INTO PolicyManagement..TPolicyDetail (          
 PlanDescriptionId, IndigoClientId, ConcurrencyId, RefAnnuityPaymentTypeId, CapitalElement, AssumedGrowthRatePercentage)                   
VALUES (@PlanDescriptionId, @IndigoClientId, 1, @RefAnnuityPaymentTypeId, @CapitalElement, @AssumedGrowthRatePercentage)                   
                  
SET @PolicyDetailId = SCOPE_IDENTITY()                  
-- Audit                  
EXEC PolicyManagement..SpNAuditPolicyDetail @StampUser, @PolicyDetailId, 'C'          
                  
-----------------------------------------------------------------------------------                  
-- Create a TPolicyOwner record(s)                  
-----------------------------------------------------------------------------------          
DECLARE @PolicyOwnerId bigint                  
DECLARE @PolicyOwnerCRMId bigint                  
                  
IF @Owner = 'Client 1' or @Owner = 'Joint'                  
 SET @PolicyOwnerCRMId = @CRMContactId           
                  
IF @Owner = 'Client 2' AND @CRMContactId2 IS NOT NULL                  
 SET @PolicyOwnerCRMId = @CRMContactId2                  
                          
IF ISNULL(@CRMContactId,0) > 0  BEGIN                
 INSERT INTO PolicyManagement..TPolicyOwner (CRMContactId, PolicyDetailId, ConcurrencyId )                   
 VALUES ( @PolicyOwnerCRMId, @PolicyDetailId, 1)                   
                  
 SET @PolicyOwnerId = SCOPE_IDENTITY()                          
 EXEC PolicyManagement..SpNAuditPolicyOwner @StampUser, @PolicyOwnerId, 'C'                  
END                
                  
-- add the second owner                  
IF @Owner = 'Joint' AND ISNULL(@CRMContactId2,0)>0 BEGIN                  
 INSERT INTO PolicyManagement..TPolicyOwner (CRMContactId, PolicyDetailId, ConcurrencyId )                   
 VALUES ( @CRMContactId2, @PolicyDetailId, 1)                   
                   
 SET @PolicyOwnerId = SCOPE_IDENTITY()                          
 EXEC PolicyManagement..SpNAuditPolicyOwner @StampUser, @PolicyOwnerId, 'C'                    
END                  
                  
-----------------------------------------------------------------------------------                  
-- Get the Pre-Existing advice type for this organisation                  
-----------------------------------------------------------------------------------          
DECLARE @AdviceTypeId bigint                  
SET @AdviceTypeId = (                  
 SELECT AdviceTypeId                   
 FROM PolicyManagement..TAdviceType                   
 WHERE IndigoClientId = @IndigoClientId              
 AND IntelligentOfficeAdviceType = 'Pre-Existing'                  
 AND ArchiveFg = 0                  
)                  
              
-- Get the LifeCycleId                  
DECLARE @LifeCycleId bigint                  
SET @LifeCycleId = (                  
 SELECT LifeCycleId                   
 FROM PolicyManagement..TLifeCycle                   
 WHERE IndigoClientId = @IndigoClientId                   
 AND Descriptor = 'Pre-Existing'                  
 AND Status = 1                  
)                  
                                         
-----------------------------------------------------------------------------------                          
-- Create the TPolicyBusiness record                  
-----------------------------------------------------------------------------------          
DECLARE @PolicyBusinessId bigint                  
          
-----------------------------------------------------------------------------------          
-- Contribution information.          
-----------------------------------------------------------------------------------          
DECLARE @IsCurrent bit            
DECLARE @RefContributionTypeId int = 1          
DECLARE @RegAmount money, @LumpAmount money                  
              
IF @RefContributionFrequencyId IS NOT NULL          
 SELECT @ContributionFrequency = FrequencyName FROM PolicyManagement..TRefFrequency WHERE RefFrequencyId = @RefContributionFrequencyId          
ELSE          
 SELECT @RefContributionFrequencyId = RefFrequencyId                   
 FROM PolicyManagement..TRefFrequency          
 WHERE FrequencyName = @ContributionFrequency AND RetireFg = 0       
       
                 
              
IF (@ContributionFrequency = 'Single')          
	SET @LumpAmount = @ContributionAmount          
ELSE BEGIN
	SET @RegAmount = @ContributionAmount                 
	IF ISNULL(@RegAmount, 0) = 0
		SET @ContributionFrequency = NULL
END
   
   
-----------------------------------------------------------------------------------                  
-- Add PolicyBusiness          
-----------------------------------------------------------------------------------          
INSERT INTO PolicyManagement..TPolicyBusiness (          
 PolicyDetailId, PolicyNumber, PractitionerId,TnCCoachId, AdviceTypeId,          
 IndigoClientId, TotalRegularPremium, TotalLumpSum, PremiumType, PolicyStartDate, MaturityDate,           
 LifeCycleId, ProductName,  ConcurrencyId, IsGuaranteedToProtectOriginalInvestment,LowMaturityValue,        
 MediumMaturityValue,HighMaturityValue, ProjectionDetails, BaseCurrency)                  
VALUES (          
 @PolicyDetailId, @PolicyNumber, @SellingAdviserId, @TnCCoachId, @AdviceTypeId,           
 @IndigoClientId, ISNULL(@RegAmount, 0), ISNULL(@LumpAmount, 0) + ISNULL(@LumpSumContributionAmount, 0) + ISNULL(@TransferContributionAmount, 0),           
 @ContributionFrequency, @StartDate, @MaturityDate,           
 @LifeCycleId, @ProductName, 1, @IsGuaranteedToProtectOriginalInvestment,@LowMaturityValue,@MediumMaturityValue,        
 @HighMaturityValue, @ProjectionDetails, @PlanCurrency)                      
                  
SET @PolicyBusinessId = SCOPE_IDENTITY()                  
-- Audit          
EXEC PolicyManagement..SpNAuditPolicyBusiness @StampUser, @PolicyBusinessId, 'C'                   
                  
-----------------------------------------------------------------------------------                  
-- Create the TPolicyBusinessExt record
-----------------------------------------------------------------------------------          
DECLARE @PolicyBusinessExtId bigint,
        @ReceivingAdviserId INT,
        @UseCRABanding TINYINT,
        @IsVisibleToClient bit = 1

SELECT @ReceivingAdviserId = ReceivingPractitionerId, @UseCRABanding = UseCRABandingFg
FROM Commissions..TReceivingAdviser
WHERE SellingPractitionerId = @SellingAdviserId

INSERT INTO PolicyManagement..TPolicyBusinessExt (PolicyBusinessId, BandingTemplateId, MortgageRepayPercentage, MortgageRepayAmount, InterestRate, ForwardIncomeToAdviserId, ForwardIncomeToUseAdviserBanding, AgencyStatus, WhoCreatedUserId, IsVisibleToClient)
VALUES (@PolicyBusinessId, @BandingTemplateId, @MortgageRepayPercentage, @MortgageRepayAmount, @InterestRate, @ReceivingAdviserId, @UseCRABanding, @AgencyStatus, @StampUser, @IsVisibleToClient)

SET @PolicyBusinessExtId = SCOPE_IDENTITY()
-- Audit          
EXEC PolicyManagement..SpNAuditPolicyBusinessExt @StampUser, @PolicyBusinessExtId, 'C'                   
                  
-----------------------------------------------------------------------------------                  
-- Add an Inforce Status for the plan                  
-----------------------------------------------------------------------------------          
DECLARE @StatusId bigint                  
DECLARE @StatusHistoryId bigint                  
                   
SET @StatusId = (                  
 SELECT TOP 1 StatusId                  
 FROM PolicyManagement..TStatus                   
 WHERE IndigoClientId = @IndigoClientId                  
 AND IntelligentOfficeStatusType = 'In force'                  
)                  
                  
INSERT INTO PolicyManagement..TStatusHistory(PolicyBusinessId, StatusId, ChangedToDate, ChangedByUserId, DateOfChange, CurrentStatusFg, LifeCycleStepFg, ConcurrencyId)                  
VALUES (@PolicyBusinessId, @StatusId, @InForceDate, @StampUser, getdate(), 1, 1, 1)                  
                  
SET @StatusHistoryId = SCOPE_IDENTITY()                  
-- Audit          
EXEC PolicyManagement..SpNAuditStatusHistory @StampUser, @StatusHistoryId, 'C'                   
                          
-----------------------------------------------------------------------------------          
-- Create any contribution records                          
-----------------------------------------------------------------------------------          
DECLARE @PolicyMoneyInId bigint                  
          
IF @ContributionAmount IS NOT NULL AND @ContributionFrequency IS NOT NULL BEGIN                              
 SET @ContributionStartDate = COALESCE(@ContributionStartDate, @StartDate, @InForceDate)       
 SET @RefContributorTypeId = COALESCE(@RefContributorTypeId, 1)
 Print'1'             
 EXEC [SpNCustomCreatePlanPremium] @StampUser, @PolicyBusinessId, @RefContributionFrequencyId,           
  @ContributionAmount, @ContributionStartDate, @RefContributionTypeId, @RefContributorTypeId, @CurrentUserDateTime        
END                  
          
          
SET @ContributionStartDate = ISNULL(@StartDate, @InForceDate)        
Print @LumpSumContributionAmount            
IF @LumpSumContributionAmount IS NOT NULL          
 EXEC [SpNCustomCreatePlanPremium] @StampUser, @PolicyBusinessId, 10,           
  @LumpSumContributionAmount, @ContributionStartDate, 2, 3, @CurrentUserDateTime       
 print    @TransferContributionAmount      
IF @TransferContributionAmount IS NOT NULL          
 EXEC [SpNCustomCreatePlanPremium] @StampUser, @PolicyBusinessId, 10,           
  @TransferContributionAmount, @ContributionStartDate, 3, 3, @CurrentUserDateTime       
 print'3'                    
-----------------------------------------------------------------------------------                
-- Add a plan purpose record if required                
-----------------------------------------------------------------------------------          
IF ISNULL(@PlanPurposeId, 0) > 0 BEGIN                
 DECLARE @PolicyBusinessPurposeId bigint                
             
 INSERT PolicyManagement..TPolicyBusinessPurpose(PlanPurposeId,PolicyBusinessId,ConcurrencyId)               
 SELECT @PlanPurposeId,@PolicyBusinessId,1                
             
 SET @PolicyBusinessPurposeId=SCOPE_IDENTITY()                   
 -- Audit          
 EXEC PolicyManagement..SpNAuditPolicyBusinessPurpose @StampUser, @PolicyBusinessPurposeId, 'C'                            
END               
          
------------------------------------------------------------------------------------          
--- AME-92 Add default TPolicyBusinessTotalPlanValuationType          
------------------------------------------------------------------------------------          
EXEC policymanagement..spAddDefaultTotalPlanValuationTypeForPlan @StampUser, @PolicyBusinessId          
              
-----------------------------------------------------------------------------------          
-- Add any task for the client and plan          
-----------------------------------------------------------------------------------          
DECLARE @PolicyOwnerOrCRMId bigint = ISNULL(@PolicyOwnerCRMId, @CRMContactId);

EXEC SpNCustomCreateLifeCycleTasks @StampUser, @IndigoClientId, @LifeCycleId, @StatusId,
 @SellingAdviserId, @PolicyOwnerOrCRMId, @PolicyBusinessId, @CurrentUserDateTime, @Timezone
             
-----------------------------------------------------------------------------------             
-- Finally add a dnpolicymatching record              
-----------------------------------------------------------------------------------          
EXEC SpNCustomCreateDnPolicyMatchingByPolicyId @PolicyBusinessId, @StampUser               
    
-- Return PolicyBusinessId          
SET @ReturnId = @PolicyBusinessId                  
          
-- Errors                        
errh:                
 RETURN(100)   
GO
