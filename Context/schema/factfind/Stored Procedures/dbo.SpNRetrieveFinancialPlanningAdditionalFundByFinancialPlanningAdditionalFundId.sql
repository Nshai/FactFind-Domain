SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNRetrieveFinancialPlanningAdditionalFundByFinancialPlanningAdditionalFundId]
	@FinancialPlanningAdditionalFundId bigint
AS

SELECT T1.FinancialPlanningAdditionalFundId, T1.FundId, T1.FinancialPlanningId, T1.UnitQuantity, T1.UnitPrice, T1.FundDetails, T1.ConcurrencyId
FROM TFinancialPlanningAdditionalFund  T1
WHERE T1.FinancialPlanningAdditionalFundId = @FinancialPlanningAdditionalFundId
GO
