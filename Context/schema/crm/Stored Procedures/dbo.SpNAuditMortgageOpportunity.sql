SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditMortgageOpportunity]
	@StampUser varchar (255),
	@MortgageOpportunityId bigint,
	@StampAction char(1)
AS

INSERT INTO TMortgageOpportunityAudit 
( OpportunityId, LoanPurpose, LoanAmount, LTV, 
		RefMortgageBorrowerTypeId, Term, RefMortgageRepaymentMethodId, InterestOnly, 
		Repayment, Price, Deposit, PlanPurpose, 
		CurrentLender, CurrentLoanAmount, MonthlyRentalIncome, Owner, 
		RelationshipCRMContactId, RefOpportunityEmploymentTypeId, IncomeAmount, RepaymentAmountMonthly, 
		StatusFg, SelfCertFg, NonStatusFg, ExPatFg, 
		ForeignCitizenFg, TrueCostOverTerm, ConcurrencyId, 
	MortgageOpportunityId, StampAction, StampDateTime, StampUser,SourceOfDeposit, InterestOnlyRepaymentVehicle,
	RelatedAddressStoreId,RepaymentOfExistingMortgage,HomeImprovements,MortgageFees,Other,
	GuarantorMortgageFg,GuarantorText,DebtConsolidatedFg,DebtConsolidationText,RepaymentTerm,InterestOnlyTerm, DebtConsolidation,Details, InterestDetails,
	RefMortgageSaleTypeId, IsHighNetWorthClient, IsMortgageForBusiness, IsProfessionalClient, IsRejectedAdvice, ExecutionOnlyDetails,RefOpportunityType2ProdSubTypeId, 
	IsFirstTimeBuyer, RefEquityReleaseTypeId, PercentageOwnershipSold, LumpsumAmount, MonthlyIncomeAmount, RefAdverseCreditId, CurrentLenderId,
	EquityLoanPercentage, EquityLoanAmount) 
Select OpportunityId, LoanPurpose, LoanAmount, LTV, 
		RefMortgageBorrowerTypeId, Term, RefMortgageRepaymentMethodId, InterestOnly, 
		Repayment, Price, Deposit, PlanPurpose, 
		CurrentLender, CurrentLoanAmount, MonthlyRentalIncome, Owner, 
		RelationshipCRMContactId, RefOpportunityEmploymentTypeId, IncomeAmount, RepaymentAmountMonthly, 
		StatusFg, SelfCertFg, NonStatusFg, ExPatFg, 
		ForeignCitizenFg, TrueCostOverTerm, ConcurrencyId, 
	MortgageOpportunityId, @StampAction, GetDate(), @StampUser,SourceOfDeposit, InterestOnlyRepaymentVehicle,
	RelatedAddressStoreId,RepaymentOfExistingMortgage,HomeImprovements,MortgageFees,Other,
	GuarantorMortgageFg,GuarantorText,DebtConsolidatedFg,DebtConsolidationText,RepaymentTerm,InterestOnlyTerm, DebtConsolidation,Details, InterestDetails,
	RefMortgageSaleTypeId, IsHighNetWorthClient, IsMortgageForBusiness, IsProfessionalClient, IsRejectedAdvice, ExecutionOnlyDetails,RefOpportunityType2ProdSubTypeId, 
	IsFirstTimeBuyer, RefEquityReleaseTypeId, PercentageOwnershipSold, LumpsumAmount, MonthlyIncomeAmount, RefAdverseCreditId, CurrentLenderId,
	EquityLoanPercentage, EquityLoanAmount
FROM TMortgageOpportunity
WHERE MortgageOpportunityId = @MortgageOpportunityId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
