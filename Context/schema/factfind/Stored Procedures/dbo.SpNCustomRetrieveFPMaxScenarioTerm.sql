SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SpNCustomRetrieveFPMaxScenarioTerm] @FinancialPlanningId bigint as  
  
select   
max(CASE
       WHEN getdate() > targetdate THEN 12
       WHEN DATEPART(day, getdate()) > DATEPART(day, targetdate) THEN DATEDIFF(month, getdate(), targetdate) - 1
       ELSE DATEDIFF(month, getdate(), targetdate)
END / 12) as maxterm,  
max(CASE
       WHEN getdate() > targetdate THEN 12
       WHEN DATEPART(day, getdate()) > DATEPART(day, targetdate) THEN DATEDIFF(month, getdate(), targetdate) - 1
       ELSE DATEDIFF(month, getdate(), targetdate)
END / 12) as termleft  
from factfind..TObjective a  
inner join factfind..TFinancialPlanningSelectedGoals b on a.ObjectiveId = b.ObjectiveId  
where b.FinancialPlanningId = @FinancialPlanningId  
GO
