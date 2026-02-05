SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].SpNCustomRetrieveFPDateRange @FinancialPlanningId bigint as

select 
min(StartDate) as StartDate,
max(TargetDate) as TargetDate
from factfind..TObjective a
inner join factfind..TFinancialPlanningSelectedGoals b on a.ObjectiveId = b.ObjectiveId
where	b.FinancialPlanningId = @FinancialPlanningId

GO
