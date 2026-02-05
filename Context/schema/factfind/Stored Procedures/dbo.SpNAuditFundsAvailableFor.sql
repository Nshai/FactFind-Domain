SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditFundsAvailableFor]
	@StampUser varchar (255),
	@FundsAvailableForId bigint,
	@StampAction char(1)
AS

INSERT INTO TFundsAvailableForAudit 
( CRMContactId, LumpSum, MonthlySum, DoYouWantAccessToFunds, 
		WhenAreTheFunds, HowLong, FurtherFundsAnticipated, FurtherFundsAnticipatedAmount, 
		InvestmentRestrictions, InvestmentRestrictionsNote, Notes, ConcurrencyId, SourceOfInvestmentFunds,
		
	FundsAvailableForId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, LumpSum, MonthlySum, DoYouWantAccessToFunds, 
		WhenAreTheFunds, HowLong, FurtherFundsAnticipated, FurtherFundsAnticipatedAmount, 
		InvestmentRestrictions, InvestmentRestrictionsNote, Notes, ConcurrencyId, SourceOfInvestmentFunds,
		
	FundsAvailableForId, @StampAction, GetDate(), @StampUser
FROM TFundsAvailableFor
WHERE FundsAvailableForId = @FundsAvailableForId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)


GO
