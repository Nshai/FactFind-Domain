SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditMortgageQuoteResult]
	@StampUser varchar (255),
	@MortgageQuoteResultId bigint,
	@StampAction char(1)
AS

INSERT INTO TMortgageQuoteResultAudit 
	(QuoteItemId, InitialMonthlyAmount, InitialInterestRate, ReviosnaryRate,
	ProductType, Duration, EarlyRepaymentCharge, TrueCostofMortgage, 
	TrueCostTerm, BookingFeeAmount, CompletionFeeAmount, HLCAmount,
	ConcurrencyId, MortgageQuoteResultId, StampAction, StampDateTime, StampUser,DurationDescription,Position,HasKfi)

Select QuoteItemId, InitialMonthlyAmount, InitialInterestRate, ReviosnaryRate,
	ProductType, Duration, EarlyRepaymentCharge, TrueCostofMortgage, 
	TrueCostTerm, BookingFeeAmount, CompletionFeeAmount, HLCAmount,
	ConcurrencyId, MortgageQuoteResultId, @StampAction, GetDate(), @StampUser,DurationDescription,Position,HasKfi
FROM TMortgageQuoteResult
WHERE MortgageQuoteResultId = @MortgageQuoteResultId

IF @@ERROR != 0 GOTO errh
RETURN (0)

errh:
RETURN (100)
GO
