SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomDeleteFinancialPlanningSelectedGoalsByFinancialPlanningIdAndObjectiveId]
	@FinancialPlanningId Bigint,
	@ObjectiveId Bigint, 	
	@StampUser varchar (255)
	
AS

-- Delete the financialPlanningGoal first.
Exec SpNCustomSyncFPGoals @FinancialPlanningId, @StampUser


-- Delete the selected goals that aren't selected anymore.
insert into TFinancialPlanningSelectedGoalsAudit
(
FinancialPlanningSelectedGoalsId,
FinancialPlanningId,
ObjectiveId,
ConcurrencyId,
StampAction,
StampDateTime,
StampUser
)
select
FinancialPlanningSelectedGoalsId,
FinancialPlanningId,
ObjectiveId,
ConcurrencyId,
'D',
getdate(),
@StampUser
from TFinancialPlanningSelectedGoals
where	FinancialPlanningId = @FinancialPlanningId and
		ObjectiveId = @ObjectiveId

DELETE T1 FROM TFinancialPlanningSelectedGoals T1
WHERE	FinancialPlanningId = @FinancialPlanningId and
		ObjectiveId = @ObjectiveId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:

RETURN (100)
GO
