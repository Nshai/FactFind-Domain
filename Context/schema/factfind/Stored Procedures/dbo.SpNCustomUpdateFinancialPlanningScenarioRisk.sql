SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SpNCustomUpdateFinancialPlanningScenarioRisk]   
            @FinancialPlanningId bigint,  
            @RiskProfile uniqueidentifier,  
            @AtrPortfolioGUID uniqueidentifier,  
            @StampUser varchar(255)
as  
  

--update the recommended risk profile  
insert into TFinancialPlanningScenarioAudit
(FinancialPlanningId,
Scenario,
RiskProfile,
AtrPortfolioGUID,
FinancialPlanningScenarioId,
StampAction,
StampDateTime,
StampUser,
PrefferedScenario,
active)
select 
FinancialPlanningId,
Scenario,
RiskProfile,
AtrPortfolioGUID,
FinancialPlanningScenarioId,
'U',
getdate(),
@StampUser,
PrefferedScenario,
active
from TFinancialPlanningScenario
where   @FinancialPlanningId = FinancialPlanningId   
and isreadonly = 0

update      TFinancialPlanningScenario  
set         RiskProfile = @RiskProfile,  
            AtrPortfolioGUID = @AtrPortfolioGUID  
where   @FinancialPlanningId = FinancialPlanningId    
and isreadonly = 0                    
GO
