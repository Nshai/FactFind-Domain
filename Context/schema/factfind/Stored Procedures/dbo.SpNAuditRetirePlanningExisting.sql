SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditRetirePlanningExisting]
	@StampUser varchar (255),
	@RetirePlanningExistingId bigint,
	@StampAction char(1)
AS

INSERT INTO TRetirePlanningExistingAudit 
( CRMContactId, RetirementPlanningObjectives, CurrentPensionArrangements, PlanTypes, 
		ConcurrencyId, 
	RetirePlanningExistingId, StampAction, StampDateTime, StampUser) 
Select CRMContactId, RetirementPlanningObjectives, CurrentPensionArrangements, PlanTypes, 
		ConcurrencyId, 
	RetirePlanningExistingId, @StampAction, GetDate(), @StampUser
FROM TRetirePlanningExisting
WHERE RetirePlanningExistingId = @RetirePlanningExistingId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
