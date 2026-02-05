SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveFinancialPlanningByFinancialPlanningId]  
 @FinancialPlanningId bigint  
AS  
  
SELECT T1.FinancialPlanningId, T1.FactFindId, T1.AdjustValue, T1.RefPlanningTypeId, T1.RefInvestmentTypeId, T1.IncludeAssets, T1.RegularImmediateIncome, T1.ConcurrencyId,  
 T2.PensionIncrease,  
 T2.SpousePercentage,   
 T2.GuaranteePeriod,  
 isnull(T2.StatePension,0) as StatePension   ,
goaltype,
RefLumpsumAtRetirementTypeId
FROM TFinancialPlanning  T1  
left join TFinancialPlanningExt T2 on T2.FinancialPlanningId = T1.FinancialPlanningId  
WHERE T1.FinancialPlanningId = @FinancialPlanningId  
GO
