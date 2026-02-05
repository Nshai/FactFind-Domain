SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


    
CREATE procedure [dbo].[spNCustomRetrieveFundSimple]      
      
@PolicyBusinessFundId bigint      
      
as      
      
select       
case when fu.FundUnitId is null then tpbf.FundId else fu.FundUnitId end as FundUnitId,      
case when fu.FundId is null then 0 else fu.FundId end as FundId,      
FundName as FundName,      
case when  ft.Fundtypename = 'Equities' then 'Equity' else FundSectorName end as FundSector, 
ISNULL(CurrentUnitQuantity,0) as Units,      
ISNULL(CurrentPrice,0) as UnitValue,  
case    
  when ft.Fundtypename = 'Equities' then 'Equity' else 'Fund'
 end as HoldingType,
  FromFeedFg AS IsFromFeed,
  RegularContributionPercentage
  
from policymanagement..tpolicybusinessfund tpbf          
       
 inner join policymanagement..TPolicyBusiness pb on pb.policybusinessid = tpbf.policybusinessid      
 inner join fund2..TRefFundType ft on ft.reffundtypeid = tpbf.fundtypeid  
 left join fund2..TFundUnit fu on fu.FundUnitId = tpbf.fundid     
 left join fund2..TFund f on f.fundid = fu.fundid      
 left join fund2..TFundSector fs on f.FundSectorId = fs.FundSectorId  
 where tpbf.PolicyBusinessFundId = @PolicyBusinessFundId  
  
GO
