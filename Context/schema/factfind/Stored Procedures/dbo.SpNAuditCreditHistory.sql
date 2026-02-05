SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditCreditHistory]
	@StampUser varchar (255),
	@CreditHistoryId bigint,
	@StampAction char(1)
AS

INSERT INTO TCreditHistoryAudit 
(ConcurrencyId, CRMContactId, Owner, Type, DateRegistered, DateDischarged, DateRepossessed, DateSatisfied, AmountRegistered, AmountOutstanding, 
	NumberOfPaymentsMissed, NumberOfPaymentsInArrears, AreArrearsClearedUponCompletion, IsDebtOutstanding, IsIvaCurrent, 
	YearsMaintained, Lender,
	CreditHistoryId, StampAction, StampDateTime, StampUser, LiabilitiesId)
SELECT  ConcurrencyId, CRMContactId, Owner, Type, DateRegistered, DateDischarged, DateRepossessed, DateSatisfied, AmountRegistered, AmountOutstanding,
	NumberOfPaymentsMissed, NumberOfPaymentsInArrears, AreArrearsClearedUponCompletion, IsDebtOutstanding, IsIvaCurrent, 
	YearsMaintained, Lender,
	CreditHistoryId, @StampAction, GetDate(), @StampUser, LiabilitiesId
FROM TCreditHistory
WHERE CreditHistoryId = @CreditHistoryId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
