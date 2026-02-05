SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomUpdateFinancialPlanningScenario]
	@FinancialPlanningScenarioId Bigint,	
	@StampUser varchar (255),
	@FinancialPlanningId bigint, 
	@Scenario char(1) , 
	@ScenarioName varchar(255) = '', 
	@RebalanceInvestments	bit = 0,
	@RefTaxWrapperId int = 0,
	@RefTaxWrapperId2 int = 0,
	@RetirementAge int, 
	@InitialLumpSum money = NULL, 
	@InitialLumpSum2 money = NULL, 
	@MonthlyContribution money = NULL, 
	@MonthlyContribution2 money = NULL, 
	@AnnualWithdrawal money = NULL, 
	@AnnualWithdrawal2 money = NULL, 
	@AnnualWithdrawalPercent decimal(18,2) = 0,
	@AnnualWithdrawalPercent2 decimal(18,2) = 0,
	@AnnualWithdrawalIncrease varchar(50) = null, 
	@AnnualWithdrawalIncrease2 varchar(50) = null, 
	@RiskProfile uniqueidentifier = NULL, 
	@AtrPortfolio uniqueidentifier = NULL, 
	@PODGuid uniqueidentifier  = NULL, 
	@EvalueXML xml  = NULL, 
	@PrefferedScenario bit, 
	@Active bit,
	@StartDate datetime  = NULL,
	@TargetDate datetime  = NULL

AS


Declare @Result int
Execute @Result = dbo.SpNAuditFinancialPlanningScenario @StampUser, @FinancialPlanningScenarioId, 'U'

IF @Result  != 0 GOTO errh


UPDATE T1
SET T1.FinancialPlanningId = @FinancialPlanningId, T1.Scenario = @Scenario,T1.ScenarioName = @ScenarioName, 
T1.RebalanceInvestments = @RebalanceInvestments,
T1.RefTaxWrapperId = @RefTaxWrapperId,
T1.RefTaxWrapperId2 = @RefTaxWrapperId2,
T1.StartDate = @StartDate,
T1.TargetDate = @TargetDate,
T1.RetirementAge = @RetirementAge , 
T1.InitialLumpSum = @InitialLumpSum, 
T1.MonthlyContribution = @MonthlyContribution, 
T1.AnnualWithdrawal = @AnnualWithdrawal, 
T1.AnnualWithdrawalPercent = @AnnualWithdrawalPercent,
T1.AnnualWithdrawalIncrease = @AnnualWithdrawalIncrease, 
T1.InitialLumpSum2 = @InitialLumpSum2, 
T1.MonthlyContribution2 = @MonthlyContribution2, 
T1.AnnualWithdrawal2 = @AnnualWithdrawal2, 
T1.AnnualWithdrawalPercent2 = @AnnualWithdrawalPercent2,
T1.AnnualWithdrawalIncrease2 = @AnnualWithdrawalIncrease2, 
T1.RiskProfile = @RiskProfile, T1.AtrPortfolioGUID = @AtrPortfolio,
	T1.PODGuid = @PODGuid, T1.EvalueXML = @EvalueXML, 
	--T1.PrefferedScenario = @PrefferedScenario, 
	T1.Active = @Active, T1.ConcurrencyId = T1.ConcurrencyId + 1
FROM TFinancialPlanningScenario T1
WHERE  T1.FinancialPlanningScenarioId = @FinancialPlanningScenarioId --And T1.ConcurrencyId = @ConcurrencyId

--update the link between the scenario and the selected Investment
--exec SpNUpdateFinancialPlanningScenario2InvestmentByFinancialPlanningScenarioId @StampUser,@FinancialPlanningScenarioId,@SelectedInvestmentId,@SelectedInvestmentType

--update active financialplanningid
exec SpNCustomCreateFinancialPlanningActiveScenario @FinancialPlanningId,@FinancialPlanningScenarioId,@StampUser

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)

GO
