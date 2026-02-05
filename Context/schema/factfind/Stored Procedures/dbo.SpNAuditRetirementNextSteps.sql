SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRetirementNextSteps]
	@StampUser varchar (255),
	@RetirementNextStepsId bigint,
	@StampAction char(1)
AS

INSERT INTO TRetirementNextStepsAudit 
( CRMContactId, NextSteps, ConcurrencyId, 
	RetirementNextStepsId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, NextSteps, ConcurrencyId, 
	RetirementNextStepsId, @StampAction, GetDate(), @StampUser
FROM TRetirementNextSteps
WHERE RetirementNextStepsId = @RetirementNextStepsId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
