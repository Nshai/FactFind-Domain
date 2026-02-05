SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[SpNCustomUpdateFinancialPlanningRecommendedRisk] 
		@FinancialPlanningScenarioId bigint,
		@RiskProfile uniqueidentifier,
		@AtrPortfolioGUID uniqueidentifier,
		@StampUser varchar(255)
as

--update the recommended risk profile
exec spNAuditFinancialPlanningScenario @StampUser,@FinancialPlanningScenarioId,'U'


update	TFinancialPlanningScenario
set		RiskProfile = @RiskProfile,
		AtrPortfolioGUID = @AtrPortfolioGUID
where   @FinancialPlanningScenarioId = FinancialPlanningScenarioId  
			

GO
