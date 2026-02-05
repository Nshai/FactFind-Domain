SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNRetrieveFinancialPlanningSelectedGoalsByFinancialPlanningSelectedGoalsId]
	@FinancialPlanningSelectedGoalsId bigint
AS
    SELECT	
	T1.FinancialPlanningSelectedGoalsId, 
	T1.FinancialPlanningId, 
	T1.ObjectiveId, 
	T1.ConcurrencyId
	FROM TFinancialPlanningSelectedGoals T1
	
	WHERE T1.FinancialPlanningSelectedGoalsId = @FinancialPlanningSelectedGoalsId
GO
