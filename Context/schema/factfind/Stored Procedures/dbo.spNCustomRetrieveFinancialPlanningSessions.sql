SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spNCustomRetrieveFinancialPlanningSessions] @FactFindId BIGINT  
 ,@RefPlanningTypeId BIGINT  
AS  
SELECT DISTINCT fps.FinancialPlanningId  
 ,Description  
 ,Date  
 ,Description + ':' + CASE   
  WHEN RefInvestmentTypeId = 1  
   THEN 'Review Portfolio'  
  WHEN RefInvestmentTypeId = 2  
   THEN 'Invest New Money'  
  WHEN RefInvestmentTypeId = 3  
   THEN 'Review and Invest'  
  END + '-' + CASE     
  WHEN fp.goaltype = 3
   THEN CASE   
     WHEN @RefPlanningTypeId = 1
	  THEN 'Income'  
     WHEN fp.RefLumpSumAtRetirementTypeId = 1 AND @RefPlanningTypeId = 2
      THEN 'Income with Lump Sum Amount'  
     WHEN fp.RefLumpSumAtRetirementTypeId = 2 AND @RefPlanningTypeId = 2  
      THEN 'Income with Lump Sum Percentage'  
     END  
  WHEN fp.goaltype = 2  
   THEN 'Growth With Target'  
  WHEN fp.goaltype = 4  
   THEN 'Growth Without Target'  
  END + ' (' + right('00' + cast(datepart(dd, DATE) AS VARCHAR), 2) + '/' + right('00' + cast(datepart(mm, DATE) AS VARCHAR), 2) + '/' + cast(datepart(yyyy, DATE) AS VARCHAR) + ')' AS DisplayText  
 ,fp.goaltype  
FROM TFinancialPlanning fp  
INNER JOIN TFinancialPLanningSession fps ON fps.financialplanningid = fp.financialplanningid  
INNER JOIN TFInancialPLanningSelectedGoals g ON g.financialplanningid = fp.financialplanningid  
INNER JOIN TObjective o ON o.objectiveid = g.objectiveid  
 AND fp.goaltype = o.goaltype  
WHERE refplanningTypeid = @RefPlanningTypeId  
 AND fp.factfindid = @FactFindId  
 AND IsArchived = 0  
ORDER BY DATE DESC  
GO
