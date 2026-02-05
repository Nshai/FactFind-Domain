SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditRetirementGoalsNeedsQuestion]
	@StampUser varchar (255),
	@RetirementGoalsNeedsQuestionId bigint,
	@StampAction char(1)
AS

INSERT INTO TRetirementGoalsNeedsQuestionAudit 
( CRMContactId, RequiredIncome, ConcurrencyId, IsThereASpecificInvestmentPreference, IsFutureMoneyAnticipated,
	RetirementGoalsNeedsQuestionId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, RequiredIncome, ConcurrencyId, IsThereASpecificInvestmentPreference, IsFutureMoneyAnticipated,
	RetirementGoalsNeedsQuestionId, @StampAction, GetDate(), @StampUser
FROM TRetirementGoalsNeedsQuestion
WHERE RetirementGoalsNeedsQuestionId = @RetirementGoalsNeedsQuestionId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
