SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SpNAuditFinancialPlanningScenario]
	@StampUser varchar (255),
	@FinancialPlanningScenarioId bigint,
	@StampAction char(1)
AS

INSERT INTO TFinancialPlanningScenarioAudit 
(FinancialPlanningId, Scenario, ScenarioName, RetirementAge, InitialLumpSum, MonthlyContribution, AnnualWithdrawal,AnnualWithdrawalIncrease, RiskProfile, AtrPortfolioGUID,
	PODGuid, EvalueXML, PrefferedScenario, Active, IsMonthlyModelling,
RebalanceInvestments,
RefTaxWrapperId,
AnnualWithdrawalPercent,
StartDate,
TargetDate, RiskProfileId, ProposedSolutionGoalId, ProposalStatus, InitialFeePercentage, OngoingFeePercentage, CreatedDate,
ConcurrencyId,
	FinancialPlanningScenarioId, StampAction, StampDateTime, StampUser)
SELECT  FinancialPlanningId, Scenario,ScenarioName, RetirementAge, InitialLumpSum, MonthlyContribution, AnnualWithdrawal,AnnualWithdrawalIncrease, RiskProfile, AtrPortfolioGUID,
	PODGuid, EvalueXML, PrefferedScenario, Active, IsMonthlyModelling,
RebalanceInvestments,
RefTaxWrapperId,
AnnualWithdrawalPercent,
StartDate,
TargetDate, RiskProfileId, ProposedSolutionGoalId, ProposalStatus, InitialFeePercentage, OngoingFeePercentage, CreatedDate,
ConcurrencyId,
	FinancialPlanningScenarioId, @StampAction, GetDate(), @StampUser
FROM TFinancialPlanningScenario
WHERE FinancialPlanningScenarioId = @FinancialPlanningScenarioId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)



GO
