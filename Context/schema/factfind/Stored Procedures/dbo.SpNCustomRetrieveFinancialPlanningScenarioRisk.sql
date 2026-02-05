SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create procedure [dbo].[SpNCustomRetrieveFinancialPlanningScenarioRisk]

@FinancialPlanningId bigint

as

select
FinancialPlanningId,
ScenarioId,
RiskDescription,
RiskNumber
from TFinancialPlanningScenarioRisk
where	@FinancialPlanningId  = FinancialPlanningId
order by scenarioid asc


GO
