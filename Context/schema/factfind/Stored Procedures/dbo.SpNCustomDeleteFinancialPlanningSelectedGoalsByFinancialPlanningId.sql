SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomDeleteFinancialPlanningSelectedGoalsByFinancialPlanningId]
	@FinancialPlanningId Bigint,	
	@StampUser varchar (255)
	
AS

-- Delete from TFinancialPlanningGoal too if the record exists there. -- NEW Stuff
Exec SpNCustomSyncFPGoals @FinancialPlanningId, @StampUser


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
where	FinancialPlanningId = @FinancialPlanningId

DELETE T1 FROM TFinancialPlanningSelectedGoals T1
WHERE FinancialPlanningId = @FinancialPlanningId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:

RETURN (100)
GO
