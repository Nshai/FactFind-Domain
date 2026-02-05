SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[spNDeleteFinancialPlanningScenarioAssetAllocation]  
@FinancialPlanningId bigint,  
@ScenarioId bigint,  
@IsFinal bit  
  
as  
  
delete from TFinancialPlanningScenarioAllocation  
where FinancialPlanningId = @FinancialPlanningId and  
  ScenarioId = @ScenarioId and  
  isnull(IsFinal,0) = @IsFinal  
  
if(@IsFinal = 1)
	delete from TFinancialPlanningScenarioAllocation  
	where FinancialPlanningId = @FinancialPlanningId and  
	ScenarioId != 0 and  
	isnull(IsFinal,0) = 1
GO
