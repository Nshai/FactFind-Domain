SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[spNio_CustomRetrieveActionFundsForActionPlan]  
@ActionPlanIds varchar(max)  
  
as  

Declare @ParsedValues Table ( Id int, ParsedValue varchar(200) )  
Insert Into @ParsedValues(Id, ParsedValue)
Exec Administration.dbo.SpCustomParseCsvStringToStringList @CommaSeperatedList = @ActionPlanIds

select   
a.ActionFundId,  
a.ActionPlanId,  
a.FundId,  
a.FundUnitId,  
a.PercentageAllocation,  
a.PolicyBusinessFundId,  
COALESCE(UnitLongName, a.UnknownFundName) as FundName,
COALESCE(FundSectorName, 'Unknown') as FundSector ,
a.AssetFundId
from TActionFund a  
left join fund2..TFundUnit fu on fu.FundUnitId = a.FundUnitId      
left join fund2..TFund f on f.fundid = fu.fundid      
left join fund2..TFundSector fs on f.FundSectorId = fs.FundSectorId
Where actionplanid in (Select ParsedValue From @ParsedValues)
order by PolicyBusinessFundId desc,ActionFundId  
GO
