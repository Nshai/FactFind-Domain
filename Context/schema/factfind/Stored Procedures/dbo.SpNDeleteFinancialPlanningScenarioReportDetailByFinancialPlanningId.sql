SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNDeleteFinancialPlanningScenarioReportDetailByFinancialPlanningId]
	@FinancialPlanningId Bigint,
	@IsFinal bit,	
	@StampUser varchar (255)
	
AS

insert into TFinancialPlanningScenarioReportDetailAudit
(FinancialPlanningId,
FinancialPlanningScenarioId,
IsRebalance,
StartDate,
TargetDate,
TaxWrapper,
InitialLumpSum,
MonthlyContribution,
AnnualWithdrawal,
AnnualWithdrawalPercent,
AnnualWithdrawalIncrease,
IsFinal,
ConcurrencyId,
FinancialPlanningScenarioReportDetailId,
StampAction,
StampDateTime,
StampUser)
select
FinancialPlanningId,
FinancialPlanningScenarioId,
IsRebalance,
StartDate,
TargetDate,
TaxWrapper,
InitialLumpSum,
MonthlyContribution,
AnnualWithdrawal,
AnnualWithdrawalPercent,
AnnualWithdrawalIncrease,
IsFinal,
ConcurrencyId,
FinancialPlanningScenarioReportDetailId,
'D',
getdate(),
@StampUser
FROM TFinancialPlanningScenarioReportDetail
WHERE FinancialPlanningId = @FinancialPlanningId

DELETE FROM TFinancialPlanningScenarioReportDetail
WHERE FinancialPlanningId = @FinancialPlanningId and
		isnull(IsFinal,0) = @IsFinal

GO
