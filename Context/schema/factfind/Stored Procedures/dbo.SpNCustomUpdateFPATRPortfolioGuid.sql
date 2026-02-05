SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomUpdateFPATRPortfolioGuid]  
 @StampUser varchar (255),   
 @RiskProfile varchar(255),  
 @ATRPortfolioGuid uniqueidentifier ,
 @FinancialPlanningScenarioId bigint
AS  
  
  
insert into TFinancialPlanningScenarioAudit  
(FinancialPlanningId,  
Scenario,  
RetirementAge,   
InitialLumpSum,  
MonthlyContribution,  
AnnualWithdrawal,  
AnnualWithdrawalIncrease,  
RiskProfile,  
AtrPortfolioGUID,  
PODGuid,  
EvalueXML,  
PrefferedScenario,  
Active,  
ConcurrencyId,  
FinancialPlanningScenarioId,  
StampAction,  
StampDateTime,  
StampUser)  
select   
FinancialPlanningId,  
Scenario,  
RetirementAge,   
InitialLumpSum,  
MonthlyContribution,  
AnnualWithdrawal,  
AnnualWithdrawalIncrease,  
RiskProfile,  
AtrPortfolioGUID,  
PODGuid,  
EvalueXML,  
PrefferedScenario,  
Active,  
ConcurrencyId,  
FinancialPlanningScenarioId,  
'U',  
getdate(),  
'U'  
FROM TFinancialPlanningScenario T1  
WHERE  @FinancialPlanningScenarioId = FinancialPlanningScenarioId  
  
UPDATE T1  
SET T1.AtrPortfolioGUID = @ATRPortfolioGuid,  
 T1.ConcurrencyId = T1.ConcurrencyId + 1  
FROM TFinancialPlanningScenario T1  
WHERE  @FinancialPlanningScenarioId = FinancialPlanningScenarioId  
GO
