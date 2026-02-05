SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SpNCustomRetrieveFinancialPlanningActiveScenario]  
  
@FinancialPlanningId bigint  
  
as  
  
declare @FinancialPlanningActiveScenarioId bigint

select @FinancialPlanningActiveScenarioId = FinancialPlanningActiveScenarioId
											from TFinancialPlanningActiveScenario  
											where @FinancialPlanningId = FinancialPlanningId

if(@FinancialPlanningActiveScenarioId is null) begin

insert into TFinancialPlanningActiveScenario(FinancialPlanningId,FinancialPlanningScenarioId,ConcurrencyId)
select top 1 @FinancialPlanningId,FinancialPlanningScenarioId,1
from	TFinancialPlanningScenario
where	@FinancialPlanningId = FinancialPlanningId
order by scenario asc

select @FinancialPlanningActiveScenarioId = SCOPE_IDENTITY()

end


select   
FinancialPlanningActiveScenarioId,  
FinancialPlanningId,  
FinancialPlanningScenarioId  
 from TFinancialPlanningActiveScenario  
where @FinancialPlanningActiveScenarioId = FinancialPlanningActiveScenarioId
GO
