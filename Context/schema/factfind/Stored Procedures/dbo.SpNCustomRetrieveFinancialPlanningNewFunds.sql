SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  PROCEDURE [dbo].[SpNCustomRetrieveFinancialPlanningNewFunds]
	@FinancialPlanningId bigint
AS

select  a.FundId,
		b.policybusinessfundid		,
		Name,
		cast(revisedvalue as varchar) as BuySell,
		FundDetails,
		RevisedPercentage as Percentage
from TFinancialPlanningAdditionalFund a
left join fund2..TFundUnit fu on fu.FundUnitId = a.fundid
left join fund2..TFund f on f.fundid = fu.fundid
left join TFinancialPLanningSelectedFundsRevised b on b.policybusinessfundid = '999000' + cast(FinancialPlanningAdditionalFundId as varchar)
where a.FinancialPLanningId = @FinancialPlanningId	and
		IsExecuted = 0
GO
