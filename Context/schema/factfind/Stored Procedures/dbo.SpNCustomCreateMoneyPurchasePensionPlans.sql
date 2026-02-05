SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomCreateMoneyPurchasePensionPlans]
	@CRMContactId bigint,    
	@Owner varchar(10),    
	@PlanType varchar(255),    
	@Provider varchar(255),
	@CurrentUserDateTime datetime,   
	@PolicyNumber varchar(50) = null,    
	@Employer varchar(255) = null,    
	@DateJoined datetime = null,    
	@NormalSchemeRetirementAge int = null,    
	@SelfContributionAmount money = null,    
	@EmployerContributionAmount money = null,    
	@Frequency varchar(255),    
	@Value money = null,    
	@ValuationDate datetime = null,    
	@Indexed bit = null,    
	@Preserved bit = null,    
	@SellingAdviser bigint,    
	@LumpSumCommutation money = null,  
	@StampUser varchar(50),  
	@MortgageRepayPercentage money  = null,
	@MortgageRepayAmount money  = null
AS
DECLARE @CRMContactId2 bigint, @PolicyBusinessId bigint    
DECLARE @ContributionStartDate datetime = ISNULL(@DateJoined, @CurrentUserDateTime)            
    
-- is there a client 2?    
SET @CRMContactId2 = (Select CRMContactId2 FROM TFactFind WHERE CRMContactId1 = @CRMContactId)    
    
-- Get the indigoClientId, use the CRMContactId to get it    
DECLARE @IndigoClientId bigint         
SET @IndigoClientId = (SELECT IndClientId FROM CRM..TCRMContact WHERE CRMContactId = @CRMContactId)    
    
--------------------------------------------------------------    
-- create the basic plan data, this will return a PolicyBusinessId    
--------------------------------------------------------------    
exec SpNCustomCreatePlan @CRMContactId, @CRMContactId2, @PlanType,NULL, @Provider, @PolicyNumber, @Owner, @SelfContributionAmount, 
	@Frequency, null, @IndigoClientId, null, @StampUser, @DateJoined, @SellingAdviser, @PolicyBusinessId OUTPUT,
	@MortgageRepayAmount = @MortgageRepayAmount, @MortgageRepayPercentage = @MortgageRepayPercentage    

IF ISNULL(@PolicyBusinessId,0) = 0 
	RAISERROR('Error occurred when creating Personal Pension Plan', 11, 1);

--------------------------------------------------------------    
-- add an Employer contribution    
--------------------------------------------------------------    
IF @EmployerContributionAmount IS NOT NULL AND @Frequency IS NOT NULL BEGIN    
	DECLARE @RefFrequencyId bigint    
	SET @RefFrequencyId = (    
		SELECT RefFrequencyId     
		FROM PolicyManagement..TRefFrequency rf    
		WHERE FrequencyName = @Frequency    
		AND RetireFg = 0    
	)    

	EXEC SpNCustomCreatePlanPremium @StampUser, @PolicyBusinessId,  
		@RefFrequencyId, @EmployerContributionAmount, @ContributionStartDate, 1, 2, @CurrentUserDateTime
END    	

--------------------------------------------------------------    
-- Add Pension Info
--------------------------------------------------------------    
EXEC [SpNCustomCreatePlanPensionInfo] @StampUser, @PolicyBusinessId, @NormalSchemeRetirementAge, @Preserved, @Indexed

--------------------------------------------------------------    
-- Add a valuation        
--------------------------------------------------------------    
EXEC SpNCustomCreatePlanValuation @StampUser, @PolicyBusinessId, @Value, @CurrentUserDateTime, @ValuationDate

--------------------------------------------------------------    
-- Ext fields    
--------------------------------------------------------------    
DECLARE @MoneyPurchasePensionPlanFFExtId bigint    

INSERT INTO TMoneyPurchasePensionPlanFFExt(PolicyBusinessId, Employer, LumpSumCommutation,ConcurrencyId)    
VALUES (@PolicyBusinessId, @Employer, @LumpSumCommutation, 1)    

SET @MoneyPurchasePensionPlanFFExtId =  SCOPE_IDENTITY()      
EXEC SpNAuditMoneyPurchasePensionPlanFFExt @StampUser, @MoneyPurchasePensionPlanFFExtId, 'C'  

-- return    
SELECT @PolicyBusinessId as MoneyPurchasePensionPlansId 
GO
