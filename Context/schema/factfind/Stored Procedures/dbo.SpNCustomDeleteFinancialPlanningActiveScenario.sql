SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[SpNCustomDeleteFinancialPlanningActiveScenario]

@FinancialPlanningScenarioId bigint,
@StampUser varchar(255)

as

declare @identity bigint		

select @identity = FinancialPlanningActiveScenarioId from TFinancialPlanningActiveScenario 
							where FinancialPlanningScenarioId = @FinancialPlanningScenarioId	

exec SpNAuditFinancialPlanningActiveScenario @StampUser,@identity,'D'

delete from TFinancialPlanningActiveScenario
where FinancialPlanningScenarioId = @FinancialPlanningScenarioId

GO
