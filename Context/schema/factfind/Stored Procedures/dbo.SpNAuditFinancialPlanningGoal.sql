SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditFinancialPlanningGoal]
	@StampUser varchar (255),
	@FinancialPlanningGoalId bigint,
	@StampAction char(1)
AS

INSERT INTO TFinancialPlanningGoalAudit 
( ObjectiveId, Objective, TargetAmount, StartDate, 
		TargetDate, RiskProfileGuid, ObjectiveTypeId, RefGoalCategoryId,
		CRMContactId, CRMContactId2, FinancialPlanningSessionId, RiskProfileId, 
		ConcurrencyId, 
	FinancialPlanningGoalId, StampAction, StampDateTime, StampUser) 
Select ObjectiveId, Objective, TargetAmount, StartDate, 
		TargetDate, RiskProfileGuid, ObjectiveTypeId, RefGoalCategoryId,
		CRMContactId, CRMContactId2, FinancialPlanningSessionId, RiskProfileId, 
		ConcurrencyId, 
	FinancialPlanningGoalId, @StampAction, GetDate(), @StampUser
FROM TFinancialPlanningGoal
WHERE FinancialPlanningGoalId = @FinancialPlanningGoalId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
