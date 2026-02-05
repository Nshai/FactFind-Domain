SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditMortgagePreferences]
	@StampUser varchar (255),
	@MortgagePreferencesId bigint,
	@StampAction char(1)
AS

INSERT INTO TMortgagePreferencesAudit 
(CRMContactId, likelyToChange, incomeTimescale, expenditureTimescale, redeemFg, avoidUncertainty, 
	fixingPayments, upperLimitEarly, minPaymEarly, lendingChargeFg, speed, addFeeFg, 
	varyRepaym, varyNoPenalty, overpayNoPenalty, underpay, paymHoliday, linkToAccount, 
	freeLegalFees, noValFee, valRefunded, bookingFeeFg, cashback, prefLenderFg, 
	borrowingsFg, addBorrowingsFg, freeLegalFeesImpFg, notSteppedFg, offsetFg, borrowBack, 
	creditCard, other, feesRef, portable, ConcurrencyId, LikelyToMove, 
	ExpectedMoveDate,
	MortgagePreferencesId, StampAction, StampDateTime, StampUser,HighLendingCharge,DailyInterestRates,
	ClubFeeMortgageAdvance)
SELECT  CRMContactId, likelyToChange, incomeTimescale, expenditureTimescale, redeemFg, avoidUncertainty, 
	fixingPayments, upperLimitEarly, minPaymEarly, lendingChargeFg, speed, addFeeFg, 
	varyRepaym, varyNoPenalty, overpayNoPenalty, underpay, paymHoliday, linkToAccount, 
	freeLegalFees, noValFee, valRefunded, bookingFeeFg, cashback, prefLenderFg, 
	borrowingsFg, addBorrowingsFg, freeLegalFeesImpFg, notSteppedFg, offsetFg, borrowBack, 
	creditCard, other, feesRef, portable, ConcurrencyId, LikelyToMove, 
	ExpectedMoveDate,
	MortgagePreferencesId, @StampAction, GetDate(), @StampUser,HighLendingCharge,DailyInterestRates,
	ClubFeeMortgageAdvance
FROM TMortgagePreferences
WHERE MortgagePreferencesId = @MortgagePreferencesId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
