SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[spNCustomRetrieveFinancialPlanning]  
  
@FinancialPlanningId bigint  
  
as  
  
SELECT T1.FinancialPlanningId, 
T1.FactFindId, T1.AdjustValue, 
T1.RefPlanningTypeId, 
T1.RefInvestmentTypeId,
 T1.IncludeAssets, 
 T1.RegularImmediateIncome, 
 T1.ConcurrencyId,  
 T2.PensionIncrease,  
 T2.SpousePercentage,  
 T2.GuaranteePeriod,  
 isnull(T2.StatePension,0) as StatePension,  
 T3.Description,  
 isnull(DefaultLumpSum, 0) as DefaultLumpSum,  
 isnull(DefaultMonthlyPremium, 0) as DefaultMonthlyPremium  ,
 GoalType
FROM TFinancialPlanning  T1  
left join TFinancialPlanningExt T2 on T2.FinancialPlanningId = T1.FinancialPlanningId  
inner join TFinancialplanningsession t3 on t3.financialplanningid = t1.financialplanningid  
WHERE T1.FinancialPlanningId = @FinancialPlanningId  
GO
