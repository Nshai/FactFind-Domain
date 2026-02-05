SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[spNCustomRetrieveActionFundsForActionPlan]  
@ActionPlanId bigint  
  
as  
  
select   
a.ActionFundId,  
a.ActionPlanId,  
a.FundId,  
a.FundUnitId,  
a.PercentageAllocation,  
a.RegularContributionPercentage,
a.PolicyBusinessFundId,  
UnitLongName as FundName,      
FundSectorName as FundSector  
from TActionFund a  
left join fund2..TFundUnit fu on fu.FundUnitId = a.FundUnitId      
left join fund2..TFund f on f.fundid = fu.fundid      
left join fund2..TFundSector fs on f.FundSectorId = fs.FundSectorId      
where actionplanid = @actionplanid  
order by PolicyBusinessFundId desc,ActionFundId  
GO
