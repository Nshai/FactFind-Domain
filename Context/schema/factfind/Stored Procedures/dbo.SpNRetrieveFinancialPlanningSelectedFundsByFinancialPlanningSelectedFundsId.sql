SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNRetrieveFinancialPlanningSelectedFundsByFinancialPlanningSelectedFundsId]
	@FinancialPlanningSelectedFundsId bigint
AS

SELECT T1.FinancialPlanningSelectedFundsId, T1.FinancialPlanningSelectedInvestmentsId, T1.PolicyBusinessFundId, T1.IsAsset, T1.ConcurrencyId
FROM TFinancialPlanningSelectedFunds  T1
WHERE T1.FinancialPlanningSelectedFundsId = @FinancialPlanningSelectedFundsId
GO
