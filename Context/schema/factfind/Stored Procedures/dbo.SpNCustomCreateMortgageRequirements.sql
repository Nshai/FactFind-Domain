SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SpNCustomCreateMortgageRequirements]
	@StampUser varchar (255),
	@CRMContactId int,
	@Owner varchar(16),
	@PlanPurpose varchar(50)=NULL,
	@RefMortgageBorrowerTypeId int,
	@RefMortgageRepaymentMethodId int = NULL,
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
	@RelatedAddressStoreId int=null,
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
	@RefMortgageSaleTypeId int = NULL,
    @IsHighNetWorthClient bit = NULL,
    @IsMortgageForBusiness bit = NULL,
    @IsProfessionalClient bit = NULL,
    @IsRejectedAdvice bit = NULL,
    @ExecutionOnlyDetails varchar(5000) = NULL,
	@RefOpportunityType2ProdSubTypeId int = NULL,
	@IsFirstTimeBuyer bit = NULL,
	@IsEquityRelease bit = NULL,
	@RefEquityReleaseTypeId int = NULL,
	@PercentageOwnershipSold decimal(10,2) = NULL,
	@LumpsumAmount decimal(10,2) = NULL,
	@MonthlyIncomeAmount decimal(10,2) = NULL,
	@EquityLoanAmount money = NULL,
	@EquityLoanPercentage decimal(5,2) = NULL,
	@CurrentUserDate datetime
AS
-- Declarations.
DECLARE @IndigoClientId int, @OpportunityTypeId int, @StatusHistoryID int, @MortgageOpportunityid int,
	@NextSeq varchar(50), @OpportunityId int, @InitialStatusId int, @CreatedDate datetime, @OpportunityCustomerId int,
	@CRMContactId2 int, @RequirementID int
DECLARE @PropositionTypeId int
DECLARE @RequirementType VARCHAR(100) = 'Mortgage'
DECLARE @RegulatedOpportunityType VARCHAR(100) = 'Mortgage'
DECLARE @EquityReleaseOpportunityType VARCHAR(100) = 'Equity Release'

SELECT @PropositionTypeId = 0
SELECT @CreatedDate = @CurrentUserDate

-- Update CRMContacts on the basis of the specified owner
EXEC SpNCustomUpdateCRMContactsByOwner @Owner, @CRMContactId output, @CRMContactId2 output

-- Get tenant details.
SELECT @IndigoClientId = IndClientId FROM CRM..TCRMContact WHERE CRMContactId = @CRMContactId

-- Get default status for this tenant.
SELECT @InitialStatusId = OpportunityStatusId FROM CRM..TOpportunityStatus WHERE IndigoClientId = @IndigoClientId AND InitialStatusFG = 1
IF @InitialStatusId IS NULL BEGIN
	RAISERROR('Mortgage Requirement: System Opportunity Initial Status must be configured.', 11, 1)
	RETURN
END

--If Opportunity type is Equity Release then update the requirement type
IF @IsEquityRelease IS NOT NULL AND @IsEquityRelease = 1
BEGIN
    SELECT @RequirementType = 'EquityRelease'

	SELECT @OpportunityTypeId = OpportunityTypeId 
	FROM  crm..TOpportunityType 
	WHERE IndigoClientId = @IndigoClientId
	AND	  OpportunityTypeName = @EquityReleaseOpportunityType
END
ELSE
	BEGIN
	-- Opportunity Type for mortgages is a system type and should always be present.
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
			AND   OpportunityTypeName = @RegulatedOpportunityType
		END
END

IF @OpportunityTypeId IS NULL BEGIN
	RAISERROR('Mortgage Requirement: System Opportunity Type for Mortgage must be configured.', 11, 1)
	RETURN
END	

-- Get the proposition type for this opportunity if configured.
SELECT @PropositionTypeId = PropositionTypeId from crm..TPropositionToOpportunityTypeLink where OpportunityTypeId = @OpportunityTypeId

--Add the Opportunity
INSERT INTO CRM..TOpportunity (IndigoClientId, OpportunityTypeId, CreatedDate, IsClosed, ConcurrencyId)
VALUES (@IndigoClientId, @OpportunityTypeId, @CreatedDate, 0, 1)
-- Audit
SELECT @OpportunityId = SCOPE_IDENTITY()
EXEC CRM..SpNAuditOpportunity @StampUser,@OpportunityId,'C'

-- Add Opportunity Owner
INSERT INTO CRM..TOpportunityCustomer (OpportunityId, PartyId)
VALUES (@OpportunityId, @CRMContactId)
-- Audit
SET @OpportunityCustomerId = SCOPE_IDENTITY()     
EXEC CRM..SpNAuditOpportunityCustomer @StampUser = @StampUser, @OpportunityCustomerId = @OpportunityCustomerId, @StampAction = 'C'  

-- Add 2nd Owner?
IF @CRMContactId2 IS NOT NULL
BEGIN
	INSERT INTO CRM..TOpportunityCustomer (OpportunityId, PartyId)
	VALUES (@OpportunityId, @CRMContactId2)
	-- Audit
	SET @OpportunityCustomerId = SCOPE_IDENTITY()     
	EXEC CRM..SpNAuditOpportunityCustomer @StampUser = @StampUser, @OpportunityCustomerId = @OpportunityCustomerId, @StampAction = 'C'  
END

-- Add a status record
INSERT CRM..TOpportunityStatusHistory(OpportunityId, OpportunityStatusId, DateOfChange, ChangedByUserId, CurrentStatusFG, ConcurrencyId)
SELECT @OpportunityId,@InitialStatusId,GETDATE(),@StampUser,1,1
-- Audit
SELECT @StatusHistoryID = SCOPE_IDENTITY()
EXEC CRM..SpNAuditOpportunityStatusHistory @StampUser, @StatusHistoryId, 'C'

--Create Mortgage Opportunity
INSERT CRM..TMortgageOpportunity(
	OpportunityId, PlanPurpose, LoanAmount, LTV, RefMortgageBorrowerTypeId, Term, RefMortgageRepaymentMethodId,
	InterestOnly, Repayment, Price, Deposit, CurrentLender, CurrentLoanAmount, 
	MonthlyRentalIncome, RepaymentAmountMonthly,SourceOfDeposit, InterestOnlyRepaymentVehicle,RelatedAddressStoreId,
	RepaymentOfExistingMortgage,HomeImprovements,MortgageFees,Other,
	GuarantorMortgageFg,GuarantorText,DebtConsolidatedFg,DebtConsolidationText,RepaymentTerm,InterestOnlyTerm,Details,
	RefMortgageSaleTypeId, IsHighNetWorthClient, IsMortgageForBusiness, IsProfessionalClient, IsRejectedAdvice, ExecutionOnlyDetails, 
	RefOpportunityType2ProdSubTypeId, IsFirstTimeBuyer, RefEquityReleaseTypeId, PercentageOwnershipSold, LumpsumAmount, MonthlyIncomeAmount,
	CurrentLenderId, EquityLoanPercentage, EquityLoanAmount)
SELECT 
	@OpportunityId, @PlanPurpose, @LoanAmount, @LTV, @RefMortgageBorrowerTypeId, @Term, @RefMortgageRepaymentMethodId, 
	@InterestOnly, @Repayment, @Price, @Deposit,	@CurrentLender, @CurrentLoanAmount, 
	@MonthlyRentalIncome, @RepaymentAmountMonthly,@SourceOfDeposit, @InterestOnlyRepaymentVehicle,@RelatedAddressStoreId,
	@RepaymentOfExistingMortgage,@HomeImprovements,@MortgageFees,@MROther,
	@IsGuarantorMortgage,@GuarantorText,@IsDebtConsolidated,@DebtConsolidationText,@RepaymentTerm,@InterestOnlyTerm,@Details,
	@RefMortgageSaleTypeId, @IsHighNetWorthClient, @IsMortgageForBusiness, @IsProfessionalClient, @IsRejectedAdvice, @ExecutionOnlyDetails, 
	@RefOpportunityType2ProdSubTypeId, @IsFirstTimeBuyer, @RefEquityReleaseTypeId, @PercentageOwnershipSold, @LumpsumAmount, @MonthlyIncomeAmount,
 	@CurrentLenderId, @EquityLoanPercentage, @EquityLoanAmount
SELECT @MortgageOpportunityId = SCOPE_IDENTITY()
EXEC CRM..SpNAuditMortgageOpportunity @StampUser, @MortgageOpportunityId, 'C'

--Add the Requirement
INSERT CRM..TRequirement([Type], PrimaryPartyId, SecondaryPartyId, TenantId, MortgageOpportunityId)
VALUES (@RequirementType, @CRMContactId, @CRMContactId2, @IndigoClientId, @MortgageOpportunityid)
--Audit
SELECT @RequirementID = SCOPE_IDENTITY()
EXEC CRM..SpNAuditRequirement @StampUser, @RequirementID, 'C'

-- Return details.
SELECT @MortgageOpportunityid AS MortgageRequirementsId, SequentialRef, @OpportunityId as OpportunityId
From CRM..TOpportunity
Where OpportunityId = @OpportunityId
