SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveFinancialPlanningSelectedGoalsByFinancialPlanningId]        
 @FinancialPlanningId Bigint        
         
AS        
        
select  fpsg.FinancialPlanningSelectedGoalsId, fpsg.FinancialPLanningId, o.ObjectiveId, 
isnull(Objective, ' ') as Objective, 
isnull(TargetAmount,0) as TargetAmount,         
datediff(yyyy,(case when o.startdate < getdate() then getdate() else o.startdate end),targetdate) as term,        
0 as LumpSumAtEnd,        
RiskProfileGuid,        
RiskNumber ,      
CRMContactId,       
isnull(CRMContactId2,0) as   CRMContactId2    
from TFinancialPlanningSelectedGoals  fpsg        
inner join TObjective o on o.objectiveid = fpsg.objectiveid        
inner join TFinancialPlanning fp on fp.financialplanningid = fpsg.financialplanningid        
left join policymanagement..TRiskProfileCombined rp on  RiskProfileGuid = rp.guid        
where fpsg.financialplanningid = @FinancialPlanningId and o.goaltype = fp.goaltype        


-- Call up the Sync SP to Sync FP data with AdvisaCenta table.
Exec SpNCustomSyncFPGoals @FinancialPlanningId, 0


GO
