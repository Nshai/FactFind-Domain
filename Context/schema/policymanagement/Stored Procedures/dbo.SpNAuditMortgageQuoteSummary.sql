SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditMortgageQuoteSummary]
	@StampUser varchar (255),
	@MortgageQuoteSummaryId bigint,
	@StampAction char(1)
AS

INSERT INTO TMortgageQuoteSummaryAudit 
( ProductName,RefApplicationId,ApplicationTypeId,PropertyValue,LoanAmount,
Deposit,LTV,Term,QuoteId,MortgageQuoteId,ConcurrencyId,MortgageQuoteSummaryId,
StampAction,StampDateTime,StampUser,RefMortgageRepaymentMethodId,RefMortgageBorrowerTypeId,
 ProcFee,MortgageRefNo,RateType,RedemptionTerms,RedemptionCharge,IsPortable,TieInEndDate,
 LenderFees,FeesAddedToLoan,SelectedLenderName,IsSplitRepayment,InterestOnlyLoanAmount,
 MteFormCode,CanApplyViaMte,PolicyBusinessId,InterestOnlyTerm,IsFirstTimeBuyer) 
Select ProductName,RefApplicationId,ApplicationTypeId,PropertyValue,LoanAmount,
Deposit,LTV,Term,QuoteId,MortgageQuoteId,ConcurrencyId,MortgageQuoteSummaryId,
	 @StampAction, GetDate(), @StampUser,RefMortgageRepaymentMethodId,
	 RefMortgageBorrowerTypeId, ProcFee,MortgageRefNo,RateType,
	 RedemptionTerms,RedemptionCharge,IsPortable,TieInEndDate,
	 LenderFees,FeesAddedToLoan,SelectedLenderName,IsSplitRepayment,InterestOnlyLoanAmount,
	 MteFormCode,CanApplyViaMte,PolicyBusinessId,InterestOnlyTerm,IsFirstTimeBuyer
	 
FROM TMortgageQuoteSummary
WHERE MortgageQuoteSummaryId = @MortgageQuoteSummaryId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
