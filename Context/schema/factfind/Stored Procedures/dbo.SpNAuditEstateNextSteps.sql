SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditEstateNextSteps]
	@StampUser varchar (255),
	@EstateNextStepsId bigint,
	@StampAction char(1)
AS

INSERT INTO TEstateNextStepsAudit 
( CRMContactId, NextSteps, ConcurrencyId, 
	EstateNextStepsId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, NextSteps, ConcurrencyId, 
	EstateNextStepsId, @StampAction, GetDate(), @StampUser
FROM TEstateNextSteps
WHERE EstateNextStepsId = @EstateNextStepsId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
