SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditFinancialPlanningScenarioReportDetail]
	@StampUser varchar (255),
	@FinancialPlanningScenarioReportDetailId bigint,
	@StampAction char(1)
AS

INSERT INTO TFinancialPlanningScenarioReportDetailAudit 
(FinancialPlanningId, FinancialPlanningScenarioId, IsRebalance, StartDate, TargetDate, TaxWrapper, 
	InitialLumpSum, MonthlyContribution, AnnualWithdrawal, AnnualWithdrawalPercent, AnnualWithdrawalIncrease,IsFinal, ConcurrencyId,
	FinancialPlanningScenarioReportDetailId, StampAction, StampDateTime, StampUser)
SELECT  FinancialPlanningId, FinancialPlanningScenarioId, IsRebalance, StartDate, TargetDate, TaxWrapper, 
	InitialLumpSum, MonthlyContribution, AnnualWithdrawal, AnnualWithdrawalPercent, AnnualWithdrawalIncrease,IsFinal, ConcurrencyId,
	FinancialPlanningScenarioReportDetailId, @StampAction, GetDate(), @StampUser
FROM TFinancialPlanningScenarioReportDetail
WHERE FinancialPlanningScenarioReportDetailId = @FinancialPlanningScenarioReportDetailId

IF @@ERROR != 0 GOTO errh

RETURN (0)

errh:
RETURN (100)
GO
