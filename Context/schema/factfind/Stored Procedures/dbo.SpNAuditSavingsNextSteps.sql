SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditSavingsNextSteps]
	@StampUser varchar (255),
	@SavingsNextStepsId bigint,
	@StampAction char(1)
AS

INSERT INTO TSavingsNextStepsAudit 
( CRMContactId, NextSteps, ConcurrencyId, 
	SavingsNextStepsId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, NextSteps, ConcurrencyId, 
	SavingsNextStepsId, @StampAction, GetDate(), @StampUser
FROM TSavingsNextSteps
WHERE SavingsNextStepsId = @SavingsNextStepsId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
