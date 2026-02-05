SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_SpCustomDeleteOpportunity]
	@OpportunityId Bigint,
	@StampUser varchar (255)
AS

DECLARE @StampDateTime datetime = GETDATE()
DECLARE @RequirementId int
DECLARE @Result int

--Delete Requirement (If Exists)
SELECT	@RequirementId = r.RequirementId 
FROM	TRequirement r JOIN	TMortgageOpportunity m ON r.MortgageOpportunityId = m.MortgageOpportunityId
WHERE	m.OpportunityId = @OpportunityId

IF (@RequirementId IS NOT NULL) BEGIN
    --Write to audit table
	Execute @Result = dbo.SpNAuditRequirement @StampUser, @RequirementId, 'D'
	IF @@ERROR != 0 GOTO errh
	--Delete requirement
	DELETE	FROM TRequirement WHERE RequirementId = @RequirementId
	IF @@ERROR != 0 GOTO errh
END

--Delete OpportunityCustomer
DELETE FROM TOpportunityCustomer
OUTPUT deleted.OpportunityId, deleted.PartyId, deleted.ConcurrencyId, deleted.OpportunityCustomerId, 'D', @StampDateTime, @StampUser
INTO TOpportunityCustomerAudit (OpportunityId, PartyId, ConcurrencyId, OpportunityCustomerId,StampAction, StampDateTime, StampUser)
WHERE OpportunityId = @OpportunityId

IF @@ERROR != 0 GOTO errh

--Delete MortgageOpportunity
DELETE FROM TMortgageOpportunity
OUTPUT deleted.OpportunityId, deleted.LoanPurpose, deleted.LoanAmount, deleted.LTV, deleted.RefMortgageBorrowerTypeId, deleted.Term, deleted.RefMortgageRepaymentMethodId, deleted.InterestOnly
      ,deleted.Repayment, deleted.Price, deleted.Deposit, deleted.PlanPurpose, deleted.CurrentLender, deleted.CurrentLoanAmount, deleted.MonthlyRentalIncome, deleted.[Owner], deleted.RelationshipCRMContactId
      ,deleted.EmploymentType, deleted.IncomeAmount, deleted.RepaymentAmountMonthly, deleted.StatusFg, deleted.SelfCertFg, deleted.NonStatusFg, deleted.ExPatFg, deleted.ForeignCitizenFg, deleted.TrueCostOverTerm
      ,deleted.ConcurrencyId, deleted.MortgageOpportunityId, 'D', @StampDateTime, @StampUser, deleted.SourceOfDeposit, deleted.InterestOnlyRepaymentVehicle, deleted.RelatedAddressStoreId, deleted.RepaymentOfExistingMortgage, deleted.HomeImprovements
	  ,deleted.MortgageFees, deleted.Other, deleted.GuarantorMortgageFg, deleted.GuarantorText, deleted.DebtConsolidatedFg, deleted.DebtConsolidationText, deleted.RepaymentTerm, deleted.InterestOnlyTerm, deleted.DebtConsolidation
      ,deleted.Details, deleted.InterestDetails, deleted.RefMortgageSaleTypeId, deleted.IsHighNetWorthClient, deleted.IsMortgageForBusiness, deleted.IsProfessionalClient, deleted.IsRejectedAdvice
      ,deleted.ExecutionOnlyDetails, deleted.RefOpportunityType2ProdSubTypeId, deleted.IsFirstTimeBuyer, deleted.RefEquityReleaseTypeId, deleted.PercentageOwnershipSold, deleted.LumpsumAmount
      ,deleted.MonthlyIncomeAmount, deleted.RefAdverseCreditId, deleted.RefOpportunityEmploymentTypeId
INTO TMortgageOpportunityAudit (OpportunityId, LoanPurpose, LoanAmount, LTV, RefMortgageBorrowerTypeId, Term, RefMortgageRepaymentMethodId, InterestOnly
      ,Repayment, Price, Deposit, PlanPurpose, CurrentLender, CurrentLoanAmount, MonthlyRentalIncome, [Owner], RelationshipCRMContactId
      ,EmploymentType, IncomeAmount, RepaymentAmountMonthly, StatusFg, SelfCertFg, NonStatusFg, ExPatFg, ForeignCitizenFg, TrueCostOverTerm
      ,ConcurrencyId, MortgageOpportunityId, StampAction, StampDateTime, StampUser, SourceOfDeposit, InterestOnlyRepaymentVehicle, RelatedAddressStoreId, RepaymentOfExistingMortgage, HomeImprovements
	  ,MortgageFees, Other, GuarantorMortgageFg, GuarantorText, DebtConsolidatedFg, DebtConsolidationText, RepaymentTerm, InterestOnlyTerm, DebtConsolidation
      ,Details, InterestDetails, RefMortgageSaleTypeId, IsHighNetWorthClient, IsMortgageForBusiness, IsProfessionalClient, IsRejectedAdvice
      ,ExecutionOnlyDetails, RefOpportunityType2ProdSubTypeId, IsFirstTimeBuyer, RefEquityReleaseTypeId, PercentageOwnershipSold, LumpsumAmount
      ,MonthlyIncomeAmount, RefAdverseCreditId, RefOpportunityEmploymentTypeId)
WHERE OpportunityId = @OpportunityId

IF @@ERROR != 0 GOTO errh

-- Delete OpportunityStatusHistory
DELETE FROM TOpportunityStatusHistory
OUTPUT deleted.OpportunityId, deleted.OpportunityStatusId, deleted.DateOfChange, deleted.ChangedByUserId, deleted.CurrentStatusFG, deleted.ConcurrencyId, deleted.OpportunityStatusHistoryId, 'D', @StampDateTime, @StampUser
INTO TOpportunityStatusHistoryAudit (OpportunityId, OpportunityStatusId, DateOfChange, ChangedByUserId, CurrentStatusFG, ConcurrencyId, OpportunityStatusHistoryId, StampAction, StampDateTime, StampUser)
WHERE OpportunityId = @OpportunityId

IF @@ERROR != 0 GOTO errh

Execute @Result = dbo.SpNAuditOpportunity @StampUser, @OpportunityId, 'D'

IF @@ERROR  != 0 GOTO errh

DELETE 
FROM TOpportunity
WHERE OpportunityId = @OpportunityId

IF @@ERROR != 0 GOTO errh

SELECT 1

errh:

RETURN (100)
GO