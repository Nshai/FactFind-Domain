SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomCreateSavingsPlans]   
	@CRMContactId bigint,  
	@PlanType bigint,
	@CurrentUserDateTime datetime,
	@Timezone varchar(100),
	@SavingsPlanPurpose varchar(255)=null, 
	@SavingsPlansStartDate datetime=null,
	@PolicyNumber varchar(50)=null, 
	@RefProdProviderId bigint,
	@ProductName varchar(255)=null,  
	@MaturityDate datetime = null,  
	@Owner varchar(255),  
	@CurrentValue money=null,  
	@InterestRate money = null,  
	@SellingAdviser bigint,  
	@StampUser varchar(255),  
	@MortgageRepayPercentage money = null,
	@MortgageRepayAmount money = null,
	@PlanPurposeId bigint=null,
	@SplitTemplateGroupId int = null,  
	@TemplateGroupType varchar(255) = null,
	@PlanCurrency varchar(3)  =  null,
	@AgencyStatus varchar(50)  = null,
    @LastUpdatedDate datetime = null,
	@PensionArrangement varchar(100) = null,
	@CrystallisationStatus varchar (20) = null,
	@HistoricalCrystallisedPercentage decimal (10, 2) = null,
	@CurrentCrystallisedPercentage decimal (10, 2) = null,
	@CrystallisedPercentage decimal (10, 2) = null,
	@UncrystallisedPercentage decimal (10, 2) = null
AS  
DECLARE @CRMContactId2 bigint, @PolicyBusinessId bigint, @IndigoClientId bigint  

-- Get the indigoClientId, use the CRMContactId to get it     
SET @IndigoClientId = (SELECT IndClientId FROM CRM..TCRMContact WHERE CRMContactId = @CRMContactId)  
-- is there a client 2?  
SET @CRMContactId2 = (Select CRMContactId2 FROM TFactFind WHERE CRMContactId1 = @CRMContactId)  

IF(@PlanPurposeId IS NOT NULL)
  SET @SavingsPlanPurpose = (SELECT Descriptor
                              FROM PolicyManagement..TPlanPurpose 
                              WHERE IndigoClientId=@IndigoClientId AND 
                                     PlanPurposeId=@PlanPurposeId)    

--------------------------------------------------------------    
-- create the basic plan data, this will return a PolicyBusinessId  
--------------------------------------------------------------    
exec SpNCustomCreatePlan @CRMContactId, @CRMContactId2, @CurrentUserDateTime, @Timezone, null, @SavingsPlanPurpose, @PolicyNumber, @Owner, null, null, 
	@MaturityDate, @IndigoClientId, @ProductName, @StampUser, @SavingsPlansStartDate, @SellingAdviser, @PolicyBusinessId OUTPUT, @RefProdProviderId = @RefProdProviderId,
	@MortgageRepayAmount = @MortgageRepayAmount, @MortgageRepayPercentage = @MortgageRepayPercentage,
	@RefPlanType2ProdSubTypeId = @PlanType, @InterestRate = @InterestRate, @PlanCurrency=@PlanCurrency, @AgencyStatus = @AgencyStatus

--------------------------------------------------------------
-- Add Pension Info
--------------------------------------------------------------
EXEC [SpNCustomCreatePlanPensionInfo] @StampUser, @PolicyBusinessId, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL, NULL,
	@CrystallisationStatus, @HistoricalCrystallisedPercentage, @CurrentCrystallisedPercentage, @CrystallisedPercentage,
	@UncrystallisedPercentage, @PensionArrangement
	
--------------------------------------------------------------    
-- Add a valuation  
--------------------------------------------------------------    
EXEC SpNCustomCreatePlanValuation @StampUser, @PolicyBusinessId, @CurrentValue, @CurrentUserDateTime, @LastUpdatedDate

SELECT @PolicyBusinessId as SavingsPlansId  

-- Exec SplitTemplate for Plan
IF((@SplitTemplateGroupId IS NOT NULL) AND (@SplitTemplateGroupId > 0) AND (@TemplateGroupType IS NOT NULL))
BEGIN
	EXEC SpNCreateSplitTemplatesForPlans @IndigoClientId,@CRMContactId, @PolicyBusinessId, @SellingAdviser,@SplitTemplateGroupId,@TemplateGroupType
END
GO

