SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNCustomCreateEquityRelease]
	@StampUser varchar(50),  
	@CRMContactId bigint,
	@CurrentUserDateTime datetime,
	@Timezone varchar(100),
	@Owner varchar(255) = null,  
	@SellingAdviser bigint = null,  
	@PolicyNumber varchar(50) = null,  
	@RefProdProviderId bigint,  
	@AddressStoreId bigint = null,  
	@RateType varchar(255) = null, 
	@StartDate varchar(255) = null,
	@RepaymentMethod bigint = null,
	@RepaymentAmount money = null, 
	@InterestOnlyAmount money = null,   
	@LoanAmount money = null, 
	@InterestRatePercentage decimal(10, 2) = null,
	@AssetsId bigint = null,
	@AmountReleased varchar(50) = null,
	@InterestRate decimal(10, 2) = null,
	@RedemptionFg bit = Null, 
	@RedemptionTerms varchar(1000) = null,  
	@RedemptionEndDate datetime = null,  	
	@ProductName varchar(200) = null,
	@RefEquityReleaseTypeId bigint = null,
    @PercentageOwnershipSold decimal(10, 2) = null,
    @LumpsumAmount decimal(10, 2) = null,
    @MonthlyIncomeAmount decimal(10, 2) = null,
	@CurrentBalance money = null, 
	@SplitTemplateGroupId int = null,
	@TemplateGroupType varchar(255) = null,
    @PlanCurrency varchar(3) = null,
	@AddressId bigint = null,
	@AgencyStatus varchar(50) null = null,
	@IsToBeConsolidated bit = default,
    @IsLiabilityToBeRepaid bit = null,
    @LiabilityRepaymentDescription varchar(500) = null,
	@PensionArrangement varchar(100) = null,
	@CrystallisationStatus varchar (20) = null,
	@HistoricalCrystallisedPercentage decimal (10, 2) = null,
	@CurrentCrystallisedPercentage decimal (10, 2) = null,
	@CrystallisedPercentage decimal (10, 2) = null,
	@UncrystallisedPercentage decimal (10, 2) = null
AS  
DECLARE @CRMContactId2 bigint, @IndigoClientId bigint, @PolicyBusinessId bigint, @PlanType varchar(255), @MortgageId bigint,
	@StatusFg bit, @NonStatusFg bit, @SelfCertFg bit, @AttributeList2AttributeId bigint,@PolicyBusinessAttributeId bigint
    
SELECT @CRMContactId2 = CRMContactId2 FROM TFactFind WHERE CRMContactId1 = @CRMContactId  
SELECT @IndigoClientId = IndClientId FROM CRM..TCRMContact WHERE CRMContactId = @CRMContactId          
SELECT @PlanType = 'Equity Release'

IF @Owner='Client 2'  
	SELECT @CRMContactId=@CRMContactId2 
-- Create the basic plan data, this will return a PolicyBusinessId      
EXEC SpNCustomCreatePlan @CRMContactId, @CRMContactId2, @CurrentUserDateTime, @Timezone, @PlanType, NULL, @PolicyNumber, @Owner, NULL, NULL, NULL, @IndigoClientId, @ProductName, @StampUser, @StartDate, @SellingAdviser, @PolicyBusinessId OUTPUT, @AgencyStatus = @AgencyStatus, @RefProdProviderId = @RefProdProviderId
    ,@PlanCurrency=@PlanCurrency      
-- Check for error.  
IF ISNULL(@PolicyBusinessId, 0) = 0 OR EXISTS (SELECT 1 FROM PolicyManagement..TMortgage WHERE PolicyBusinessId = @PolicyBusinessId)
	RAISERROR('Error occurred when adding Existing Mortgage Details', 11, 1);

--Amount released is a plan attribute and needs to be added.
SELECT @AttributeList2AttributeId = MIN(A.AttributeList2AttributeId) 
FROM PolicyManagement..TAttributeList2Attribute A WITH(NOLOCK)  
		INNER JOIN PolicyManagement..TAttributeList B WITH(NOLOCK)  
		ON A.AttributeListId=B.AttributeListId WHERE B.[Name] = 'Amount Released'

IF ISNULL(@AttributeList2AttributeId,0)!= 0
BEGIN
	INSERT PolicyManagement..TPolicyBusinessAttribute(PolicyBusinessId,AttributeList2AttributeId,AttributeValue,ConcurrencyId)
	SELECT @PolicyBusinessId,@AttributeList2AttributeId,@AmountReleased,1	
	
	SELECT @PolicyBusinessAttributeId = SCOPE_IDENTITY()
	EXEC PolicyManagement..SpNAuditPolicyBusinessAttribute @StampUser,@PolicyBusinessAttributeId,'C'
END

--Update Current Balance field
exec SpNCustomCreateOutstandingBalance @StampUser, @PolicyBusinessId, @CurrentBalance, @CurrentUserDateTime

--------------------------------------------------------------
-- Add Pension Info
--------------------------------------------------------------
EXEC [SpNCustomCreatePlanPensionInfo] @StampUser, @PolicyBusinessId, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL, NULL,
	@CrystallisationStatus, @HistoricalCrystallisedPercentage, @CurrentCrystallisedPercentage, @CrystallisedPercentage,
	@UncrystallisedPercentage, @PensionArrangement
	
-- Add the equity release details	
INSERT INTO PolicyManagement..TEquityRelease 
		(PolicyBusinessId, 
		IndigoClientId, 
		AddressStoreId, 
		RateType, 
		RefMortgageRepaymentMethodId, 
		RepaymentAmount, 
		InterestOnlyAmount, 
		LoanAmount, 
		InterestRatePercentage, 
		AssetsId, 
		InterestRate, 
		PenaltyFg, 
		RedemptionTerms, 
		PenaltyExpiryDate, 
		RefEquityReleaseTypeId, 
		PercentageOwnershipSold, 
		LumpsumAmount, 
		MonthlyIncomeAmount,
		AddressId,
		IsToBeConsolidated,
		IsLiabilityToBeRepaid,
		LiabilityRepaymentDescription)
VALUES (@PolicyBusinessId,
		@IndigoClientId,
		@AddressStoreId, 
		@RateType,
		@RepaymentMethod, 
		@RepaymentAmount, 
		@InterestOnlyAmount, 
		@LoanAmount, 
		@InterestRatePercentage, 
		@AssetsId, 
		@InterestRate, 
		@RedemptionFg, 
		@RedemptionTerms, 
		@RedemptionEndDate,
		@RefEquityReleaseTypeId, 
		@PercentageOwnershipSold, 
		@LumpsumAmount, 
		@MonthlyIncomeAmount, 
		@AddressId,
		@IsToBeConsolidated,
		@IsLiabilityToBeRepaid,
		@LiabilityRepaymentDescription)

-- Audit.        
SELECT @MortgageId = SCOPE_IDENTITY()
EXEC PolicyManagement..SpNAuditMortgage @StampUser, @MortgageId, 'C'    

IF((@SplitTemplateGroupId IS NOT NULL) AND (@SplitTemplateGroupId > 0) AND (@TemplateGroupType IS NOT NULL))
BEGIN
	EXEC [SpNCreateSplitTemplatesForPlans] @IndigoClientId,@CRMContactId, @PolicyBusinessId, @SellingAdviser,@SplitTemplateGroupId,@TemplateGroupType
END 

-- FF expects the policy business id to be returned.
SELECT @PolicyBusinessId AS 'EquityReleaseId'  
RETURN(@PolicyBusinessId)

GO

