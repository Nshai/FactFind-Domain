SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpCreateMortgageOpportunity]
	@StampUser varchar (255),
	@OpportunityId bigint, 
	@LoanPurpose varchar(50)  = NULL, 
	@LoanAmount decimal (10,2)  = NULL, 
	@LTV decimal (10,2)  = NULL, 
	@RefMortgageBorrowerTypeId bigint = NULL, 
	@Term int = NULL, 
	@RefMortgageRepaymentMethodId bigint = NULL, 
	@InterestOnly decimal (10,2)  = NULL, 
	@Repayment decimal (10,2)  = NULL, 
	@Price decimal (10,2)  = NULL, 
	@Deposit decimal (10,2)  = NULL, 
	@PlanPurpose varchar(255)  = NULL, 
	@CurrentLender varchar(50)  = NULL, 
	@CurrentLoanAmount decimal (10,2)  = NULL, 
	@MonthlyRentalIncome decimal (10,2)  = NULL, 
	@Owner varchar(50)  = NULL, 
	@RelationshipCRMContactId bigint = NULL, 
	@EmploymentTypeId bigint  = NULL, 
	@IncomeAmount decimal (10,2)  = NULL, 
	@RepaymentAmountMonthly decimal (10,2)  = NULL, 
	@StatusFg bit = NULL, 
	@SelfCertFg bit = NULL, 
	@NonStatusFg bit = NULL, 
	@ExPatFg bit = NULL, 
	@ForeignCitizenFg bit = NULL, 
	@TrueCostOverTerm int = NULL	
AS

SET NOCOUNT ON

DECLARE @tx int
SELECT @tx = @@TRANCOUNT
IF @tx = 0 BEGIN TRANSACTION TX

BEGIN
	
	DECLARE @MortgageOpportunityId bigint
			
	
	INSERT INTO TMortgageOpportunity (
		OpportunityId, 
		LoanPurpose, 
		LoanAmount, 
		LTV, 
		RefMortgageBorrowerTypeId, 
		Term, 
		RefMortgageRepaymentMethodId, 
		InterestOnly, 
		Repayment, 
		Price, 
		Deposit, 
		PlanPurpose, 
		CurrentLender, 
		CurrentLoanAmount, 
		MonthlyRentalIncome, 
		Owner, 
		RelationshipCRMContactId, 
		RefOpportunityEmploymentTypeId, 
		IncomeAmount, 
		RepaymentAmountMonthly, 
		StatusFg, 
		SelfCertFg, 
		NonStatusFg, 
		ExPatFg, 
		ForeignCitizenFg, 
		TrueCostOverTerm, 
		ConcurrencyId)
		
	VALUES(
		@OpportunityId, 
		@LoanPurpose, 
		@LoanAmount, 
		@LTV, 
		@RefMortgageBorrowerTypeId, 
		@Term, 
		@RefMortgageRepaymentMethodId, 
		@InterestOnly, 
		@Repayment, 
		@Price, 
		@Deposit, 
		@PlanPurpose, 
		@CurrentLender, 
		@CurrentLoanAmount, 
		@MonthlyRentalIncome, 
		@Owner, 
		@RelationshipCRMContactId, 
		@EmploymentTypeId, 
		@IncomeAmount, 
		@RepaymentAmountMonthly, 
		@StatusFg, 
		@SelfCertFg, 
		@NonStatusFg, 
		@ExPatFg, 
		@ForeignCitizenFg, 
		@TrueCostOverTerm,
		1)

	SELECT @MortgageOpportunityId = SCOPE_IDENTITY()
	
	INSERT INTO TMortgageOpportunityAudit (
		OpportunityId, 
		LoanPurpose, 
		LoanAmount, 
		LTV, 
		RefMortgageBorrowerTypeId, 
		Term, 
		RefMortgageRepaymentMethodId, 
		InterestOnly, 
		Repayment, 
		Price, 
		Deposit, 
		PlanPurpose, 
		CurrentLender, 
		CurrentLoanAmount, 
		MonthlyRentalIncome, 
		Owner, 
		RelationshipCRMContactId, 
		EmploymentType, 
		IncomeAmount, 
		RepaymentAmountMonthly, 
		StatusFg, 
		SelfCertFg, 
		NonStatusFg, 
		ExPatFg, 
		ForeignCitizenFg, 
		TrueCostOverTerm, 
		ConcurrencyId,
		MortgageOpportunityId,
		StampAction,
    	StampDateTime,
    	StampUser)
	SELECT  
		OpportunityId, 
		LoanPurpose, 
		LoanAmount, 
		LTV, 
		RefMortgageBorrowerTypeId, 
		Term, 
		RefMortgageRepaymentMethodId, 
		InterestOnly, 
		Repayment, 
		Price, 
		Deposit, 
		PlanPurpose, 
		CurrentLender, 
		CurrentLoanAmount, 
		MonthlyRentalIncome, 
		Owner, 
		RelationshipCRMContactId, 
		RefOpportunityEmploymentTypeId, 
		IncomeAmount, 
		RepaymentAmountMonthly, 
		StatusFg, 
		SelfCertFg, 
		NonStatusFg, 
		ExPatFg, 
		ForeignCitizenFg, 
		TrueCostOverTerm, 
		ConcurrencyId,
		MortgageOpportunityId,
		'C',
    	GetDate(),
    	@StampUser
	FROM TMortgageOpportunity
	WHERE MortgageOpportunityId = @MortgageOpportunityId
	EXEC SpRetrieveMortgageOpportunityById @MortgageOpportunityId

IF @@ERROR != 0 GOTO errh
IF @tx = 0 COMMIT TRANSACTION TX

END
RETURN (0)

errh:
  IF @tx = 0 ROLLBACK TRANSACTION TX
  RETURN (100)
GO
