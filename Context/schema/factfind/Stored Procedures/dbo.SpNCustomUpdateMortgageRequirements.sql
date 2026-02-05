SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomUpdateMortgageRequirements]  
	@StampUser varchar (255),
	@MortgageRequirementsId bigint,  
	@ConcurrencyId bigint,  
	@CRMContactId bigint,
	@Owner varchar(16), -- Not used in update
	@PlanPurpose varchar(50)=NULL,
	@RefMortgageBorrowerTypeId bigint,
	@RefMortgageRepaymentMethodId bigint = NULL,
	@RepaymentAmountMonthly decimal(10,2) = NULL,
	@Price decimal(10,2) = NULL,
	@Deposit decimal(10,2) = NULL,
	@LoanAmount decimal(10,2) = NULL,
	@LTV decimal(10,2) = NULL,
	@Term decimal(10,6) = NULL,
	@InterestOnly decimal(10,2) = NULL,
	@Repayment decimal(10,2) = NULL,
	@CurrentLender varchar(50) = NULL,
	@CurrentLenderId int = NULL,
	@CurrentLoanAmount decimal(10,2) = NULL,
	@MonthlyRentalIncome decimal(10,2) = NULL,	
	@SourceOfDeposit varchar(255)=null,
	@InterestOnlyRepaymentVehicle varchar(255)=null,
	@RelatedAddressStoreId bigint=null,
	@RepaymentOfExistingMortgage decimal(10,2) = NULL,
	@HomeImprovements decimal(10,2) = NULL,
	@MortgageFees decimal(10,2) = NULL,
	@MROther decimal(10,2) = NULL,
	@IsGuarantorMortgage bit = NULL,
	@GuarantorText varchar(5000) = NULL,
	@IsDebtConsolidated bit = NULL,
	@DebtConsolidationText varchar(5000) = NULL,
	@RepaymentTerm decimal(10,6) = NULL,
	@InterestOnlyTerm decimal(10,6) = NULL,
	@Details varchar(255) = NULL,
	@RefMortgageSaleTypeId bigint = NULL,
    @IsHighNetWorthClient bit = NULL,
    @IsMortgageForBusiness bit = NULL,
    @IsProfessionalClient bit = NULL,
    @IsRejectedAdvice bit = NULL,
    @ExecutionOnlyDetails varchar(5000) = NULL,
	@RefOpportunityType2ProdSubTypeId bigint = NULL,
	@IsFirstTimeBuyer bit = NULL,
	@IsEquityRelease bit = NULL,
	@RefEquityReleaseTypeId bigint = NULL,
	@PercentageOwnershipSold decimal(10,2) = NULL,
	@LumpsumAmount decimal(10,2) = NULL,
	@MonthlyIncomeAmount decimal(10,2) = NULL,
	@EquityLoanAmount money = NULL,
	@EquityLoanPercentage decimal(5,2) = NULL
AS  
SET NOCOUNT ON 
     
DECLARE @IndigoClientId bigint
DECLARE @OpportunityTypeId bigint = null
DECLARE @OpportunityId bigint
DECLARE @RegulatedOpportunityType VARCHAR(100) = 'Mortgage'

SELECT @IndigoClientId = IndClientId 
FROM CRM..TCRMContact 
WHERE CRMContactId = @CRMContactId

--If Opportunity type is Mortgage/Mortgage Non-Regulated, then update the same
IF (@IsEquityRelease IS NULL) OR (@IsEquityRelease IS NOT NULL AND @IsEquityRelease = 0)
BEGIN
	IF @RefOpportunityType2ProdSubTypeId IS NOT NULL
	BEGIN
		SELECT @OpportunityTypeId = OpportunityTypeId 
		FROM  crm..TRefOpportunityType2ProdSubType 
		WHERE RefOpportunityType2ProdSubTypeId = @RefOpportunityType2ProdSubTypeId 
	END
	ELSE
	BEGIN
		SELECT @OpportunityTypeId = OpportunityTypeId 
		FROM  crm..TOpportunityType 
		WHERE IndigoClientId = @IndigoClientId
				AND OpportunityTypeName = @RegulatedOpportunityType
					AND ArchiveFG = 0 
	END
END

IF @OpportunityTypeId IS NOT NULL
BEGIN
	UPDATE CRM..TOpportunity
	SET    OpportunityTypeId = @OpportunityTypeId
	FROM   CRM..TOpportunity OT
		   INNER JOIN CRM..TMortgageOpportunity TMO
			ON OT.OpportunityId = TMO.OpportunityId
	WHERE  TMO.MortgageOpportunityId = @MortgageRequirementsId
		   AND OT.IndigoClientId = @IndigoClientId

	-- Audit
	SELECT @OpportunityId = SCOPE_IDENTITY()
	EXEC CRM..SpNAuditOpportunity @StampUser,@OpportunityId,'U'
END

-- Audit
EXEC CRM..SpNAuditMortgageOpportunity @StampUser, @MortgageRequirementsId, 'U'

-- Update  
UPDATE MO
SET   
	LoanAmount = @LoanAmount,  
	LTV = @LTV,  
	RefMortgageBorrowerTypeId = @RefMortgageBorrowerTypeId,  
	Term = @Term,  
	RefMortgageRepaymentMethodId = @RefMortgageRepaymentMethodId,  
	InterestOnly = @InterestOnly,  
	Repayment = @Repayment,  
	Price = @Price,  
	Deposit = @Deposit,  
	PlanPurpose = @PlanPurpose,  
	CurrentLender = @CurrentLender,
	CurrentLenderId = @CurrentLenderId,  
	CurrentLoanAmount = @CurrentLoanAmount,  
	MonthlyRentalIncome = @MonthlyRentalIncome,  	
	RepaymentAmountMonthly = @RepaymentAmountMonthly,
	SourceOfDeposit=@SourceOfDeposit,
	InterestOnlyRepaymentVehicle = @InterestOnlyRepaymentVehicle,
	RelatedAddressStoreId = @RelatedAddressStoreId,
	RepaymentOfExistingMortgage = @RepaymentOfExistingMortgage,
	HomeImprovements =@HomeImprovements,
	MortgageFees=@MortgageFees,
	Other=@MROther,
	GuarantorMortgageFg = @IsGuarantorMortgage,
	GuarantorText = @GuarantorText,
	DebtConsolidatedFg=@IsDebtConsolidated,
	DebtConsolidationText = @DebtConsolidationText,
	RepaymentTerm =@RepaymentTerm,
	InterestOnlyTerm=@InterestOnlyTerm,
	Details = @Details,
	ConcurrencyId = ConcurrencyId + 1,
	RefMortgageSaleTypeId = @RefMortgageSaleTypeId,
    IsHighNetWorthClient = @IsHighNetWorthClient,
    IsMortgageForBusiness = @IsMortgageForBusiness,
    IsProfessionalClient = @IsProfessionalClient,
    IsRejectedAdvice = @IsRejectedAdvice,
    ExecutionOnlyDetails = @ExecutionOnlyDetails,
	RefOpportunityType2ProdSubTypeId = @RefOpportunityType2ProdSubTypeId,
	IsFirstTimeBuyer = @IsFirstTimeBuyer,
	RefEquityReleaseTypeId = @RefEquityReleaseTypeId,
	PercentageOwnershipSold = @PercentageOwnershipSold,
	LumpsumAmount = @LumpsumAmount,
	MonthlyIncomeAmount = @MonthlyIncomeAmount,
	EquityLoanPercentage = @EquityLoanPercentage,
	EquityLoanAmount = @EquityLoanAmount
FROM CRM..TMortgageOpportunity MO
WHERE MortgageOpportunityId = @MortgageRequirementsId
GO
