SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveAtRetirementIncomeGoalsTypeByFinancialPlanningId]        
 @FinancialPlanningId Bigint        
         
AS        
        
select top 1 fpsg.FinancialPlanningSelectedGoalsId, fpsg.FinancialPLanningId, o.ObjectiveId, Objective, 
LumpSumAtRetirement As AtRetirementPercentageOrValue,         
o.RefLumpsumAtRetirementTypeId AS RefLumpsumAtRetirementTypeId,
datediff(yyyy,(case when o.startdate < getdate() then getdate() else o.startdate end),targetdate) as term,        
1 as LumpSumAtEnd,        
RiskProfileGuid,        
RiskNumber,      
CRMContactId,       
isnull(CRMContactId2,0) as   CRMContactId2    

from TFinancialPlanningSelectedGoals  fpsg        
inner join TObjective o on o.objectiveid = fpsg.objectiveid        
inner join TFinancialPlanning fp on fp.financialplanningid = fpsg.financialplanningid        
left join policymanagement..TRiskProfileCombined rp on  RiskProfileGuid = rp.guid     
   
where fpsg.financialplanningid = @FinancialPlanningId and o.goaltype = fp.goaltype and        
  o.LumpSumAtRetirement > 0 
  --AND o.RefLumpsumAtRetirementTypeId = 2  -- Percentage
  AND ObjectiveTypeId  = 2 -- Pension
  
 order by LumpSumAtRetirement desc


 -- Call up the Sync SP to Sync FP data with AdvisaCenta table.
Exec SpNCustomSyncFPGoals @FinancialPlanningId, 0


GO
