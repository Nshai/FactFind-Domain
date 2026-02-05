SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create PROCEDURE [dbo].[SpNAuditFinancialPlanningSelectedGoals]
	@StampUser varchar (255),
	@FinancialPlanningSelectedGoalsId bigint,
	@StampAction char(1)
AS

INSERT INTO TFinancialPlanningSelectedGoalsAudit 
( FinancialPlanningId, ObjectiveId, ConcurrencyId, 
	FinancialPlanningSelectedGoalsId, StampAction, StampDateTime, StampUser) 
Select FinancialPlanningId, ObjectiveId, ConcurrencyId, 
	FinancialPlanningSelectedGoalsId, @StampAction, GetDate(), @StampUser
FROM TFinancialPlanningSelectedGoals
WHERE FinancialPlanningSelectedGoalsId = @FinancialPlanningSelectedGoalsId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
