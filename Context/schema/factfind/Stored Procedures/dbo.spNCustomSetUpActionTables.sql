SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[spNCustomSetUpActionTables]       
      
@FinancialPlanningId bigint,      
@ScenarioId bigint      
      
as      
      
--add all the plans and funds included for this fp/scenario combo if not already in        
insert into TActionPlan      
(      
FinancialPlanningId,      
ScenarioId,      
Owner1,      
Owner2,      
RefPlan2ProdSubTypeId,      
refplantypeid,  
PercentageAllocation,      
PolicyBusinessId  ,    
Contribution,    
Withdrawal,
RevisedValueDifferenceAmount,
RevisedPercentage    
)      
select       
FinancialPlanningId,      
@ScenarioId,      
0,      
0,      
0,      
0,     
-99,      
InvestmentId,    
0,    
0,
0,
-99 
from TFinancialPlanningSelectedInvestments a      
where InvestmentType != 'asset' and      
  financialplanningid = @FinancialPlanningId and      
  isnull(InvestmentId,0) > 0 and  
  not exists (select 1 from TActionPlan b       
     where b.ScenarioId = @ScenarioId and       
       b.FinancialPlanningId = @FinancialPlanningId and      
       b.PolicyBusinessId = a.investmentid)      
      
      
insert into TActionFund      
(      
ActionPlanId,      
FundId,      
FundUnitId,      
PercentageAllocation,     
RegularContributionPercentage, 
PolicyBusinessFundId      
)      
select      
actionplanid,      
null,      
null,      
-99,      
-99,
policybusinessfundid      
from TFinancialPlanningSelectedFunds a      
inner join TFinancialPlanningSelectedInvestments b on b.FinancialPlanningSelectedInvestmentsId = a.FinancialPlanningSelectedInvestmentsId      
inner join TActionPlan c on c.policybusinessid = b.investmentid      
where InvestmentType != 'asset' and      
  b.financialplanningid = @FinancialPlanningId and      
  not exists (select 1 from TActionFund f      
     where f.actionplanid = c.actionplanid and       
       f.policybusinessfundid = a.policybusinessfundid)      
             
             
--It's possible the user has removed a plan.  remove the action funds and action plans      
delete a      
from TACtionFund a      
inner join TActionPlan b on a.actionplanid = b.actionplanid      
where b.financialplanningid = @FinancialPlanningId and      
  b.scenarioid = @scenarioid and      
  isnull(b.policybusinessid,0) > 0 and         
  not exists (select 1       
     from TFinancialPlanningSelectedInvestments c      
     where c.InvestmentType != 'asset' and      
       c.financialplanningid = @FinancialPlanningId and      
       c.investmentid = b.policybusinessid)      
             
update b
set		PercentageAllocation = -999      
from TActionPlan b       
where b.financialplanningid = @FinancialPlanningId and      
  b.scenarioid = @scenarioid and      
  isnull(b.policybusinessid,0) > 0 and         
  not exists (select 1       
     from TFinancialPlanningSelectedInvestments c      
     where c.InvestmentType != 'asset' and      
       c.financialplanningid = @FinancialPlanningId and      
       c.investmentid = b.policybusinessid)      
            
--they may also have delete a single fund or funds.  Get rid of it  
delete a      
from TACtionFund a      
inner join TActionPlan b on a.actionplanid = b.actionplanid      
left join policymanagement..TPolicyBusinessFund c on c.policybusinessfundid = a.policybusinessfundid  
where b.financialplanningid = @FinancialPlanningId and      
  b.scenarioid = @scenarioid and      
  isnull(a.policybusinessfundid,0) > 0 and         
  c.policybusinessfundid is null  
  
  
GO
