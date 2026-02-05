SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SpCustomRetrievePolicyBusinessFundsWithAttributes]
@PolicyBusinessId bigint  
  
as   
  

set nocount on   
  
select   
tpbf.PolicyBusinessFundId as "@PolicyBusinessFundId",   
tpbf.FundId as "@FundId",   
tpbf.FundName as "@FundName",  
tpbf.FundTypeId as "@FundTypeId",  
case  
 when tpbf.FundTypeId < 10 then 'Fund'  
 when tpbf.FundTypeId > 9 then 'Equity'  
end as "@Type",  
tpbf.FromFeedFg as "@FromFeedFg",  
isnull(tpbf.FundIndigoClientId,0) as "@FundIndigoClientId",  
tpbf.CategoryId AS "@CategoryId",  
tpbf.CategoryName AS "@CategoryName",
tpbfam.AttributeMask as Attributes

from tpolicybusinessfund tpbf 
	Left join  tpolicybusinessfundattributeMask tpbfam on tpbf.Policybusinessfundid = tpbfam.Policybusinessfundid
 
where tpbf.policybusinessid = @PolicyBusinessId  

order by tpbf.PolicyBusinessFundId

for xml path('PolicyBusinessFund')



GO
