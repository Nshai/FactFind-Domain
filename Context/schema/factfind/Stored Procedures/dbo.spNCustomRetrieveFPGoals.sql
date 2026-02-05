SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[spNCustomRetrieveFPGoals] @FinancialPlanningId bigint, @CRMContactId bigint, @CRMContactId2 bigint, @ObjectiveTypeId int, @goaltype int

as
        
select         
a.ObjectiveId,        
case when a.CRMContactId2 != 0 then 'Joint' else crm.Firstname end as GoalOwner,      
isnull(Objective, ' ') as Objective,        
cast(TargetAmount as varchar) as TargetAmount,        
StartDate,        
TargetDate,        
a.RegularImmediateIncome,        
ReasonForChange,        
a.CRMContactId,        
a.CRMContactId2,        
ObjectiveTypeId,        
IsFactFind,        
CASE        
       WHEN getdate() > targetdate THEN 12        
       WHEN DATEPART(day, getdate()) > DATEPART(day, targetdate) THEN DATEDIFF(month, getdate(), targetdate) - 1        
       ELSE DATEDIFF(month, getdate(), targetdate)        
END / 12  as term,        
Frequency,        
RiskProfileGuid,        
case when b.ObjectiveId is not null then 1 else 0 end as selected,    
crm.DOB as   DateOfBirth  ,  
a.GoalType,  
case   
 when a.GoalType = 2 then 'Growth with Target'  
 when a.GoalType = 4 then 'Growth without Target'  
 when a.GoalType = 3 then 'Income'  
 end as GoalTypeDescription  ,
 
a.RefLumpsumAtRetirementTypeId,  
case   
 when a.RefLumpsumAtRetirementTypeId = 1 then 'Monetary Amount'  
 when a.RefLumpsumAtRetirementTypeId = 2 then 'Percentage'  
end as LumpsumAtRetirementType,
f.RefLumpSumAtRetirementTypeId AS FPSessionRetirementGoalType
 
 
from factfind..TObjective a        
left join factfind..TFinancialPlanningSelectedGoals b on a.ObjectiveId = b.ObjectiveId and (b.FinancialPlanningId = @FinancialPlanningId) -- or @FinancialPlanningId = 0)        
inner join crm..TCRMContact crm on crm.crmcontactid = a.CRMContactId      
left join crm..TCRMContact crm2 on crm2.crmcontactid = a.CRMContactId2     

-- Selected goal type for income goals only
LEFT join TFinancialPlanning f on f.FinancialPlanningId = @FinancialPlanningId -- or @FinancialPlanningId = 0   
--LEFT JOIN TRefLumpsumAtRetirementType r ON f.RefLumpsumAtRetirementTypeId = r.RefLumpsumAtRetirementTypeId AND r.RefLumpsumAtRetirementTypeId = a.RefLumpsumAtRetirementTypeId
 
where (a.crmcontactid in(@CRMContactId,@CRMContactId2) or a.crmcontactid2 = @CRMContactId) and        
  --goal has started or is in the next year        
  startdate <= dateadd(yyyy,1,current_timestamp) and        
  --has a targetdate        
  TargetDate is not null and        
  --has a target amount if it is not Growth without target        
  (isnull(TargetAmount,0) > 0 or a.GoalType = 4) and  
  --term is greater than or equal to 3 years and less than or equal to 50 years        
  CASE        
       WHEN getdate() > targetdate THEN 12        
       WHEN DATEPART(day, getdate()) > DATEPART(day, targetdate) THEN DATEDIFF(month, getdate(), targetdate) - 1        
       ELSE DATEDIFF(month, getdate(), targetdate)        
  END / 12   between 3 and 50 and        
  IsFactFind = 1 and        
  ObjectiveTypeId = @ObjectiveTypeId and          
  @goaltype = a.GoalType 
GO
