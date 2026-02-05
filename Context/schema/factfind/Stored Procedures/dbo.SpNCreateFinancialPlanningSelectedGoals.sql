SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCreateFinancialPlanningSelectedGoals]
	@StampUser varchar (255),
	@FinancialPlanningId bigint, 
	@ObjectiveId bigint	
AS

declare @Result int, @FinancialPlanningSelectedGoalsId int
	
INSERT INTO TFinancialPlanningSelectedGoals
(FinancialPlanningId, ObjectiveId, ConcurrencyId)
VALUES(@FinancialPlanningId, @ObjectiveId, 1)

SELECT @FinancialPlanningSelectedGoalsId = SCOPE_IDENTITY(), @Result = @@ERROR
IF @Result != 0 GOTO errh


Execute @Result = dbo.SpNAuditFinancialPlanningSelectedGoals @StampUser, @FinancialPlanningSelectedGoalsId, 'C'

 -- Call up the Sync SP to Sync FP data with AdvisaCenta table.
Exec SpNCustomSyncFPGoals @FinancialPlanningId, @StampUser

IF @Result  != 0 GOTO errh

Execute dbo.SpNRetrieveFinancialPlanningSelectedGoalsByFinancialPlanningSelectedGoalsId @FinancialPlanningSelectedGoalsId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
