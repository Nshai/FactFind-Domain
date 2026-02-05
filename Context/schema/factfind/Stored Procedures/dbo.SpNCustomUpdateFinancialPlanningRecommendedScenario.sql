SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SpNCustomUpdateFinancialPlanningRecommendedScenario]  
  
@FinancialPlanningScenarioId bigint,  
@StampUser varchar (255),  
@FinancialPlanningId bigint,  
@RefTaxWrapperId bigint,  
@isMonthlyModelling bit  
  
as  
  
exec spNAuditFinancialPlanningScenario @StampUser,@FinancialPlanningScenarioId,'U'  
  
update TFinancialPlanningScenario  
set  
RefTaxWrapperId = 0,
RefTaxWrapperId2 = @RefTaxWrapperId,  
  IsMonthlyModelling = @isMonthlyModelling  
where FinancialPlanningScenarioId = @FinancialPlanningScenarioId  
  
  
  
GO
