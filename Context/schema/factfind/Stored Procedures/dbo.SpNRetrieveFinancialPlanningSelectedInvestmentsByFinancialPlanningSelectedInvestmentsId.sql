SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNRetrieveFinancialPlanningSelectedInvestmentsByFinancialPlanningSelectedInvestmentsId]
	@FinancialPlanningSelectedInvestmentsId bigint
AS

SELECT T1.FinancialPlanningSelectedInvestmentsId, T1.FinancialPlanningId, T1.InvestmentId, T1.InvestmentType, T1.ConcurrencyId
FROM TFinancialPlanningSelectedInvestments  T1
WHERE T1.FinancialPlanningSelectedInvestmentsId = @FinancialPlanningSelectedInvestmentsId
GO
