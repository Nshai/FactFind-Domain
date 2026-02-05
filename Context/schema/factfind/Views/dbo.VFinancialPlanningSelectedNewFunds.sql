SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
	
CREATE VIEW dbo.VFinancialPlanningSelectedNewFunds

AS

	SELECT 
		b.FinancialPlanningSelectedFundsRevisedId,
		fu.FundUnitId,
		a.FinancialPlanningId,
		b.RevisedPercentage AS AllocationPercentage,
		b.FinancialPlanningSelectedFundsId
	FROM 
		TFinancialPlanningAdditionalFund a
		JOIN Fund2..TFundUnit fu ON fu.FundUnitId = a.fundid
		JOIN Fund2..TFund f ON f.fundid = fu.fundid
		JOIN TFinancialPlanningSelectedFundsRevised b ON b.policybusinessfundid = '999000' + cast(FinancialPlanningAdditionalFundId as varchar)
		
GO
