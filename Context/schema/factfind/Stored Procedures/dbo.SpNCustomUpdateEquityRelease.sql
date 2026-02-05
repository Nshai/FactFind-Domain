SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomUpdateEquityRelease]  
	@StampUser varchar(50),  
	@EquityReleaseId bigint,
	@CRMContactId bigint,
	@CurrentUserDateTime datetime,
	@Owner varchar(255) = null,  
	@SellingAdviser bigint = null,  
	@PolicyNumber varchar(50) = null,  
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
DECLARE @TenantId bigint, @MortgageEquityReleaseId bigint, @PolicyBusinessId bigint = @EquityReleaseId, @IsGuaranteed bit,
	@PolicyBusinessAttributeId bigint, @PolicyBusinessExtId bigint
  
SELECT @TenantId = IndigoClientId, @IsGuaranteed = IsGuaranteedToProtectOriginalInvestment
FROM PolicyManagement..TPolicyBusiness 
WHERE PolicyBusinessId = @PolicyBusinessId

-- Make sure TMortgage record exists
SELECT @MortgageEquityReleaseId = EquityReleaseId FROM PolicyManagement..TEquityRelease WHERE PolicyBusinessId = @PolicyBusinessId 
IF @MortgageEquityReleaseId IS NULL BEGIN
	-- Create TEquityRelease
	INSERT INTO PolicyManagement..TEquityRelease(PolicyBusinessId, IndigoClientId, PenaltyFg)
	VALUES (@PolicyBusinessId, @TenantId, 0)

	SET @EquityReleaseId = SCOPE_IDENTITY()	
	EXEC PolicyManagement..SpNAuditEquityRelease @StampUser, @MortgageEquityReleaseId, 'C'
END
   
-- Update Policy Business details
EXEC SpNCustomUpdatePlanPolicyBusiness @StampUser, @PolicyBusinessId, 
	@PolicyNumber, @StartDate, NULL, @ProductName, @IsGuaranteed, @PlanCurrency = @PlanCurrency

-- Update dnpolicymatching  
EXEC PolicyManagement..SpNCustomManageDnPolicyMatching @PolicyBusinessId, @StampUser 

--Amount released is a plan attribute and needs to be updated.
SELECT @PolicyBusinessAttributeId = PBA.PolicyBusinessAttributeId 
FROM   PolicyManagement..TPolicyBusinessAttribute PBA WITH(NOLOCK) 			
		INNER JOIN PolicyManagement..TAttributeList2Attribute ALA WITH(NOLOCK)
			ON PBA.AttributeList2AttributeId = ALA.AttributeList2AttributeId 
	    INNER JOIN PolicyManagement..TAttributeList A WITH(NOLOCK)  
			ON ALA.AttributeListId = A.AttributeListId 
WHERE  PBA.PolicyBusinessId = @PolicyBusinessId
		AND A.[Name] = 'Amount Released'

IF ISNULL(@PolicyBusinessAttributeId,0)!= 0
BEGIN
	UPDATE PolicyManagement..TPolicyBusinessAttribute
	SET    AttributeValue = @AmountReleased
	WHERE  PolicyBusinessAttributeId = @PolicyBusinessAttributeId
	
	EXEC PolicyManagement..SpNAuditPolicyBusinessAttribute @StampUser,@PolicyBusinessAttributeId,'U'
END

--Update Current Balance field
exec SpNCustomCreateOutstandingBalance @StampUser, @PolicyBusinessId, @CurrentBalance, @CurrentUserDateTime

-- Update the Mortgage  
EXEC PolicyManagement..SpNAuditMortgage @StampUser, @MortgageEquityReleaseId, 'U'

--Update Agency Status
SELECT @PolicyBusinessExtId = PBE.PolicyBusinessExtId
FROM PolicyManagement.dbo.TPolicyBusinessExt PBE
WHERE PBE.PolicyBusinessId = @PolicyBusinessId;

EXEC PolicyManagement.dbo.SpNAuditPolicyBusinessExt @StampUser, @PolicyBusinessExtId, 'U';

UPDATE PolicyManagement.dbo.TPolicyBusinessExt
SET AgencyStatus = @AgencyStatus
WHERE PolicyBusinessExtId = @PolicyBusinessExtId;

--------------------------------------------------------------
-- Update Pension Info
--------------------------------------------------------------
EXEC [SpNCustomUpdatePlanPensionInfo] @StampUser, @PolicyBusinessId, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL, NULL,
	@CrystallisationStatus, @HistoricalCrystallisedPercentage, @CurrentCrystallisedPercentage, @CrystallisedPercentage,
	@UncrystallisedPercentage, @PensionArrangement

UPDATE PolicyManagement..TEquityRelease  
SET    AddressStoreId = @AddressStoreId, 
	   RateType = @RateType, 
	   RefMortgageRepaymentMethodId = @RepaymentMethod, 
	   RepaymentAmount = @RepaymentAmount, 
	   InterestOnlyAmount = @InterestOnlyAmount, 
	   LoanAmount = @LoanAmount, 
	   InterestRatePercentage = @InterestRatePercentage, 
	   AssetsId = @AssetsId, 
	   InterestRate = @InterestRate, 
	   PenaltyFg = @RedemptionFg, 
	   RedemptionTerms = @RedemptionTerms, 
	   PenaltyExpiryDate = @RedemptionEndDate, 
	   RefEquityReleaseTypeId = @RefEquityReleaseTypeId, 
	   PercentageOwnershipSold = @PercentageOwnershipSold, 
	   LumpsumAmount = @LumpsumAmount, 
	   MonthlyIncomeAmount = @MonthlyIncomeAmount,
	   AddressId = @AddressId,
	   IsToBeConsolidated = @IsToBeConsolidated,
	   IsLiabilityToBeRepaid = @IsLiabilityToBeRepaid,
	   LiabilityRepaymentDescription = @LiabilityRepaymentDescription
WHERE 
	EquityReleaseId = @MortgageEquityReleaseId
GO